package com.example.void_url_shortner.service;

import com.example.void_url_shortner.dto.CreateCodeResponseDto;
import com.example.void_url_shortner.dto.RedirectCodeResponseDto;
import com.example.void_url_shortner.dto.VerifyPasswordResponseDto;
import com.example.void_url_shortner.exceptions.*;
import com.example.void_url_shortner.model.ShortCode;
import com.example.void_url_shortner.repository.ShortCodeRepository;
import com.example.void_url_shortner.utils.ShortCodeGenerator;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

@Service
public class ShortCodeService {
    private final int collisionRetries;
    private final int expirationHours;
    private final ShortCodeRepository shortCodeRepository;
    private final PasswordEncoder passwordEncoder;

    public ShortCodeService(
            @Value("${url-shortener.collision.retries}") int collisionRetries,
            @Value("${url-shortener.expiration.hours}") int expirationHours,
            ShortCodeRepository shortCodeRepository,
            PasswordEncoder passwordEncoder
    ) {
        this.collisionRetries = collisionRetries;
        this.expirationHours = expirationHours;
        this.shortCodeRepository = shortCodeRepository;
        this.passwordEncoder = passwordEncoder;
    }

    ThreadLocalRandom random = ThreadLocalRandom.current();

    public CreateCodeResponseDto createShortCode(String password, String longUrl) throws HashingAlgorithmException, RepeatedCollisionException {
        try {
            String hashedPassword = null;
            if (password != null) {
                hashedPassword = passwordEncoder.encode(password);
            }

            Date creationTimestamp = new Date();

            for (int i = 0 ; i < collisionRetries; i++) {
                String code = ShortCodeGenerator.getCode(longUrl, random.nextInt());
                Optional<ShortCode> existingCode = shortCodeRepository.findById(code);
                boolean hasNotCollided = existingCode.map(value -> value.getExpirationTime().before(creationTimestamp)).orElse(true);

                if (hasNotCollided) {
                    ShortCode shortCode = new ShortCode(
                            code,
                            longUrl,
                            hashedPassword,
                            creationTimestamp,
                            new Date(creationTimestamp.getTime() + TimeUnit.HOURS.toMillis(expirationHours))
                    );
                    shortCodeRepository.save(shortCode);
                    return new CreateCodeResponseDto(shortCode.getCode(), shortCode.getLongUrl());
                }
            }

            throw new RepeatedCollisionException();
        } catch (NoSuchAlgorithmException e) {
            throw new HashingAlgorithmException();
        }
    }

    @Cacheable(value = "shortCode")
    public RedirectCodeResponseDto getRedirectInfo(String code) throws CodeNotFoundException, CodeExpiredException {
        ShortCode shortCode = this.getShortCode(code);

        if (shortCode.getPassword() == null) {
            return new RedirectCodeResponseDto(
                    false,
                    shortCode.getLongUrl()
            );
        } else {
            return new RedirectCodeResponseDto(
                    true,
                    null
            );
        }
    }

    public VerifyPasswordResponseDto verifyPassword(String code, String userPassword)
    throws CodeNotFoundException, CodeExpiredException, IncorrectPasswordException, MissingPasswordException, BadRequestNoPasswordException {
        ShortCode shortCode = this.getShortCode(code);

        String password = shortCode.getPassword();
        if (password == null) {
            throw new BadRequestNoPasswordException();
        }

        if (userPassword == null) {
            throw new MissingPasswordException();
        }

        if (passwordEncoder.matches(userPassword, password)) {
            return new VerifyPasswordResponseDto(shortCode.getLongUrl());
        } else {
            throw new IncorrectPasswordException();
        }
    }

    private ShortCode getShortCode(String code) {
        Optional<ShortCode> shortCode = shortCodeRepository.findById(code);
        if (shortCode.isEmpty()) {
            throw new CodeNotFoundException();
        } else if (shortCode.get().getExpirationTime().before(new Date())) {
            throw new CodeExpiredException();
        } else {
            return shortCode.get();
        }
    }
}

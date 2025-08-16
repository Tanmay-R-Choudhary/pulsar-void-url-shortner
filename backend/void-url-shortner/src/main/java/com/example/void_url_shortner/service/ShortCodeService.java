package com.example.void_url_shortner.service;

import com.example.void_url_shortner.dto.CreateCodeDto;
import com.example.void_url_shortner.model.ShortCode;
import com.example.void_url_shortner.repository.ShortCodeRepository;
import com.example.void_url_shortner.utils.ShortCodeGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

@Service
public class ShortCodeService {
    @Autowired
    ShortCodeRepository shortCodeRepository;

    @Autowired
    PasswordEncoder passwordEncoder;

    ThreadLocalRandom random = ThreadLocalRandom.current();

    public Optional<ShortCode> createShortCode(CreateCodeDto createCodeDto) throws NoSuchAlgorithmException {
        String password = null;
        if (createCodeDto.getPassword() != null) {
            password = passwordEncoder.encode(createCodeDto.getPassword());
        }

        ShortCode newShortCode = null;
        for (int i = 0 ; i < 10; i++) {
            String code = ShortCodeGenerator.getCode(createCodeDto.getLongUrl(), random.nextInt());
            Optional<ShortCode> existingCode = shortCodeRepository.findById(code);
            if (existingCode.isEmpty()) {
                Date creationTimestamp = new Date();
                newShortCode = new ShortCode(
                        code,
                        createCodeDto.getLongUrl(),
                        password,
                        creationTimestamp,
                        new Date(creationTimestamp.getTime() + TimeUnit.HOURS.toMillis(2))
                );
                break;
            }
        }

        if (newShortCode != null) {
            shortCodeRepository.save(newShortCode);
            return Optional.of(newShortCode);
        } else {
            return Optional.empty();
        }
    }

    public Optional<ShortCode> getShortCode(String code, String userPassword) {
        Optional<ShortCode> shortCode = shortCodeRepository.findById(code);
        if (shortCode.isEmpty()) {
            return shortCode;
        } else {
            String password = shortCode.get().getPassword();
            if (userPassword != null && password != null) {
                if (passwordEncoder.matches(userPassword, password)) {
                    return shortCode;
                } else {
                    return Optional.empty();
                }
            } else if (userPassword == null && password == null) {
                return shortCode;
            } else {
                return Optional.empty();
            }
        }
    }
}

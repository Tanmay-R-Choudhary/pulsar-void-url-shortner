package com.example.void_url_shortner.controller;

import com.example.void_url_shortner.dto.CreateForm;
import com.example.void_url_shortner.model.ShortUrl;
import com.example.void_url_shortner.repository.ShortUrlRepository;
import com.example.void_url_shortner.utils.ShortCodeGenerator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

@RestController()
@RequestMapping("/api")
@Slf4j
public class ShortUrlController {
    @Autowired
    ShortUrlRepository shortUrlRepository;

    ThreadLocalRandom random = ThreadLocalRandom.current();

    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("Pong!");
    }

    @PostMapping("/code")
    public ResponseEntity<ShortUrl> createCode(@RequestBody CreateForm createForm) {
        try {
            ShortUrl newCode = null;
            for (int i = 0 ; i < 10; i++) {
                String code = ShortCodeGenerator.getCode(createForm.getLongUrl(), random.nextInt());
                Optional<ShortUrl> existingCode = shortUrlRepository.findById(code);
                if (existingCode.isEmpty()) {
                    Date creationTimestamp = new Date();
                    newCode = new ShortUrl(
                            code,
                            createForm.getLongUrl(),
                            creationTimestamp,
                            new Date(creationTimestamp.getTime() + TimeUnit.HOURS.toMillis(2))
                    );
                    break;
                }
            }

            if (newCode == null) {
                log.error("ShortUrlController::createCode - Could not get collision free code!");
                return ResponseEntity.internalServerError().build();
            } else {
                shortUrlRepository.save(newCode);
                return ResponseEntity.ok(newCode);
            }
        } catch (Exception e) {
            log.error("ShortUrlController::createCode - {}", e.toString());
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/code")
    public ResponseEntity<List<ShortUrl>> getAllCodes() {
        try {
            List<ShortUrl> codes = shortUrlRepository.findAll();
            return ResponseEntity.ok(codes);
        } catch (Exception e) {
            log.error("ShortUrlController::getAllCodes - {}", e.toString());
            return ResponseEntity.internalServerError().build();
        }
    }
}

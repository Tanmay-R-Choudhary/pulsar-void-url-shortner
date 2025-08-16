package com.example.void_url_shortner.controller;

import com.example.void_url_shortner.dto.CreateCodeDto;
import com.example.void_url_shortner.dto.SendCodeDataDto;
import com.example.void_url_shortner.model.ShortCode;
import com.example.void_url_shortner.service.ShortCodeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController()
@RequestMapping("/api")
@Slf4j
public class ShortCodeController {
    @Autowired
    ShortCodeService service;

    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("Pong!");
    }

    @PostMapping("/code")
    public ResponseEntity<SendCodeDataDto> createShortCode(@RequestBody CreateCodeDto createCodeDto) {
        try {
            Optional<ShortCode> newCode = service.createShortCode(createCodeDto);

            if (newCode.isEmpty()) {
                log.error("ShortUrlController::createCode - Could not get collision free code!");
                return ResponseEntity.internalServerError().build();
            } else {
                SendCodeDataDto response = new SendCodeDataDto(newCode.get().getCode(), newCode.get().getLongUrl());
                return ResponseEntity.status(HttpStatus.CREATED).body(response);
            }
        } catch (Exception e) {
            log.error("ShortUrlController::createCode - {}", e.toString());
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/code/{code}")
    public ResponseEntity<SendCodeDataDto> getShortCode(
            @PathVariable String code,
            @RequestParam(required = false, name = "password") String userPassword) {
        try {
            Optional<ShortCode> shortCode = service.getShortCode(code, userPassword);

            if (shortCode.isEmpty()) {
                return ResponseEntity.notFound().build();
            } else {
                SendCodeDataDto sendCodeDataDto = new SendCodeDataDto(
                        shortCode.get().getCode(),
                        shortCode.get().getLongUrl()
                );

                return ResponseEntity.ok(sendCodeDataDto);
            }
        } catch (Exception e) {
            log.error("ShortUrlController::getCode - {}", e.toString());
            return ResponseEntity.internalServerError().build();
        }
    }
}

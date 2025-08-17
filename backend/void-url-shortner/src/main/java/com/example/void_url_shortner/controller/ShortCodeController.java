package com.example.void_url_shortner.controller;

import com.example.void_url_shortner.dto.*;
import com.example.void_url_shortner.service.ShortCodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController()
@RequestMapping("/api")
public class ShortCodeController {
    private final ShortCodeService service;

    @Autowired
    public ShortCodeController(ShortCodeService service) {
        this.service = service;
    }

    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("Pong!");
    }

    @PostMapping("/shorten")
    public ResponseEntity<CreateCodeResponseDto> createShortCode(@RequestBody CreateCodeRequestDto createCodeRequestDto) {
        CreateCodeResponseDto response = service.createShortCode(
                createCodeRequestDto.getPassword(),
                createCodeRequestDto.getLongUrl()
        );

        return ResponseEntity.ok().body(response);
    }

    @GetMapping("/redirect/{code}")
    public ResponseEntity<RedirectCodeResponseDto> getRedirectInfo(@PathVariable String code) {
        RedirectCodeResponseDto response = service.getRedirectInfo(code);

        return ResponseEntity.ok().body(response);
    }

    @PostMapping("/verify-password")
    public ResponseEntity<VerifyPasswordResponseDto> verifyPassword(@RequestBody VerifyPasswordRequestDto verifyPasswordRequestDto) {
        VerifyPasswordResponseDto response = service.verifyPassword(
                verifyPasswordRequestDto.getCode(),
                verifyPasswordRequestDto.getPassword()
        );

        return ResponseEntity.ok().body(response);
    }
}

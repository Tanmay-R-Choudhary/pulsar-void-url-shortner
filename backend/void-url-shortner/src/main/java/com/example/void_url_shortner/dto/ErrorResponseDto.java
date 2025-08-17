package com.example.void_url_shortner.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ErrorResponseDto {
    private int statusCode;
    private String message;
    private long timestamp;
}
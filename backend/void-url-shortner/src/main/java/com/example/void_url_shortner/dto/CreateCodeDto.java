package com.example.void_url_shortner.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CreateCodeDto {
    private String longUrl;
    private String password;
}

package com.example.void_url_shortner.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class RedirectCodeResponseDto {
    @JsonProperty("is_password_protected")
    private boolean isPasswordProtected;

    @JsonProperty("original_url")
    private String longUrl;
}

package com.example.void_url_shortner.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class VerifyPasswordRequestDto {
    @JsonProperty("short_code")
    private String code;

    @JsonProperty("password")
    private String password;
}

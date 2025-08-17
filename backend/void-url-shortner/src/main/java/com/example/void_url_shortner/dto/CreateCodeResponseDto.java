package com.example.void_url_shortner.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CreateCodeResponseDto {
    @JsonProperty("short_code")
    private String code;

    @JsonProperty("original_url")
    private String longUrl;
}

package com.example.void_url_shortner.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CreateCodeRequestDto {
    @JsonProperty("is_file")
    private boolean isFile;

    @JsonProperty("original_url")
    private String longUrl;

    @JsonProperty("filename")
    private String filename;

    @JsonProperty("password")
    private String password;
}

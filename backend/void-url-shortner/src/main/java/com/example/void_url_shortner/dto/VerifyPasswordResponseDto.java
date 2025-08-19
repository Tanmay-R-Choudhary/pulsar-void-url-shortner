package com.example.void_url_shortner.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class VerifyPasswordResponseDto {
    @JsonProperty("is_file")
    private boolean isFile;

    @JsonProperty("original_url")
    private String longUrl;

    @JsonProperty("file_download_url")
    private String fileDownloadUrl;
}

package com.example.void_url_shortner.configuration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;

@Configuration
public class S3Configuration {
    @Value("${aws.region}")
    private String awsRegion;

    @Bean
    public S3Presigner s3Presigner() {
        return S3Presigner
                .builder()
                .region(Region.of(awsRegion))
                .build();
    }
}

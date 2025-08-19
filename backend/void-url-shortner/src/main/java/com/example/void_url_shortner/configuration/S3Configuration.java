package com.example.void_url_shortner.configuration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.AwsCredentials;
import software.amazon.awssdk.auth.credentials.ProfileCredentialsProvider;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;

@Configuration
public class S3Configuration {
    @Value("${aws.credentials.profile-name}")
    private String awsCredentialsProfileName;

    @Value("${aws.region}")
    private String awsRegion;

    @Bean
    public ProfileCredentialsProvider awsCredentialsProvider() {
        return ProfileCredentialsProvider.create(awsCredentialsProfileName);
    }

    @Bean
    public S3Presigner s3Presigner(ProfileCredentialsProvider credentialsProvider) {
        return S3Presigner
                .builder()
                .region(Region.of(awsRegion))
                .credentialsProvider(credentialsProvider)
                .build();
    }
}

package com.example.void_url_shortner.repository;

import com.example.void_url_shortner.model.ShortCode;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ShortCodeRepository extends MongoRepository<ShortCode, String> {
}
package com.example.void_url_shortner.repository;

import com.example.void_url_shortner.model.ShortUrl;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ShortUrlRepository extends MongoRepository<ShortUrl, String> {
}
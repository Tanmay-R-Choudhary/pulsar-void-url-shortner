package com.example.void_url_shortner.schedulers;


import com.example.void_url_shortner.model.ShortCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;

@Slf4j
@Component
public class DatabaseCleaner {
    private final MongoTemplate mongoTemplate;

    @Autowired
    public DatabaseCleaner(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Scheduled(fixedRate = 2 * 60 * 60 * 1000)
    public void cleanExpiredCodes() {
        log.info("Starting scheduled deletion of expired URLs");
        Query query = new Query();
        query.addCriteria(Criteria.where("expirationTime").lt(new Date()));
        mongoTemplate.remove(query, ShortCode.class);
        log.info("Finished scheduled deletion of expired URLs");
    }
}

package com.example.void_url_shortner.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document("ShortUrl")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ShortUrl {
    @Id
    private String code;
    private String longUrl;
    private Date creationTime;
    private Date expirationTime;
}

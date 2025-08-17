package com.example.void_url_shortner.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR, reason = "Error occured when trying to hash the long url")
public class HashingAlgorithmException extends RuntimeException {
    private String message;

    public HashingAlgorithmException() {}

    public HashingAlgorithmException(String msg) {
        super(msg);
        this.message = msg;
    }
}

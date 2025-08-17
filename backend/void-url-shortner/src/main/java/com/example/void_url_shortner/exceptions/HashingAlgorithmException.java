package com.example.void_url_shortner.exceptions;


public class HashingAlgorithmException extends RuntimeException {
    private String message;

    public HashingAlgorithmException() {}

    public HashingAlgorithmException(String msg) {
        super(msg);
        this.message = msg;
    }
}

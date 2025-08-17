package com.example.void_url_shortner.exceptions;


public class MissingPasswordException extends RuntimeException {
    private String message;

    public MissingPasswordException() {}

    public MissingPasswordException(String msg) {
        super(msg);
        this.message = msg;
    }
}

package com.example.void_url_shortner.exceptions;


public class BadRequestNoPasswordException extends RuntimeException {
    private String message;

    public BadRequestNoPasswordException() {}

    public BadRequestNoPasswordException(String msg) {
        super(msg);
        this.message = msg;
    }
}

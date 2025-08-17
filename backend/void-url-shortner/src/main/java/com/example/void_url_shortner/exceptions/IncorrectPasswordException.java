package com.example.void_url_shortner.exceptions;


public class IncorrectPasswordException extends RuntimeException {
    private String message;

    public IncorrectPasswordException() {}

    public IncorrectPasswordException(String msg) {
        super(msg);
        this.message = msg;
    }
}

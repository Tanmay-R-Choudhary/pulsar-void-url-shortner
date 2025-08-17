package com.example.void_url_shortner.exceptions;


public class CodeNotFoundException extends RuntimeException {
    private String message;

    public CodeNotFoundException() {}

    public CodeNotFoundException(String msg) {
        super(msg);
        this.message = msg;
    }
}

package com.example.void_url_shortner.exceptions;


public class CodeExpiredException extends RuntimeException {
    private String message;

    public CodeExpiredException() {}

    public CodeExpiredException(String msg) {
        super(msg);
        this.message = msg;
    }
}

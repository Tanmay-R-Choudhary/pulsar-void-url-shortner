package com.example.void_url_shortner.exceptions;


public class RepeatedCollisionException extends RuntimeException {
    private String message;

    public RepeatedCollisionException() {}

    public RepeatedCollisionException(String msg) {
        super(msg);
        this.message = msg;
    }
}

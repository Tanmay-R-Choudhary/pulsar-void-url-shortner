package com.example.void_url_shortner.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Password is missing")
public class MissingPasswordException extends RuntimeException {
    private String message;

    public MissingPasswordException() {}

    public MissingPasswordException(String msg) {
        super(msg);
        this.message = msg;
    }
}

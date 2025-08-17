package com.example.void_url_shortner.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.UNAUTHORIZED, reason = "Incorrect password")
public class IncorrectPasswordException extends RuntimeException {
    private String message;

    public IncorrectPasswordException() {}

    public IncorrectPasswordException(String msg) {
        super(msg);
        this.message = msg;
    }
}

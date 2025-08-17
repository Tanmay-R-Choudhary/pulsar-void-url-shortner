package com.example.void_url_shortner.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Password missing and code is password-protected")
public class BadRequestNoPasswordException extends RuntimeException {
    private String message;

    public BadRequestNoPasswordException() {}

    public BadRequestNoPasswordException(String msg) {
        super(msg);
        this.message = msg;
    }
}

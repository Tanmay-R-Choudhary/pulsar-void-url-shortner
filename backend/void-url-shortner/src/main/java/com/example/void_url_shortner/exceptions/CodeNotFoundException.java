package com.example.void_url_shortner.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.NOT_FOUND, reason = "Could not find code")
public class CodeNotFoundException extends RuntimeException {
    private String message;

    public CodeNotFoundException() {}

    public CodeNotFoundException(String msg) {
        super(msg);
        this.message = msg;
    }
}

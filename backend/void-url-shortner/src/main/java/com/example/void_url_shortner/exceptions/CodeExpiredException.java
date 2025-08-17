package com.example.void_url_shortner.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.GONE, reason = "Code has expired")
public class CodeExpiredException extends RuntimeException {
    private String message;

    public CodeExpiredException() {}

    public CodeExpiredException(String msg) {
        super(msg);
        this.message = msg;
    }
}

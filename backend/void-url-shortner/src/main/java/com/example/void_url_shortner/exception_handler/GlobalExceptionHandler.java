package com.example.void_url_shortner.exception_handler;

import com.example.void_url_shortner.dto.ErrorResponseDto;
import com.example.void_url_shortner.exceptions.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(IncorrectPasswordException.class)
    public ResponseEntity<ErrorResponseDto> handleIncorrectPasswordException(IncorrectPasswordException ex) {
        log.warn("Incorrect password attempt: {}", ex.getMessage()); // Log as warning, not error
        ErrorResponseDto errorResponse = new ErrorResponseDto(
                HttpStatus.UNAUTHORIZED.value(),
                "The password provided is incorrect.",
                System.currentTimeMillis()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(CodeNotFoundException.class)
    public ResponseEntity<ErrorResponseDto> handleCodeNotFoundException(CodeNotFoundException ex) {
        log.info("Code not found: {}", ex.getMessage()); // Log as info
        ErrorResponseDto errorResponse = new ErrorResponseDto(
                HttpStatus.NOT_FOUND.value(),
                "The requested link could not be found.",
                System.currentTimeMillis()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(CodeExpiredException.class)
    public ResponseEntity<ErrorResponseDto> handleCodeExpiredException(CodeExpiredException ex) {
        log.info("Code has expired: {}", ex.getMessage()); // Log as info
        ErrorResponseDto errorResponse = new ErrorResponseDto(
                HttpStatus.GONE.value(),
                "This link has expired and is no longer available.",
                System.currentTimeMillis()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.GONE);
    }

    @ExceptionHandler({BadRequestNoPasswordException.class, MissingPasswordException.class})
    public ResponseEntity<ErrorResponseDto> handleBadRequestPasswordExceptions(RuntimeException ex) {
        log.warn("Bad password request: {}", ex.getMessage());
        ErrorResponseDto errorResponse = new ErrorResponseDto(
                HttpStatus.BAD_REQUEST.value(),
                ex.getMessage(), // The exception message is user-friendly enough here
                System.currentTimeMillis()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(RepeatedCollisionException.class)
    public ResponseEntity<ErrorResponseDto> handleRepeatedCollisionException(RepeatedCollisionException ex) {
        log.error("Repeated collisions occurred when generating short code.", ex);
        ErrorResponseDto errorResponse = new ErrorResponseDto(
                HttpStatus.CONFLICT.value(),
                "Could not generate a unique link at this time. Please try again.",
                System.currentTimeMillis()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.CONFLICT);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponseDto> handleGenericException(Exception ex) {
        log.error("An unexpected internal server error occurred: ", ex);

        ErrorResponseDto errorResponse = new ErrorResponseDto(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "An internal server error occurred. Please try again later.",
                System.currentTimeMillis()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
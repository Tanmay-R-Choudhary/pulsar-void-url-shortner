package com.example.void_url_shortner.exception_handler;

import com.example.void_url_shortner.dto.ErrorResponseDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponseDto> handleGenericException(Exception ex) {
        log.error("An unexpected error occurred: ", ex);

        ErrorResponseDto errorResponse = new ErrorResponseDto(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "An internal server error occurred. Please try again later.",
                System.currentTimeMillis()
        );
        return ResponseEntity.internalServerError().body(errorResponse);
    }
}

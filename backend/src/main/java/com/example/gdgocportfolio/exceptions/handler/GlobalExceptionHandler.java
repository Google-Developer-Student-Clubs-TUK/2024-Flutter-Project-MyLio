package com.example.gdgocportfolio.exceptions.handler;

import com.example.gdgocportfolio.exceptions.*;
import io.jsonwebtoken.JwtException;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 전역적으로 발생하는 예외를 처리하고, JSON 형태로 반환하는 클래스
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 예외 응답 형식
     * - 필요한 필드만 자유롭게 추가 가능 (status, code, error, message, fieldErrors 등)
     */
    @Data
    @AllArgsConstructor
    static class ErrorResponse {
        private String timestamp;
        private int status;
        private String error;   // 예외 클래스/원인 요약
        private String message; // 상세 메시지
        private List<FieldError> fieldErrors; // Valid 에러 필드를 모을 경우

        @Data
        @AllArgsConstructor
        static class FieldError {
            private String field;
            private String defaultMessage;
        }
    }

    /**
     * 1) @Valid 검증 실패 예외 처리
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationExceptions(MethodArgumentNotValidException ex) {
        // log.warn() 등으로 예외를 로그
        log.warn("Validation failed: {}", ex.getMessage());

        // 발생한 필드 에러들을 모아 JSON으로 내려줌
        List<ErrorResponse.FieldError> fieldErrors = ex.getBindingResult().getFieldErrors().stream()
                .map(error -> new ErrorResponse.FieldError(
                        error.getField(),
                        error.getDefaultMessage()
                ))
                .collect(Collectors.toList());

        ErrorResponse errorResponse = new ErrorResponse(
                LocalDateTime.now().toString(),
                HttpStatus.BAD_REQUEST.value(),
                "Validation Failed",
                "The request data validation has failed.",
                fieldErrors
        );

        return ResponseEntity.badRequest().body(errorResponse);
    }

    /**
     * 2) @Valid 외, BindException (또는 다른 Validation) 발생 시 처리
     *   - 폼 데이터 바인딩 실패 등을 잡고 싶다면 추가
     */
    @ExceptionHandler(BindException.class)
    public ResponseEntity<ErrorResponse> handleBindExceptions(BindException ex) {
        log.warn("BindException: {}", ex.getMessage());
        List<ErrorResponse.FieldError> fieldErrors = ex.getBindingResult().getFieldErrors().stream()
                .map(error -> new ErrorResponse.FieldError(
                        error.getField(),
                        error.getDefaultMessage()
                ))
                .collect(Collectors.toList());
        ErrorResponse errorResponse = new ErrorResponse(
                LocalDateTime.now().toString(),
                HttpStatus.BAD_REQUEST.value(),
                "BindException Occurred",
                "Data binding has failed.",
                fieldErrors
        );

        return ResponseEntity.badRequest().body(errorResponse);
    }

    /**
     * 3) Custom 예외 처리 예시
     *    - 예: UserNotExistsException, CoverLetterNotExistsException 등
     */
    @ExceptionHandler({
            CoverLetterException.class,
            JwtExpireException.class,
            JwtException.class,
            UserException.class,
            ResumeException.class,
            UnauthorizedException.class
    })
    public ResponseEntity<ErrorResponse> handleCustomExceptions(RuntimeException ex) {
        log.warn("Custom Exception: {}", ex.getClass().getSimpleName(), ex);

        ErrorResponse errorResponse = new ErrorResponse(
                LocalDateTime.now().toString(),
                HttpStatus.NOT_FOUND.value(),
                ex.getClass().getSimpleName(),
                ex.getMessage(),
                null // fieldErrors 없음
        );

        // 여기서는 404 NOT_FOUND로 처리, 필요에 따라 400/403 등 변경 가능
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
    }

    /**
     * 4) 그 외 Exception 처리
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception ex) {
        log.error("Unexpected Exception: {}", ex.getMessage(), ex);

        ErrorResponse errorResponse = new ErrorResponse(
                LocalDateTime.now().toString(),
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "InternalServerError",
                ex.getMessage(),
                null
        );

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
    }
}

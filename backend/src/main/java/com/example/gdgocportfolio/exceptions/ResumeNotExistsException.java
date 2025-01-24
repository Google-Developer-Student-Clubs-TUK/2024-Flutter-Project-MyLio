package com.example.gdgocportfolio.exceptions;

public class ResumeNotExistsException extends ResumeException {
    public ResumeNotExistsException(String message) {
        super(message);
    }

    public ResumeNotExistsException() {
        super("Resume does not exist.");
    }
}

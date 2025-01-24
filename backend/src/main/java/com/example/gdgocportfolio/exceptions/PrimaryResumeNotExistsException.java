package com.example.gdgocportfolio.exceptions;

public class PrimaryResumeNotExistsException extends ResumeException {
    public PrimaryResumeNotExistsException(String message) {
        super(message);
    }

    public PrimaryResumeNotExistsException() {
        super("Primary resume does not exist.");
    }
}

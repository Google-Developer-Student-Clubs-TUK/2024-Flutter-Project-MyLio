package com.example.gdgocportfolio.exceptions;

public class InvalidUserException extends UserException {
    public InvalidUserException(String message) {
        super(message);
    }

    public InvalidUserException() {
        super("Invalid User");
    }
}

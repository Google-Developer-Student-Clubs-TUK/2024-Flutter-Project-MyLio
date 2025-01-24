package com.example.gdgocportfolio.exceptions;

public class UserNotExistsException extends UserException {
    public UserNotExistsException() {
        super("User does not exist.");
    }

    public UserNotExistsException(String message) {
        super(message);
    }
}

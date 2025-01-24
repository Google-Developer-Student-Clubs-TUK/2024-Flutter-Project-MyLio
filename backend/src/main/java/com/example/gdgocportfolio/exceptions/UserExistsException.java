package com.example.gdgocportfolio.exceptions;

public class UserExistsException extends UserException {
    public UserExistsException(String message) {
        super(message);
    }
    public UserExistsException() {
        super("User already exist.");
    }
}

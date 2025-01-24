package com.example.gdgocportfolio.exceptions;

public class IncorrectPasswordException extends PasswordException {
    public IncorrectPasswordException(String message) {
        super(message);
    }

    public IncorrectPasswordException() {
        super("Incorrect Password");
    }
}

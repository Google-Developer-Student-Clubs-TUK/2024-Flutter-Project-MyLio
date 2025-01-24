package com.example.gdgocportfolio.exceptions;

public class UserExistsWithPhoneNumberException extends UserExistsException {
    public UserExistsWithPhoneNumberException(String message) {
        super(message);
    }
    public UserExistsWithPhoneNumberException() {
        super("User with this phone number already exists.");
    }
}

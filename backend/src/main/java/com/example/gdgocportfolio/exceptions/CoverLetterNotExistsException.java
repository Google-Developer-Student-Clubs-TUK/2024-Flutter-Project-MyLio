package com.example.gdgocportfolio.exceptions;

public class CoverLetterNotExistsException extends CoverLetterException{
    public CoverLetterNotExistsException(String message) {
        super(message);
    }

    public CoverLetterNotExistsException() {
        super("CoverLetter does not exist.");
    }

}

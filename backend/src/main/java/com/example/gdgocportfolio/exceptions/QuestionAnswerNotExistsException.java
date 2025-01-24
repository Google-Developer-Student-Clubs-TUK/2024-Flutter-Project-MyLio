package com.example.gdgocportfolio.exceptions;

public class QuestionAnswerNotExistsException extends CoverLetterException{
    public QuestionAnswerNotExistsException(String message) {
        super(message);
    }

    public QuestionAnswerNotExistsException() {
        super("QuestionAnswer does not exist.");
    }
}

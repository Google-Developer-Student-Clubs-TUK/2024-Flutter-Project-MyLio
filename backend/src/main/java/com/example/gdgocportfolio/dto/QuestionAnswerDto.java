package com.example.gdgocportfolio.dto;

import lombok.Data;

@Data
public class QuestionAnswerDto {
    private Long questionAnswerId;
    private String question;
    private String answer;
}
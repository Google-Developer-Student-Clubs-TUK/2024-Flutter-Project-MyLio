package com.example.gdgocportfolio.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class QuestionAnswerUpdateRequestDto {
    @NotBlank
    private String question;
    @NotBlank
    private String answer;
}

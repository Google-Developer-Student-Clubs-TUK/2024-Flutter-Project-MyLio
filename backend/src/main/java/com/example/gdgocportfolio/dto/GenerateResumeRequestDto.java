package com.example.gdgocportfolio.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GenerateResumeRequestDto {

    @NotNull(message = "Questions cannot be null")
    @Size(min = 3, max = 3, message = "Exactly 3 questions are required")
    private List<String> questions;
}

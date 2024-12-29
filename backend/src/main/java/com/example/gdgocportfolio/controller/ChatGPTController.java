package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.GenerateCoverLetterRequestDto;
import com.example.gdgocportfolio.dto.GenerateCoverLetterResponseDto;
import com.example.gdgocportfolio.service.ChatGPTService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/chatgpt4")
public class ChatGPTController {

    @Autowired
    private ChatGPTService chatGPTService;

    @PostMapping("/generate-coverLetter")
    public ResponseEntity<List<GenerateCoverLetterResponseDto>> generateCoverLetter(@Valid @RequestBody GenerateCoverLetterRequestDto requestDTO) {
        List<GenerateCoverLetterResponseDto> responses = new ArrayList<>();

        for (String question : requestDTO.getQuestions()) {
            String response = chatGPTService.generateCoverLetter(question);
            responses.add(new GenerateCoverLetterResponseDto(response));
        }

        return ResponseEntity.ok(responses);
    }
}

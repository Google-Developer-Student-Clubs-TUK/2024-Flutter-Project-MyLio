package com.example.gdgocportfolio.controller;

import com.example.gdgocportfolio.dto.GenerateCoverLetterRequestDto;
import com.example.gdgocportfolio.dto.GenerateCoverLetterResponseDto;
import com.example.gdgocportfolio.service.ChatGPTService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/chatgpt4")
@Tag(name = "gpt-4o 자소서 생성")
public class ChatGPTController {

    @Autowired
    private ChatGPTService chatGPTService;

    @PostMapping("/generate-coverLetter")
    @Operation(summary = "자소서 생성", description = "자소서를 생성합니다.")
    public ResponseEntity<List<GenerateCoverLetterResponseDto>> generateCoverLetter(@RequestParam Long userId, @Valid @RequestBody GenerateCoverLetterRequestDto requestDTO) {
        List<GenerateCoverLetterResponseDto> responses = new ArrayList<>();

        for (String question : requestDTO.getQuestions()) {
            String response = chatGPTService.generateCoverLetter(userId, question);
            responses.add(new GenerateCoverLetterResponseDto(response));
        }

        return ResponseEntity.ok(responses);
    }
}

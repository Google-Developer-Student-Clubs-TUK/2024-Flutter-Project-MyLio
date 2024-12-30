package com.example.gdgocportfolio.controller;


import com.example.gdgocportfolio.dto.CoverLetterRequestDto;
import com.example.gdgocportfolio.dto.CoverLetterResponseDto;
import com.example.gdgocportfolio.entity.CoverLetter;
import com.example.gdgocportfolio.service.CoverLetterService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/coverLetter")
@Tag(name = "자소서(틀만 구현. 회원과 mapping x)")
public class CoverLetterController {

    @Autowired
    private CoverLetterService coverLetterService;

    @PostMapping
    public ResponseEntity<CoverLetterResponseDto> createCoverLetter(@RequestBody CoverLetterRequestDto coverLetterRequestDto) {
        CoverLetter coverLetter = new CoverLetter();
        coverLetter.setUserId(coverLetterRequestDto.getUserId());
        coverLetter.setData(coverLetterRequestDto.getData());

        CoverLetter savedCoverLetter = coverLetterService.saveCoverLetter(coverLetter);
        CoverLetterResponseDto responseDto = mapToResponseDto(savedCoverLetter);
        return ResponseEntity.ok(responseDto);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CoverLetterResponseDto> updateCoverLetter(
            @PathVariable Long id,
            @RequestBody CoverLetterRequestDto coverLetterRequestDto) {
        CoverLetter updatedCoverLetter = coverLetterService.updateCoverLetter(id, mapToEntity(coverLetterRequestDto));
        CoverLetterResponseDto responseDto = mapToResponseDto(updatedCoverLetter);
        return ResponseEntity.ok(responseDto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCoverLetter(@PathVariable Long id) {
        coverLetterService.deleteCoverLetter(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping
    public ResponseEntity<List<CoverLetterResponseDto>> getAllCoverLetters() {
        List<CoverLetter> coverLetters = coverLetterService.getAllCoverLetters();
        List<CoverLetterResponseDto> responseDtos = coverLetters.stream()
                .map(this::mapToResponseDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responseDtos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<CoverLetterResponseDto> getCoverLetterById(@PathVariable Long id) {
        return coverLetterService.getCoverLetterById(id)
                .map(this::mapToResponseDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    private CoverLetter mapToEntity(CoverLetterRequestDto dto) {
        CoverLetter coverLetter = new CoverLetter();
        coverLetter.setUserId(dto.getUserId());
        coverLetter.setData(dto.getData());
        return coverLetter;
    }

    private CoverLetterResponseDto mapToResponseDto(CoverLetter coverLetter) {
        CoverLetterResponseDto dto = new CoverLetterResponseDto();
        dto.setCoverLetterId(coverLetter.getCoverLetterId());
        dto.setUserId(coverLetter.getUserId());
        dto.setData(coverLetter.getData());
        dto.setCreateTime(coverLetter.getCreateTime());
        dto.setLastUpdateTime(coverLetter.getLastUpdateTime());
        return dto;
    }
}

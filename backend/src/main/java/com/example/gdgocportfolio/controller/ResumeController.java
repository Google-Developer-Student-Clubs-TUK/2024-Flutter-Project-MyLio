package com.example.gdgocportfolio.controller;


import com.example.gdgocportfolio.dto.ResumeRequestDto;
import com.example.gdgocportfolio.dto.ResumeResponseDto;
import com.example.gdgocportfolio.entity.Resume;
import com.example.gdgocportfolio.service.ResumeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/resumes")
public class ResumeController {

    @Autowired
    private ResumeService resumeService;

    @PostMapping
    public ResponseEntity<ResumeResponseDto> createResume(@RequestBody ResumeRequestDto resumeRequestDto) {
        Resume resume = new Resume();
        resume.setUserId(resumeRequestDto.getUserId());
        resume.setData(resumeRequestDto.getData());

        Resume savedResume = resumeService.saveResume(resume);
        ResumeResponseDto responseDto = mapToResponseDto(savedResume);
        return ResponseEntity.ok(responseDto);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ResumeResponseDto> updateResume(
            @PathVariable Long id,
            @RequestBody ResumeRequestDto resumeRequestDto) {
        Resume updatedResume = resumeService.updateResume(id, mapToEntity(resumeRequestDto));
        ResumeResponseDto responseDto = mapToResponseDto(updatedResume);
        return ResponseEntity.ok(responseDto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteResume(@PathVariable Long id) {
        resumeService.deleteResume(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping
    public ResponseEntity<List<ResumeResponseDto>> getAllResumes() {
        List<Resume> resumes = resumeService.getAllResumes();
        List<ResumeResponseDto> responseDtos = resumes.stream()
                .map(this::mapToResponseDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responseDtos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ResumeResponseDto> getResumeById(@PathVariable Long id) {
        return resumeService.getResumeById(id)
                .map(this::mapToResponseDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    private Resume mapToEntity(ResumeRequestDto dto) {
        Resume resume = new Resume();
        resume.setUserId(dto.getUserId());
        resume.setData(dto.getData());
        return resume;
    }

    private ResumeResponseDto mapToResponseDto(Resume resume) {
        ResumeResponseDto dto = new ResumeResponseDto();
        dto.setResumeId(resume.getResumeId());
        dto.setUserId(resume.getUserId());
        dto.setData(resume.getData());
        dto.setCreateTime(resume.getCreateTime());
        dto.setLastUpdateTime(resume.getLastUpdateTime());
        return dto;
    }
}

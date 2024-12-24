package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.dto.ResumeDto;
import com.example.gdgocportfolio.entity.Resume;
import com.example.gdgocportfolio.repository.ResumeRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.util.Arrays;

@Service
public class ResumeService {
    private final ResumeRepository resumeRepository;
    private final ObjectMapper objectMapper;

    public ResumeService(ResumeRepository resumeRepository, ObjectMapper objectMapper) {
        this.resumeRepository = resumeRepository;
        this.objectMapper = objectMapper;
    }

    // 이력서 저장
    public void saveResume(ResumeDto resumeDto) {
        Resume resume = new Resume();
        resume.setTitle(resumeDto.getTitle());
        resume.setIndustries(resumeDto.getIndustries());
        resume.setJob(resumeDto.getJob());
        resume.setStrengths(resumeDto.getStrengths());
        resume.setWeaknesses(resumeDto.getWeaknesses());
        resume.setSkills(resumeDto.getSkills());

        try {
            resume.setActivities(objectMapper.writeValueAsString(resumeDto.getActivities()));
            resume.setAwards(objectMapper.writeValueAsString(resumeDto.getAwards()));
            resume.setCertificates(objectMapper.writeValueAsString(resumeDto.getCertificates()));
            resume.setLanguages(objectMapper.writeValueAsString(resumeDto.getLanguages()));
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 오류", e);
        }

        resumeRepository.save(resume);
    }

    // 이력서 조회
    public ResumeDto getResume(Long id) {
        Resume resume = resumeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("이력서를 찾을 수 없습니다."));

        try {
            return ResumeDto.builder()
                    .title(resume.getTitle())
                    .industries(resume.getIndustries())
                    .job(resume.getJob())
                    .strengths(resume.getStrengths())
                    .weaknesses(resume.getWeaknesses())
                    .skills(resume.getSkills())
                    .activities(Arrays.asList(objectMapper.readValue(resume.getActivities(), ResumeDto.Activity[].class))) // 수정
                    .awards(Arrays.asList(objectMapper.readValue(resume.getAwards(), ResumeDto.Award[].class)))
                    .certificates(Arrays.asList(objectMapper.readValue(resume.getCertificates(), ResumeDto.Certificate[].class)))
                    .languages(Arrays.asList(objectMapper.readValue(resume.getLanguages(), ResumeDto.Language[].class)))
                    .build();
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 오류", e);
        }
    }
}

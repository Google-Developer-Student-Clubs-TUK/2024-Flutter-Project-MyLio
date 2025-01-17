package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.dto.ResumeDto;
import com.example.gdgocportfolio.entity.Resume;
import com.example.gdgocportfolio.entity.User;
import com.example.gdgocportfolio.repository.ResumeRepository;
import com.example.gdgocportfolio.repository.UserRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;


@Service
public class ResumeService {
    private final ResumeRepository resumeRepository;
    private final UserRepository userRepository;
    private final ObjectMapper objectMapper;

    public ResumeService(ResumeRepository resumeRepository, UserRepository userRepository, ObjectMapper objectMapper) {
        this.resumeRepository = resumeRepository;
        this.userRepository = userRepository;
        this.objectMapper = objectMapper;
    }

    // 이력서 저장
    public void saveResume(Long userId, ResumeDto resumeDto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        Resume resume = new Resume();
        mapDtoToResume(resumeDto, resume);
        resume.setUser(user); // 사용자 연결
        resumeRepository.save(resume);
    }

    // 이력서 조회 (단건)
    public ResumeDto getResume(Long userId, Long resumeId) {
        Resume resume = resumeRepository.findByResumeIdAndUserUserId(resumeId, userId)
                .orElseThrow(() -> new RuntimeException("이력서를 찾을 수 없습니다."));
        return mapResumeToDto(resume);
    }

    // 사용자별 이력서 전체 조회
    public List<ResumeDto> getResumesByUser(Long userId) {
        List<Resume> resumes = resumeRepository.findByUserUserId(userId);
        return resumes.stream().map(this::mapResumeToDto).collect(Collectors.toList());
    }

    // 이력서 업데이트
    public void updateResume(Long userId, Long resumeId, ResumeDto resumeDto) {
        Resume resume = resumeRepository.findByResumeIdAndUserUserId(resumeId, userId)
                .orElseThrow(() -> new RuntimeException("이력서를 찾을 수 없습니다."));

        // 이력서 내용 업데이트
        resume.setResumeTitle(resumeDto.getResumeTitle());
        resume.setJobDuty(resumeDto.getJobDuty());
        resume.setCapabilities(resumeDto.getCapabilities());
        resumeRepository.save(resume);
    }

    // 이력서 삭제
    public void deleteResume(Long userId, Long resumeId) {
        Resume resume = resumeRepository.findByResumeIdAndUserUserId(resumeId, userId)
                .orElseThrow(() -> new RuntimeException("이력서를 찾을 수 없습니다."));
        resumeRepository.delete(resume);
    }

    // 대표 이력서 설정
    public void setPrimaryResume(Long userId, Long resumeId) {
        // 기존 대표 이력서 초기화
        List<Resume> resumes = resumeRepository.findAll();
        for (Resume resume : resumes) {
            if (resume.getUser().getUserId().equals(userId)) {
                resume.setPrimary(false);
            }
        }

        // 새로운 대표 이력서 설정
        Resume primaryResume = resumeRepository.findById(resumeId)
                .orElseThrow(() -> new RuntimeException("이력서를 찾을 수 없습니다."));
        primaryResume.setPrimary(true);
        resumeRepository.saveAll(resumes);
    }

    // DTO -> Entity
    private void mapDtoToResume(ResumeDto resumeDto, Resume resume) {
        resume.setResumeTitle(resumeDto.getResumeTitle());
        resume.setIndustryGroups(resumeDto.getIndustryGroups());
        resume.setJobDuty(resumeDto.getJobDuty());
        resume.setStrengths(resumeDto.getStrengths());
        resume.setWeaknesses(resumeDto.getWeaknesses());
        resume.setCapabilities(resumeDto.getCapabilities());

        try {
            resume.setActivityExperience(objectMapper.writeValueAsString(resumeDto.getActivityExperience()));
            resume.setAwards(objectMapper.writeValueAsString(resumeDto.getAwards()));
            resume.setCertificates(objectMapper.writeValueAsString(resumeDto.getCertificates()));
            resume.setLanguages(objectMapper.writeValueAsString(resumeDto.getLanguages()));
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 오류", e);
        }
    }

    // Entity -> DTO
    private ResumeDto mapResumeToDto(Resume resume) {
        try {
            return ResumeDto.builder()
                    .resumeTitle(resume.getResumeTitle())
                    .industryGroups(resume.getIndustryGroups())
                    .jobDuty(resume.getJobDuty())
                    .strengths(resume.getStrengths())
                    .weaknesses(resume.getWeaknesses())
                    .capabilities(resume.getCapabilities())
                    .activityExperience(List.of(objectMapper.readValue(resume.getActivityExperience(), ResumeDto.Activity[].class)))
                    .awards(List.of(objectMapper.readValue(resume.getAwards(), ResumeDto.Award[].class)))
                    .certificates(List.of(objectMapper.readValue(resume.getCertificates(), ResumeDto.Certificate[].class)))
                    .languages(List.of(objectMapper.readValue(resume.getLanguages(), ResumeDto.Language[].class)))
                    .build();
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 오류", e);
        }
    }
}

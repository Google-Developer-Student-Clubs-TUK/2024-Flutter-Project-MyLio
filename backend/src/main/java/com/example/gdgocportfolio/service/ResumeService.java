package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.dto.ResumeDto;
import com.example.gdgocportfolio.entity.Resume;
import com.example.gdgocportfolio.entity.User;
import com.example.gdgocportfolio.exceptions.ResumeNotExistsException;
import com.example.gdgocportfolio.exceptions.UserNotExistsException;
import com.example.gdgocportfolio.repository.ResumeRepository;
import com.example.gdgocportfolio.repository.UserRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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
                .orElseThrow(UserNotExistsException::new);

        Resume resume = new Resume();
        mapDtoToResume(resumeDto, resume);
        resume.setUser(user); // 사용자 연결
        resumeRepository.save(resume);
    }

    // 이력서 조회 (단건)
    public ResumeDto getResume(Long userId, Long resumeId) {
        Resume resume = resumeRepository.findByResumeIdAndUserUserId(resumeId, userId)
                .orElseThrow(ResumeNotExistsException::new);
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
                .orElseThrow(ResumeNotExistsException::new);

        // 이력서 내용 업데이트
        resume.setResumeTitle(resumeDto.getResumeTitle());
        resume.setJobDuty(resumeDto.getJobDuty());
        resume.setCapabilities(resumeDto.getCapabilities());
        resumeRepository.save(resume);
    }

    // 이력서 삭제
    public void deleteResume(Long userId, Long resumeId) {
        Resume resume = resumeRepository.findByResumeIdAndUserUserId(resumeId, userId)
                .orElseThrow(ResumeNotExistsException::new);
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
                .orElseThrow(ResumeNotExistsException::new);
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
            throw new RuntimeException("JSON conversion error.", e);
        }
    }

    @Transactional
    public Resume copyResume(Long resumeId) {
        Resume resume = resumeRepository.findById(resumeId).orElseThrow(ResumeNotExistsException::new);
        Resume newResume = new Resume(null,
                resume.getUser(),
                resume.isPrimary(),
                resume.getResumeTitle(),
                new ArrayList<>(resume.getIndustryGroups()),
                resume.getJobDuty(),
                new ArrayList<>(resume.getStrengths()),
                new ArrayList<>(resume.getWeaknesses()),
                new ArrayList<>(resume.getCapabilities()),
                resume.getActivityExperience(),
                resume.getAwards(),
                resume.getCertificates(),
                resume.getLanguages(),
                resume.getCreateTime(),
                resume.getLastUpdateTime());
        return resumeRepository.save(newResume);
    }

    // Entity -> DTO
    private ResumeDto mapResumeToDto(Resume resume) {
        return ResumeDto.builder()
                .resumeTitle(resume.getResumeTitle())
                .industryGroups(resume.getIndustryGroups())
                .jobDuty(resume.getJobDuty())
                .strengths(resume.getStrengths())
                .weaknesses(resume.getWeaknesses())
                .capabilities(resume.getCapabilities())
                // 안전하게 변환
                .activityExperience(safeList(resume.getActivityExperience(), ResumeDto.Activity[].class))
                .awards(safeList(resume.getAwards(), ResumeDto.Award[].class))
                .certificates(safeList(resume.getCertificates(), ResumeDto.Certificate[].class))
                .languages(safeList(resume.getLanguages(), ResumeDto.Language[].class))
                .build();
    }

    private <T> List<T> safeList(String json, Class<T[]> clazz) {
        // JSON이 null 또는 비어 있는 경우 빈 리스트 반환
        if (json == null || json.isBlank()) {
            return new ArrayList<>();
        }
        try {
            T[] arr = objectMapper.readValue(json, clazz);
            return arr == null ? new ArrayList<>() : new ArrayList<>(List.of(arr));
        } catch (JsonProcessingException e) {
            // 로깅 추가
            System.err.println("Error parsing JSON: " + e.getMessage());
            return new ArrayList<>();
        }
    }
}

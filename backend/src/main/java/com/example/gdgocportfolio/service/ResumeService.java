package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.entity.Resume;
import com.example.gdgocportfolio.repository.ResumeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ResumeService {

    @Autowired
    private ResumeRepository resumeRepository;

    public Resume saveResume(Resume resume) {
        return resumeRepository.save(resume);
    }

    public Resume updateResume(Long resumeId, Resume updatedResume) {
        Optional<Resume> existingResume = resumeRepository.findById(resumeId);
        if (existingResume.isPresent()) {
            Resume resume = existingResume.get();
            resume.setUserId((updatedResume.getUserId()));
            resume.setData(updatedResume.getData());
            return resumeRepository.save(resume);
        }
        throw new RuntimeException("Resume not found");
    }

    public void deleteResume(Long resumeID) {
        if (resumeRepository.existsById(resumeID)) {
            resumeRepository.deleteById(resumeID);
        } else {
            throw new RuntimeException("Resume not found");
        }
    }

    public List<Resume> getAllResumes() {
        return resumeRepository.findAll();
    }

    public Optional<Resume> getResumeById(Long resumeId) {
        return resumeRepository.findById(resumeId);
    }
}

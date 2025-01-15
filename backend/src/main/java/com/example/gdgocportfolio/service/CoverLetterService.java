package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.entity.CoverLetter;
import com.example.gdgocportfolio.repository.CoverLetterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CoverLetterService {

    @Autowired
    private CoverLetterRepository coverLetterRepository;

    public CoverLetter saveCoverLetter(CoverLetter coverLetter) {
        // questionAnswers는 cascade로 함께 저장
        return coverLetterRepository.save(coverLetter);
    }

    public CoverLetter updateCoverLetter(Long coverLetterId, Long userId, CoverLetter updated) {
        return coverLetterRepository.findByCoverLetterIdAndUserId(coverLetterId, userId)
                .map(existing -> {
                    existing.setTitle(updated.getTitle());
                    // questionAnswers는 필요 시 별도 로직으로 관리
                    return coverLetterRepository.save(existing);
                })
                .orElseThrow(() -> new RuntimeException("CoverLetter not found or does not belong to this user"));
    }

    public void deleteCoverLetter(Long coverLetterId, Long userId) {
        if (coverLetterRepository.existsByCoverLetterIdAndUserId(coverLetterId, userId)) {
            coverLetterRepository.deleteById(coverLetterId);
        } else {
            throw new RuntimeException("CoverLetter not found or does not belong to this user");
        }
    }

    public Optional<CoverLetter> getCoverLetterByIdAndUserId(Long coverLetterId, Long userId) {
        return coverLetterRepository.findByCoverLetterIdAndUserId(coverLetterId, userId);
    }

    public List<CoverLetter> getAllCoverLettersByUserId(Long userId) {
        return coverLetterRepository.findAllByUserId(userId);
    }
}

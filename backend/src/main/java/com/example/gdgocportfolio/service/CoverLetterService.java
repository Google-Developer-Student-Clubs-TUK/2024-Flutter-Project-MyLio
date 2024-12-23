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
        return coverLetterRepository.save(coverLetter);
    }

    public CoverLetter updateCoverLetter(Long CoverLetterId, CoverLetter updatedCoverLetter) {
        Optional<CoverLetter> existingCoverLetter = coverLetterRepository.findById(CoverLetterId);
        if (existingCoverLetter.isPresent()) {
            CoverLetter coverLetter = existingCoverLetter.get();
            coverLetter.setUserId((updatedCoverLetter.getUserId()));
            coverLetter.setData(updatedCoverLetter.getData());
            return coverLetterRepository.save(coverLetter);
        }
        throw new RuntimeException("CoverLetter not found");
    }

    public void deleteCoverLetter(Long coverLetterID) {
        if (coverLetterRepository.existsById(coverLetterID)) {
            coverLetterRepository.deleteById(coverLetterID);
        } else {
            throw new RuntimeException("CoverLetter not found");
        }
    }

    public List<CoverLetter> getAllCoverLetters() {
        return coverLetterRepository.findAll();
    }

    public Optional<CoverLetter> getCoverLetterById(Long coverLetterId) {
        return coverLetterRepository.findById(coverLetterId);
    }
}

package com.example.gdgocportfolio.repository;

import com.example.gdgocportfolio.entity.CoverLetter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CoverLetterRepository extends JpaRepository<CoverLetter, Long> {
    Optional<CoverLetter> findByCoverLetterIdAndUserUserId(Long id, Long userId);
    List<CoverLetter> findAllByUserUserId(Long userId);
    boolean existsByCoverLetterIdAndUserUserId(Long id, Long userId);
}

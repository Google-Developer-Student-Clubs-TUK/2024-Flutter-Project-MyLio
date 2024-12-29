package com.example.gdgocportfolio.repository;

import com.example.gdgocportfolio.entity.Resume;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ResumeRepository extends JpaRepository<Resume, Long> {
    List<Resume> findByUserUserId(Long userId); // 사용자별 이력서 조회
}

package com.example.gdgocportfolio.service;

import com.example.gdgocportfolio.entity.Resume;
import com.example.gdgocportfolio.repository.ResumeRepository;
import com.theokanning.openai.completion.chat.ChatCompletionRequest;
import com.theokanning.openai.completion.chat.ChatMessage;
import com.theokanning.openai.service.OpenAiService;
import okhttp3.OkHttpClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.List;

@Service
public class ChatGPTService {

    private final OpenAiService openAiService;
    private final ResumeRepository resumeRepository;

    public ChatGPTService(@Value("${openai.api-key}") String apiKey, ResumeRepository resumeRepository) {
        this.openAiService = new OpenAiService(apiKey);
        this.resumeRepository = resumeRepository;
    }

    private OkHttpClient createCustomClient() {
        return new OkHttpClient.Builder()
                .connectTimeout(Duration.ofSeconds(60)) // 연결 타임아웃
                .readTimeout(Duration.ofSeconds(60))    // 읽기 타임아웃
                .writeTimeout(Duration.ofSeconds(60))   // 쓰기 타임아웃
                .build();
    }

    // 단일 문항에 대해 GPT 답변 반환
    public String generateAnswer(Long userId, String question) {

        // ChatGPT 메시지 생성
        ChatMessage systemMessage = new ChatMessage("system", "당신은 뛰어난 자기소개서 작성가입니다.");

        // 사용자 대표 이력서 검색
        Resume resume = resumeRepository.findByUserUserIdAndIsPrimaryTrue(userId)
                .orElseThrow(() -> new RuntimeException("대표 이력서가 존재하지 않습니다."));

        // 이력서 내용
        String resumeContent = String.format(
                "제목: %s\n직무: %s\n강점: %s\n약점: %s\n기술: %s\n활동: %s\n수상: %s\n자격증: %s\n언어: %s\n",
                resume.getResumeTitle(),
                resume.getJobDuty(),
                String.join(", ", resume.getStrengths()),
                String.join(", ", resume.getWeaknesses()),
                String.join(", ", resume.getCapabilities()),
                resume.getActivityExperience(),
                resume.getAwards(),
                resume.getCertificates(),
                resume.getLanguages()
        );


        ChatMessage userMessage = new ChatMessage("user", resumeContent + "\n 이 이력서 내용들을 바탕으로 다음 질문에 대해 자기소개서를 작성해주세요:\n" + question);

        // ChatCompletionRequest 생성
        ChatCompletionRequest chatCompletionRequest = ChatCompletionRequest.builder()
                .model("gpt-4o") // GPT-4o 모델 지정
                .messages(List.of(systemMessage, userMessage))
                .maxTokens(2000)
                .temperature(0.7)
                .build();

        // OpenAI API 호출
        return openAiService.createChatCompletion(chatCompletionRequest)
                .getChoices()
                .get(0)
                .getMessage()
                .getContent();
    }
}

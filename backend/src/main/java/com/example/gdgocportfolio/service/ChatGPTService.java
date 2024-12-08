package com.example.gdgocportfolio.service;

import com.theokanning.openai.completion.chat.ChatCompletionRequest;
import com.theokanning.openai.completion.chat.ChatMessage;
import com.theokanning.openai.service.OpenAiService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChatGPTService {

    private final OpenAiService openAiService;

    public ChatGPTService(@Value("${openai.api-key}") String apiKey) {
        this.openAiService = new OpenAiService(apiKey);
    }

    public String generateResume(String question) {

        // ChatGPT 메시지 생성
        ChatMessage systemMessage = new ChatMessage("system", "당신은 뛰어난 자기소개서 작성가입니다.");
        ChatMessage userMessage = new ChatMessage("user", "다음 질문에 대해 자기소개서를 작성해주세요:\n" + question);

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

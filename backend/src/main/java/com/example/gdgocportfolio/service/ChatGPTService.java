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

    public String generateResume(List<String> questions) {

        // 프롬프트 생성
        String prompt = buildPrompt(questions);

        // ChatGPT 메시지 생성
        ChatMessage systemMessage = new ChatMessage("system", "You are a professional resume writer.");
        ChatMessage userMessage = new ChatMessage("user", prompt);

        // ChatCompletionRequest 생성
        ChatCompletionRequest chatCompletionRequest = ChatCompletionRequest.builder()
                .model("gpt-3") // GPT-3 모델 지정
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

    private String buildPrompt(List<String> questions) {
        return "Based on the following questions, please create a detailed and professional resume:\n" +
                "1. " + questions.get(0) + "\n" +
                "2. " + questions.get(1) + "\n" +
                "3. " + questions.get(2);
    }
}

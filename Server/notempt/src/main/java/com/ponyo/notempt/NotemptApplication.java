package com.ponyo.notempt;

import com.ponyo.notempt.model.Challenge;
import com.ponyo.notempt.repository.ChallengeRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.context.annotation.Bean;

import java.util.Arrays;

@SpringBootApplication(exclude = SecurityAutoConfiguration.class)
public class NotemptApplication {

	public static void main(String[] args) {
		SpringApplication.run(NotemptApplication.class, args);
	}

    @Bean
    public CommandLineRunner demo(ChallengeRepository repository) {
        return (args) -> {
            // 초기 챌린지 데이터 삽입
            repository.save(new Challenge("매일 푸시업 100회", "5일간 푸시업 100회씩 도전", 0.6, Arrays.asList("user1", "user2")));
            repository.save(new Challenge("하루 한 챕터 독서", "매일 책 한 챕터씩 읽기", 0.2, Arrays.asList("user3")));
            repository.save(new Challenge("미라클 모닝", "아침 6시에 일어나기", 0.9, Arrays.asList("user1", "user4", "user5")));
        };
    }

}

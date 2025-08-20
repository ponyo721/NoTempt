package com.ponyo.notempt.model;
import jakarta.persistence.*;

import java.util.List;

@Entity // JPA 엔티티임을
@Table(name = "challenge") // 테이블 이름을 명시적으로 "challenge"로 지정
public class Challenge {

    @Id // 기본 키(Primary Key) 설정
    @GeneratedValue(strategy = GenerationType.IDENTITY) // ID 자동 생성 전략
    private Long id; // DB에서는 Long 타입이 일반적입니다.

    private String name;
    private String description;
    private double progress;

    // 이 예시에서는 참가자를 단순 문자열 리스트로 가정합니다.
    // 실제로는 관계형 테이블로 모델링하는 것이 좋습니다.
    @ElementCollection
    private List<String> participants;

    // JPA가 필요로 하는 기본 생성자
    public Challenge() {}

    public Challenge(String name, String description, double progress, List<String> participants) {
        this.name = name;
        this.description = description;
        this.progress = progress;
        this.participants = participants;
    }

    // Getter & Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getProgress() { return progress; }
    public void setProgress(double progress) { this.progress = progress; }

    public List<String> getParticipants() { return participants; }
    public void setParticipants(List<String> participants) { this.participants = participants; }
}
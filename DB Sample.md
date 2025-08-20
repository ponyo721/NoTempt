SELECT * FROM CAFES 

CREATE TABLE users ( id BIGINT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) NOT NULL UNIQUE, email VARCHAR(100) NOT NULL UNIQUE, password_hash VARCHAR(255) NOT NULL, failed_attempts INT DEFAULT 0, is_locked BOOLEAN DEFAULT FALSE, last_login_at TIMESTAMP, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP );

1. 기본 정보 사용자 고유 ID (PK, Auto Increment) 아이디(username, unique) 이메일(email, unique) 비밀번호(password → 절대 평문 저장 ❌, 해시 후 저장 ✅) 

2. 보안 관련 필드 password_salt : 해시 강화용 (선택 사항, bcrypt/argon2 같은 함수 쓰면 불필요) failed_attempts : 로그인 실패 횟수 → 계정 잠금 기능에 필요 is_locked : 계정 잠김 여부 last_login_at : 마지막 로그인 시간 → 이상 행동 탐지 가능 created_at / updated_at : 계정 생성 및 수정 시각

INSERT INTO cafes (
    id, name, type, address, latitude, longitude,
    date, group_name, internet, number, parking,
    table_info, toilet, created_at, updated_at
) VALUES (
    'CAF1234567890',                     -- id (UUID 등으로 생성 추천)
    '커피에반하다 삼청점',                -- name
    '무인',                              -- type
    '서울 종로구 삼청로4길 18',           -- address
    '37.5823168',                        -- latitude (문자열)
    '126.9820046',                       -- longitude (문자열)
    '2024-01-24',                        -- date
    '4인석',                             -- group_name
    '가능',                              -- internet
    '070-4493-7699',                     -- number
    '',                                  -- parking
    '2 테이블',                          -- table_info
    '',                                  -- toilet
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO places (
    id, name, type, address, latitude, longitude,
    additional, group_name, internet, number, parking,
    table_info, toilet, created_at, updated_at
) VALUES (
    '11xAY9RP9nfRMY4JaFVx',       -- id
    'asdasd',                     -- name
    '무인',                       -- type
    '서울 서초구 사임당로19길 6',   -- address
    37.490444,                    -- latitude
    127.0202161,                  -- longitude
    '',                           -- additional
    '',                           -- group_name
    '',                           -- internet
    '',                           -- number
    '',                           -- parking
    '',                           -- table_info
    '',                           -- toilet
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

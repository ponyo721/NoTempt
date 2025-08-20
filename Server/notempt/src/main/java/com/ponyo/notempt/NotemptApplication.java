package com.ponyo.notempt;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = SecurityAutoConfiguration.class)
public class NotemptApplication {

	public static void main(String[] args) {
		SpringApplication.run(NotemptApplication.class, args);
	}

}

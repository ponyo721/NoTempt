package com.ponyo.notempt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.logging.Logger;

@Controller
public class HomeController {
    final static Logger logger = Logger.getLogger(HomeController.class.getName());

    @GetMapping("/")
    public String home() {
        logger.info("call home getMapping");

        return "signin";
    }
}

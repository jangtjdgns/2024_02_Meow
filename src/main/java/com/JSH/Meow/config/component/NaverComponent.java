package com.JSH.Meow.config.component;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
public class NaverComponent {

    @Value("${oauth.naver.client.id}")
    @Getter
    private String clientId;

    @Value("${oauth.naver.client.secret}")
    @Getter
    private String cliendSecret;
    
    @Value("${oauth.naver.get-info.url}")
    @Getter
    private String infoUrl;
}
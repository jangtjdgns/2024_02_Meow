package com.JSH.Meow.component;

import java.math.BigInteger;
import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter
public class NaverComponent {

    @Value("${oauth.naver.client.id}")
    private String clientId;

    @Value("${oauth.naver.client.secret}")
    private String clientSecret;
    
    @Value("${oauth.naver.uri.authorize}")
    private String authUri;
    
    @Value("${oauth.naver.uri.token}")
    private String tokenUri;
    
    @Value("${oauth.naver.uri.user_info}")
    private String userInfoUri;
    
    @Value("${oauth.naver.uri.redirect}")
    private String redirectUri;
    
    @Value("${oauth.naver.type.response}")
    private String responseType;
    
    @Value("${oauth.naver.type.grant}")
    private String grantType;
    
    private String state;
    
    // state 생성
    public void generateState() {
        SecureRandom random = new SecureRandom();
        this.state = new BigInteger(130, random).toString(32);
    }
}
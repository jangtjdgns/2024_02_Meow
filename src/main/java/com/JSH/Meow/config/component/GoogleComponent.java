package com.JSH.Meow.config.component;

import java.math.BigInteger;
import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter
public class GoogleComponent {

    @Value("${oauth.google.client.id}")
    private String clientId;
	
    @Value("${oauth.google.client.secret}")
    private String clientSecret;
    
    @Value("${oauth.google.uri.authorize}")
    private String authUri;
    
    @Value("${oauth.google.uri.token}")
    private String tokenUri;
    
    @Value("${oauth.google.uri.user_info}")
    private String userInfoUri;
    
    @Value("${oauth.google.uri.scope}")
    private String scope;
    
    @Value("${oauth.google.uri.redirect}")
    private String redirectUri;
    
    @Value("${oauth.google.type.response}")
    private String responseType;
    
    @Value("${oauth.google.type.grant}")
    private String grantType;
    
    private String state;
    
    // state 생성
    public void generateState() {
        SecureRandom random = new SecureRandom();
        this.state = new BigInteger(130, random).toString(32);
    }
}
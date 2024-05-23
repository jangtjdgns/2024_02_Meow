package com.JSH.Meow.config.component;

import java.math.BigInteger;
import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter
public class GithubComponent {

    @Value("${oauth.github.client.id}")
    private String clientId;

    @Value("${oauth.github.client.secret}")
    private String clientSecret;
    
    @Value("${oauth.github.uri.authorize}")
    private String authUri;
    
    @Value("${oauth.github.uri.token}")
    private String tokenUri;
    
    @Value("${oauth.github.uri.user_info}")
    private String userInfoUri;
    
    @Value("${oauth.github.uri.redirect}")
    private String redirectUri;
    
    @Value("${oauth.github.type.response}")
    private String responseType;
    
    @Value("${oauth.github.type.grant}")
    private String grantType;
    
    private String state;
    
    // state 생성
    public void generateState() {
        SecureRandom random = new SecureRandom();
        this.state = new BigInteger(130, random).toString(32);
    }
}
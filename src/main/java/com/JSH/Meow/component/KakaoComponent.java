package com.JSH.Meow.component;

import java.math.BigInteger;
import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter
public class KakaoComponent {

    @Value("${oauth.kakao.client.appKey.native_app}")
    private String nativeAppKey;
	
    @Value("${oauth.kakao.client.appKey.rest_api}")
    private String restApiKey;
    
    @Value("${oauth.kakao.client.appKey.javascript}")
    private String javascriptKey;
    
    @Value("${oauth.kakao.client.appKey.admin}")
    private String adminKey;
    
    @Value("${oauth.kakao.client.secret}")
    private String clientSecret;
    
    @Value("${oauth.kakao.uri.authorize}")
    private String authUri;
    
    @Value("${oauth.kakao.uri.token}")
    private String tokenUri;
    
    @Value("${oauth.kakao.uri.user_info}")
    private String userInfoUri;
    
    @Value("${oauth.kakao.uri.redirect}")
    private String redirectUri;
    
    @Value("${oauth.kakao.type.response}")
    private String responseType;
    
    @Value("${oauth.kakao.type.grant}")
    private String grantType;
    
    private String state;
    
    // state 생성
    public void generateState() {
        SecureRandom random = new SecureRandom();
        this.state = new BigInteger(130, random).toString(32);
    }
}
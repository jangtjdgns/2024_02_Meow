package com.JSH.Meow.config.component;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
public class KakaoComponent {

    @Value("${oauth.kakao.client.appKey.native_app}")
    @Getter
    private String nativeAppKey;
	
    @Value("${oauth.kakao.client.appKey.rest_api}")
    @Getter
    private String restApiKey;
    
    @Value("${oauth.kakao.client.appKey.javascript}")
    @Getter
    private String javascriptKey;
    
    @Value("${oauth.kakao.client.appKey.admin}")
    @Getter
    private String adminKey;
    
    @Value("${oauth.kakao.client.secret}")
    @Getter
    private String clientSecret;
    
    @Value("${oauth.kakao.uri.authorize}")
    @Getter
    private String authUri;
    
    @Value("${oauth.kakao.uri.token}")
    @Getter
    private String tokenUri;
    
    @Value("${oauth.kakao.uri.user_info}")
    @Getter
    private String userInfoUri;
    
    @Value("${oauth.kakao.uri.redirect}")
    @Getter
    private String redirectUri;
    
    @Value("${oauth.kakao.type.response}")
    @Getter
    private String responseType;
    
    @Value("${oauth.kakao.type.grant}")
    @Getter
    private String grantType;

//    private static final String TOKEN_URI = "https://kauth.kakao.com/oauth/token";
//    private static final String REDIRECT_URI = "https://localhost:8080/oauth";
//    private static final String GRANT_TYPE = "authorization_code";
//    private static final String CLIENT_ID = "{secret.CLIENT_ID}";

//    public String getToken(String code) {
//        String uri = TOKEN_URI + "?grant_type=" + GRANT_TYPE + "&client_id=" + CLIENT_ID + "&redirect_uri=" + REDIRECT_URI + "&code=" + code;
//        System.out.println(uri);
//
//        Flux<KakaoTokenResponse> response = webClient.post()
//                .uri(uri)
//                .contentType(MediaType.APPLICATION_JSON)
//                .retrieve()
//                .bodyToFlux(KakaoTokenResponse.class);
//
//        return response.blockFirst();
//    }
}
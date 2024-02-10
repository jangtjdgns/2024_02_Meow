package com.JSH.Meow.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
public class KakaoConfig {

    @Value("${oauth.kakao.appKey.JavaScript}")
    @Getter
    private String javaScriptKey;

}
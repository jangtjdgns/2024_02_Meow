package com.JSH.Meow.config.component;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
public class KakaoComponent {

    @Value("${oauth.kakao.appKey.JavaScript}")
    @Getter
    private String javascriptKey;

}
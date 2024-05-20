package com.JSH.Meow.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.JSH.Meow.config.component.KakaoComponent;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class OAuth2Service {
	
	private KakaoComponent kakaoComponent;
	
	public OAuth2Service(KakaoComponent kakaoComponent) {
		this.kakaoComponent = kakaoComponent;
	}
	
	public String getTokenData(HttpServletRequest request) {
		String tokenUri = kakaoComponent.getTokenUri() 
				+ "?grant_type=" + kakaoComponent.getGrantType()
				+ "&client_id=" + kakaoComponent.getRestApiKey()
				+ "&redirect_uri=" + kakaoComponent.getRedirectUri()
				+ "&code=" + request.getParameter("code")
				+ "&client_secret=" + kakaoComponent.getClientSecret();
		
        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.getForObject(tokenUri, String.class);
    }

	public String getUserData(String accessToken) {
		
		Map<String, String> userData = new HashMap<>();
		userData.put("Authorization", "Bearer " + accessToken);
		
		String userInfoUri = kakaoComponent.getUserInfoUri();
		HttpURLConnection con = connect(userInfoUri);
        try {
            con.setRequestMethod("GET");
            for(Map.Entry<String, String> header :userData.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }

            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream());
            } else { // 에러 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
	}

	public HttpURLConnection connect(String apiUri){
        try {
            URL url = new URL(apiUri);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUri, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUri, e);
        }
    }


    public String readBody(InputStream body){
        InputStreamReader streamReader = new InputStreamReader(body);

        try (BufferedReader lineReader = new BufferedReader(streamReader)) {
            StringBuilder responseBody = new StringBuilder();

            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }

            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
    }
}

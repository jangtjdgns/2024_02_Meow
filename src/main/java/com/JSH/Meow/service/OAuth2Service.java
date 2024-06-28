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

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.JSH.Meow.component.GithubComponent;
import com.JSH.Meow.component.GoogleComponent;
import com.JSH.Meow.component.KakaoComponent;
import com.JSH.Meow.component.NaverComponent;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.SnsInfo;

@Service
public class OAuth2Service {
	
	private NaverComponent naverComponent;
	private KakaoComponent kakaoComponent;
	private GoogleComponent googleComponent;
	private GithubComponent githubComponent;
	
	public OAuth2Service(NaverComponent naverComponent, KakaoComponent kakaoComponent, GoogleComponent googleComponent, GithubComponent githubComponent) {
		this.naverComponent = naverComponent;
		this.kakaoComponent = kakaoComponent;
		this.googleComponent = googleComponent;
		this.githubComponent = githubComponent;
	}
	
	// token 정보
	// 토큰을 요청할때는 POST 요청을 사용했어야하는데, 지금까지 GET 요청을 사용했어서 에러가 났던거였음.
	public Map<String, Object> getTokenMap(String code, String snsType) {
		
	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
	    
	    MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	    params.add("code", code);
	    params.add("client_id", getClientId(snsType));
	    params.add("client_secret", getClientSecret(snsType));
	    params.add("redirect_uri", getRedirectUri(snsType));
	    params.add("grant_type", "authorization_code");
	    params.add("state", getState(snsType));
	    
	    HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

	    RestTemplate restTemplate = new RestTemplate();
	    ResponseEntity<Map> responseEntity = restTemplate.postForEntity(getTokenUri(snsType), request, Map.class);
	    Map<String, Object> responseMap = responseEntity.getBody();
	    
	    return responseMap;
	}
	
	// getAuthorizeUri
	public String getAuthorizeUri(String snsType) {
		
		generateState(snsType);
		String uri = "%s?response_type=code&client_id=%s&redirect_uri=%s&state=%s";
		String authUri = Util.f(uri, getAuthUri(snsType), getClientId(snsType), getRedirectUri(snsType), getState(snsType));
		
		if(snsType.equals("google")) {
			authUri += "&scope=" + googleComponent.getScope();
		}
		
		return authUri;
	}
	
	// 액세스 토큰을 통해 sns 회원 정보 가져오기
	public String getUserData(String accessToken, String snsType) {
		
		Map<String, String> userData = new HashMap<>();
		userData.put("Authorization", "Bearer " + accessToken);
		
		String userInfoUri = getUserInfoUri(snsType);
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
	
	// 가져온 회원 정보를 DB에 저장하기 위해 SnsInfo 객체에 다시 저장
	public SnsInfo getSnsInfo(Map<String, Object> userData, String snsType) {
		SnsInfo snsInfo = new SnsInfo();
		// snsInfo.setSnsConnectDate(Util.currentTime());	// 이거 일단 불필요
		snsInfo.setSnsType(snsType);
		switch (snsType) {
	        case "naver": return populateNaverInfo(userData, snsInfo);
	        case "kakao": return populateKakaoInfo(userData, snsInfo);
	        case "google": return populateGoogleInfo(userData, snsInfo);
	        case "github": return populateGithubInfo(userData, snsInfo);
	    }
		return null;
	}
	
	// 네이버 회원 정보 채우기
	private SnsInfo populateNaverInfo(Map<String, Object> userData, SnsInfo snsInfo) {
	    Map<String, String> response = (Map<String, String>) userData.get("response");
	    snsInfo.setSnsId(response.get("id"));
	    snsInfo.setName(response.get("name"));
	    snsInfo.setProfileImage(response.get("profile_image"));
	    snsInfo.setEmail(response.get("email"));
	    snsInfo.setMobile(response.get("mobile"));
	    return snsInfo;
	}
	
	// 카카오 회원 정보 채우기
	private SnsInfo populateKakaoInfo(Map<String, Object> userData, SnsInfo snsInfo) {
	    Map<String, String> properties = (Map<String, String>) userData.get("properties");
	    Map<String, String> kakaoAccount = (Map<String, String>) userData.get("kakao_account");
	    snsInfo.setSnsId(String.valueOf(userData.get("id")));
	    snsInfo.setName(properties.get("nickname"));
	    snsInfo.setProfileImage(properties.get("profile_image"));
	    snsInfo.setEmail(kakaoAccount.get("email"));
	    snsInfo.setMobile("0" + kakaoAccount.get("phone_number").substring(4));
	    return snsInfo;
	}
	
	// 구글 회원 정보 채우기
	private SnsInfo populateGoogleInfo(Map<String, Object> userData, SnsInfo snsInfo) {
	    snsInfo.setSnsId(String.valueOf(userData.get("id")));
	    snsInfo.setName(String.valueOf(userData.get("family_name")) + String.valueOf(userData.get("given_name")));
	    snsInfo.setProfileImage(String.valueOf(userData.get("picture")));
	    snsInfo.setEmail(String.valueOf(userData.get("email")));
	    return snsInfo;
	}
	
	// 깃허브 회원 정보 채우기
	private SnsInfo populateGithubInfo(Map<String, Object> userData, SnsInfo snsInfo) {
		
		snsInfo.setSnsId(String.valueOf(userData.get("id")));
		snsInfo.setName(String.valueOf(userData.get("name")));
		snsInfo.setProfileImage(String.valueOf(userData.get("avatar_url")));
		snsInfo.setEmail(String.valueOf(userData.get("email")));
		 
	    return snsInfo;
	}
	
	
	// authUri 가져오기
	private String getAuthUri(String snsType) {
		switch (snsType) {
		    case "naver": return naverComponent.getAuthUri();
		    case "kakao": return kakaoComponent.getAuthUri();
		    case "google": return googleComponent.getAuthUri();
		    case "github": return githubComponent.getAuthUri();
		}
		return null;
	}
	
	// tokenUri 가져오기
	private String getTokenUri(String snsType) {
		switch (snsType) {
		    case "naver": return naverComponent.getTokenUri();
		    case "kakao": return kakaoComponent.getTokenUri();
		    case "google": return googleComponent.getTokenUri();
		    case "github": return githubComponent.getTokenUri();
		}
	    return null;
	}
	
	// userInfoUri 가져오기
	private String getUserInfoUri(String snsType) {
		switch (snsType) {
		    case "naver": return naverComponent.getUserInfoUri();
		    case "kakao": return kakaoComponent.getUserInfoUri();
		    case "google": return googleComponent.getUserInfoUri();
		    case "github": return githubComponent.getUserInfoUri();
		}
		return null;
	}
	
	// redirectUri 가져오기
	private String getRedirectUri(String snsType) {
		switch (snsType) {
		    case "naver": return naverComponent.getRedirectUri();
		    case "kakao": return kakaoComponent.getRedirectUri();
		    case "google": return googleComponent.getRedirectUri();
		    case "github": return githubComponent.getRedirectUri();
		}
	    return null;
	}
	
	// clientId 가져오기
	private String getClientId(String snsType) {
		switch (snsType) {
		    case "naver": return naverComponent.getClientId();
		    case "kakao": return kakaoComponent.getRestApiKey();
		    case "google": return googleComponent.getClientId();
		    case "github": return githubComponent.getClientId();
		}
	    return null;
	}
	
	// clientSecret 가져오기
	private String getClientSecret(String snsType) {
		switch (snsType) {
		    case "naver": return naverComponent.getClientSecret();
		    case "kakao": return kakaoComponent.getClientSecret();
		    case "google": return googleComponent.getClientSecret();
		    case "github": return githubComponent.getClientSecret();
		}
	    return null;
	}
	
	// state 생성
	private void generateState(String snsType) {
		switch (snsType) {
		    case "naver": naverComponent.generateState(); break;
		    case "kakao": kakaoComponent.generateState(); break;
		    case "google": googleComponent.generateState(); break;
		    case "github": githubComponent.generateState(); break;
		}
	}
	
	// state 가져오기
	private String getState(String snsType) {
		switch (snsType) {
		    case "naver": return naverComponent.getState();
		    case "kakao": return kakaoComponent.getState();
		    case "google": return googleComponent.getState();
		    case "github": return githubComponent.getState();		    
		}
		return null;
	}
	
	// API URI 연결
	private HttpURLConnection connect(String apiUri){
        try {
            URL url = new URL(apiUri);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUri, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUri, e);
        }
    }
	
	// 연결 BODY 읽기
    private String readBody(InputStream body){
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

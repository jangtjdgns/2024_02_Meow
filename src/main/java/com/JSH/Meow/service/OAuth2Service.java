package com.JSH.Meow.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.JSH.Meow.config.component.GoogleComponent;
import com.JSH.Meow.config.component.KakaoComponent;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.SnsInfo;

@Service
public class OAuth2Service {
	
	private KakaoComponent kakaoComponent;
	private GoogleComponent googleComponent;
	
	public OAuth2Service(KakaoComponent kakaoComponent, GoogleComponent googleComponent) {
		this.kakaoComponent = kakaoComponent;
		this.googleComponent = googleComponent;
	}
	
	// token 정보
	// 토큰을 요청할때는 POST 요청을 사용했어야하는데, 지금까지 GET 요청을 사용했어서 에러가 났던거였음.
	public Map<String, Object> getTokenMap(String code, String snsType) {
	    String tokenUri = getTokenUri(snsType);
	    
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
	    String response = restTemplate.postForObject(tokenUri, request, String.class);

	    return Util.jsonToMap(response);
	}
	
	// authUri
	public String getAuthUri(String snsType) {
		
		String authUri = null;
		String uri = "%s?response_type=%s&client_id=%s&redirect_uri=%s&state=%s";
		
		if(snsType.equals("kakao")) {
			kakaoComponent.generateState();
			authUri = Util.f(uri, kakaoComponent.getAuthUri(), kakaoComponent.getResponseType(), kakaoComponent.getRestApiKey(), kakaoComponent.getRedirectUri(), googleComponent.getState());
		} else if(snsType.equals("google")) {
			googleComponent.generateState();
			uri += "&scope=%s";
			authUri = Util.f(uri, googleComponent.getAuthUri(), googleComponent.getResponseType(), googleComponent.getClientId(), googleComponent.getRedirectUri(), googleComponent.getState(), googleComponent.getScope());
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
		
		snsInfo.setSnsConnectDate(Util.currentTime());
		snsInfo.setSnsType(snsType);
		
		if(snsType.equals("kakao")) {
			snsInfo.setSnsId(String.valueOf(userData.get("id")));
			snsInfo.setName(((Map<String, String>) userData.get("properties")).get("nickname"));
			snsInfo.setProfileImage(((Map<String, String>) userData.get("properties")).get("profile_image"));
			snsInfo.setEmail(((Map<String, String>) userData.get("kakao_account")).get("email"));
			snsInfo.setMobile("0" + ((Map<String, String>) userData.get("kakao_account")).get("phone_number").substring(4));
		} else if(snsType.equals("google")) {
			snsInfo.setSnsId(String.valueOf(userData.get("id")));
			snsInfo.setName(String.valueOf(userData.get("family_name") + String.valueOf(userData.get("given_name"))));
			snsInfo.setProfileImage(String.valueOf(userData.get("picture")));
			snsInfo.setEmail(String.valueOf(userData.get("email")));
		}
		
		return snsInfo;
	}
	
	private String getTokenUri(String snsType) {
	    if (snsType.equals("kakao")) {
	        return kakaoComponent.getTokenUri();
	    } else if (snsType.equals("google")) {
	        return googleComponent.getTokenUri();
	    }
	    return null;
	}

	private String getClientId(String snsType) {
	    if (snsType.equals("kakao")) {
	        return kakaoComponent.getRestApiKey();
	    } else if (snsType.equals("google")) {
	        return googleComponent.getClientId();
	    }
	    return null;
	}

	private String getClientSecret(String snsType) {
	    if (snsType.equals("kakao")) {
	        return kakaoComponent.getClientSecret();
	    } else if (snsType.equals("google")) {
	        return googleComponent.getClientSecret();
	    }
	    return null;
	}

	private String getRedirectUri(String snsType) {
	    if (snsType.equals("kakao")) {
	        return kakaoComponent.getRedirectUri();
	    } else if (snsType.equals("google")) {
	        return googleComponent.getRedirectUri();
	    }
	    return null;
	}
	
	private String getState(String snsType) {
		if (snsType.equals("kakao")) {
			return kakaoComponent.getState();
		} else if (snsType.equals("google")) {
			return googleComponent.getState();
		}
		return null;
	}
	
	private String getUserInfoUri(String snsType) {
		if (snsType.equals("kakao")) {
			return kakaoComponent.getUserInfoUri();
		} else if (snsType.equals("google")) {
			return googleComponent.getUserInfoUri();
		}
		return null;
	}

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

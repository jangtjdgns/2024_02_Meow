package com.JSH.Meow.controller;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.config.component.KakaoComponent;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.OAuth2Service;
import com.JSH.Meow.service.SnsInfoService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class KakaoController {
	
	private OAuth2Service oAuth2Service;
	private KakaoComponent kakaoComponent;
	private SnsInfoService snsInfoService;
	private MemberService memberService;
	private Rq rq;
	
	public KakaoController(OAuth2Service oAuth2Service, KakaoComponent kakaoComponent, SnsInfoService snsInfoService, MemberService memberService, Rq rq){
		this.oAuth2Service = oAuth2Service;
		this.kakaoComponent = kakaoComponent;
		this.snsInfoService = snsInfoService;
		this.memberService = memberService;
		this.rq = rq;
	}
	
	// 카카오 login
	@RequestMapping("/usr/member/login/{snsType}")
	public String kakaoLogin(@PathVariable String snsType) throws UnsupportedEncodingException {
		System.out.println(snsType);
		
		String authUri = kakaoComponent.getAuthUri()
				+ "?response_type=" + kakaoComponent.getResponseType()
	    		+ "&client_id=" + kakaoComponent.getRestApiKey()
    			+ "&redirect_uri=" + kakaoComponent.getRedirectUri()
    			+ "&snsType=" + snsType;
	    
	    // state 필수아니라 제외
		// SecureRandom random = new SecureRandom();
		// String state = new BigInteger(130, random).toString();
	    
	    return "redirect:" + authUri;
	}
	
	@RequestMapping("/usr/member/oauth/signup")
	@ResponseBody
	public Map<String, Object> OAuthSignupCallback(HttpServletRequest request, String snsType) {
		
		System.out.println(snsType);
		
		String tokenData = oAuth2Service.getTokenData(request);
		Map<String, Object> tokenMap = Util.jsonToMap(tokenData);
		
		Map<String, Object> userData = Util.jsonToMap(oAuth2Service.getUserData(tokenMap.get("access_token").toString()));
		System.out.println(userData);
		return userData;
	}

	// 네이버 doLogin
//	@RequestMapping("/usr/member/doLogin/naver")
//	@ResponseBody
//	public String naverLoginCallback(HttpServletRequest request) {
//		String jsonResponse = naverLoginService.getJsonResponse(request, naverComponent.getClientId(), naverComponent.getCliendSecret());
//		
//		String access_token = "";
//		String refresh_token = "";
//		
//		// 토큰 추출
//		try {
//			ObjectMapper objectMapper = new ObjectMapper();
//			JsonNode jsonNode = objectMapper.readTree(jsonResponse);
//
//			access_token = jsonNode.get("access_token").asText();
//			refresh_token = jsonNode.get("refresh_token").asText();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//
//		String token = access_token; 		// 네이버 로그인 접근 토큰;
//		String header = "Bearer " + token;
//		
//		String apiURL = naverComponent.getInfoUrl();
//		
//		Map<String, String> requestHeaders = new HashMap<>();
//		requestHeaders.put("Authorization", header);
//		String responseBody = naverLoginService.get(apiURL, requestHeaders);
//		/* System.out.println(responseBody); */
//		
//		// SNS 계정 정보
//		String snsId = "";
//		String name = "";
//		String nickname = "";
//		String age = "";
//		String mobile = "";
//		String email = "";
//		String snsProfile = "";
//		
//		try {
//            ObjectMapper objectMapper = new ObjectMapper();
//            JsonNode jsonNode = objectMapper.readTree(responseBody);
//
//            JsonNode responseNode = jsonNode.get("response");
//            if (responseNode != null) {
//            	snsId = responseNode.get("id").asText();
//            	name = responseNode.get("name").asText();
//            	nickname = responseNode.get("nickname").asText();
//            	age = responseNode.get("age").asText();
//            	mobile = responseNode.get("mobile").asText();
//            	email = responseNode.get("email").asText();
//            	snsProfile = responseNode.get("profile_image").asText();
//            } else {
//                System.out.println("Response key not found.");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//		
//		Member member = memberService.getMemberByNickname(nickname);
//		
//		// 첫 로그인 시 회원 등록
//		if(member == null) {
//			member = joinNewMember(snsId, name, nickname, mobile, email, snsProfile);
//		}
//		
//		rq.login(member);
//		
//		return Util.jsReplace(Util.f("%s님 환영합니다.", nickname), "/");
//	}
	
	// 첫 소셜로그인 시 회원등록, memberId로 관리하기 위해 추가
//	private Member joinNewMember(String snsId, String name, String nickname, String mobile, String email, String snsProfile) {
//		
//	    memberService.joinMember("", "", name, nickname, 0, "", mobile, email, snsProfile, "");
//
//	    int memberId = memberService.getLastInsertId();
//
//	    Member newMember = memberService.getMemberById(memberId);
//
//	    snsInfoService.saveSnsMemberInfo(snsId, "naver", memberId, name, mobile, email);
//	    
//	    return newMember;
//	}
}

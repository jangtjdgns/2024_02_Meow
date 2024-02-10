package com.JSH.Meow.controller;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.config.NaverConfig;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.NaverService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.Rq;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class NaverController {

	private NaverService naverLoginService;
	private MemberService memberService;
	private Rq rq;
	private NaverConfig naverConfig;
	
	public NaverController(NaverService naverLoginService, MemberService memberService, Rq rq, NaverConfig naverConfig){
		this.naverLoginService = naverLoginService;
		this.memberService = memberService;
		this.rq = rq;
		this.naverConfig = naverConfig;
	}
	
	// 네이버 login
	@RequestMapping("/usr/member/login/naver")
	public String naverLogin(HttpSession session) throws UnsupportedEncodingException {

		String clientId = naverConfig.getClientId();//애플리케이션 클라이언트 아이디값";
	    String redirectURI = URLEncoder.encode("http://localhost:8085/usr/member/doLogin/naver", "UTF-8");
	    SecureRandom random = new SecureRandom();
	    String state = new BigInteger(130, random).toString();
	    String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
	    apiURL += "&client_id=" + clientId;
	    apiURL += "&redirect_uri=" + redirectURI;
	    apiURL += "&state=" + state;
	    session.setAttribute("state", state);
		
		return "redirect:" + apiURL;
	}

	// 네이버 doLogin
	@RequestMapping("/usr/member/doLogin/naver")
	@ResponseBody
	public String naverLoginCallback(HttpServletRequest request) {
		String jsonResponse = naverLoginService.getJsonResponse(request, naverConfig.getClientId(), naverConfig.getCliendSecret());
		
		String access_token = "";
		String refresh_token = "";
		
		// 토큰 추출
		try {
			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode jsonNode = objectMapper.readTree(jsonResponse);

			access_token = jsonNode.get("access_token").asText();
			refresh_token = jsonNode.get("refresh_token").asText();
		} catch (Exception e) {
			e.printStackTrace();
		}

		String token = access_token; 		// 네이버 로그인 접근 토큰;
		String header = "Bearer " + token;
		
		String apiURL = naverConfig.getInfoUrl();
		
		Map<String, String> requestHeaders = new HashMap<>();
		requestHeaders.put("Authorization", header);
		String responseBody = naverLoginService.get(apiURL, requestHeaders);
		/* System.out.println(responseBody); */
		
		// SNS 계정 정보
		String snsId = "";
		String name = "";
		String nickname = "";
		String age = "";
		String mobile = "";
		String email = "";
		String snsProfile = "";
		
		try {
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonNode = objectMapper.readTree(responseBody);

            JsonNode responseNode = jsonNode.get("response");
            if (responseNode != null) {
            	snsId = responseNode.get("id").asText();
            	name = responseNode.get("name").asText();
            	nickname = responseNode.get("nickname").asText();
            	age = responseNode.get("age").asText();
            	mobile = responseNode.get("mobile").asText();
            	email = responseNode.get("email").asText();
            	snsProfile = responseNode.get("profile_image").asText();
            } else {
                System.out.println("Response key not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		Member member = memberService.getMemberByNickname(nickname);
		
		// 첫 로그인 시 회원 등록
		if(member == null) {
			member = joinNewMember(snsId, name, nickname, mobile, email, snsProfile);
		}
		
		rq.login(member);
		
		return Util.jsReplace(Util.f("%s님 환영합니다.", nickname), "/");
	}
	
	// 첫 소셜로그인 시 회원등록, memberId로 관리하기 위해 추가
	private Member joinNewMember(String snsId, String name, String nickname, String mobile, String email, String snsProfile) {
		
	    memberService.joinMember("", "", name, nickname, 0, "", mobile, email, snsProfile, "");

	    int memberId = memberService.getLastInsertId();

	    Member newMember = memberService.getMemberById(memberId);

	    naverLoginService.saveSnsMemberInfo(snsId, "naver", memberId, name, mobile, email);
	    
	    return newMember;
	}
}

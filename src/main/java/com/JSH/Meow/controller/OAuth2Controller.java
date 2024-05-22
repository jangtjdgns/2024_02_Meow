package com.JSH.Meow.controller;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.config.component.GoogleComponent;
import com.JSH.Meow.config.component.KakaoComponent;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.OAuth2Service;
import com.JSH.Meow.service.SnsInfoService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Rq;
import com.JSH.Meow.vo.SnsInfo;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class OAuth2Controller {
	
	private OAuth2Service oAuth2Service;
	private KakaoComponent kakaoComponent;
	private GoogleComponent googleComponent;
	private SnsInfoService snsInfoService;
	private MemberService memberService;
	private Rq rq;
	
	public OAuth2Controller(OAuth2Service oAuth2Service, KakaoComponent kakaoComponent, GoogleComponent googleComponent, SnsInfoService snsInfoService, MemberService memberService, Rq rq){
		this.oAuth2Service = oAuth2Service;
		this.kakaoComponent = kakaoComponent;
		this.googleComponent = googleComponent;
		this.snsInfoService = snsInfoService;
		this.memberService = memberService;
		this.rq = rq;
	}
	
	// sns login 버튼 클릭
	@RequestMapping("/usr/member/login/{snsType}")
	public String OAuth2Login(@PathVariable String snsType) throws UnsupportedEncodingException {
		
	    return "redirect:" + oAuth2Service.getAuthUri(snsType);
	}
	
	// 인터셉터 변경해야함
	// 토큰 발급 및, sns 회원 정보 가져오기
	@RequestMapping("/usr/member/oauth/signup/{snsType}")
	@ResponseBody
	public SnsInfo OAuth2SignupCallback(HttpServletRequest request, @PathVariable String snsType) {
		//String tokenData = oAuth2Service.getTokenData(request);
		Map<String, Object> tokenMap = oAuth2Service.getTokenMap(request.getParameter("code"), snsType);
		
		Map<String, Object> userData = Util.jsonToMap(oAuth2Service.getUserData(tokenMap.get("access_token").toString(), snsType));
		
		SnsInfo snsInfo = oAuth2Service.getSnsInfo(userData, snsType);
		
		return snsInfo;
	}
	
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

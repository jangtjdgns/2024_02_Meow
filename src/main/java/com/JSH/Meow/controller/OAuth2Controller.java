package com.JSH.Meow.controller;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.config.component.GoogleComponent;
import com.JSH.Meow.config.component.KakaoComponent;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.OAuth2Service;
import com.JSH.Meow.service.SnsInfoService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.ResultData;
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
	public String OAuth2SignupCallback(
			HttpServletRequest request
			, @PathVariable String snsType
			, Model model) {
		
		Map<String, Object> tokenData = oAuth2Service.getTokenMap(request.getParameter("code"), snsType);
		
		Map<String, Object> userData = Util.jsonToMap(oAuth2Service.getUserData(tokenData.get("access_token").toString(), snsType));
		
		SnsInfo snsInfo = oAuth2Service.getSnsInfo(userData, snsType);
		
		model.addAttribute("snsInfo", Util.objectTojson(snsInfo));
		
		return "usr/member/loginSns";
	}
	
	// 로그인 기록 확인
	// 기록 없음 -> 회원가입 진행, false
	// 기록 있음 -> 로그인 진행, true
	@RequestMapping("/usr/member/sns/checkLogin")
	@ResponseBody
	public ResultData hasLoggedInBefore(String snsId) {
		
		SnsInfo snsInfo = snsInfoService.getSnsInfoBySnsId(snsId);

		// 기록 없는 경우, 회원가입
		if(snsInfo == null) {
			return ResultData.from("F-1", "회원가입");
		}
		
		// 기록 있는 경우, 로그인
		return ResultData.from("S-1", "로그인", snsInfo.getMemberId());
	}
}

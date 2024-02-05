package com.JSH.Meow.controller;

import java.security.NoSuchAlgorithmException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.util.SHA256;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Member;

@Controller
public class MemberController {
	
	private MemberService memberService;
	
	public MemberController(MemberService memberService) {
		this.memberService = memberService;
	}
	
	
	@RequestMapping("/usr/member/login")
	public String login() {
		
		return "usr/member/login";
	}
	
	@RequestMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw) throws NoSuchAlgorithmException {
		
		System.out.println(loginId);
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if(member == null) {
			return Util.jsHistoryBack(Util.f("%s은(는) 존재하지 않는 아이디입니다.", loginId)); 
		}
		
		SHA256 sha256 = new SHA256();
		
		if(sha256.passwordsNotEqual(loginPw, member.getLoginPw())) {
			return Util.jsHistoryBack("비밀번호가 일치하지 않습니다.");
		}
		
		return Util.jsReplace(Util.f("%s님 환영합니다.", member.getNickname()), "/");
	}
	
}
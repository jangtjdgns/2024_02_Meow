package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.EmailService;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.ResultData;

@Controller
public class EmailController {
	
	private EmailService emailService;
	private MemberService memberService;
	
	public EmailController(EmailService emailService, MemberService memberService) {
		this.emailService = emailService;
		this.memberService = memberService;
	}
	
	// 회원가입 인증번호 발송
	@RequestMapping("/usr/sendMail/join")
	@ResponseBody
	public ResultData sendJoinMail(String email) {
		
		// 가입한 적이 있는지 확인하는 메일, 탈퇴여부도 확인해야할듯
		Member member = memberService.getMemberByEmail(email);
		if(member != null) {
			return ResultData.from("F-1", Util.f("%s은(는) 이미 가입되어있는 이메일입니다.", email));
		}
		
		String authCode = emailService.sendMail(email);
		
		if(Util.isEmpty(authCode)) {
			return ResultData.from("F-2", "인증메일 발송을 실패했습니다.");
		}
		
		return ResultData.from("S-1", "인증메일이 발송되었습니다. 이메일을 확인해주세요.", authCode);
	}
}

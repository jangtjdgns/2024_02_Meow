package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.EmailService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.ResultData;

@Controller
public class EmailController {
	
	private EmailService emailService;
	
	public EmailController(EmailService emailService) {
		this.emailService = emailService;
	}
	
	// 회원가입 인증번호 발송
	@RequestMapping("/usr/sendMail/join")
	@ResponseBody
	public ResultData sendJoinMail(String email) {
		
		String authCode = emailService.sendMail(email);
		
		if(Util.isEmpty(authCode)) {
			return ResultData.from("F-1", "인증메일 발송 실패");
		}
		
		return ResultData.from("S-1", "인증메일이 발송되었습니다.", authCode);
	}
}

package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.JSH.Meow.config.KakaoConfig;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.Rq;

@Controller
public class HomeController {
	
	private MemberService memberService;
	private KakaoConfig kakaoConfig;
	private Rq rq;
	
	public HomeController(MemberService memberService, KakaoConfig kakaoConfig, Rq rq) {
		this.memberService = memberService;
		this.kakaoConfig = kakaoConfig;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/home/main")
	public String main(Model model) {
		
		String memberAddress = "대전광역시 서구 둔산로 52";
		
		Member member = memberService.getMemberById(rq.getLoginedMemberId());
		
		if(member != null) {
			memberAddress = member.getAddress();
		}
		
		model.addAttribute("memberAddress", memberAddress);
		model.addAttribute("javaScriptKey", kakaoConfig.getJavaScriptKey());		// 앱키 js
		
		return "usr/home/main";
	}
	
	@RequestMapping("/")
	public String root() {
		
		return "redirect:/usr/home/main";
	}
	
	@RequestMapping("/test")
	public String test() {
		
        return "test/test"; 
	}
}

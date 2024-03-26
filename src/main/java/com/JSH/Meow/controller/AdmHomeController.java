package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Rq;

@Controller
public class AdmHomeController {
	
	private Rq rq;
	
	public AdmHomeController (Rq rq) {
		this.rq = rq;
	}
	
	// 관리자 메인 페이지
	@RequestMapping("/adm/home/main")
	public String main() {
		
		return "adm/home/main";
	}
	
	// 관리자 getContentJsp
	@RequestMapping("/adm/get/content")
	public String getContentJsp(String type) {
		
		if(type.equals("main")) {
			return "adm/home/mainContent";
		}
		
		return "adm/home/mainContent";
	}
	
	
	
	/* 관리자 root */
	@RequestMapping("/adm")
	public String root1() {
		return getRootUrl();
	}
	
	
	public String root2() {
		return getRootUrl();
	}
	
	private String getRootUrl() {
		if(Util.isEmpty(rq.getAuthLevel()) || rq.getAuthLevel() != 0 ) {
			return "redirect:/adm/member/login";
		}
		
		return "redirect:/adm/home/main";
	}
}

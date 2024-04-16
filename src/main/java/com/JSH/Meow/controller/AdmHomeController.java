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
	@RequestMapping("/adm/content/getJsp")
	public String getContentJsp(String type) {
		
		String jsp = "adm/"; 
				
		switch(type) {
			case "main": return jsp += "home/mainContent";
			case "memberList": return jsp += "memberManagement/list";
			case "articleList": return jsp += "articleManagement/list";
			case "customerList": return jsp += "inquiryManagement/list";
			case "report": return jsp += "common/report";
		}
		
		return "redirect:/adm/home/main";
	}
	
	
	
	/* 관리자 root */
	@RequestMapping("/adm")
	public String root1() {
		return "redirect:/adm/home/main";
	}
	
	@RequestMapping("/adm/")
	public String root2() {
		return "redirect:/adm/home/main";
	}
}

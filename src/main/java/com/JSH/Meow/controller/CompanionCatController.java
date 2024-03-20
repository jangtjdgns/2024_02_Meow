package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.CompanionCatService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Rq;

@Controller
public class CompanionCatController {
	private CompanionCatService companionCatService;
	private Rq rq;
	
	public CompanionCatController(CompanionCatService companionCatService, Rq rq) {
		this.companionCatService = companionCatService;
		this.rq = rq;
	}
	
	// 반려묘 등록 페이지
	@RequestMapping("/usr/companionCat/register")
	public String register() {
		
		return "usr/companionCat/register";
	}
	
	// 반려묘 등록
	@RequestMapping("/usr/companionCat/doRegister")
	@ResponseBody
	public String doRegister(int memberId, String name, String gender, String birthDate, String profileImage, String aboutCat) {
		
		if(memberId != rq.getLoginedMemberId()) {
			return Util.jsHistoryBack("본인 계정이 아닙니다.");
		}
		
		if (Util.isEmpty(name)) {
			return Util.jsHistoryBack("이름을 입력해주세요.");
		}
		
		if(Util.isEmpty(gender)) {
			return Util.jsHistoryBack("성별을 선택해주세요.");
		}
		
		if (Util.isEmpty(birthDate)) {
			return Util.jsHistoryBack("생일을 선택해주세요.");
		}
		
		if (Util.isEmpty(profileImage)) {
			profileImage = null;
		}
		
		if (Util.isEmpty(aboutCat)) {
			aboutCat = null;
		}
		
		companionCatService.doRegister(memberId, name, gender, birthDate, profileImage, aboutCat);
		
		return Util.jsReplace(Util.f("%s 등록 완료!", name), Util.f("/usr/member/profile?memberId=%d", memberId));
	}
}

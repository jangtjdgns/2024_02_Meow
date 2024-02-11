package com.JSH.Meow.controller;

import java.security.NoSuchAlgorithmException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.SnsInfoService;
import com.JSH.Meow.util.SHA256;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.Rq;

@Controller
public class MemberController {
	
	private MemberService memberService;
	private SnsInfoService snsInfoService;
	private Rq rq;
	
	public MemberController(MemberService memberService, SnsInfoService snsInfoService, Rq rq) {
		this.memberService = memberService;
		this.snsInfoService = snsInfoService;
		this.rq = rq;
	}
	
	
	@RequestMapping("/usr/member/login")
	public String login() {
		
		return "usr/member/login";
	}
	
	@RequestMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw) throws NoSuchAlgorithmException {
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if(member == null) {
			return Util.jsHistoryBack(Util.f("%s은(는) 존재하지 않는 아이디입니다.", loginId)); 
		}
		
		SHA256 sha256 = new SHA256();
		
		if(sha256.passwordsNotEqual(loginPw, member.getLoginPw())) {
			return Util.jsHistoryBack("비밀번호가 일치하지 않습니다.");
		}
		
		rq.login(member);
		
		return Util.jsReplace(Util.f("%s님 환영합니다.", member.getNickname()), "/");
	}
	
	@RequestMapping("/usr/member/doLogout")
	@ResponseBody
	public String doLogout() {
		
		rq.logout();
		
		return Util.jsReplace("로그아웃 되었습니다.", "/");
	}
	
	@RequestMapping("/usr/member/profile")
	public String showProfile(Model model, int memberId) {
		
		Member member = memberService.getMemberById(memberId);
		
		if(member == null) {
			return rq.jsReturnOnView(Util.f("%d번 회원은 존재하지 않습니다.", memberId));
		}
		
		String snsType = snsInfoService.getSnsTypeBymemberId(memberId);
		
		model.addAttribute("member", member);
		model.addAttribute("snsType", snsType);
		
		return "usr/member/profile";
	}
	
	
	// 지도 표시, ajax
	@RequestMapping("/usr/member/getMembers")
	@ResponseBody
	public List<Member> getMembers() {
		
		List<Member> members = memberService.getMembersExceptLoginedMember(rq.getLoginedMemberId());
		
		return members;
	}
}
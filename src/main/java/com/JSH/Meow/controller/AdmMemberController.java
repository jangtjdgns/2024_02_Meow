package com.JSH.Meow.controller;

import java.security.NoSuchAlgorithmException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.CompanionCatService;
import com.JSH.Meow.service.EmailService;
import com.JSH.Meow.service.MemberDeletionService;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.SnsInfoService;
import com.JSH.Meow.service.UploadService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;
import com.JSH.Meow.vo.Status;

/** 
 * AdminController
 * 관리자 컨트롤러
 * */

@Controller
public class AdmMemberController {
	private MemberService memberService;
	private MemberDeletionService memberDeletionService;
	private CompanionCatService companionCatService;
	private SnsInfoService snsInfoService;
	private EmailService emailService;
	private UploadService uploadService;
	private Rq rq;
	
	public AdmMemberController(MemberService memberService, MemberDeletionService memberDeletionService, CompanionCatService companionCatService, SnsInfoService snsInfoService, EmailService emailService, UploadService uploadService, Rq rq) {
		this.memberService = memberService;
		this.memberDeletionService = memberDeletionService;
		this.companionCatService = companionCatService;
		this.snsInfoService = snsInfoService;
		this.emailService = emailService;
		this.uploadService = uploadService;
		this.rq = rq;
	}
	
	// 로그인 페이지
	@RequestMapping("/adm/member/login")
	public String login() {
		
		return "adm/member/login";
	}
	
	// 로그인
	@RequestMapping("/adm/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw) throws NoSuchAlgorithmException {
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if(member == null) {
			return Util.jsHistoryBack(Util.f("%s은(는) 존재하지 않는 아이디입니다.", loginId)); 
		}
		
		// 비밀번호 일치유무 가져오기
		boolean equalsPw = memberService.getPasswordEquality(loginPw, member.getLoginPw());
		
		if(equalsPw) {
			return Util.jsHistoryBack("비밀번호가 일치하지 않습니다.");
		}
		
		// 관리자 권한이 없는 경우
		if(member.getAuthLevel() != 0) {
			return Util.jsHistoryBack("해당 계정은 관리자 권한이 없습니다.");
		}
		
		rq.login(member);
		
		return Util.jsReplace(Util.f("%s님 환영합니다.", member.getNickname()), "/adm");
	}
	
	
	// 회원 상태 정보 가져오기(pie 차트에 사용), ajax
	@RequestMapping("/adm/member/getStatus")
	@ResponseBody
	public ResultData<List<Status>> getStatus() {
		
		List<Status> status = memberService.getStatus();
		
		return ResultData.from("S-1", "성공", status);
	}
}

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
import com.JSH.Meow.vo.ResultData;
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
	
	@RequestMapping("/usr/member/join")
	public String join() {
		
		return "usr/member/join";
	}
	
	@RequestMapping("/usr/member/duplicationCheck")
	@ResponseBody
	public ResultData duplicationCheck(String loginId) {
		
		if(Util.isEmpty(loginId)) {
			return  ResultData.from("F-1", "아이디를 입력해주세요.");
		}
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if(member != null) {
			return ResultData.from("F-2", Util.f("%s 은(는) 이미 사용중인 아이디입니다.", loginId));
		}
		
		return ResultData.from("S-1", Util.f("%s 은(는) 사용가능한 아이디입니다.", loginId));
	}
	
	@RequestMapping("/usr/member/doJoin")
	@ResponseBody
	public String doJoin(String loginId
				, String loginPw
				, String name
				, String nickname
				, int age
				, String address
				, String cellphoneNum
				, String email
				, String profileImage
				, String aboutMe) {
		
		if (Util.isEmpty(loginId)) {
			return Util.jsHistoryBack("아이디를 입력해주세요.");
		}
		
		if (Util.isEmpty(loginPw)) {
			return Util.jsHistoryBack("비밀번호를 입력해주세요.");
		}
		
		if (Util.isEmpty(name)) {
			return Util.jsHistoryBack("이름을 입력해주세요.");
		}
		
		if (Util.isEmpty(nickname)) {
			return Util.jsHistoryBack("닉네임을 입력해주세요.");
		}
		
		if (Util.isEmpty(age)) {
			return Util.jsHistoryBack("나이를 입력해주세요.");
		}
		
		if (Util.isEmpty(address)) {
			return Util.jsHistoryBack("주소를 입력해주세요.");
		}
		
		if (Util.isEmpty(cellphoneNum)) {
			return Util.jsHistoryBack("전화번호를 입력해주세요.");
		}
		
		if (Util.isEmpty(email)) {
			return Util.jsHistoryBack("이메일을 입력해주세요.");
		}
		
		if (Util.isEmpty(profileImage)) {
			profileImage = null;
		}
		
		if (Util.isEmpty(aboutMe)) {
			aboutMe = null;
		}
		
		Member member = memberService.getMemberByLoginId(loginId);

		if (member != null) {
			return Util.jsHistoryBack(Util.f("%s은(는) 이미 사용중인 아이디입니다.", loginId));
		}
		
		SHA256 sha256 = new SHA256();
		
		try {
			loginPw = sha256.encrypt(loginPw);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		
		memberService.joinMember(loginId, loginPw, name, nickname, age, address, cellphoneNum, email, profileImage, aboutMe);
		
		return Util.jsReplace(Util.f("%s 님이 가입되었습니다.", nickname), "/");
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
	
	
	@RequestMapping("/usr/member/modify")
	public String modify(Model model, int memberId) {
		// 권한체크
		
		Member member = memberService.getMemberById(memberId);
		
		if(member == null) {
			return rq.jsReturnOnView(Util.f("%d번 회원은 존재하지 않습니다.", memberId));
		}
		
		model.addAttribute("member", member);
		
		return "usr/member/modify";
	}
	
	
	// 지도 표시, ajax
	@RequestMapping("/usr/member/getMembers")
	@ResponseBody
	public List<Member> getMembers() {
		
		List<Member> members = memberService.getMembers();
		
		for(Member member : members) {
			String address = Util.getAddress(member.getAddress());
			member.setAddress(address);
		}
		
		System.out.println(members);
		
		return members;
	}
}
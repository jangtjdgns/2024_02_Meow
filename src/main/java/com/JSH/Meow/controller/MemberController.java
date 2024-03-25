package com.JSH.Meow.controller;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.JSH.Meow.service.CompanionCatService;
import com.JSH.Meow.service.EmailService;
import com.JSH.Meow.service.MemberDeletionService;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.SnsInfoService;
import com.JSH.Meow.service.UploadService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.CompanionCat;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class MemberController {
	
	private MemberService memberService;
	private MemberDeletionService memberDeletionService;
	private CompanionCatService companionCatService;
	private SnsInfoService snsInfoService;
	private EmailService emailService;
	private UploadService uploadService;
	private Rq rq;
	
	public MemberController(MemberService memberService, MemberDeletionService memberDeletionService, CompanionCatService companionCatService, SnsInfoService snsInfoService, EmailService emailService, UploadService uploadService, Rq rq) {
		this.memberService = memberService;
		this.memberDeletionService = memberDeletionService;
		this.companionCatService = companionCatService;
		this.snsInfoService = snsInfoService;
		this.emailService = emailService;
		this.uploadService = uploadService;
		this.rq = rq;
	}
	
	
	// 회원가입 페이지
	@RequestMapping("/usr/member/join")
	public String join() {
		
		return "usr/member/join";
	}
	
	
	// 회원가입
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
				, @RequestParam MultipartFile[] profileImage
				, String aboutMe) throws NoSuchAlgorithmException, IOException {
		
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
		
		if (Util.isEmpty(aboutMe)) {
			aboutMe = null;
		}
		if (aboutMe.length() > 100) {
			return Util.jsHistoryBack("최대 100글자 입력이 가능합니다.");
		}
		
		Member member = memberService.getMemberByLoginId(loginId);

		if (member != null) {
			return Util.jsHistoryBack(Util.f("%s은(는) 이미 사용중인 아이디입니다.", loginId));
		}
		
		// 비밀번호 암호화
		String encryptPw = memberService.encryptPassword(loginPw);
		
		// 이미지
		String imagePath = null;
		for(MultipartFile image: profileImage) {
			// 이미지 확장자 확인, jpg, jpeg, png, gif 가능
			boolean isImageTypeSupported = uploadService.isImageTypeValid(image);
			
			if(isImageTypeSupported) {
				// 이미지 업로드
				uploadService.uploadFile(image, "member");
				imagePath = uploadService.getProfileImagePath("member");
				break;
			}
		}
		
		memberService.joinMember(loginId, encryptPw, name, nickname, age, address, cellphoneNum, email, imagePath, aboutMe);

		return Util.jsReplace(Util.f("%s 님이 가입되었습니다.", nickname), "/");
	}
	
	// 회원가입 인증번호 발송, ajax
	@RequestMapping("/usr/sendMail/join")
	@ResponseBody
	public ResultData sendJoinMail(String email) {
		
		// 가입한 적이 있는지 확인하는 메일, 탈퇴여부도 확인해야할듯
		Member member = memberService.getMemberByEmail(email);
		if(member != null) {
			return ResultData.from("F-1", Util.f("%s은(는) 이미 가입되어있는 이메일입니다.", email));
		}
		
		String authCode = emailService.sendJoinMail(email);
		
		if(Util.isEmpty(authCode)) {
			return ResultData.from("F-2", "인증메일 발송을 실패했습니다.");
		}
		
		return ResultData.from("S-1", "인증메일이 발송되었습니다. 이메일을 확인해주세요.", authCode);
	}
	
	// 로그인 페이지
	@RequestMapping("/usr/member/login")
	public String login() {
		
		return "usr/member/login";
	}
	
	
	// 로그인
	@RequestMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw) throws NoSuchAlgorithmException {
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if(member == null) {
			return Util.jsHistoryBack(Util.f("%s은(는) 존재하지 않는 아이디입니다.", loginId)); 
		}
		
		// 탈퇴 회원인 경우 로그인 제한
		if(member.getStatus() == 3) {
			return Util.jsHistoryBack("탈퇴 처리된 계정입니다");
		}
		
		// 비밀번호 일치유무 가져오기
		boolean equalsPw = memberService.getPasswordEquality(loginPw, member.getLoginPw());
		
		if(equalsPw) {
			return Util.jsHistoryBack("비밀번호가 일치하지 않습니다.");
		}
		
		rq.login(member);
		
		return Util.jsReplace(Util.f("%s님 환영합니다.", member.getNickname()), "/");
	}
	
	
	// 로그아웃
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
		
		List<CompanionCat> companionCats = companionCatService.getCompanionCats(memberId);
		
		model.addAttribute("member", member);
		model.addAttribute("snsType", snsType);
		model.addAttribute("companionCats", companionCats);
		
		return "usr/member/profile";
	}
	
	
	// 계정 관리 페이지
	@RequestMapping("/usr/member/userAccount")
	public String userAccount(int memberId) {
		
		Member member = memberService.getMemberById(memberId);
		
		// 존재 유뮤 확인
		if(member == null) {
			return rq.jsReturnOnView(Util.f("%d번 회원은 존재하지 않습니다.", memberId));
		}
		
		// 권한 체크
		if(memberId != rq.getLoginedMemberId()) {
			return rq.jsReturnOnView("본인 계정이 아닙니다.");
		}
		
		return "usr/member/userAccount";
	}
	
	
	// 계정 관리 관련 jsp 가져오기 (수정, 비밀번호 재설정, 삭제), ajax
	@RequestMapping("/usr/member/getUserAccountJsp")
	public String getUserAccountJsp(Model model, int memberId, @RequestParam(defaultValue = "-1") int sectionNo) {
		
		Member member = memberService.getMemberById(memberId);
		
		String jspPath = null;
		
		if(sectionNo == 0) {
			// sns 회원은 계정 수정이 불가함, 단, 이미지, 소개말은 가능 (+주소?)
			String snsType = snsInfoService.getSnsTypeBymemberId(memberId);
			
			if(snsType != null) {
				return rq.jsReturnOnView("SNS 로그인 회원은 계정 정보 수정이 불가합니다.");
			}
			
			model.addAttribute("member", member);
			
			jspPath = "usr/member/modify";
		} else if(sectionNo == 1) {
			jspPath = "usr/member/resetLoginPwLogined";
		}
		else if(sectionNo == 2) {
			jspPath = "usr/member/delete";
		} else {
			jspPath = "usr/member/userAccountDefault";
		}
		
		return jspPath;
	}
	
	
	// 한개만 수정해도 모든 값을 다가져와서 수정하고있음, 후에 수정예정
	@RequestMapping("/usr/member/doModify")
	@ResponseBody
	public String doModify(int memberId, String name, int age, String address, String cellphoneNum, String email) {
		
		Member member = memberService.getMemberById(memberId);
		
		// 존재 유뮤 확인
		if(member == null) {
			return rq.jsReturnOnView(Util.f("%d번 회원은 존재하지 않습니다.", memberId));
		}
		
		// 권한 체크
		if(memberId != rq.getLoginedMemberId()) {
			return rq.jsReturnOnView("본인 계정이 아닙니다.");
		}

		String snsType = snsInfoService.getSnsTypeBymemberId(memberId);
		
		if(snsType != null) {
			return rq.jsReturnOnView("SNS 로그인 회원은 계정 정보 변경이 불가합니다.");
		}
		
		memberService.doModify(memberId, name, age, address, cellphoneNum, email);
		
		return Util.jsReplace(Util.f("%s님의 계정 정보가 변경되었습니다.", member.getNickname()), "/");
	}
	
	
	@RequestMapping("/usr/member/doDelete")
	@ResponseBody
	public String doDelete(int memberId, String deletionReasonCode, @RequestParam(defaultValue = "") String customDeletionReason) {
		
		Member member = memberService.getMemberById(memberId);
		
		// 존재 유뮤 확인
		if(member == null) {
			return rq.jsReturnOnView(Util.f("%d번 회원은 존재하지 않습니다.", memberId));
		}
		
		// 권한 체크
		if(memberId != rq.getLoginedMemberId()) {
			return rq.jsReturnOnView("본인 계정이 아닙니다.");
		}
		
		// 업로드된 회원 프로필이미지는 삭제 진행
		if(!Util.isEmpty(member.getProfileImage())) {			
			uploadService.deleteProfileImage(member.getProfileImage());
		}
		
		// 실제로 데이터 삭제 X, status 칼럼을 3(탈퇴)로 변경
		memberService.doDelete(memberId, 3);
		
		// 탈퇴 이유 추가
		memberDeletionService.writeDeletionReason(memberId, deletionReasonCode, customDeletionReason);
		
		// 세션 초기화
		rq.logout();
		
		return Util.jsReplace("탈퇴되었습니다.", "/");
	}
	
	
	// 회원가입 중복확인, ajax
	@RequestMapping("/usr/member/duplicationCheck")
	@ResponseBody
	public ResultData duplicationCheck(String type, String inputVal) {
		
		String inputName = type.equals("loginId") ? "아이디" : "닉네임";
		
		if(Util.isEmpty(inputVal)) {
			return ResultData.from("F-1", Util.f("%s를 입력해주세요.", inputName));
		}
		
		Member member = null;
		if(type.equals("loginId")) {
			member = memberService.getMemberByLoginId(inputVal);
		} else {
			member = memberService.getMemberByNickname(inputVal);
		}
		
		if(member != null) {
			return ResultData.from("F-2", Util.f("%s 은(는) 이미 사용중인 %s입니다.", inputVal, inputName));
		}
		
		return ResultData.from("S-1", Util.f("%s 은(는) 사용가능한 %s입니다.", inputVal, inputName));
	}
	
	
	// 메인페이지 지도 마커 표시용, ajax
	@RequestMapping("/usr/member/getMembers")
	@ResponseBody
	public ResultData<List<Member>> getMembers() {
		
		List<Member> members = memberService.getMembers();
		
		if(members.size() == 0) {
			return ResultData.from("F-1", "현재 등록된 회원이 없습니다.");
		}
		
		for(Member member : members) {
			// sns 회원의 경우 주소가 없음
			if(member.getAddress().length() == 0) {
				continue;
			}
			
			String address = Util.convertAddressJsonToString(member.getAddress());
			member.setAddress(address);
		}
		
		return ResultData.from("S-1", "성공", members);
	}
	
	// 메인페이지 지도 마커 커스텀 오버레이의 닉네임 클릭 시, ajax
	@RequestMapping("/usr/member/getMemberById")
	@ResponseBody
	public ResultData getMemberById(int memberId) {
		
		Member member = memberService.getMemberById(memberId);
		List<CompanionCat> companionCats = companionCatService.getCompanionCats(memberId);
		
		if(member == null) {
			return ResultData.from("F-1", Util.f("%s 회원은 존재하지 않습니다.", member.getNickname()));
		}
		
		// 두 개의 타입 반환
		Map<String, Object> result = new HashMap<>();
		result.put("member", member);
		result.put("companionCats", companionCats);
		
		return ResultData.from("S-1", "성공", result);
	}
	
	// 아이디 찾기 페이지
	@RequestMapping("/usr/find/loginId")
	public String findLoginId() {
		
		return "usr/member/findLoginId";
	}
	
	// 아이디 찾기, ajax
	@RequestMapping("/usr/doFind/loginId")
	@ResponseBody
	public ResultData doFindLoginId(String name, String email) {
		
		Member member = memberService.getMemberByCredentials(name, "", email);
		
		if(member == null) {
			return ResultData.from("F-1", "해당 정보와 일치하는 회원을 찾을 수 없습니다.");
		}
		
		// 탈퇴 회원인 경우
		if(member.getStatus() == 3) {
			return ResultData.from("F-2", "탈퇴 처리된 계정입니다");
		}
		
		if(!Util.isEmpty(member.getSnsType())) {
			return ResultData.from("F-3", "SNS를 통해 가입된 회원입니다. " + member.getSnsType() + "에서 아이디 찾기를 진행해주세요.");
		}
		
		emailService.sendIdFoundEmail(email, name, member.getLoginId());
		
		return ResultData.from("S-1", "해당 이메일로 아이디가 발송 되었습니다.");
	}
	
	
	// 비밀번호 재설정 이메일 인증 페이지
	@RequestMapping("/usr/reset/loginPw")
	public String resetLoginPwAuth() {
		
		return "usr/member/resetLoginPw";
	}
	
	// 비밀번호 재설정 이메일 인증 및 발송, ajax
	@RequestMapping("/usr/sendMail/resetPassword")
	@ResponseBody
	public ResultData sendPwResetEmail(String name, String loginId, String email) {
		
		Member member = memberService.getMemberByCredentials(name, loginId, email);
		
		if(member == null) {
			return ResultData.from("F-1", "해당 정보와 일치하는 회원을 찾을 수 없습니다.");
		}
		
		// 탈퇴 회원인 경우
		if(member.getStatus() == 3) {
			return ResultData.from("F-2", "탈퇴 처리된 계정입니다");
		}
		
		String authCode = emailService.sendPwResetEmail(email);
		
		member.setAuthCode(authCode);
		
		return ResultData.from("S-1", "이메일 인증이 완료되었습니다. <br />해당 이메일을 통해 비밀번호 재설정을 진행해주세요.", member);
	}
	
	// 비밀번호 재설정, ajax
	@RequestMapping("/usr/doReset/loginPw")
	@ResponseBody
	public ResultData resetLoginPwPop(@RequestParam(defaultValue = "0")int memberId, String resetLoginPw) throws NoSuchAlgorithmException {
		
		if(memberId == 0 && rq.getLoginedMemberId() == 0) {
			return ResultData.from("F-1", "이메일 인증이 확인되지 않았습니다.");
		}
		
		Member member = memberService.getMemberById(memberId);
		
		// 이미 사용중인 비밀번호인지 확인
		boolean usedPwCheck = memberService.getPasswordEquality(resetLoginPw, member.getLoginPw());
		if(!usedPwCheck) {
			return ResultData.from("F-3", "이전에 사용하던 비밀번호와 같습니다.<br>다른 비밀번호를 사용해주세요.");
		}
		
		// 비밀번호 암호화
		String encryptPw = memberService.encryptPassword(resetLoginPw);
		
		memberService.doResetLoginPw(memberId, encryptPw);
		
		// 로그인 전용 비밀번호 설정인 경우
		if(rq.getLoginedMemberId() != 0) {
			rq.logout();
			return ResultData.from("S-1", "비밀번호가 변경되었습니다. 다시 로그인 해주세요.");
		}
		
		return ResultData.from("S-2", "비밀번호가 변경되었습니다.");
	}
	
}
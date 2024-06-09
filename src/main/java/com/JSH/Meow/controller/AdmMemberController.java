package com.JSH.Meow.controller;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import org.springframework.stereotype.Controller;
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
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;
import com.JSH.Meow.vo.statistics.MemberStatus;

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
		memberService.updateLastLoginDate(member.getId());
		
		
		return Util.jsReplace(Util.f("%s님 환영합니다.", member.getNickname()), "/adm");
	}
	
	// 로그아웃
	@RequestMapping("/adm/member/doLogout")
	@ResponseBody
	public String doLogout() {
		rq.logout();
		
		return Util.jsReplace("로그아웃 되었습니다.", "/adm/member/login");
	}
	
	
	// 회원 목록 가져오기, ajax
	@RequestMapping("/adm/member/list")
	@ResponseBody
	public ResultData<List<Member>> memberList(
			@RequestParam(defaultValue = "1") int page
			, @RequestParam(defaultValue = "10") int memberCnt
			, @RequestParam(defaultValue = "all") String searchType
			, @RequestParam(defaultValue = "") String searchKeyword
			, @RequestParam(defaultValue = "all") String memberType
			, @RequestParam(defaultValue = "false") boolean order) {
		
		// 표시 회원수를 기준으로 limit 시작 설정
		int limitFrom = (page - 1) * memberCnt;
		
		List<Member> members = memberService.admGetMembers(limitFrom, memberCnt, searchType, searchKeyword, memberType, order);
		
		if(members.size() == 0) {
			return ResultData.from("F-1", "검색에 일치하는 회원이 없습니다.", members);
		}
		
		return ResultData.from("S-1", "회원 조회 성공", members);
	}
	
	
	// 회원 상세 정보 가져오기, ajax
	@RequestMapping("/adm/member/detail")
	@ResponseBody
	public ResultData<Member> getMember(int memberId) {
		
		Member member = memberService.admGetMemberById(memberId);
		
		return ResultData.from("S-1", "회원 조회 성공", member);
	}
	
	
	// 회원 상태 정보 가져오기(pie 차트에 사용), ajax
	@RequestMapping("/adm/member/getStatus")
	@ResponseBody
	public ResultData<List<MemberStatus>> getStatus() {
		
		List<MemberStatus> status = memberService.getStatus();
		
		return ResultData.from("S-1", "성공", status);
	}
	
	// 지도 마커 표시용 회원 목록 가져오기, ajax
	@RequestMapping("/adm/member/getMembers")
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
	
	// 프로필 이미지 변경, ajax
	@RequestMapping("/adm/member/profileImage/doUpdate")
	@ResponseBody
	public ResultData doUpdateProfileImage(int memberId, @RequestParam MultipartFile[] profileImage) throws NoSuchAlgorithmException, IOException {
		
		// 본인 확인
		if(memberId != rq.getLoginedMemberId()) {
			return ResultData.from("F-1", "변경 권한이 없습니다."); 
		}
		
		// 이미지
		Member member = memberService.getMemberById(memberId);
		String imagePath = member.getProfileImage();
		
		for(MultipartFile image: profileImage) {
			// 이미지 확장자 확인, jpg, jpeg, png, gif 가능
			boolean isImageTypeSupported = uploadService.isImageTypeValid(image);
			
			if(isImageTypeSupported) {
				// 업로드된 기존 이미지를 삭제
				if(!Util.isEmpty(imagePath)) {			
					uploadService.deleteProfileImage(imagePath);
				}
				
				// 이미지 업로드
				uploadService.uploadFile(image, "member");
				imagePath = uploadService.getProfileImagePath("member");
				break;
			}
		}
		
		// 프로필 이미지 변경
		memberService.updateProfileImage(memberId, imagePath);
		rq.updateProfileImage(imagePath);
		
		return ResultData.from("S-1", "프로필 이미지가 변경되었습니다.<br /><span class='text-xs'>* 새로고침을 진행해주세요.</span>");
	}
		
}

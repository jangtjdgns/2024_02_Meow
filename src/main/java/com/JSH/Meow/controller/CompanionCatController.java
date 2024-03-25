package com.JSH.Meow.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.JSH.Meow.service.CompanionCatService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.CompanionCat;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class CompanionCatController {
	private CompanionCatService companionCatService;
	private Rq rq;
	
	public CompanionCatController(CompanionCatService companionCatService, Rq rq) {
		this.companionCatService = companionCatService;
		this.rq = rq;
	}
	
	
	// 내 반려묘 페이지
	@RequestMapping("/usr/companionCat/view")
	public String view(Model model, int memberId) {
		
		if(memberId != rq.getLoginedMemberId()) {
			return rq.jsReturnOnView("해당 페이지에 대한 접근 권한이 없습니다.");
		}
		
		List<CompanionCat> companionCats = companionCatService.getCompanionCats(memberId); 
		
		model.addAttribute("companionCats", companionCats);
		
		return "usr/companionCat/view";
	}
	
	
	// 반려묘 등록 페이지
	@RequestMapping("/usr/companionCat/register")
	public String register() {
		
		return "usr/companionCat/register";
	}
	
	// 반려묘 등록
	@RequestMapping("/usr/companionCat/doRegister")
	@ResponseBody
	public String doRegister(
			int memberId
			, String name
			, String gender
			, String birthDate
			, @RequestParam MultipartFile[] profileImage
			, String aboutCat) throws IOException {
		
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
		
		if (Util.isEmpty(aboutCat)) {
			aboutCat = null;
		}
		
		// 이미지
		String imagePath = null;
		for(MultipartFile image: profileImage) {
			// 이미지 타입 확인, jpg, jpeg, png, gif 가능
			boolean isImageTypeSupported = companionCatService.isImageTypeValid(image);
			
			if(isImageTypeSupported) {
				// 이미지 업로드
				companionCatService.uploadFile(image, "companionCat");
				imagePath = companionCatService.getProfileImagePath("companionCat");
				break;
			}
		}
		
		companionCatService.doRegister(memberId, name, gender, birthDate, imagePath, aboutCat);
		
		return Util.jsReplace(Util.f("%s 등록 완료!", name), Util.f("/usr/companionCat/view?memberId=%d", memberId));
	}
	
	
	// 반려묘 수정 페이지
	@RequestMapping("/usr/companionCat/modify")
	public String modify(Model model, int catId) {
		
		CompanionCat companionCat = companionCatService.getCompanionCatById(catId);
		
		model.addAttribute("companionCat", companionCat);
		
		return "usr/companionCat/modify";
	}
	
	// 반려묘 수정
	@RequestMapping("/usr/companionCat/doModify")
	@ResponseBody
	public String doModify(
			int memberId
			, int catId
			, String name
			, String gender
			, String birthDate
			, @RequestParam MultipartFile[] profileImage
			, String aboutCat) throws IOException {
		
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
		
		if (Util.isEmpty(aboutCat)) {
			aboutCat = null;
		}
		
		
		CompanionCat companionCat = companionCatService.getCompanionCatById(catId);
		if(companionCat == null) {
			return Util.jsHistoryBack("해당 반려묘에 대한 정보가 없습니다.");
		}
		
		// 이미지
		String imagePath = null;
		for(MultipartFile image: profileImage) {
			// 이미지 타입 확인, jpg, jpeg, png, gif 가능
			boolean isImageTypeSupported = companionCatService.isImageTypeValid(image);
			
			// 수정시 이미지를 등록 안했을 경우 break;
			if(!isImageTypeSupported) {
				imagePath = companionCat.getProfileImage();
				break;
			}
			
			// 이미지를 등록한 경우
			if(isImageTypeSupported) {
				// 업로드된 기존 이미지를 삭제
				if(!Util.isEmpty(companionCat.getProfileImage())) {			
					companionCatService.deleteProfileImage(companionCat.getProfileImage());
				}
				
				// 새로운 이미지 업로드
				companionCatService.uploadFile(image, "companionCat");
				imagePath = companionCatService.getProfileImagePath("companionCat");
				break;
			}
		}
		
		// 동적 sql을 통해 필요한 데이터만 업데이트 하기 위해 미리 검증
		name = companionCat.getName().equals(name) ? null : name;
		gender = companionCat.getGender().equals(gender) ? null : gender;
		birthDate = companionCat.getBirthDate().equals(birthDate) ? null : birthDate;
		imagePath = companionCat.getProfileImage().equals(imagePath) ? null : imagePath;
		aboutCat = companionCat.getAboutCat().equals(aboutCat) ? null : aboutCat;
		
		companionCatService.doModify(catId, name, gender, birthDate, imagePath, aboutCat);
		
		return Util.jsReplace(Util.f("%s 수정 완료!", name), Util.f("/usr/companionCat/view?memberId=%d", memberId));
	}
	
	
	// 반려묘 삭제, ajax
	@RequestMapping("/usr/companionCat/doDelete")
	@ResponseBody
	public ResultData doDelete(int memberId, int catId) {
		
		if(memberId != rq.getLoginedMemberId()) {
			return ResultData.from("F-1", "해당 반려묘에 대한 권한이 없습니다.");
		}
		
		CompanionCat companionCat = companionCatService.getCompanionCatById(catId);
		
		if(companionCat == null) {
			return ResultData.from("F-2", "해당 반려묘에 대한 정보가 없습니다.");
		}
		
		// 업로드된 이미지 삭제
		if(!Util.isEmpty(companionCat.getProfileImage())) {			
			companionCatService.deleteProfileImage(companionCat.getProfileImage());
		}
		companionCatService.doDelete(catId);
		
		return ResultData.from("S-1", "해당 반려묘에 대한 정보가 삭제 되었습니다.");
	}
}

package com.JSH.Meow.service;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.JSH.Meow.config.component.UploadComponent;
import com.JSH.Meow.dao.MemberDao;
import com.JSH.Meow.util.SHA256;
import com.JSH.Meow.vo.Member;

@Service
public class MemberService {

	private MemberDao memberDao;
	private UploadComponent uploadComponent;

	public MemberService(MemberDao memberDao, UploadComponent uploadComponent) {
		this.memberDao = memberDao;
		this.uploadComponent = uploadComponent;
	}

	public Member getMemberById(int id) {
		return memberDao.getMemberById(id);
	}
	
	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}

	public Member getMemberByNickname(String nickname) {
		return memberDao.getMemberByNickname(nickname);
	}
	
	public Member getMemberByEmail(String email) {
		return memberDao.getMemberByEmail(email);
	}
	
	public List<Member> getMembers() {
		return memberDao.getMembers();
	}
	
	public void joinMember(String loginId, String loginPw, String name, String nickname, int age, String address, String cellphoneNum, String email, String profileImage, String aboutMe) {
		memberDao.joinMember(loginId, loginPw, name, nickname, age, address, cellphoneNum, email, profileImage, aboutMe);
	}

	public int getLastInsertId() {
		return memberDao.getLastInsertId();
	}

	public List<Member> getMembersExceptLoginedMember(int loginedMemberId) {
		return memberDao.getMembersExceptLoginedMember(loginedMemberId);
	}

	public void doModify(int memberId, String name, int age, String address, String cellphoneNum, String email) {
		memberDao.doModify(memberId, name, age, address, cellphoneNum, email);
	}

	public void doDelete(int memberId, int status) {
		memberDao.doDelete(memberId, status);
	}
	
	// 비밀번호 암호화
	public String encryptPassword(String loginPw) throws NoSuchAlgorithmException {
		return new SHA256().encrypt(loginPw);
	}
	
	// 비밀번호 일치유무 가져오기
	public boolean getPasswordEquality(String loginPw, String chkLoginPw) throws NoSuchAlgorithmException {
		return new SHA256().getPasswordEquality(loginPw, chkLoginPw);
	}
	
	// 이미지 타입 확인
	public boolean isImageTypeValid(MultipartFile image) {
		return uploadComponent.isImageTypeValid(image);
	}
	
	// 파일 업로드
	public void uploadFile(MultipartFile image) throws IOException {
		uploadComponent.uploadFile(image);
	}
	
	// 프로필 이미지 가져오기
	public String getProfileImagePath() {
		return uploadComponent.getProfileImagePath();
	}
}

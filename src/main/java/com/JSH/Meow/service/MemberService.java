package com.JSH.Meow.service;

import java.security.NoSuchAlgorithmException;
import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.config.component.UploadComponent;
import com.JSH.Meow.dao.MemberDao;
import com.JSH.Meow.util.SHA256;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.statistics.MemberStatus;

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
	

	public Member admGetMemberById(int memberId) {
		return memberDao.admGetMemberById(memberId);
	}
	
	public List<Member> admGetMembers(int limitFrom, int memberCnt, String searchType, String searchKeyword, String memberType, boolean order) {
		return memberDao.admGetMembers(limitFrom, memberCnt, searchType, searchKeyword, memberType, order);
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
	
	// 자격 인증 [인증이 필요한 매개변수: 이름, 아이디, 이메일] (아이디 찾기, 비밀번호 재설정에서 사용)
	public Member getMemberByCredentials(String name, String loginId, String email) {
		return memberDao.getMemberByCredentials(name, loginId, email);
	}
	
	// 비밀번호 변경
	public void doResetLoginPw(int memberId, String resetLoginPw) {
		memberDao.doResetLoginPw(memberId, resetLoginPw);
	}
	
	
	// 회원 상태 가져오기
	public List<MemberStatus> getStatus() {
		return memberDao.getStatus();
	}
	
	// 프로필 이미지 변경
	public void updateProfileImage(int id, String imagePath) {
		memberDao.updateProfileImage(id, imagePath);
	}
}

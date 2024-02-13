package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.MemberDao;
import com.JSH.Meow.vo.Member;

@Service
public class MemberService {

	private MemberDao memberDao;

	public MemberService(MemberDao memberDao) {
		this.memberDao = memberDao;
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

	
}

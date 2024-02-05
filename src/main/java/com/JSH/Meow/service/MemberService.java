package com.JSH.Meow.service;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.MemberDao;
import com.JSH.Meow.vo.Member;

@Service
public class MemberService {

	private MemberDao memberDao;
	
	public MemberService(MemberDao memberDao) {
		this.memberDao = memberDao;
	}

	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}
	
	
}

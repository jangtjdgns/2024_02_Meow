package com.JSH.Meow.service;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.MemberDeletionDao;

@Service
public class MemberDeletionService {
	private MemberDeletionDao memberDeletionDao;
	
	public MemberDeletionService(MemberDeletionDao memberDeletionDao) {
		this.memberDeletionDao = memberDeletionDao;
	}
	
	public void writeDeletionReason(int memberId, String deletionReasonCode, String customDeletionReason) {
		memberDeletionDao.writeDeletionReason(memberId, deletionReasonCode, customDeletionReason);
	}
}

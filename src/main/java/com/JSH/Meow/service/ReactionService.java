package com.JSH.Meow.service;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.ReactionDao;
import com.JSH.Meow.vo.Reaction;

@Service
public class ReactionService {
	private ReactionDao reactionDao;
	
	public ReactionService(ReactionDao reactionDao) {
		this.reactionDao = reactionDao;
	}
	
	
	public Reaction getreaction(int memberId, String relTypeCode, int relId, int reactionType) {
		return reactionDao.getreaction(memberId, relTypeCode, relId, reactionType);
	}
	
	public void insertPoint(int memberId, String relTypeCode, int relId, int reactionType) {
		reactionDao.insertPoint(memberId, relTypeCode, relId, reactionType);
	}
	
	public void deletePoint(int memberId, String relTypeCode, int relId, int reactionType) {
		reactionDao.deletePoint(memberId, relTypeCode, relId, reactionType);
	}

	public int getReactionCount(String relTypeCode, int relId, int reactionType) {
		return reactionDao.getReactionCount(relTypeCode, relId, reactionType);
	}
}

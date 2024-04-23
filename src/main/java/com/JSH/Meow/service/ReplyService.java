package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.ReplyDao;
import com.JSH.Meow.vo.Reply;
import com.JSH.Meow.vo.statistics.ReplyStatus;

@Service
public class ReplyService {
	
	private ReplyDao replyDao;
	
	public ReplyService(ReplyDao replyDao) {
		this.replyDao = replyDao;
	}
	
	
	public Reply getReplyById(int id) {
		return replyDao.getReplyById(id);
	}
	
	public List<Reply> getReplies(int relId, String relTypeCode) {
		
		return replyDao.getReplies(relId, relTypeCode);
	}
	
	public List<Reply> admGetReplies(int limitFrom, int replyCnt, String searchType, String searchKeyword, boolean order) {
		
		return replyDao.admGetReplies(limitFrom, replyCnt, searchType, searchKeyword, order);
	}

	public void doWrite(int loginedMemberId, int relId, String relTypeCode, String body) {
		replyDao.doWrite(loginedMemberId, relId, relTypeCode, body);
	}

	public int getLastInsertId() {
		return replyDao.getLastInsertId();
	}

	public int getTotalCountByRelId(int relId) {
		return replyDao.getTotalCountByRelId(relId);
	}

	public void doModify(int id, String body) {
		replyDao.doModify(id, body);
	}

	public void doDelete(int id) {
		replyDao.doDelete(id);
	}

	public List<ReplyStatus> showWriteFreq(int memberId) {
		return replyDao.showWriteFreq(memberId);
	}
	
}

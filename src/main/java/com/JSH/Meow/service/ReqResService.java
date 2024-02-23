package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.ReqResDao;
import com.JSH.Meow.vo.ReqRes;

@Service
public class ReqResService {
	
	private ReqResDao reqResDao;
	
	public ReqResService(ReqResDao reqResDao) {
		this.reqResDao = reqResDao;
	}

	public void sendRequest(int requesterId, int recipientId, String code) {
		reqResDao.sendRequest(requesterId, recipientId, code);
	}

	public List<ReqRes> checkRequests(int memberId) {
		return reqResDao.checkRequests(memberId);
	}

	public void sendResponse(int id, String status) {
		reqResDao.sendResponse(id, status);
	}
}

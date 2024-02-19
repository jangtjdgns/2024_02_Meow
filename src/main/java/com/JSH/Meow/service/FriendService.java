package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.FriendDao;
import com.JSH.Meow.vo.Friend;

@Service
public class FriendService {
	private FriendDao friendDao;
	
	public FriendService(FriendDao friendDao) {
		this.friendDao = friendDao;
	}
	

	public void sendRequest(int senderId, int receiverId) {
		friendDao.sendRequest(senderId, receiverId);
	}
	
	public void sendResponse(int sendReqId, String resStatus) {
		friendDao.sendResponse(sendReqId, resStatus);
	}

	public List<Friend> checkRequests(int memberId) {
		return friendDao.checkRequests(memberId);
	}


	public Friend getFreindById(int sendReqId) {
		return friendDao.getFreindById(sendReqId);
	}

}

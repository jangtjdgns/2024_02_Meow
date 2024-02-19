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
	
	public void sendResponse(int id, String status) {
		friendDao.sendResponse(id, status);
	}

	public List<Friend> checkRequests(int memberId) {
		return friendDao.checkRequests(memberId);
	}

	public Friend getFriendStatus(int senderId, int receiverId) {
		return friendDao.getFriendStatus(senderId, receiverId);
	}

}

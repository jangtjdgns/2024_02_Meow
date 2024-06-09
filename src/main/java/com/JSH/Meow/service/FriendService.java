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
	
	// 친구 요청 응답
	public void acceptFriend(int senderId, int receiverId) {
		friendDao.acceptFriend(senderId, receiverId);
	}
	
	// 친구 목록 가져오기
	public List<Friend> getFriendsById(int memberId) {
		return friendDao.getFriendsById(memberId);
	}

}

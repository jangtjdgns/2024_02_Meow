package com.JSH.Meow.service;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.ChatDao;
import com.JSH.Meow.vo.Chat;

@Service
public class ChatService {
	private ChatDao chatDao;
	
	public ChatService(ChatDao chatDao) {
		this.chatDao = chatDao;
	}

	public void createRoom(int createrId) {
		chatDao.createRoom(createrId);
	}
	
	public int getLastInsertId() {
		return chatDao.getLastInsertId();
	}

	public Chat getChatByCreaterId(int createrId) {
		return chatDao.getChatByCreaterId(createrId);
	}

	public void deleteRoom(int senderId) {
		chatDao.deleteRoom(senderId);
	}
	
}

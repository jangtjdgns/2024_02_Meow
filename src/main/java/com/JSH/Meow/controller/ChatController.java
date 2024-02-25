package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ChatService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Chat;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class ChatController {
	private ChatService chatService;
	private Rq rq;
	
	public ChatController(ChatService chatService, Rq rq) {
		this.chatService = chatService;
		this.rq = rq;
	}
	
	// 채팅방 팝업창 열기
	@RequestMapping("/usr/chat/popUp")
	public String popup(Model model, int requesterId, int recipientId) {
		
		model.addAttribute("requesterId", requesterId);
		model.addAttribute("recipientId", recipientId);
		
		return "usr/common/chatPopUp";
	}
	
	// 채팅방 생성, 생성된 방 번호를 리턴, ajax
	@RequestMapping("/usr/chat/createRoom")
	@ResponseBody
	public ResultData createRoom(int createrId, int recipientId) {
		
		chatService.createRoom(createrId);
		
		int roomId = chatService.getLastInsertId();
		
		rq.createChatRoom(roomId);
		
		return ResultData.from("S-1", Util.f("%d번 방이 생성되었습니다.", roomId), roomId);
	}
	
	
	// 초대한 유저의 방이 열려있는지 확인, ajax
	@RequestMapping("/usr/chat/checkOpenedRoom")
	@ResponseBody
	public ResultData checkOpendRoom(int createrId) {
		
		Chat chat = chatService.getChatByCreaterId(createrId);
		
		if(chat == null) {
			return ResultData.from("F-1", Util.f("%d번 님의 방이 없습니다.", createrId));
		}
		
		return ResultData.from("S-1", Util.f("%d번 님의 방이 열려있습니다.", createrId), chat);
	}
}

package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ChatService;
import com.JSH.Meow.service.ReqResService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Chat;
import com.JSH.Meow.vo.ReqRes;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class ChatController {
	private ChatService chatService;
	private ReqResService reqResService;
	private Rq rq;
	
	public ChatController(ChatService chatService, ReqResService reqResService, Rq rq) {
		this.chatService = chatService;
		this.reqResService = reqResService;
		this.rq = rq;
	}
	
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
		
		reqResService.sendRequest(createrId, recipientId, "chat");
		
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
	
	// 채팅방 초대 요청 확인
	/*
	@RequestMapping("/usr/chat/checkRequests")
	@ResponseBody
	public ResultData<List<ReqRes>> checkRequests(int memberId) {

		List<ReqRes> reqRes = reqResService.checkRequests(memberId);
		
		if(reqRes.size() == 0) {
			return ResultData.from("F-1", "요청이 없음", reqRes);
		}
		
		return ResultData.from("S-1", Util.f("%d개의 채팅 요청이 있음", reqRes.size()), reqRes);
	}
	*/
	

	// 채팅방 초대 요청에 대한 응답 보내기
	@RequestMapping("/usr/chat/sendResponse")
	@ResponseBody
	public ResultData sendResponse(int id, int requesterId, int recipientId, String status) {
		
		Chat chat = chatService.getChatByCreaterId(requesterId);

		if(chat != null) {
			// 이미 초대를 보낸 상황
			if(chat.getCloseDate() != null) {
				return ResultData.from("F-1", "이미 친구 상태입니다.");
			}
		}
		
		reqResService.sendResponse(id, status);
		
		if(status.equals("accepted")) {
			return ResultData.from("S-1", "채팅 요청을 수락하셨습니다.");
		} else {
			return ResultData.from("F-2", "채팅 요청을 거절하셨습니다.");
		}
	}
}

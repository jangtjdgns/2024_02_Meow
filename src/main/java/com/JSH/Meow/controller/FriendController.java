package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.FriendService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Friend;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class FriendController {
	private FriendService friendService;
	private Rq rq;
	
	public FriendController(FriendService friendService, Rq rq) {
		this.friendService = friendService;
		this.rq = rq;
	}
	
	// 친구요청 보내기
	@RequestMapping("/usr/friend/sendRequest")
	@ResponseBody
	public ResultData sendRequest(int senderId, int receiverId) {
		// 값이 null인가?=
		// 받는 회원이 존재하는가?
		// 수락인가? 거절인가?
		// 이미 수락된 경우 제한
		
		// 요청 권한 확인
		if(senderId != rq.getLoginedMemberId()) {
			return ResultData.from("F-1", "해당 요청에 대한 권한이 없습니다.");
		}
		
		Friend friend = friendService.getFriendStatus(senderId, receiverId);
		
		if(friend != null) {
			// 요청중인 회원인가? (보류 상태)
			if(friend.getSenderId() == rq.getLoginedMemberId() && friend.getStatus().equals("pending")) {
				return ResultData.from("F-2", "이미 친구요청 상태입니다.");
			}
			// 요청받는 회원인가? (보류 상태)
			else if(friend.getReceiverId() == rq.getLoginedMemberId() && friend.getStatus().equals("pending")) {
				return ResultData.from("F-3", "이미 상대방이 친구요청을 보냈습니다. 알림을 확인해주세요.");
			}
			
			// 친구인 회원인가? (수락 상태)
			if(friend.getStatus().equals("accepted")) {
				return ResultData.from("F-4", "이미 친구 상태입니다.");
			}
		}
		
		friendService.sendRequest(senderId, receiverId);
		
		return ResultData.from("S-1", Util.f("%d번 회원이 %d번 회원으로 친구추가 요청", senderId, receiverId));
	}
	
	
	// 친구 요청 확인
	@RequestMapping("/usr/friend/checkRequests")
	@ResponseBody
	public ResultData<List<Friend>> checkRequests(int memberId) {
		// 값이 null인가?
		// 보류 상태인가?
		// 몇개의 요청이 있는가?
		
		List<Friend> requests = friendService.checkRequests(memberId);
		
		return ResultData.from("S-1", Util.f("%d개의 친구요청이 있음", requests.size()), requests);
	}
	
	
	// 친구요청에 대한 응답 보내기
	@RequestMapping("/usr/friend/sendResponse")
	@ResponseBody
	public ResultData sendResponse(int id, int senderId, int receiverId, String status) {
		
		// 응답 권한 확인
		if(receiverId != rq.getLoginedMemberId()) {
			return ResultData.from("F-1", "해당 요청에 대한 응답권한이 없습니다.");
		}
		
		Friend friend = friendService.getFriendStatus(senderId, receiverId);
		
		if(friend != null) {
			// 이미 친구인 경우
			if(friend.getStatus().equals("accepted")) {
				return ResultData.from("F-2", "이미 친구 상태입니다.");
			}
		}
		
		friendService.sendResponse(id, status);
		
		String msg = status.equals("accepted") ? "수락 되었습니다." : "거절 되었습니다.";
		
		return ResultData.from("S-1", msg);
	}
}

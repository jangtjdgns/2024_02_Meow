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
		// 값이 null인가?
		// 보내는 회원이 존재하는가?
		// 받는 회원이 존재하는가?
		// 아직 요청중인 회원인가? -> 보류
		// 수락인가? 거절인가?
		
		// 이미 수락된 경우 제한
		
		
		friendService.sendRequest(senderId, receiverId);
		
		return ResultData.from("S-1", Util.f("%d번 회원이 %d번 회원으로 친구추가 요청", senderId, receiverId));
	}
	
	
	// 친구요청에 대한 응답 보내기
	@RequestMapping("/usr/friend/sendResponse")
	@ResponseBody
	public ResultData sendResponse(int sendReqId, String resStatus) {
		// 값이 null인가?
		// 기록되어있는 응답회원과 로그인된 회원이 일치하는가?
		// 같은 사람에게 요청하는가?
		// 수락한 경우, 수락일 업데이트
		// 거절한 경우, 거절일 업데이트
		
		Friend friend = friendService.getFreindById(sendReqId);
		
		// 해당 요청이 없는 경우
		if(friend == null) {
			return ResultData.from("F-1", Util.f("%d번의 요청 결과가 없습니다.", sendReqId));
		}
		
		// 이미 처리된 요청인 경우, 보류상태가 아닌경우
		if(!friend.getStatus().equals("pending")) {
			return ResultData.from("F-2", "이미 처리된 요청입니다.");
		}
		
		// 응답 권한 확인
		if(friend.getReceiverId() != rq.getLoginedMemberId()) {
			return ResultData.from("F-3", Util.f("%d번의 요청에 대한 권한이 없습니다.", sendReqId));
		}
		
		friendService.sendResponse(sendReqId, resStatus);
		
		return ResultData.from("S-1", Util.f("%d번 회원의 요청 %s", friend.getSenderId(), resStatus), resStatus);
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
}

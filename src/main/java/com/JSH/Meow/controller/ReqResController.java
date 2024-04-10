package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.FriendService;
import com.JSH.Meow.service.ReqResService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.ReqRes;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class ReqResController {
	private ReqResService reqResService;
	private FriendService friendService;
	private Rq rq;
	
	public ReqResController(ReqResService reqResService, FriendService friendService, Rq rq) {
		this.reqResService = reqResService;
		this.friendService = friendService;
		this.rq = rq;
	}
	
	
	// 요청 확인
	@RequestMapping("/usr/reqRes/checkRequests")
	@ResponseBody
	public ResultData<List<ReqRes>> checkRequests(@RequestParam(defaultValue = "-1") int memberId) {
		
		List<ReqRes> reqRes = reqResService.checkRequests(memberId);
		
		if(reqRes.size() == 0) {
			return ResultData.from("F-1", "요청이 없음", reqRes);
		}
		
		return ResultData.from("S-1", Util.f("%d개의 요청이 있음", reqRes.size()), reqRes);
	}
	
	
	// 요청 보내기
	@RequestMapping("/usr/reqRes/sendRequest")
	@ResponseBody
	public ResultData sendRequest(int requesterId, int recipientId, String code) {
		
		ReqRes reqRes = reqResService.getReqStatus(requesterId, recipientId, code);

		String msg = null;
		
		if(reqRes != null && reqRes.getCode().equals("friend")) {
			
			// 요청중인 회원인가? (보류 상태)
			if(reqRes.getRequesterId() == rq.getLoginedMemberId() && reqRes.getStatus().equals("pending")) {
				return ResultData.from("F-1", "이미 친구요청을 보냈습니다.");
			}
			// 요청받는 회원인가? (보류 상태)
			else if(reqRes.getRecipientId() == rq.getLoginedMemberId() && reqRes.getStatus().equals("pending")) {
				return ResultData.from("F-2", "이미 상대방이 친구요청을 보냈습니다. 알림을 확인해주세요.");
			}
			
			// 이미 수락 상태인가?
			if(reqRes.getStatus().equals("accepted")) {
				return ResultData.from("F-3", "이미 친구 상태입니다.");
			}
		}
		
		reqResService.sendRequest(requesterId, recipientId, code);
		
		msg = code.equals("friend") ? "친구 요청 되었습니다." : Util.f("%d번 방으로 초대 되었습니다.", rq.getChatRoomId());
		
		return ResultData.from("S-1", msg);
	}
	
	
	// 응답 보내기
	/*
	@RequestMapping("/usr/reqRes/sendResponse")
	@ResponseBody
	public ResultData sendResponse(int id, int requesterId, int recipientId, String status, String code) {
		
		reqResService.sendResponse(id, status);
		
		if(code.equals("friend") && status.equals("accepted")) {			
			friendService.sendResponse(requesterId, recipientId);
		}
		
		String msg = status.equals("accepted") ? "요청을 수락하셨습니다." : "요청을 거절하셨습니다.";
		
		return ResultData.from("S-1", msg);
	}
	*/
	
	@RequestMapping("/usr/reqRes/sendResponse")
	@ResponseBody
	public ResultData sendResponse(int id, int requesterId, int recipientId, String status, String code) {
		
		reqResService.sendResponse(id, status);
		
		if(code.equals("friend") && status.equals("accepted")) {			
			friendService.sendResponse(requesterId, recipientId);
		}
		
		String msg = null;
		switch(status) {
			case "accepted": msg = "요청을 수락하셨습니다."; break;
			case "refuse": msg = "요청을 거절하셨습니다."; break;
			case "checked": msg = "문의 답변 알림을 확인했습니다."; break;
		}
		
		return ResultData.from("S-1", msg);
	}
}

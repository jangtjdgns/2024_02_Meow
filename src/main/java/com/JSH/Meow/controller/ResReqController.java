package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ChatService;
import com.JSH.Meow.service.FriendService;
import com.JSH.Meow.service.ReqResService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.ReqRes;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class ResReqController {
	private ReqResService reqResService;
	private ChatService chatService;
	private FriendService friendService;
	private Rq rq;
	
	public ResReqController(ReqResService reqResService, ChatService chatService, FriendService friendService, Rq rq) {
		this.reqResService = reqResService;
		this.chatService = chatService;
		this.friendService = friendService;
		this.rq = rq;
	}
	
	// 요청 확인
	@RequestMapping("/usr/reqRes/checkRequests")
	@ResponseBody
	public ResultData<List<ReqRes>> checkRequests(int memberId) {
		
		List<ReqRes> reqRes = reqResService.checkRequests(memberId);
		
		if(reqRes.size() == 0) {
			return ResultData.from("F-1", "요청이 없음", reqRes);
		}
		
		return ResultData.from("S-1", Util.f("%d개의 채팅 요청이 있음", reqRes.size()), reqRes);
	}
}

package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;

import com.JSH.Meow.service.FriendService;
import com.JSH.Meow.vo.Rq;

@Controller
public class UsrFriendController {
	private FriendService friendService;
	private Rq rq;
	
	public UsrFriendController(FriendService friendService, Rq rq) {
		this.friendService = friendService;
		this.rq = rq;
	}
	
	// 관리자 페이지 만들 쯤에 추가할듯 함, 이 부분이 고민이 필요함
}

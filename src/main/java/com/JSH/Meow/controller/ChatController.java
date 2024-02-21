package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChatController {
	
	@RequestMapping("/usr/chat/popUp")
	public String popup() {
		return "usr/common/chatPopUp";
	}
}

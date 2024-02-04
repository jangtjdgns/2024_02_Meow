package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
	
	@RequestMapping("/usr/home/main")
	public String main() {
		
		return "usr/home/main";
	}
	
	@RequestMapping("/")
	public String root() {
		
		return "redirect:/usr/home/main";
	}
}

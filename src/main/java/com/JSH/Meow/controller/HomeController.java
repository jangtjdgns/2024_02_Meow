package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.config.NaverConfig;

@Controller
public class HomeController {
	
	private NaverConfig naverConfig;
	
	public HomeController( NaverConfig naverConfig) {
		this.naverConfig = naverConfig;
	}
	
	@RequestMapping("/usr/home/main")
	public String main() {
		
		return "usr/home/main";
	}
	
	@RequestMapping("/")
	public String root() {
		
		return "redirect:/usr/home/main";
	}
	
	@RequestMapping("/test")
	@ResponseBody
	public String test() {
        
        return naverConfig.getClientId();
	}
}

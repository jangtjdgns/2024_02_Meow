package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.JSH.Meow.config.component.KakaoComponent;
import com.JSH.Meow.service.ArticleService;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.Rq;

@Controller
public class UsrHomeController {
	
	private MemberService memberService;
	private KakaoComponent kakaoComponent;
	private ArticleService articleService;
	private Rq rq;
	
	public UsrHomeController(MemberService memberService, KakaoComponent kakaoComponent, ArticleService articleService, Rq rq) {
		this.memberService = memberService;
		this.kakaoComponent = kakaoComponent;
		this.articleService = articleService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/home/main")
	public String main(Model model) {
		
		String memberAddress = "대전 둔산동";	// 기본 주소
		
		Member member = memberService.getMemberById(rq.getLoginedMemberId());
		
		if(member != null && member.getAddress().length() != 0) {
	        memberAddress = Util.convertAddressJsonToString(member.getAddress());
		}
		
		// 배너에 표시할 최신 게시글 4개 가져오기
		List<Article> articles = articleService.getLatestArticles(4);
		
		model.addAttribute("memberAddress", memberAddress);
		model.addAttribute("javascriptKey", kakaoComponent.getJavascriptKey());		// 앱키 js
		model.addAttribute("articles", articles);
		
		return "usr/home/main";
	}
	
	@RequestMapping("/")
	public String root() {
		
		return "redirect:/usr/home/main";
	}
	
	@RequestMapping("/test")
	public ModelAndView test() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("test/test");
		return mv;
	}
}

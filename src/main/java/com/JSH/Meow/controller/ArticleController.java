package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ArticleService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Rq;

@Controller
public class ArticleController {
	
	private ArticleService articleService;
	private Rq rq;
	
	public ArticleController(ArticleService articleService, Rq rq) {
		this.articleService = articleService;
		this.rq = rq;
	}
	
	
	@RequestMapping("/usr/article/list")
	public String showList(Model model) {
		
		List<Article> articles = articleService.getArticles();
		
		model.addAttribute("articles", articles);
		
		return "usr/article/list";
	}
	

	@RequestMapping("/usr/article/detail")
	public String showDetail(Model model, int id) {
		
		Article article = articleService.getArticleById(id);
		
		if(article == null) {
			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
				
		model.addAttribute("article", article);
		
		return "usr/article/detail";
	}
	
	
	@RequestMapping("/usr/article/write")
	public String write() {

		return "usr/article/write";
	}
	
	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	public String doWrtie(String title, String body) {

		if(Util.isEmpty(title)) {
			return Util.jsHistoryBack("제목을 입력하세요.");
		}
		
		if(Util.isEmpty(body)) {
			return Util.jsHistoryBack("내용을 입력하세요.");
		}
		
		articleService.doWrite(title, body);
		
		int id = articleService.getLastInsertId();
		return Util.jsReplace(Util.f("%d번 게시물이 작성되었습니다.", id), Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(int id) {

		Article article = articleService.getArticleById(id);
		
		if (article == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		articleService.doDeleteById(id);
		
		return Util.jsReplace(Util.f("%d번 게시물이 삭제되었습니다.", id), "list");
	}
	
	@RequestMapping("/usr/article/modify")
	public String modify(Model model, int id) {
		
		Article article = articleService.getArticleById(id);
		
		if(article == null) {
			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		model.addAttribute("article", article);
		
		return "usr/article/modify";
	}
	
	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String modify(int id, String title, String body) {
		
		if(Util.isEmpty(title)) {
			return Util.jsHistoryBack("제목을 입력하세요.");
		}
		
		if(Util.isEmpty(body)) {
			return Util.jsHistoryBack("내용을 입력하세요.");
		}
		
		Article article = articleService.getArticleById(id);
		
		if (article == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		articleService.doModify(id, title, body);
		
		return Util.jsReplace(Util.f("%d번 게시물이 수정되었습니다.", id), "list");
	}
}

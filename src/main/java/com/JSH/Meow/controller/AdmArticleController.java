package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ArticleService;
import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Interval;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class AdmArticleController {
	private ArticleService articleService;
	private Rq rq;
	
	public AdmArticleController(ArticleService articleService, Rq rq) {
		this.articleService = articleService;
		this.rq = rq;
	}
	
	
	// 게시글 목록 가져오기, ajax
	@RequestMapping("/adm/article/list")
	@ResponseBody
	public ResultData<List<Article>> getMembers(
			@RequestParam(defaultValue = "1") int page
			, @RequestParam(defaultValue = "10") int articleCnt
			, @RequestParam(defaultValue = "0") int searchType
			, @RequestParam(defaultValue = "") String searchKeyword
			, @RequestParam(defaultValue = "1") int boardType
			, @RequestParam(defaultValue = "false") boolean order) {
		
		// 표시 회원수를 기준으로 limit 시작 설정
		int limitFrom = (page - 1) * articleCnt;
		
		List<Article> articles = articleService.admGetArticles(limitFrom, articleCnt, searchType, searchKeyword, boardType, order);
		
		if(articles.size() == 0) {
			return ResultData.from("F-1", "검색에 일치하는 게시글이 없습니다.", articles);
		}
		
		return ResultData.from("S-1", "게시글 조회 성공", articles);
	}
	
	// 게시글 정보 가져오기, ajax
	@RequestMapping("/adm/article/detail")
	@ResponseBody
	public ResultData<Article> getArticle(int articleId) {
		
		Article article = articleService.admGetArticleById(articleId);
		
		return ResultData.from("S-1", "게시글 조회 성공", article);
	}
	
	// 공지사항 가져오기, ajax
	@RequestMapping("/adm/article/notice")
	@ResponseBody
	public ResultData<List<Article>> getNoticeArticle() {
		
		List<Article> noticeArticles = articleService.getNoticeArticles();
		
		if(noticeArticles.size() == 0) {
			return ResultData.from("F-1", "등록된 공지사항이 없습니다.");
		}
		
		return ResultData.from("S-1", "공지사항 게시글 조회 성공", noticeArticles);
	}
	
	
	// 게시글 작성 빈도 가져오기(column 차트에 사용), ajax
	@RequestMapping("/adm/article/frequency")
	@ResponseBody
	public ResultData<List<Interval>> getArticleFreq(
			int memberId
			, @RequestParam(defaultValue = "month") String interval
			, @RequestParam(defaultValue = "6") int intervalFreq
			, @RequestParam(defaultValue = "7") int barCnt) {
		
		List<Interval> IntervalFreq = articleService.getArticleFreq(memberId, interval, intervalFreq, barCnt);

		if(IntervalFreq.size() == 0) {
			return ResultData.from("F-1", "해당 옵션에 대한 데이터가 없습니다.");
		}
		
		return ResultData.from("S-1", "빈도 수 조회 성공", IntervalFreq);
	}
}

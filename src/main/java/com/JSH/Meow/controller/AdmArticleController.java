package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ArticleService;
import com.JSH.Meow.service.BoardService;
import com.JSH.Meow.service.ReplyService;
import com.JSH.Meow.service.UploadService;
import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Interval;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class AdmArticleController {
	private ArticleService articleService;
	private BoardService boardService;
	private ReplyService replyService;
	private UploadService uploadService;
	private Rq rq;
	
	public AdmArticleController(ArticleService articleService, BoardService boardService, ReplyService replyService, UploadService uploadService, Rq rq) {
		this.articleService = articleService;
		this.boardService = boardService;
		this.replyService = replyService;
		this.uploadService = uploadService;
		this.rq = rq;
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

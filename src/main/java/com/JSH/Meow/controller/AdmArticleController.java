package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ArticleService;
import com.JSH.Meow.service.BoardService;
import com.JSH.Meow.service.ReplyService;
import com.JSH.Meow.service.UploadService;
import com.JSH.Meow.vo.Article;
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
	
	// 공지사항 가져오기
	@RequestMapping("/adm/getArticle/notice")
	@ResponseBody
	public ResultData<List<Article>> getNoticeArticle() {
		
		List<Article> noticeArticles = articleService.getNoticeArticles();
		
		if(noticeArticles.size() == 0) {
			return ResultData.from("F-1", "등록된 공지사항이 없습니다.");
		}
		
		return ResultData.from("S-1", "공지사항 게시글 조회 성공", noticeArticles);
	}
}

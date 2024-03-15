package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ArticleService;
import com.JSH.Meow.service.BoardService;
import com.JSH.Meow.service.ReplyService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Board;
import com.JSH.Meow.vo.Reply;
import com.JSH.Meow.vo.Rq;

@Controller
public class ArticleController {
	
	private ArticleService articleService;
	private BoardService boardService;
	private ReplyService replyService;
	private Rq rq;
	
	public ArticleController(ArticleService articleService, BoardService boardService, ReplyService replyService, Rq rq) {
		this.articleService = articleService;
		this.boardService = boardService;
		this.replyService = replyService;
		this.rq = rq;
	}
	
	
	@RequestMapping("/usr/article/list")
	public String showList(Model model
			, @RequestParam(defaultValue = "1") int boardId
			, @RequestParam(defaultValue = "1") int page
			, @RequestParam(defaultValue = "15") int itemsInAPage
			, @RequestParam(defaultValue = "0") int listStyle
			, @RequestParam(defaultValue = "1") int searchType
			, @RequestParam(defaultValue = "") String searchKeyword){
		
		// 게시판 번호에 해당되지 않을 때
		if(!(boardId >= 1 && boardId <= 6)) {
			return rq.jsReturnOnView("존재하지않는 게시판 입니다.");
		}
		
		// 페이지 번호가 0이하일 때
		if (page <= 0){
			return rq.jsReturnOnView("페이지 번호가 올바르지 않습니다.");
		}
		
		// DB limit 시작 부분
		int limitFrom = (page - 1) * itemsInAPage;
		
		// 게시물의 전체 수
		int articlesCnt = articleService.getTotalCount(boardId, searchType, searchKeyword);
		
		// 전체 페이지 수
		int totalPageCnt = (int) Math.ceil((double) articlesCnt / itemsInAPage);
		
		// 페이징 버튼 시작
		int from = ((page - 1) / 10) * 10 + 1;
		
		// 페이징 버튼 끝
		int end = ((page - 1) / 10 + 1) * 10;
		
		// 전체 페이지 수를 벗어나는 경우
		end = end > totalPageCnt ? totalPageCnt : end;
		
		List<Article> articles = articleService.getArticles(boardId, limitFrom, itemsInAPage, searchType, searchKeyword);
		List<Board> boards = boardService.getBoards();

		model.addAttribute("articles", articles);
		model.addAttribute("boards", boards);
		model.addAttribute("boardId", boardId);
		model.addAttribute("articlesCnt", articlesCnt);
		model.addAttribute("totalPageCnt", totalPageCnt);
		model.addAttribute("itemsInAPage", itemsInAPage);
		model.addAttribute("page", page);
		model.addAttribute("from", from);
		model.addAttribute("end", end);
		model.addAttribute("listStyle", listStyle);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		
		return "usr/article/list";
	}
	

	@RequestMapping("/usr/article/detail")
	public String showDetail(Model model, int id, int boardId) {
		
		Article article = articleService.getArticleWithDetailsById(id);
		
		if(article == null) {
			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		model.addAttribute("article", article);
		model.addAttribute("boardId", boardId);
		
		return "usr/article/detail";
	}
	
	
	@RequestMapping("/usr/article/write")
	public String write(Model model) {

		List<Board> boards = boardService.getBoards();
		
		model.addAttribute("boards", boards);
		
		return "usr/article/write";
	}
	
	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	public String doWrtie(int boardId, String title, String body) {
		
		if(Util.isEmpty(title)) {
			return Util.jsHistoryBack("제목을 입력하세요.");
		}
		
		if(Util.isEmpty(body)) {
			return Util.jsHistoryBack("내용을 입력하세요.");
		}
		
		articleService.doWrite(rq.getLoginedMemberId(), boardId, title, body);
		
		int id = articleService.getLastInsertId();
		
		return Util.jsReplace(Util.f("%d번 게시물이 작성되었습니다.", id), Util.f("detail?id=%d&boardId=%d", id, boardId));
	}
	
	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(int id) {

		Article article = articleService.getArticleById(id);
		
		if (article == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if(article.getMemberId() != rq.getLoginedMemberId()) {
			return Util.jsHistoryBack(Util.f("%d번 게시물에 대한 권한이 없습니다.", id));
		}
		
		articleService.doDeleteById(id);
		
		return Util.jsReplace(Util.f("%d번 게시물이 삭제되었습니다.", id), "list");
	}
	
	@RequestMapping("/usr/article/modify")
	public String modify(Model model, int id, int boardId) {
		
		Article article = articleService.getArticleById(id);
		
		if(article == null) {
			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if(article.getMemberId() != rq.getLoginedMemberId()) {
			return rq.jsReturnOnView(Util.f("%d번 게시물에 대한 권한이 없습니다.", id));
		}
		
		List<Board> boards = boardService.getBoards();
		
		model.addAttribute("article", article);
		model.addAttribute("boards", boards);
		model.addAttribute("boardId", boardId);
		
		return "usr/article/modify";
	}
	
	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String modify(int id, int boardId,String title, String body) {
		
		Article article = articleService.getArticleById(id);
		
		if (article == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if(article.getMemberId() != rq.getLoginedMemberId()) {
			return Util.jsHistoryBack(Util.f("%d번 게시물에 대한 권한이 없습니다.", id));
		}
		
		articleService.doModify(id, title, body);
		
		return Util.jsReplace(Util.f("%d번 게시물이 수정되었습니다.", id), Util.f("detail?id=%d&boardId=%d", id, boardId));
	}
}

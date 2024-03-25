package com.JSH.Meow.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.JSH.Meow.service.ArticleService;
import com.JSH.Meow.service.BoardService;
import com.JSH.Meow.service.ReplyService;
import com.JSH.Meow.service.UploadService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Board;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** 
 * ArticleController
 * 게시글을 관리하는 컨트롤러
 * */

@Controller
public class ArticleController {
	
	private ArticleService articleService;
	private BoardService boardService;
	private ReplyService replyService;
	private UploadService uploadService;
	private Rq rq;
	
	public ArticleController(ArticleService articleService, BoardService boardService, ReplyService replyService, UploadService uploadService, Rq rq) {
		this.articleService = articleService;
		this.boardService = boardService;
		this.replyService = replyService;
		this.uploadService = uploadService;
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
		if (!(boardId >= 1 && boardId <= 6)) {
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
	
	// 핫 게시글 가져오기, ajax
	@RequestMapping("/usr/article/getHotArticles")
	@ResponseBody
	public ResultData<List<Article>> getHotArticles() {
		
		List<Article> hotArticles = articleService.getHotArticles();
		
		if(hotArticles.size() == 0) {
			return ResultData.from("F-1", "핫 게시글이 없음");
		}
		
		return ResultData.from("S-1", "핫 게시글이 존재합니다.", hotArticles);
	}
	

	@RequestMapping("/usr/article/detail")
	public String showDetail(HttpServletRequest req, HttpServletResponse res, Model model, int id, int boardId) {
		
		Article article = articleService.getArticleWithDetailsById(id);
		
		if(article == null) {
			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if (articleService.getArticleById(id) == null) {
			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다", id));
		}
		
		// 쿠키, 조회수 추가
		Cookie oldCookie = null;							
		Cookie[] cookies = req.getCookies();				// 여러개의 쿠키를 사용할 수 있기에 배열로 저장-> 브라우저의 Cookies에 있는 쿠키정보들을 가져옴

		if (cookies != null) {								// 쿠키배열이 null이 아닐때
			for (Cookie cookie : cookies) {					// 반복
				if (cookie.getName().equals("hitCnt")) {	// hitCnt란 이름의 쿠키가 있는 경우
					oldCookie = cookie;						// oldCookie에 저장
				}
			}
		}
		
		if(oldCookie != null) {												// oldCookie가 null이 아닐 때 -> hitCnt란 쿠키가 있는 경우
			if(!oldCookie.getValue().contains("[" + id + "]")) {			// [id] 형태의 문자열이 포함되어 있지 않다면
				articleService.increaseHitCnt(id);							// 해당 게시물의 hitCnt 조회수 증가
				oldCookie.setValue(oldCookie.getValue() + "_[" + id + "]");	// 기존쿠키 + _[id] 형태의 문자열 추가 -> 다른 게시물들을 들어간 경우
				oldCookie.setPath("/");
				oldCookie.setMaxAge(60 * 60 * 24);							// 만료시점, 최대 24시간(60 * 60 * 24) 자정에 초기화
				res.addCookie(oldCookie);									// 쿠키 추가
			}
		} else {															// oldCookie가 null일 때
			articleService.increaseHitCnt(id);								// 해당 게시물의 hitCnt 조회수 증가
			Cookie newCookie = new Cookie("hitCnt", "[" + id + "]");		// 새로운 쿠키 생성, ("hitCnt", [id])
			newCookie.setPath("/");
			newCookie.setMaxAge(60 * 60 * 24);								// 만료시점, 최대 24시간(60 * 60 * 24) 자정에 초기화
			res.addCookie(newCookie);										// 쿠키 추가
			/*
			 * fierfox에서 samesite 때문에 설정하는건데 https 프로토콜에서만 사용가능하다고 한다.
			 * res.setHeader("Set-Cookie", "hitCnt=[" + id + "]; Secure; SameSite=None; Path=/; Max-Age=86400");
			 */
		}
		
		Board board = boardService.getBoardById(article.getBoardId());
		
		model.addAttribute("article", article);
		model.addAttribute("board", board);
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
	
	
	// 토스트UI의 base64 를 통해 이미지를 업로드 하면 해상도에 따라 데이터의 값이 너무 커져버림
	// 이를 방지하기 위해 업로드 후 해당 이미지를 가져오도록 변경, ajax
	@RequestMapping("/usr/article/uploadImage")
	@ResponseBody
	public ResultData uploadImage(@RequestParam MultipartFile articleImage) throws IOException {
		
		uploadService.uploadFile(articleImage, "article");
		
		String imagePath = uploadService.getProfileImagePath("article");
		
		return ResultData.from("S-1", "이미지 업로드 성공", imagePath);
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

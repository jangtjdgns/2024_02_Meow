package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ArticleService;
import com.JSH.Meow.service.MemberService;
import com.JSH.Meow.service.ReplyService;
import com.JSH.Meow.service.ReportService;
import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Member;
import com.JSH.Meow.vo.Reply;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class ReportController {
	
	private ReportService reportService;
	private MemberService memberService;
	private ArticleService articleService;
	private ReplyService replyService;
	private Rq rq;
	
	public ReportController(ReportService reportService, MemberService memberService, ArticleService articleService, ReplyService replyService, Rq rq) {
		this.reportService = reportService;
		this.memberService = memberService;
		this.articleService = articleService;
		this.replyService = replyService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/report/doReport")
	@ResponseBody
	public ResultData doReport(int reporterId, String relTypeCode, String relId, String reportBody, int reportType) {
		
		// 신고자가 본인이 아닐 때
		if(reporterId != rq.getLoginedMemberId()) {
			return ResultData.from("F-1", "신고자와 로그인 한 유저가 다릅니다.");
		}
		
		// ++ 중복 신고 체크 하면 좋을듯
		
		// 신고 대상자 id
		int reportedTargetId = 0;
		
		// 관련 항목을 조회 했을때 존재 하는지 검증
		switch(relTypeCode) {
			// 회원 조회 (회원번호 또는 닉네임으로)
			case "member":
				Member member = null;
				try {
					int relIdToInt = Integer.parseInt(relId);
					member = memberService.getMemberById(relIdToInt);
				} catch (NumberFormatException e) {
					member = memberService.getMemberByNickname(relId);
				}
				
				// 존재하지 않는 경우
				if(member == null) {
					return ResultData.from("F-2-1", "해당 회원은 존재하지 않습니다."); 
				}
				reportedTargetId = member.getId();
				break;
			
			// 게시글 조회
			case "article":
				Article article = articleService.getArticleById(Integer.parseInt(relId));
				
				if(article == null) {
					return ResultData.from("F-2-2", "해당 게시글은 존재하지 않습니다."); 
				}
				reportedTargetId = article.getMemberId();
				break;
			
			// 댓글 조회
			case "reply":
				Reply reply = replyService.getReplyById(Integer.parseInt(relId));
				
				if(reply == null) {
					return ResultData.from("F-2-3", "해당 댓글은 존재하지 않습니다."); 
				}
				reportedTargetId = reply.getMemberId();
				break;
			
			// 그 외
			default: return ResultData.from("F-2-4", "관련 항목 유형을 선택해주세요."); 
		}
		
		reportService.doReport(reporterId, reportedTargetId, relTypeCode, relId, reportBody, reportType);
		
		return ResultData.from("S-1", "신고완료 되었습니다.");
	}
}

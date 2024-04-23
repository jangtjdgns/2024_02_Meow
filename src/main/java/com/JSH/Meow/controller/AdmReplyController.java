package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ReplyService;
import com.JSH.Meow.vo.Reply;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;
import com.JSH.Meow.vo.statistics.ReplyStatus;

@Controller
public class AdmReplyController {
	private ReplyService replyService;
	private Rq rq;
	
	public AdmReplyController(ReplyService replyService, Rq rq) {
		this.replyService = replyService;
		this.rq = rq;
	}
	
	// 댓글들 가져오기, ajax
	@RequestMapping("/adm/reply/list")
 	@ResponseBody
 	public ResultData<List<Reply>> admGetReplies(
 			@RequestParam(defaultValue = "1") int page
			, @RequestParam(defaultValue = "10") int replyCnt
			, @RequestParam(defaultValue = "all") String searchType
			, @RequestParam(defaultValue = "") String searchKeyword
			, @RequestParam(defaultValue = "false") boolean order) {
		
		// 표시 댓글 수를 기준으로 limit 시작 설정
		int limitFrom = (page - 1) * replyCnt;
		
		// 댓글 가져오기
		List<Reply> replies = replyService.admGetReplies(limitFrom, replyCnt, searchType, searchKeyword, order);
		
		if(replies.size() == 0) {
			return ResultData.from("F-1", "검색에 일치하는 댓글이 없습니다.", replies);
		}
		
		return ResultData.from("S-1", "댓글 조회 성공", replies);
	}
	
	
	// 해당 댓글 정보 가져오기, ajax
	@RequestMapping("/adm/reply/detail")
 	@ResponseBody
 	public ResultData<Reply> getReply(int replyId) {
		
		Reply reply = replyService.getReplyById(replyId);
		
		return ResultData.from("S-1", "댓글 조회 성공", reply);
	}
	
	// 댓글 작성 빈도 가져오기, ajax
	@RequestMapping("/adm/reply/showWriteFreq")
	@ResponseBody
	public ResultData<List<ReplyStatus>> showWriteFreq(int memberId) {
		
		List<ReplyStatus> replyStatus = replyService.showWriteFreq(memberId);

		return ResultData.from("S-1", "댓글 작성 빈도", replyStatus);
	}
}

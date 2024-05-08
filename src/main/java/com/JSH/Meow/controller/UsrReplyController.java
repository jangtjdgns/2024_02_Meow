package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ReplyService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Reply;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class UsrReplyController {
	private ReplyService replyService;
	private Rq rq;
	
	public UsrReplyController(ReplyService replyService, Rq rq) {
		this.replyService = replyService;
		this.rq = rq;
	}
	
	// 댓글들 가져오기
	@RequestMapping("/usr/reply/getReplies")
 	@ResponseBody
 	public ResultData<List<Reply>> getReplies(int relId) {
		
		// 댓글 가져오기
		List<Reply> replies = replyService.getReplies(relId, "article");
		
		return ResultData.from("S-1", "댓글 조회 성공", replies);
	}
	
	
	// 해당 댓글 정보 가져오기, ajax
	@RequestMapping("/usr/reply/getReplyContent")
 	@ResponseBody
 	public ResultData<Reply> getReplyContent(int id) {
		
		Reply reply = replyService.getReplyById(id);
		
		return ResultData.from("S-1", "댓글 조회 성공", reply);
	}
	 
	// 댓글 작성, ajax
	@RequestMapping("/usr/reply/doWrite")
	@ResponseBody
	public ResultData doWrite(int relId, String relTypeCode, String body, int boardId) {
		
		if(Util.isEmpty(body)) {
			return ResultData.from("F-1", "댓글을 입력해주세요.");
		}
		
		replyService.doWrite(rq.getLoginedMemberId(), relId, relTypeCode, body);
		
		int id = replyService.getLastInsertId();
		
		Reply reply = replyService.getReplyById(relId);
		
		return ResultData.from("S-1", "댓글이 작성되었습니다.", reply);
	}
	
	// 댓글 수정
	@RequestMapping("/usr/reply/doModify")
	@ResponseBody
	public ResultData doModify(int id, String body, int boardId) {
		
		if(Util.isEmpty(body)) {
			return ResultData.from("F-1", "내용을 입력해주세요.");
		}
		
		Reply reply = replyService.getReplyById(id);
		
		if(reply == null) {
			return ResultData.from("F-2", "해당 댓글은 존재하지 않습니다.");
		}
		
		if(rq.getLoginedMemberId() != reply.getMemberId()) {
			return ResultData.from("F-3", "해당 댓글에 대한 권한이 없습니다.");
		}
		
		replyService.doModify(id, body);
		
		return ResultData.from("S-1", "댓글이 수정되었습니다.");
	}
	
	
	// 댓글 삭제
	@RequestMapping("/usr/reply/doDelete")
	@ResponseBody
	public ResultData doDelete(int id) {
		
		Reply reply = replyService.getReplyById(id);
		
		if(reply == null) {
			return ResultData.from("F-1", "해당 댓글은 존재하지 않습니다.");
		}
		
		if(rq.getLoginedMemberId() != reply.getMemberId()) {
			return ResultData.from("F-2", "해당 댓글에 대한 권한이 없습니다.");
		}
		 
		replyService.doDelete(id);
		
		return ResultData.from("S-1", "댓글이 삭제되었습니다.");
	}
}

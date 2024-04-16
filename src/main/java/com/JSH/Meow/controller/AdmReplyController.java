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
public class AdmReplyController {
	private ReplyService replyService;
	private Rq rq;
	
	public AdmReplyController(ReplyService replyService, Rq rq) {
		this.replyService = replyService;
		this.rq = rq;
	}
	
	// 댓글들 가져오기, ajax
	@RequestMapping("/adm/reply/getReplies")
 	@ResponseBody
 	public ResultData<List<Reply>> getReplies(int relId) {
		
		// 댓글 가져오기
		List<Reply> replies = replyService.getReplies(relId, "article");
		
		return ResultData.from("S-1", "댓글 조회 성공", replies);
	}
	
	
	// 해당 댓글 정보 가져오기, ajax
//	@RequestMapping("/usr/reply/getReplyContent")
// 	@ResponseBody
// 	public ResultData<Reply> getReplyContent(int id) {
//		
//		Reply reply = replyService.getReplyById(id);
//		
//		return ResultData.from("S-1", "댓글 조회 성공", reply);
//	}
}

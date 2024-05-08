package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ReactionService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Reaction;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

/** 
 * ReactionController
 * 사용자의 반응(좋아요 & 싫어요)을 관리하는 컨트롤러
 * */

@Controller
public class UsrReactionController {
	private ReactionService reactionService;
	private Rq rq;
	
	public UsrReactionController(ReactionService reactionService, Rq rq) {
		this.reactionService = reactionService;
		this.rq = rq;
	}
	
	// 반응 기록 조회, ajax
	@RequestMapping("/usr/reaction/getReaction")
	@ResponseBody
	public ResultData getReaction(String relTypeCode, int relId, int reactionType) {
		
		Reaction reaction = reactionService.getreaction(rq.getLoginedMemberId(), relTypeCode, relId, reactionType);
		
		int reactionCount = reactionService.getReactionCount(relTypeCode, relId, reactionType);
		
		if (reaction == null) {
			return ResultData.from("F-1", "좋아요 & 싫어요 기록 없음", reactionCount);
		}
		
		return ResultData.from("S-1", "좋아요 & 싫어요 기록 있음", reactionCount);
	}
	
	// 반응 등록 & 취소, ajax
	@RequestMapping("/usr/reaction/doReaction")
	@ResponseBody
	public ResultData insertPoint(int relId, String relTypeCode, int reactionType, boolean reactionStatus) { 
		
		String successCode = !reactionStatus ? "S-1" : "S-2";
		String reactionCodeName = reactionType == 0 ? "좋아요" : "싫어요";
		String reactionState = !reactionStatus ? "누르셨습니다." : "취소하셨습니다.";
		String relTypeCodeName = null;
		if(relTypeCode.equals("article")) {
			relTypeCodeName = "게시글";
		} else if(relTypeCode.equals("reply")) {
			relTypeCodeName = "댓글";
		}
		
		String msg = Util.f("%d번 %s에 %s를 %s", relId, relTypeCodeName, reactionCodeName, reactionState);
		
		if (!reactionStatus) {		// 반응 등록
			reactionService.insertPoint(rq.getLoginedMemberId(), relTypeCode, relId, reactionType);
		} else {					// 반응 취소
			reactionService.deletePoint(rq.getLoginedMemberId(), relTypeCode, relId, reactionType);
		}
		
		int reactionCount = reactionService.getReactionCount(relTypeCode, relId, reactionType);
		
		return ResultData.from(successCode, msg, reactionCount);
	}
}

package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.CustomerCenterService;
import com.JSH.Meow.service.ReqResService;
import com.JSH.Meow.vo.Inquiry;
import com.JSH.Meow.vo.ResultData;
import com.JSH.Meow.vo.Rq;

@Controller
public class AdmCustomerCenterController {
	
	private CustomerCenterService customerCenterService;
	private ReqResService reqResService;
	private Rq rq;
	
	public AdmCustomerCenterController(CustomerCenterService customerCenterService, ReqResService reqResService, Rq rq) {
		this.customerCenterService = customerCenterService;
		this.reqResService = reqResService;
		this.rq = rq;
	}
	
	// 문의 접수 목록 가져오기, ajax
	@RequestMapping("/adm/inquiry/list")
	@ResponseBody
	public ResultData<List<Inquiry>> getInquiries(
			@RequestParam(defaultValue = "1") int page
			, @RequestParam(defaultValue = "15") int inquiryCnt
			, @RequestParam(defaultValue = "progress") String status
			, @RequestParam(defaultValue = "1") int inquiryType
			, @RequestParam(defaultValue = "false") boolean order) {
		
		int limitFrom = (page - 1) * inquiryCnt;
		
		// 처리 상태가 완료인 경우
		if(status.equals("progress")) {
			// 처리할 문의를 전부 가져오게끔 처리하는 용도
			int progressCnt = customerCenterService.getProgressCount();
			inquiryCnt = inquiryCnt >= progressCnt ? inquiryCnt : progressCnt;
		}
		
		List<Inquiry> inquiries = customerCenterService.getInquiries(limitFrom, inquiryCnt, status, inquiryType, order);
		
		return ResultData.from("S-1", "문의 접수 목록 조회 성공", inquiries);
	}
	
	
	// 문의 정보 가져오기, ajax
	@RequestMapping("/adm/inquiry/detail")
	@ResponseBody
	public ResultData<Inquiry> getInquiry(int inquiryId) {
		
		Inquiry inquiry = customerCenterService.admGetInquiryById(inquiryId);
		
		return ResultData.from("S-1", "문의 내역 조회 성공", inquiry);
	}
	
	
	// 문의 답변하기, ajax
	@RequestMapping("/adm/inquiry/answer")
	@ResponseBody
	public ResultData<Inquiry> answerInquiry(int inquiryId, int recipientId, String answerBody, @RequestParam(defaultValue = "0") int repostProcessing) {
		
		// 부적절한 문의인 경우 신고 처리에 대한 번호 (없음 = 0, 경고 = 1, 정지 = 2, 강제탈퇴 = 3), 신고 테이블 생성 예정
		if(repostProcessing != 0) {
			System.out.println("report service 생성 예정");
		}
		
		// 문의 답변
		customerCenterService.answerInquiry(inquiryId, answerBody);
		
		// 알림 요청
		reqResService.sendRequest(rq.getLoginedMemberId(), recipientId, "inquiry");
		
		return ResultData.from("S-1", "문의 답변 성공");
	}
}

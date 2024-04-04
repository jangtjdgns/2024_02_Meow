package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.CustomerCenterService;
import com.JSH.Meow.vo.Inquiry;
import com.JSH.Meow.vo.ResultData;

@Controller
public class AdmCustomerCenterController {
	
	private CustomerCenterService customerCenterService;
	
	public AdmCustomerCenterController(CustomerCenterService customerCenterService) {
		this.customerCenterService = customerCenterService;
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
}

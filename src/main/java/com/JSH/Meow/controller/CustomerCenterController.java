package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.CustomerCenterService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.CustomerCenter;
import com.JSH.Meow.vo.ResultData;

@Controller
public class CustomerCenterController {
	
	private CustomerCenterService customerCenterService;
	
	public CustomerCenterController(CustomerCenterService customerCenterService) {
		this.customerCenterService = customerCenterService;
	}
	
	
	// 고객센터 페이지
	@RequestMapping("/usr/customer/main")
	public String customerMain() {
		
		return "usr/customerCenter/main";
	}
	
	
	// 고객센터 컨텐츠.jsp 가져오기, ajax
	@RequestMapping("/usr/customer/getContent")
	public String getContent(Model model, int contentId, @RequestParam(defaultValue = "0") int memberId) {
		
		String getJsp = null;
		
		if(contentId == 0) {
			getJsp = "write";
		} else if(contentId == 1) {
			getJsp = "history";
			List<CustomerCenter> inquiries = customerCenterService.getInquiryHistory(memberId);
			model.addAttribute("inquiries", inquiries);
		}
		
		
		return "usr/customerCenter/" + getJsp;
	}
	
	
	// 문의접수, ajax
	@RequestMapping("/usr/customer/submitRequest")
	@ResponseBody
	public ResultData<Integer> submitRequest(int memberId, String type, String title, String body
			, @RequestParam(defaultValue = "") String imagePath) {
		
		customerCenterService.submitRequest(memberId, type, title, body, imagePath);
		
		int receiptNum = customerCenterService.getLastInsertId();
		
		return ResultData.from("S-1", Util.f("접수번호: %d, 접수완료", receiptNum), receiptNum);
	}
	
	// 문의 내역 가져오기, ajax
	@RequestMapping("/usr/customer/showDetail")
	@ResponseBody
	public ResultData<CustomerCenter> showDetail(int receiptId) {
		
		CustomerCenter customerCenter = customerCenterService.getInquiryByReceiptId(receiptId);
		
		return ResultData.from("S-1", Util.f("접수번호 %d번 상세보기", receiptId), customerCenter);
	}
}

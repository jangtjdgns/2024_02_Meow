package com.JSH.Meow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.CustomerCenterService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.ResultData;

@Controller
public class CustomerCenterController {
	
	private CustomerCenterService customerCenterService;
	
	public CustomerCenterController(CustomerCenterService customerCenterService) {
		this.customerCenterService = customerCenterService;
	}
	
	
	@RequestMapping("/usr/customer/submitRequest")
	@ResponseBody
	public ResultData submitRequest(int memberId, String type, String title, String body
			, @RequestParam(defaultValue = "") String imagePath) {
		
		customerCenterService.submitRequest(memberId, type, title, body, imagePath);
		
		int receiptNum = customerCenterService.getLastInsertId();
				
		return ResultData.from("S-1", Util.f("접수번호: %d, 접수완료", receiptNum), receiptNum);
	}
}

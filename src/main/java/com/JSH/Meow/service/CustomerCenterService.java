package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.CustomerCenterDao;
import com.JSH.Meow.vo.CustomerCenter;

@Service
public class CustomerCenterService {
	private CustomerCenterDao customerCenterDao;
	
	public CustomerCenterService(CustomerCenterDao customerCenterDao) {
		this.customerCenterDao = customerCenterDao;
	}
	
	
	public void submitRequest(int memberId, String type, String title, String body, String imagePath) {
		customerCenterDao.submitRequest(memberId, type, title, body, imagePath);
	}


	public int getLastInsertId() {
		return customerCenterDao.getLastInsertId();
	}


	public List<CustomerCenter> getInquiryHistory(int memberId) {
		return customerCenterDao.getInquiryHistory(memberId);
	}


	public CustomerCenter getInquiryByReceiptId(int receiptId) {
		return customerCenterDao.getInquiryByReceiptId(receiptId);
	}
}

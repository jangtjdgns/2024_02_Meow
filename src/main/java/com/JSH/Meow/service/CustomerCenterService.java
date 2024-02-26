package com.JSH.Meow.service;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.CustomerCenterDao;

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
}

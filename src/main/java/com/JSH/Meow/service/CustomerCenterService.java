package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.CustomerCenterDao;
import com.JSH.Meow.vo.CustomerFeedback;
import com.JSH.Meow.vo.Inquiry;

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


	public List<Inquiry> getInquiryHistory(int memberId) {
		return customerCenterDao.getInquiryHistory(memberId);
	}


	public Inquiry getInquiryByReceiptId(int receiptId) {
		return customerCenterDao.getInquiryByReceiptId(receiptId);
	}


	public List<CustomerFeedback> getFeedback() {
		return customerCenterDao.getFeedback();
	}


	public void doWriteFeedback(int memberId, String content) {
		customerCenterDao.doWriteFeedback(memberId, content);
	}


	public CustomerFeedback getCustomerFeedbackByFeedbackId(int feedbackId) {
		return customerCenterDao.getCustomerFeedbackByFeedbackId(feedbackId);
	}


	public void doModifyFeedback(int feedbackId, String content) {
		customerCenterDao.doModifyFeedback(feedbackId, content);
	}
	
	public int getProgressCount() {
		return customerCenterDao.getProgressCount();
	}

	public List<Inquiry> getInquiries(int limitFrom, int inquiryCnt, String status, int inquiryType, boolean order) {
		return customerCenterDao.getInquiries(limitFrom, inquiryCnt, status, inquiryType, order);
	}

	public Inquiry admGetInquiryById(int id) {
		return customerCenterDao.admGetInquiryById(id);
	}
}

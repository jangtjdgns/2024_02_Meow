package com.JSH.Meow.service;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.ReportDao;

@Service
public class ReportService {
	
	private ReportDao reportDao;
	
	public ReportService(ReportDao reportDao) {
		this.reportDao = reportDao;
	}
	
	
	public void doReport(int reporterId, int reportedTargetId, String relTypeCode, String relId, String reportBody, int reportType) {
		reportDao.doReport(reporterId, reportedTargetId, relTypeCode, relId, reportBody, reportType);
	}
}

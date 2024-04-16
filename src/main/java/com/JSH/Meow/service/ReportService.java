package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.ReportDao;
import com.JSH.Meow.vo.Report;

@Service
public class ReportService {
	
	private ReportDao reportDao;
	
	public ReportService(ReportDao reportDao) {
		this.reportDao = reportDao;
	}
	
	
	public void doReport(int reporterId, int reportedTargetId, String relTypeCode, String relId, String reportBody, int reportType) {
		reportDao.doReport(reporterId, reportedTargetId, relTypeCode, relId, reportBody, reportType);
	}


	public List<Report> getReportsByRelTypeCode(String relTypeCode, String status) {
		return reportDao.getReportsByRelTypeCode(relTypeCode, status);
	}


	public Report getReportById(int reportId) {
		return reportDao.getReportById(reportId);
	}


	public void reportProcessing(int reportId, int processingType) {
		reportDao.reportProcessing(reportId, processingType);
	}


	public void saveMemo(int reportId, String memo) {
		reportDao.saveMemo(reportId, memo);
	}
}

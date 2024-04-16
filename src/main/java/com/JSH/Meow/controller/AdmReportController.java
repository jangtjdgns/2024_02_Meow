package com.JSH.Meow.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.JSH.Meow.service.ReportService;
import com.JSH.Meow.util.Util;
import com.JSH.Meow.vo.Report;
import com.JSH.Meow.vo.ResultData;

@Controller
public class AdmReportController {
	
	private ReportService reportService;
	
	public AdmReportController(ReportService reportService) {
		this.reportService = reportService;
	}
	
	
	// 신고 내역 목록 가져오기
	@RequestMapping("/adm/report/getReports")
	@ResponseBody
	public ResultData<List<Report>> getReports(String relTypeCode, String status) {
		
		List<Report> reports = reportService.getReportsByRelTypeCode(relTypeCode, status);
		
		if(reports.size() == 0) {
			return ResultData.from("F-1", "조회 가능한 신고 내역이 없습니다.", reports);
		}
		
		return ResultData.from("S-1", "신고 내역 조회 성공", reports);
	}
	
	
	// 신고 내역 상세보기
	@RequestMapping("/adm/report/getReport")
	@ResponseBody
	public ResultData<Report> getReport(int reportId) {
		
		Report report = reportService.getReportById(reportId);
		
		if(report == null) {
			return ResultData.from("F-1", Util.f("%s번 신고 내역이 없습니다.", reportId));
		}
		
		return ResultData.from("S-1", "신고 내역 조회 성공", report);
	}
	
	
	// 신고 조치 상태 저장
	@RequestMapping("/adm/report/reportProcessing")
	@ResponseBody
	public ResultData reportProcessing(int reportId, int processingType) {
		
		reportService.reportProcessing(reportId, processingType);
		
		return ResultData.from("S-1", "신고 조치 상태 저장 성공");
	}
	
	// 메모 저장
	@RequestMapping("/adm/report/saveMemo")
	@ResponseBody
	public ResultData saveMemo(int reportId, String memo) {
		
		reportService.saveMemo(reportId, memo);
		
		return ResultData.from("S-1", "신고 조치 상태 저장 성공");
	}
}

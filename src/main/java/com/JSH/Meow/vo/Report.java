package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Report {
	private int id;
	private String regDate;
	private String updateDate;
	private int reporterId;
	private int reportedTargetId;
	private String relTypeCode;
	private int relId;
	private String body;
	private String memo;
	private int type;
	private int processing;
	
	private String reporterNickname;
	private String reportedTargetNickname;
	
	
	public String getRelTypeCodeName() {
		String relTypeCode = null;
		
		switch(this.relTypeCode) {
			case "member": relTypeCode = "회원"; break;
			case "article": relTypeCode = "게시물"; break;
			case "reply": relTypeCode = "댓글"; break;
		}
		
		return relTypeCode;
	}
	
	public String getReportType() {
		
		String reportType = null;
		
		switch(this.type) {
			case 1: reportType = "스팸"; break;
			case 2: reportType = "욕설 또는 비방"; break;
			case 3: reportType = "성적인 콘텐츠"; break;
			case 4: reportType = "저작권 침해"; break;
			case 5: reportType = "사기 또는 부정행위"; break;
			case 6: reportType = "기타"; break;
		}
		
		return reportType;
	}
	
	public String getProcessing() {
		
		String processing = null;
		
		switch(this.processing) {
			case 1: processing = "경고"; break;
			case 2: processing = "정지"; break;
			case 3: processing = "강제탈퇴"; break;
			case 4: processing = "잘못된 신고"; break;
			default: processing = "미처리"; break;
		}
		
		return processing;
	}
}

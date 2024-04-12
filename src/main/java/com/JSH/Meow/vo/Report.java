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
	private int reportedtargetId;
	private String relTypeCode;
	private int relId;
	private String body;
	private String processingBody;
	private int type;
	private int processing;
}

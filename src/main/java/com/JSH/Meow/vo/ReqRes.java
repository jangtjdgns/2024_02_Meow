package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReqRes {
	private int id;
	private String requestDate;
	private String acceptDate;
	private String refuseDate;
	private int requesterId;
	private int recipientId;
	private String status;
	private String code;
	
	private String writerName;
	private int timeDiffSec;
}

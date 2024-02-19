package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Friend {
	private int id;
	private String requestDate;
	private String acceptDate;
	private String refuseDate;
	private int senderId;
	private int receiverId;
	private String status;
	
	private String writerName;
	private int timeDiffSec;
}

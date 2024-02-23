package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Chat {
	private int id;
	private String openDate;
	private String closeDate;
	private String createrId;
	
	private String writerName;
}

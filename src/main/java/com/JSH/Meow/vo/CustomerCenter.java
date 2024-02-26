package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CustomerCenter {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private String type;
	private String title;
	private String body;
	private String imagePath;
	private String status;
}

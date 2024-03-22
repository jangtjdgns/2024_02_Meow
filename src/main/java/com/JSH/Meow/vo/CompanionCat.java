package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CompanionCat {
	
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private String name;
	private String gender;
	private String birthDate;
	private String profileImage;
	private String aboutCat;
}

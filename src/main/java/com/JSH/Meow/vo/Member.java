package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Member {
	private int id;
	private String regDate;
	private String updateDate;
	private String loginId;
	private String loginPw;
	private int authLevel;
	private String name;
	private String nickname;
	private int age;
	private String cellphoneNum;
	private String email;
	private int status;
	private String delDate;
	private String lastLoginDate;
	private int lastLoginDays;
	private String profileImage;
	private String aboueMe;
}

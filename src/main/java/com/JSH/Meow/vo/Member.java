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
	private String address;
	private String cellphoneNum;
	private String email;
	private int status;
	private String lastLoginDate;
	private String profileImage;
	private String aboutMe;

	private String snsType;
	private String authCode;
	private int lastLoginDaysDiff;
	
	public String getStatus() {
		switch(this.status) {
			case 0: return "활동";
			case 1: return "정지";
			case 2: return "휴면";
			case 3: return "탈퇴";
			case 4: return "강제탈퇴";
		}
		return null;
	}
}
package com.JSH.Meow.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SnsInfo {
	private int id;
	private String snsId;
	private String snsConnectDate;
	private String snsType;
	private int memberId;
	private String name;
	private String mobile;
	private String email;
	private String profileImage;
}

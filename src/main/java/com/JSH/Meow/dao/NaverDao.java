package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface NaverDao {

	@Insert("""
			INSERT INTO sns_info
			SET snsId = #{snsId}
				, snsConnectDate = NOW()
				, snsType = #{snsType}
				, memberId = #{memberId}
				, `name` = #{name}
				, mobile = #{mobile}
				, email = #{email}
			""")
	public void saveSnsMemberInfo(String snsId, String snsType, int memberId, String name, String mobile, String email);
	
}

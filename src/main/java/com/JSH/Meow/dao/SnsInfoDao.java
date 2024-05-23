package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.JSH.Meow.vo.SnsInfo;

@Mapper
public interface SnsInfoDao {
	/*
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
	*/
	
	@Select("""
			SELECT SNStYPE
			FROM sns_info
			WHERE memberId = #{memberId}
			""")
	public String getSnsTypeByMemberId(int memberId);
	
	@Select("""
			SELECT * FROM sns_info
			WHERE snsId = #{snsId}
			""")
	public SnsInfo getSnsInfoBySnsId(String snsId);
	
	@Insert("""
			INSERT INTO sns_info
			SET snsId = #{snsId}
				, snsConnectDate = NOW()
				, snsType = #{snsType}
				, memberId = #{memberId}
				, `name` = #{name}
				, mobile = #{mobile}
				, email = #{email}
				, profileImage = #{profileImage}
			""")
	public void saveSnsMemberInfo(String snsId, String snsType, int memberId, String name, String mobile, String email, String profileImage);
	
}

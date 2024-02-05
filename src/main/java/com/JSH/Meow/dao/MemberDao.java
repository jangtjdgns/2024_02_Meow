package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Member;

@Mapper
public interface MemberDao {

	@Select("""
			SELECT * FROM `member`
			WHERE loginId = #{loginId}
			""")
	public Member getMemberByLoginId(String loginId);

	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();

	
}

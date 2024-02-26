package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface CustomerCenterDao {
	
	@Insert("""
			INSERT INTO customer_center
			SET regDate = NOW()
			    , memberId = #{memberId}
			    , `type` = #{type}
			    , title = #{title}
			    , `body` = #{body}
			    , imagePath = #{imagePath}
			    , `status` = 'progress'
			""")
	void submitRequest(int memberId, String type, String title, String body, String imagePath);
	
	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();
}

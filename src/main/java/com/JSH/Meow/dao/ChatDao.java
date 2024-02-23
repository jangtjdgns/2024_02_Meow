package com.JSH.Meow.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Chat;

@Mapper
public interface ChatDao {
	
	@Select("""
			SELECT * FROM chat
			WHERE createrId = #{createrId}
			AND closeDate IS NULL
			""")
	public Chat getChatByCreaterId(int createrId);
	
	@Insert("""
			INSERT INTO chat
			SET openDate = NOW()
			    , createrId = #{createrId};
			""")
	public void createRoom(int createrId);
	
	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();

	@Update("""
			UPDATE chat
			SET closeDate = NOW()
			WHERE createrId = #{senderId}
			ORDER BY id DESC
			LIMIT 1;
			""")
	public void deleteRoom(int senderId);
}

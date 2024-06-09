package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Friend;

@Mapper
public interface FriendDao {
	
	@Insert("""
			INSERT INTO friend
			SET acceptDate = NOW()
				, senderId = #{senderId}
			    , receiverId = #{receiverId}
			""")
	public void acceptFriend(int senderId, int receiverId);
	
	@Select("""
			SELECT F.*, M1.nickname senderNickname, M2.nickname receiverNickname
			FROM friend F
			LEFT JOIN `member` M1
				ON M1.id = F.senderId
			LEFT JOIN `member` M2
				ON M2.id = F.receiverId
			WHERE F.deleteDate IS NULL
				AND (
					F.senderId = #{memberId}
					OR F.receiverId = #{memberId} 
				);
			""")
	public List<Friend> getFriendsById(int memberId);

}

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
	public void sendResponse(int senderId, int receiverId);

	
	@Select("""
			SELECT F.*, M.nickname writerName, TIMESTAMPDIFF(SECOND, requestDate, NOW()) timeDiffSec
			FROM friend F
			INNER JOIN `member` M
			ON F.senderId = M.id
			WHERE F.receiverId = #{memberId}
			AND F.`status` = 'pending';
			""")
	public List<Friend> checkRequests(int memberId);

	
	@Select("""
			SELECT * FROM friend
			WHERE (
				(senderId = #{senderId} AND receiverId = #{receiverId})
			    OR (senderId = #{receiverId} AND receiverId = #{senderId})
			)
			AND `status` != 'refuse'
			""")
	public Friend getFriendStatus(int senderId, int receiverId);
	
}

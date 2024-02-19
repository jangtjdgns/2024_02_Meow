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
			SET requestDate = NOW()
			    , senderId = #{senderId}
			    , receiverId = #{receiverId};
			""")
	void sendRequest(int senderId, int receiverId);

	@Update("""
			<script>
				UPDATE friend
				<if test="resStatus == 'accepted'">
					SET acceptDate = NOW()
				</if>
				<if test="resStatus == 'refuse'">
					SET refuseDate = NOW()
				</if>
					, `status` = #{resStatus}
				WHERE id = #{sendReqId}
			</script>
			""")
	void sendResponse(int sendReqId, String resStatus);	
	
	@Select("""
			SELECT F.*, M.nickname writerName, TIMESTAMPDIFF(SECOND, requestDate, NOW()) timeDiffSec
			FROM friend F
			INNER JOIN `member` M
			ON F.senderId = M.id
			WHERE F.receiverId = #{memberId}
			AND F.`status` = 'pending';
			""")
	List<Friend> checkRequests(int memberId);

	@Select("""
			SELECT * FROM friend
			WHERE id = #{sendReqId}
			""")
	Friend getFreindById(int sendReqId);
	
}

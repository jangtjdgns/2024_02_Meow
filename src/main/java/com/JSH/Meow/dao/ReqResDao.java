package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.ReqRes;

@Mapper
public interface ReqResDao {
	
	@Insert("""
			INSERT INTO req_res
			SET requestDate = NOW()
				, requesterId = #{requesterId}
			    , recipientId = #{recipientId}
			    , `code` = #{code}
			""")
	void sendRequest(int requesterId, int recipientId, String code);
	
	@Select("""
			SELECT R.*, M.nickname writerName, TIMESTAMPDIFF(SECOND, requestDate, NOW()) timeDiffSec
			FROM req_res R
			INNER JOIN `member` M
			ON R.requesterId = M.id
			WHERE R.recipientId = #{memberId}
			AND R.`status` = 'pending';
			""")
	List<ReqRes> checkRequests(int memberId);
	
	@Update("""
			<script>
				UPDATE req_res
				SET `status` = #{status}
				<if test="status == 'accepted'">
					, acceptDate = NOW()
				</if>
				<if test="status == 'refuse'">
					, refuseDate = NOW()
				</if>
				WHERE id = #{id}
			</script>
			""")
	void sendResponse(int id, String status);	
	
	/*
	@Select("""
			SELECT F.*, M.nickname writerName, TIMESTAMPDIFF(SECOND, requestDate, NOW()) timeDiffSec
			FROM friend F
			INNER JOIN `member` M
			ON F.senderId = M.id
			WHERE F.receiverId = #{memberId}
			AND F.`status` = 'pending';
			""")
	List<Friend> checkRequests(int memberId);
	*/
}

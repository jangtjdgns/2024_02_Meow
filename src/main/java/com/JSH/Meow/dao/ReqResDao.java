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
	public void sendRequest(int requesterId, int recipientId, String code);
	
	@Select("""
			SELECT R.*, M.nickname writerName, TIMESTAMPDIFF(SECOND, requestDate, NOW()) timeDiffSec
			FROM req_res R
			INNER JOIN `member` M
			ON R.requesterId = M.id
			WHERE R.recipientId = #{memberId}
			AND R.`status` = 'pending';
			""")
	public List<ReqRes> checkRequests(int memberId);
	
	/*
	 * <script>
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
	 */
	@Update("""
			UPDATE req_res
			SET responseDate = NOW()
				, `status` = #{status}
			WHERE id = #{id}
			""")
	public void sendResponse(int id, String status);

	@Select("""
			SELECT * FROM req_res
			WHERE (
				(requesterId = #{requesterId} AND recipientId = #{recipientId})
			    OR (requesterId = #{recipientId} AND recipientId = #{requesterId})
			)
			AND `status` != 'refuse'
			AND `code` = #{code}
			ORDER BY id DESC
			LIMIT 1;
			""")
	public ReqRes getReqStatus(int requesterId, int recipientId, String code);
	
	/*
	 * UPDATE req_res
		SET refuseDate = NOW()
		    , `status` = 'refuse'
		WHERE requesterId = #{senderId}
		AND `status` = 'pending'
		AND `code` = 'chat';
	 */
	@Update("""
			UPDATE req_res
			SET responseDate = NOW()
			    , `status` = 'refuse'
			WHERE requesterId = #{senderId}
			AND `status` = 'pending'
			AND `code` = 'chat';
			""")
	public void deleteRoom(int senderId);
}

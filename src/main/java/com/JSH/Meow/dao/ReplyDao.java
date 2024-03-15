package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Reply;

@Mapper
public interface ReplyDao {
	
	@Select("""
			SELECT R.*, M.nickname writerName
			FROM reply R
			INNER JOIN `member` M
			ON R.memberId = M.id
			WHERE R.id = #{id}
			""")
	public Reply getReplyById(int id);
	
	@Select("""
			SELECT R.*, M.nickname writerName, M.profileImage
			FROM reply R
			INNER JOIN `member` M
			ON R.memberId = M.id
			WHERE R.relTypeCode = #{relTypeCode}
			AND R.relId = #{relId}
			ORDER BY R.id DESC
			""")
	List<Reply> getReplies(int relId, String relTypeCode);
	
	@Insert("""
			INSERT INTO reply
			SET regDate = NOW()
				, updateDate = NOW()
				, memberId = #{loginedMemberId}
				, relTypeCode = #{relTypeCode}
				, relId = #{relId}
				, `body` = #{body}
			""")
	public void doWrite(int loginedMemberId, int relId, String relTypeCode, String body);
	
	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();
	
	@Select("""
			<script>
				SELECT COUNT(*)
				FROM reply
				WHERE relId = #{relId}
			</script>
			""")
	public int getTotalCountByRelId(int relId);
	
	@Update("""
			UPDATE reply
			SET updateDate = NOW()
				, `body` = #{body}
			WHERE id = #{id}
			""")
	public void doModify(int id, String body);
	
	@Delete("""
			DELETE FROM reply
			WHERE id = #{id};
			""")
	public void doDelete(int id);
}

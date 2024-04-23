package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Reply;
import com.JSH.Meow.vo.statistics.ReplyStatus;

@Mapper
public interface ReplyDao {
	
	@Select("""
			SELECT R.*, M.nickname writerName, M.profileImage, A.boardId
			FROM reply R
			LEFT JOIN `member` M
			ON R.memberId = M.id
			LEFT JOIN article A
			ON R.relId = A.id
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
	
	
	@Select("""
			<script>
				SELECT R.*, M.nickname writerName, M.profileImage
				FROM reply R
				INNER JOIN `member` M
				ON R.memberId = M.id
				WHERE 1 = 1
				<choose>
					<when test="searchType == 'replyId'">
						AND R.id LIKE CONCAT('%', #{searchKeyword}, '%')
					</when>
					<when test="searchType == 'memberId'">
						AND M.id LIKE CONCAT('%', #{searchKeyword}, '%')
					</when>
					<when test="searchType == 'articleId'">
						AND R.relId LIKE CONCAT('%', #{searchKeyword}, '%')
					</when>
					<when test="searchType == 'nickname'">
						AND M.nickname LIKE CONCAT('%', #{searchKeyword}, '%')
					</when>
					<otherwise>
						AND (
				            R.id LIKE CONCAT('%', #{searchKeyword}, '%')
				            OR M.id LIKE CONCAT('%', #{searchKeyword}, '%')
				            OR R.relId LIKE CONCAT('%', #{searchKeyword}, '%')
				            OR M.nickname LIKE CONCAT('%', #{searchKeyword}, '%')
				        )
					</otherwise>
				</choose>
				<if test="order == true">
					ORDER BY R.id ASC
				</if>
				<if test="order == false">
					ORDER BY R.id DESC
				</if>
				LIMIT #{limitFrom}, #{replyCnt}
			</script>
			""")
	List<Reply> admGetReplies(int limitFrom, int replyCnt, String searchType, String searchKeyword, boolean order);
	
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
	
	@Select("""
			SELECT DATE_FORMAT(regDate, '%Y-%m-%d') `date`, COUNT(*) replyCnt
			FROM reply
			WHERE memberId = #{memberId}
				AND regDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
			GROUP BY DATE_FORMAT(regDate, '%Y-%m-%d')
			ORDER BY regDate DESC
			LIMIT 6
			""")
	public List<ReplyStatus> showWriteFreq(int memberId);
}

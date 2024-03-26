package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Article;

@Mapper
public interface ArticleDao {

	
	@Select("""
			<script>
				SELECT
					A.*
					, M.nickname writerName
					, (SELECT COUNT(*) FROM reply WHERE relId = A.id) replyCnt
					, IFNULL(SUM(R.point), 0) reactionLikeCnt
				FROM article A
				LEFT JOIN `member` M
				ON A.memberId = M.id
				LEFT JOIN reaction R
				ON A.id = R.relId AND R.reactionType = 0
				LEFT JOIN board B
				ON A.boardId = B.id
				WHERE 1 = 1
				<if test="boardId != null and boardId != 1">
					AND A.boardId = #{boardId}
				</if>
				<if test="searchKeyword != ''">
					<choose>
						<when test="searchType == 1">
							AND A.title LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<when test="searchType == 2">
							AND A.body LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<otherwise>
							AND (
								A.title LIKE CONCAT('%', #{searchKeyword}, '%')
								OR A.body LIKE CONCAT('%', #{searchKeyword}, '%')
							)
						</otherwise>
					</choose>
				</if>
				GROUP BY A.id
				ORDER BY A.id DESC
				LIMIT ${limitFrom}, ${itemsInAPage};
			</script>
			""")
	public List<Article> getArticles(int boardId, int limitFrom, int itemsInAPage, int searchType, String searchKeyword);
	
	@Select("""
			SELECT * FROM article
			WHERE id = #{id}
			""")
	public Article getArticleById(int id);

	@Insert("""
			INSERT INTO article
				SET regDate = NOW()
					, updateDate = NOW()
					, memberId = #{loginedMemberId}
					, boardId = #{boardId}
					, title = #{title}
					, `body` = #{body}
			""")
	public void doWrite(int loginedMemberId, int boardId, String title, String body);

	@Delete("""
			DELETE FROM article
			WHERE id = #{id}
			""")
	public void doDeleteById(int id);

	@Update("""
			<script>
			UPDATE article
				SET updateDate = NOW()
					<if test="title != null and title != ''">
						, title = #{title}
					</if>
					<if test="body != null and title != ''">
						, `body` = #{body}
					</if>
				WHERE id = #{id}
			</script>
			""")
	public void doModify(int id, String title, String body);

	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();

	@Select("""
			<script>
				SELECT COUNT(*)
				FROM article
				WHERE 1 = 1
				<if test="boardId != 1">
					AND boardId = #{boardId}
				</if>
				<if test="searchKeyword != ''">
					<choose>
						<when test="searchType == 1">
							AND title LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<when test="searchType == 2">
							AND body LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<otherwise>
							AND (
								title LIKE CONCAT('%', #{searchKeyword}, '%')
								OR body LIKE CONCAT('%', #{searchKeyword}, '%')
							)
						</otherwise>
					</choose>
				</if>
			</script>
			""")
	public int getTotalCount(int boardId, int searchType, String searchKeyword);
	
	/*
	 	SELECT A.*
				, M.nickname AS writerName
				, IFNULL(SUM(R.point), 0) `point`
				, (SELECT COUNT(*) FROM reply WHERE relId = A.id) replyCnt
				FROM article AS A
				INNER JOIN `member` AS M
				ON A.memberId = M.id
				LEFT JOIN recommendPoint R
				ON A.id = R.relId
				WHERE A.id = #{id}
				GROUP BY A.id
	 */
	@Select("""
			SELECT A.*
				, M.nickname AS writerName
				, (SELECT COUNT(*) FROM reply WHERE relId = A.id) replyCnt
				, IFNULL(SUM(R.point), 0) reactionLikeCnt
				FROM article AS A
				INNER JOIN `member` AS M
				ON A.memberId = M.id
				LEFT JOIN reaction R
				ON A.id = R.relId AND R.reactionType = 0
				WHERE A.id = #{id}
			""")
	public Article getArticleWithDetailsById(int id);
	
	@Update("""
			UPDATE article
				SET hitCnt = hitCnt + 1
				WHERE id = #{id}
			""")
	public void increaseHitCnt(int id);
	
	@Select("""
			SELECT A.*
			    , M.nickname writerName
			    , (SELECT COUNT(*) FROM reply WHERE relId = A.id) replyCnt
			    , IFNULL(SUM(R.point), 0) reactionLikeCnt
			FROM article A
			LEFT JOIN `member` M
			    ON A.memberId = M.id
			LEFT JOIN reaction R
			    ON A.id = R.relId
			    AND R.reactionType = 0
			WHERE R.relTypeCode = 'article'
			    AND A.regDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
			GROUP BY A.id
			ORDER BY reactionLikeCnt DESC, A.id DESC
			LIMIT 6;
			""")
	public List<Article> getHotArticles();
	
	@Select("""
			SELECT A.*
			    , M.nickname writerName
			    , (SELECT COUNT(*) FROM reply WHERE relId = A.id) replyCnt
			FROM article A
			LEFT JOIN `member` M
			    ON A.memberId = M.id
			WHERE boardId = 2
			ORDER BY id DESC
			LIMIT 5;
			""")
	public List<Article> getNoticeArticles();
}

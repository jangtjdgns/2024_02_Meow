package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Interval;

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
					ON A.id = R.relId
					AND R.reactionType = 0
					AND R.relTypeCode = 'article'
				LEFT JOIN board B
					ON A.boardId = B.id
				WHERE M.status != 3
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
				LIMIT ${limitFrom}, ${itemsInAPage}
			</script>
			""")
	public List<Article> getArticles(int boardId, int limitFrom, int itemsInAPage, int searchType, String searchKeyword);
	
	@Select("""
			SELECT * FROM article
			WHERE id = #{id}
			""")
	public Article getArticleById(int id);
	
	
	@Select("""
			<script>
				SELECT
				    A.*
				    , M.nickname writerName
				    , B.name boardName
				    , COUNT(DISTINCT Rp.id) replyCnt
				    , COALESCE(Likes.reactionLikeCnt, 0) AS reactionLikeCnt
			 		, COALESCE(Dislikes.reactionDislikeCnt, 0) AS reactionDislikeCnt
				FROM article A
				LEFT JOIN `member` M
				    ON A.memberId = M.id
				LEFT JOIN board B
					ON A.boardId = B.id
				LEFT JOIN (SELECT relId, COUNT(*) AS reactionLikeCnt FROM reaction WHERE reactionType = 0 AND relTypeCode = 'article' GROUP BY relId) Likes
				    ON A.id = Likes.relId
				LEFT JOIN (SELECT relId, COUNT(*) AS reactionDislikeCnt FROM reaction WHERE reactionType = 1 AND relTypeCode = 'article' GROUP BY relId) Dislikes
				    ON A.id = Dislikes.relId
				LEFT JOIN reply Rp
				    ON A.id = Rp.relId
				WHERE 1 = 1
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
				<if test="boardType > 1">
					AND B.id = #{boardType}
				</if>
				GROUP BY A.id
				<if test="order == false">
					ORDER BY A.id DESC
				</if>
				<if test="order == true">
					ORDER BY A.id ASC
				</if>
				LIMIT #{limitFrom}, #{articleCnt};
			</script>
			""")
	public List<Article> admGetArticles(int limitFrom, int articleCnt, int searchType, String searchKeyword, int boardType, boolean order);
	
	@Select("""
			SELECT
			    A.*,
			    M.nickname AS writerName,
			    B.name AS boardName,
			    COUNT(DISTINCT Rp.id) AS replyCnt,
			    COALESCE(Likes.reactionLikeCnt, 0) AS reactionLikeCnt,
			    COALESCE(Dislikes.reactionDislikeCnt, 0) AS reactionDislikeCnt
			FROM article A
			LEFT JOIN `member` M
			    ON A.memberId = M.id
			LEFT JOIN  board B
			    ON A.boardId = B.id
			LEFT JOIN (SELECT relId, COUNT(*) AS reactionLikeCnt FROM reaction WHERE reactionType = 0 AND relTypeCode = 'article' GROUP BY relId) Likes
			    ON A.id = Likes.relId
			LEFT JOIN (SELECT relId, COUNT(*) AS reactionDislikeCnt FROM reaction WHERE reactionType = 1 AND relTypeCode = 'article' GROUP BY relId) Dislikes
			    ON A.id = Dislikes.relId
			LEFT JOIN reply Rp ON A.id = Rp.relId
			WHERE A.id =  #{id}
			""")
	public Article admGetArticleById(int id);
	
	
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
			SELECT LAST_INSERT_ID()
			""")
	public int getLastInsertId();

	@Select("""
			<script>
				SELECT COUNT(*)
				FROM article A
				LEFT JOIN `member` M
			 		ON A.memberId = M.id
				WHERE M.status != 3
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
			LIMIT 6
			""")
	public List<Article> getWeeklyHotArticles();
	
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
			GROUP BY A.id
			ORDER BY reactionLikeCnt DESC, A.id DESC
			LIMIT #{count}
			""")
	public List<Article> getHotArticles(int count);
	
	@Select("""
			SELECT A.*
			    , M.nickname writerName
			    , (SELECT COUNT(*) FROM reply WHERE relId = A.id) replyCnt
			FROM article A
			LEFT JOIN `member` M
			    ON A.memberId = M.id
			WHERE boardId = 2
			ORDER BY id DESC
			LIMIT #{count}
			""")
	public List<Article> getNoticeArticles(int count);
	
	@Select("""
			<script>
				SELECT DATE_FORMAT(regDate, '%Y-%m-%d') `date`, COUNT(*) articleCnt
					FROM article
					WHERE memberId = #{memberId}
					<choose>
						<when test="interval == 'year'">
							AND regDate >= DATE_SUB(NOW(), INTERVAL #{intervalFreq} YEAR)
						</when>
						<when test="interval == 'month'">
							AND regDate >= DATE_SUB(NOW(), INTERVAL #{intervalFreq} MONTH)
						</when>
						<otherwise>
							AND regDate >= DATE_SUB(NOW(), INTERVAL #{intervalFreq} WEEK)
						</otherwise>
					</choose>
					GROUP BY DATE_FORMAT(regDate, '%Y-%m-%d')
					ORDER BY regDate DESC
					LIMIT #{barCnt}
				</script>
			""")
	public List<Interval> getArticleFreq(int memberId, String interval, int intervalFreq, int barCnt);
	
	@Select("""
			SELECT A.*
			    , B.name boardName
			    , (SELECT COUNT(*) FROM reply WHERE relId = A.id) replyCnt
			    , IFNULL(SUM(R.point), 0) reactionLikeCnt
			FROM article A
			LEFT JOIN board B
			    ON A.boardId = B.id
			LEFT JOIN reaction R
			    ON A.id = R.relId
			    AND relTypeCode = 'article'
			    AND reactionType = 0
			GROUP BY A.id
			ORDER BY A.id DESC
			LIMIT #{count}
			""")
	public List<Article> getLatestArticles(int count);

}

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
				SELECT A.*, M.nickname writerName
				FROM article A
				LEFT JOIN `member` M
				ON A.memberId = M.id
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
}

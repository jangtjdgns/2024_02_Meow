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
				<if test="boardId != null and boardId != 1">
					WHERE A.boardId = #{boardId}
				</if>
				ORDER BY A.id DESC
				LIMIT 0, 10;
			</script>
			""")
	public List<Article> getArticles(int boardId);
	
	@Select("""
			SELECT * FROM article
			WHERE id = #{id}
			""")
	public Article getArticleById(int id);

	@Insert("""
			INSERT INTO article
				SET regDate = NOW()
					, updateDate = NOW()
					, title = #{title}
					, `body` = #{body}
			""")
	public void doWrite(String title, String body);

	@Delete("""
			DELETE FROM article
			WHERE id = #{id}
			""")
	public void doDeleteById(int id);

	@Update("""
			UPDATE article
			SET updateDate = NOW()
				, title = #{title}
				, `body` = #{body}
			WHERE id = #{id}
			""")
	public void doModify(int id, String title, String body);

	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();
}

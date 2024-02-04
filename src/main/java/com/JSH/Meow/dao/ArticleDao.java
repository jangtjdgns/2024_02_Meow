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
			SELECT * FROM article
			ORDER BY id DESC;
			""")
	public List<Article> getArticles();

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

package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.ArticleDao;
import com.JSH.Meow.vo.Article;

@Service
public class ArticleService {

	private ArticleDao articleDao;
	
	public ArticleService(ArticleDao articleDao) {
		this.articleDao = articleDao;
	}
	
	
	public List<Article> getArticles(int boardId) {
		return articleDao.getArticles(boardId);
	}

	public Article getArticleById(int id) {
		return articleDao.getArticleById(id);
	}


	public void doWrite(String title, String body) {
		articleDao.doWrite(title, body);
	}


	public void doDeleteById(int id) {
		articleDao.doDeleteById(id);
	}


	public void doModify(int id, String title, String body) {
		articleDao.doModify(id, title, body);
	}


	public int getLastInsertId() {
		return articleDao.getLastInsertId();
	}
	
}

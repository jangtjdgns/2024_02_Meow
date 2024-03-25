package com.JSH.Meow.service;

import java.io.IOException;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.JSH.Meow.config.component.UploadComponent;
import com.JSH.Meow.dao.ArticleDao;
import com.JSH.Meow.vo.Article;

@Service
public class ArticleService {

	private ArticleDao articleDao;
	
	public ArticleService(ArticleDao articleDao) {
		this.articleDao = articleDao;
	}
	
	
	public List<Article> getArticles(int boardId, int limitFrom, int itemsInAPage, int searchType, String searchKeyword) {
		return articleDao.getArticles(boardId, limitFrom, itemsInAPage, searchType, searchKeyword);
	}

	public Article getArticleById(int id) {
		return articleDao.getArticleById(id);
	}

	public void doWrite(int loginedMemberId, int boardId, String title, String body) {
		articleDao.doWrite(loginedMemberId, boardId, title, body);
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

	public int getTotalCount(int boardId, int searchType, String searchKeyword) {
		return articleDao.getTotalCount(boardId, searchType, searchKeyword);
	}

	public Article getArticleWithDetailsById(int id) {
		return articleDao.getArticleWithDetailsById(id);
	}

	public void increaseHitCnt(int id) {
		articleDao.increaseHitCnt(id);
	}

	public List<Article> getHotArticles() {
		return articleDao.getHotArticles();
	}
}

package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.ArticleDao;
import com.JSH.Meow.vo.Article;
import com.JSH.Meow.vo.Interval;

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
	
	public List<Article> admGetArticles(int limitFrom, int articleCnt, int searchType, String searchKeyword, int boardType, boolean order) {
		return articleDao.admGetArticles(limitFrom, articleCnt, searchType, searchKeyword, boardType, order);
	}
	
	public Article admGetArticleById(int id) {
		return articleDao.admGetArticleById(id);
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
	
	// HOT 게시글 가져오기, 좋아요 기준 (제한: 일주일 내에 작성된 게시글 중)
	public List<Article> getWeeklyHotArticles() {
		return articleDao.getWeeklyHotArticles();
	}
	
	// HOT 게시글 가져오기, 좋아요 기준 (제한없음)
	public List<Article> getHotArticles(int count) {
		return articleDao.getHotArticles(count);
	}
	
	// 최신 공지사항 가져오기, 개수 지정
	public List<Article> getNoticeArticles(int count) {
		return articleDao.getNoticeArticles(count);
	}
	
	public List<Interval> getArticleFreq(int memberId, String interval, int intervalFreq, int barCnt) {
		return articleDao.getArticleFreq(memberId, interval, intervalFreq, barCnt);
	}

	// 최신 게시글 가져오기, 개수 지정
	public List<Article> getLatestArticles(int count) {
		return articleDao.getLatestArticles(count);
	}
}

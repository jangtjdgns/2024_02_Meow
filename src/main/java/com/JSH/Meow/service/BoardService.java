package com.JSH.Meow.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.JSH.Meow.dao.BoardDao;
import com.JSH.Meow.vo.Board;

@Service
public class BoardService {
	private BoardDao boardDao;
	
	public BoardService(BoardDao boardDao) {
		this.boardDao = boardDao;
	}

	public List<Board> getBoards() {
		return boardDao.getBoards();
	}
	
	
}

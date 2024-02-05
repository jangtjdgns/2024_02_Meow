package com.JSH.Meow.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.JSH.Meow.vo.Board;

@Mapper
public interface BoardDao {

	@Select("SELECT * FROM board")
	List<Board> getBoards();
}

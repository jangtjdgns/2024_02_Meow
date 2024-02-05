<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<section class="img-h" style="background-image: url(https://i.pinimg.com/originals/8b/ca/9a/8bca9a987e1a1873e01d83371e4a31ca.jpg);"></section>

<section class="mx-auto max-w-5xl">
	<div class="flex">
		<div class="pr-2.5">게시판</div>
		<select name="boardId" id="select-board" class="select select-bordered select-sm" onchange="location.replace('?boardId=' + this.value)">
			<c:forEach var="board" items="${boards }">
				<option value="${board.id }" ${boardId == board.id ? 'selected' : '' }>${board.name }</option>
			</c:forEach>
		</select>
		
	</div>
	
	<div>
		<table class="table text-center">
			<thead class="bg-gray-100">
				<tr>
					<th>번호</th>
					<th style="width:480px">제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>추천</th>
					<th>조회수</th>
				</tr>
			</thead>
		
			<tbody>
				<c:if test="${articles.size() == 0 }">
					<tr>
						<td class="text-center" colspan="6">등록된 게시물이 없습니다 <button class="underline text-red-600" onclick="history.back()">돌아가기</button></td>
					</tr>
				</c:if>
				
				<c:forEach var="article" items="${articles }">
					<tr>
						<td>${article.id }</td>
						<td class="hover:underline text-left px-5"><a href="detail?boardId=${board.id}&id=${article.id }">${article.title }</a></td>
						<td>${article.writerName }</td>
						<td class="text-center">${article.formattedRegDate }</td>
						<td>0</td>
						<td>0</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<a href="write" class="btn">글작성</a>
</section>

<%@ include file="../common/footer.jsp"%>
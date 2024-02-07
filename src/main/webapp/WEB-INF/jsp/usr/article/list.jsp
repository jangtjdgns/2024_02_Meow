<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/header.jsp"%>

<!-- 기본 uri -->
<c:set var="baseUri" value="?boardId=${boardId }&searchType=${searchType }&searchKeyword=${searchKeyword }&itemsInAPage=${itemsInAPage }&listStyle=${listStyle }"></c:set>
<script>
	$(function(){
		// list-style 변경 시
		$("#list-style-change-btn").change(() => {
			$("#list-style-1").toggleClass("hidden");
			$("#list-style-2").toggleClass("hidden");
			
			// list-style 버튼 클릭 시, checked 속성에 따라 0, 1 저장
			const listStyle = !\$("#list-style-change-btn").prop("checked") ? 0 : 1;
			
			$("#listStyle").val(listStyle);
			
			let baseUri = "${baseUri }";						// 기본uri
			baseUri = baseUri.substr(0, baseUri.length - 1);	// 기본uri의 listStyle 값을 자른 나머지 저장
			
			// 페이징 버튼
			$(".join a").each(function(idx, link){
				let page = $(link).prop("href").substr(38).replace(baseUri, "").substr(1);	// 해당 a태그의 href 속성값에서 page 부분만 자른 후 저장
				$(link).prop("href", baseUri + listStyle + page);							// 해당 a태그의 href 속성값 변경 (기본uri + listStyle + 페이지)
			})
		})
		
		// board 변경 시
		$("#select-board").change(function() {
			const boardId = \$(this).val()
			const listStyle = !\$("#list-style-change-btn").prop("checked") ? 0 : 1;
			window.location.replace(`?boardId=\${boardId}&listStyle=\${listStyle}`);
		})
		
	})
</script>

<section class="img-section-mh">
	<div class="img-section" style="background-image: url(https://i.pinimg.com/originals/8b/ca/9a/8bca9a987e1a1873e01d83371e4a31ca.jpg);"></div>
</section>

<section class="mx-auto max-w-5xl">

	<!-- 게시판 선택 -->
	<div class="flex pb-16">
		<div class="flex items-center border-2 border-t-0">
			<div class="self-center text-base mx-4 my-2 font-bold">게시판</div>
			<span class="border-r-2 h-full"></span>
			<select name="boardId" id="select-board" class="select select-ghost select-sm text-base mx-1">
				<c:forEach var="board" items="${boards }">
					<option value="${board.id }" ${boardId == board.id ? 'selected' : '' }>${board.name }</option>
				</c:forEach>
			</select>
		</div>
	</div>
	
	<!-- 게시글 검색, 게시글 스타일 변경 -->
	<div class="flex items-end justify-between pb-2">
		<div class="text-sm">게시물(${articlesCnt })</div>
		
		<div class="flex items-center">
		
			<div class="flex">
				<form action="list" method="get">
					<input type="hidden" name="boardId" value="${boardId }" />
					<input type="hidden" id="listStyle" name="listStyle" value="${listStyle }" />
					<div class="join mr-2">
						<select name="itemsInAPage" class="select select-bordered select-sm h-10 join-item">
							<c:forEach var="i" begin="10" end="30" step="5">
								<option value="${i }" ${itemsInAPage == i ? 'selected' : '' }>${i }</option>
							</c:forEach>
						</select>
					    <div>
					    	<input name="searchKeyword" class="input input-bordered h-10 join-item" placeholder="Search" value="${searchKeyword }" />
					    </div>
					    <select name="searchType" class="select select-bordered select-sm h-10 join-item">
					        <option value="1" ${searchType == 1 ? 'selected' : ''}>제목</option>
							<option value="2" ${searchType == 2 ? 'selected' : ''}>내용</option>
							<option value="3" ${searchType == 3 ? 'selected' : ''}>제목+내용</option>
					    </select>
					    <button class="btn btn-sm h-10 join-item">
							<i class="fa-solid fa-magnifying-glass"></i>
						</button>
					</div>
				</form>
			</div>
			
			<label class="btn btn-circle btn-ghost btn-md swap swap-rotate text-xl">
				<input type="checkbox" ${listStyle == 1 ? 'checked' : '' } id="list-style-change-btn" />
			  	<span class="swap-off"><i class="fa-solid fa-bars"></i></span>
			  	<span class="swap-on"><i class="fa-regular fa-clone"></i></span>
			</label>
		</div>
	</div>
	
	
	<!-- 게시글 스타일 1 -->
	<div id="list-style-1" class="${listStyle == 1 ? 'hidden' : '' }">
		<table class="table text-center">
			<thead class="bg-gray-100">
				<tr>
					<th>번호</th>
					<th width=50%>제목</th>
					<th width=175>작성자</th>
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
				
				<c:forEach var="article" items="${articles }" varStatus="status">
					<tr style="animation-delay: ${(status.index + 1) * 20 }ms;">
						<td>${article.id }</td>
						<td class="hover:underline text-left px-5"><a href="detail?boardId=${boardId}&id=${article.id }">${article.title }</a></td>
						<td>${article.writerName }</td>
						<td class="text-center">${article.formattedRegDate }</td>
						<td>0</td>
						<td>0</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	
	<!-- 게시글 스타일 2 -->
	<div id="list-style-2" class="${listStyle == 0 ? 'hidden' : '' }">
		<div class="grid grid-cols-3 gap-x-4 gap-y-3">
			<c:if test="${articles.size() == 0 }">
				<div class="h-10 overflow-hidden border rounded-lg list-style-2 col-start-1 col-end-4 flex items-center justify-center" style="transition: none;">
					등록된 게시물이 없습니다 <button class="underline text-red-600" onclick="history.back()">돌아가기</button>
				</div>
			</c:if>
			<c:forEach var="article" items="${articles }" varStatus="status">
				<a href="detail?id=${article.id }&boardId=${boardId }">
					<div class="h-72 overflow-hidden border rounded-lg grid list-style-2 scale" style="grid-template-rows: 3fr 1fr; animation-delay: ${(status.index + 1) * 100 }ms;">
						<div class="bg-gray-200">
							<img src=""/>
							<div>IMG</div>
						</div>
						<div class="flex flex-col">
							<div>
								<span>${article.id } |</span>
								<span>0</span>
								<span>0</span>
							</div>
							<div>
								<span>${article.title }</span>
							</div>
							<div>
								<span>${article.writerName }</span>
								<span>${article.regDate }</span>
							</div>
						</div>
					</div>
				</a>
			</c:forEach>
		</div>
	</div>
	
	
	<!-- 작성 버튼 -->
	<c:if test="${rq.loginedMemberId != 0 }">
		<div class="flex justify-end mt-4">
			<a href="write" class="btn">글작성</a>
		</div>
	</c:if>
	
	
	<!-- 페이징버튼 -->
	<div class="flex justify-center pb-12 ${rq.loginedMemberId == 0 ? 'pt-16' : ''}">
		
		<div class="join">
			<c:if test="${from != 1 }">
				<a href="${baseUri }&page=${1}" class="join-item btn btn-sm">≪</a>
				<a href="${baseUri }&page=${from - 1 }" class="join-item btn btn-sm">&lt;</a>
			</c:if>
			
			<c:forEach var="i" begin="${from }" end="${end }" step="1">
				<a href="${baseUri }&page=${i }" class="${end != 1 ? 'join-item' : ''} ${page == i ? 'btn-active' : '' } btn btn-sm">${i }</a>
			</c:forEach>
			
			
			<c:if test="${end != totalPageCnt }">
				<a href="${baseUri }&page=${end + 1 }" class="join-item btn btn-sm">&gt;</a>
		  		<a href="${baseUri }&page=${totalPageCnt }" class="join-item btn btn-sm">≫</a>
			</c:if>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../../usr/common/toastUiCdn.jsp"%>

<script>
	//회원 목록 가져오기
	function admGetArticles() {
		const page = $('#page').val().trim();
		const articleCnt = $('#articleCnt').val().trim();
		const searchType = $('#searchType').val().trim();
		const searchKeyword = $('#searchKeyword').val().trim();
		const boardType = $('.boardType[name="boardType"]:checked').val();
		const order = $('#order').prop("checked");
		
		$.ajax({
			url: '/adm/article/list',
		    method: 'GET',
		    data: {
		    	page: page,
		    	articleCnt: articleCnt,
		    	searchType: searchType,
		    	searchKeyword: searchKeyword,
		    	boardType: boardType,
		    	order: order
		    },
		    dataType: 'json',
		    success: function(data) {
		    	$(".articles").empty();
		    	if(data.success) {
		    		const articles = data.data;
		    		
		    		for(let i = 0; i < articles.length; i++) {
		    			const article = `
		    				<tr class="hover:bg-gray-50 cursor-pointer" onclick="admGetArticle(\${articles[i].id})">
		    					<td>\${i + 1}</td>
		    					<td>\${articles[i].id}</td>
		    					<td class="text-left truncate [width:250px] [max-width:250px]">\${articles[i].title}</td>
		    					<td>\${articles[i].writerName}</td>
		    					<td>\${articles[i].formattedRegDate}</td>
		    					<td>\${articles[i].replyCnt}</td>
		    					<td>\${articles[i].hitCnt}</td>
		    					<td>\${articles[i].reactionLikeCnt}</td>
		    					<td>\${articles[i].reactionDislikeCnt}</td>
					      	</tr>
		    			`;
		    			
		    			$(".articles").append(article);
		    		} 
		    	} else {
		    		$(".articles").append(`
		    			<tr>
			    			<td colspan=9>\${data.msg}</td>
			    		</tr>
		    		`);
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			},
		});
	}

	//게시글 정보 가져오기
	function admGetArticle(articleId) {
		
		$.ajax({
		    url: '/adm/article/detail',
		    method: 'GET',
		    data: {
		    	articleId: articleId
		    },
		    dataType: 'json',
		    success: function(data) {
		    	const article = data.data;
		    	
		    	const htmlString = `
		    		<div class="absolute top-2 left-4 z-40">
	    				<a href="../../usr/article/detail?boardId=\${article.boardId}&id=\${article.id}" target="_blank" class="btn btn-xs btn-neutral">바로가기</a>
	    			</div>
	    			
	    			<div class="absolute top-2 right-4 z-40">
		    			<div class="join">
		    			  <button class="btn btn-xs join-item" onclick="setArticleSize(-0.1)"><i class="fa-solid fa-minus"></i></button>
		    			  <input type="text" class="input input-bordered input-xs join-item w-20 text-center articleSize" onchange="setArticleSize(0)" placeholder="50 ~ 100" value="\${parseInt(articleSize * 100)}" />
		    			  <button class="btn btn-xs join-item" onclick="setArticleSize(0.1)"><i class="fa-solid fa-plus"></i></button>
		    			</div>
	    			</div>
	    			
		    		<section class="mw b-mh" style="transform: scale(\${articleSize});">
			    		<div class="border w-full [height:480px] absolute top-0 z-10">
			    			<img src="https://img.freepik.com/free-vector/cats-doodle-pattern-background_53876-100663.jpg?w=900&t=st=1710412076~exp=1710412676~hmac=a3b9244e4cb10307314db65461bb7052aa5e39285a4ff512399bfca4beb1a042" class="w-full h-full object-cover">
			    		</div>
						
			    		<div class="mx-auto max-w-4xl w-full bg-white p-14 absolute top-20 left-1/2 z-20 -translate-x-1/2 bg-opacity-95 rounded">
			    			<div class="pb-2 flex items-center justify-between">
			    				<div class="boardName"><a href="../../usr/article/list?boardId=\${article.boardId}" target="_blank" class="text-blue-600 hover:font-bold">\${article.boardName}</a></div>
			    				<div class="text-sm flex justify-between gap-2">
			    					<div class="flex gap-2">
		
			    						<!-- 게시글 작성일 -->
			    						<div class="pr-2">
			    							<span class="text-xs"><i class="fa-regular fa-clock"></i></span>
			    							<span class="text-gray-600">\${article.formattedRegDate}</span>
			    						</div>
		
			    						<!-- 게시글 댓글수 -->
			    						<div>
			    							<span class="text-xs"><i class="fa-regular fa-comment-dots"></i></span>
			    							<span class="text-gray-600 replyCnt">\${article.replyCnt}</span>
			    						</div>
		
			    						<!-- 게시글 좋아요수 -->
			    						<div>
			    							<span class="text-xs"><i class="fa-regular fa-thumbs-up"></i></span>
			    							<span class="text-gray-600 reactionLikeCnt">\${article.reactionLikeCnt}</span>
			    						</div>
		
			    						<!-- 게시글 조회수 -->
			    						<div>
			    							<span class="text-xs"><i class="fa-regular fa-eye"></i></span>
			    							<span class="text-gray-600">\${article.hitCnt}</span>
			    						</div>
			    					</div>
			    					<div></div>
			    				</div>
			    			</div>
		
			    			<!-- 게시글 제목, 내용 -->
			    			<div>
			    				<div class="text-3xl font-LINESeed pb-5">\${article.title}</div>
			    				<textarea id="body" class="hidden">\${article.body}</textarea>
								
			    				<div id="viewer" class="[min-height:30vh] mb-5"></div>
			    			</div>
		
			    			<!-- 게시글 좋아요 & 싫어요 -->
			    			<div class="flex justify-center gap-2">
			    				<button class="btn [min-width:7rem]">
			    					<i class="fa-solid fa-thumbs-up"></i> <span class="reactionCount-article">\${article.reactionLikeCnt}</span>
			    				</button>
		
			    				<button class="btn [min-width:7rem]">
			    					<i class="fa-solid fa-thumbs-down"></i> <span class="reactionCount-article">\${article.reactionDislikeCnt}</span>
			    				</button>
			    			</div>
		
			    			<!-- 댓글 -->
			    			<div class="w-full pt-4">
			    				<div class="border-b-2 pb-4">
			    					<div class="flex items-end justify-between pb-2">
			    						<div>댓글 (<span class="replyCnt">\${article.replyCnt}</span>)</div>
			    						<div>
			    							<a class="btn btn-xs btn-neutral rounded-none">목록</a>
			    							<button class="btn btn-xs btn-neutral rounded-none">뒤로가기</button>
			    						</div>
			    					</div>
			    				</div>
			    			</div>
			    			
			    			<div class="text-center mt-4">댓글은 해당
			    				<a href="../../usr/article/detail?boardId=\${article.boardId}&id=\${article.id}" target="_blank" class="underline text-red-600">게시글</a>
			    				을 통해 볼 수 있습니다.
			    			</div>
			    	</section>
		    	`;
		    	
		    	$(".article").html(htmlString)
		    	ToastEditorView__init();
		    },
		    error: function(xhr, status, error) {
		        console.error('Error fetching data:', error);
		    }
		});
	}
	
	
	// 게시글 크기 조절
	let articleSize = 1;	// scale
	function setArticleSize(size) {
		
		// 숫자 변환 시 NaN 처리
		if (isNaN(parseInt($(".articleSize").val()))) {
		    articleSize = 1;
		}
		
		if(size !== 0) {		// -, + 버튼 클릭
			articleSize += size;
		} else {	 			// size 변경 시
			articleSize = parseFloat(($(".articleSize").val() * 0.01).toFixed(2));
		}
		
		console.log(articleSize)
		size = parseInt(articleSize * 100)
		
		// 사이즈 범위 체크
		if(!(size >= 50 && size <= 100)) {
			articleSize = 1;
			size = parseInt(articleSize * 100);
		}
		
		// 크기 변환
		$(".mw").css('transform', `scale(\${articleSize})`);
		// 표시
		$(".articleSize").val(size);
	}
	
	
	// 토스트UI 뷰어, 게시글 표시용
	function ToastEditorView__init() {
		const $initialValueEl = $("#body");
		const initialValue = $initialValueEl.val();
		
		var viewer = new toastui.Editor.factory({
			el : document.querySelector("#viewer"),
			initialValue : initialValue,
			viewer : true,
			plugins : [toastui.Editor.plugin.colorSyntax]
		});

		$("#viewer").data('viewer', viewer);
	}
	
	
	$(function() {
		admGetArticles();
		
		// 게시글 옵션 슬라이드, 게시글 크게보는 용도
		$(".option-slide-btn").on({
			mouseenter: function() {
				if($(this).children().children().hasClass("fa-chevron-down")) {
					$(this).children().slideDown(200);
				}
			},
			mouseleave: function() {
				if($(this).children().children().hasClass("fa-chevron-down")) {
					$(this).children().slideUp(200);
				}
			},
			click: function() {
				$(this).children().children().toggleClass("fa-chevron-down");
				$(this).children().children().toggleClass("fa-chevron-up");
				$(this).parent().toggleClass("h-5");
				$(this).parent().prev().toggleClass("row-end-3");
			}
		})
	})
</script>


<div class="grid grid-cols-4 grid-rows-2 p-4 gap-4 h-full">
	
	<!-- 게시글 정보 -->
	<div class="article col-start-1 col-end-5 row-start-1 row-end-2 overflow-auto border-2 rounded-lg relative">
		<div class="w-full h-full flex items-center justify-center text-lg">게시글을 선택해주세요.</div>
	</div>
	
	<!-- 게시글 목록 -->
	<div class="border-2 rounded-lg col-start-1 col-end-5 relative overflow-hidden" style="transition: 300ms;">
	
		<div class="absolute w-full h-5 option-slide-btn z-10 cursor-pointer flex items-start justify-center">
			<div class="hidden w-full bg-gray-100 bg-opacity-80 text-center"><i class="fa-solid fa-chevron-down"></i></div>	
		</div>
		
		<div class="flex gap-2 p-2 w-full h-full z-20">
			<div class="w-96 h-full shadow px-2">
				<div class="w-full text-xl text-center font-LINESeed p-2">게시글 검색 옵션</div>
				
				<div class="relative h-full">
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-xs">페이지</span>
						    <span class="label-text text-xs">표시되는 게시글 수</span>
					  	</div>
					  	<div class="flex gap-2">
							<input type="number" id="page" class="input input-sm input-bordered w-1/2" value="1" min="1" placeholder="기본값 1페이지" autocomplete="off" />
							<input type="number" id="articleCnt" class="input input-sm input-bordered w-1/2" value="10" min="1" placeholder="기본값 10개" autocomplete="off" />
						</div>
					</label>
					
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-xs">옵션 선택</span>
					  	</div>
					  	<div class="flex gap-2">
						  	<select id="searchType" class="select select-sm select-bordered">
							    <option value="0" checked>제목+내용</option>
							    <option value="1">제목</option>
							    <option value="2">내용</option>
						  	</select>
						  	<input type="text" id="searchKeyword" class="input input-sm input-bordered w-full" placeholder="검색어" autocomplete="off" />
						</div>
					</label>
					
					<label class="form-control w-full">
						<div class="label">
						    <span class="label-text text-xs">게시판 선택</span>
					  	</div>
					</label>
					<div class="join grid grid-cols-6">
					  	<input class="boardType join-item btn btn-sm text-xs" type="radio" name="boardType" value="1" aria-label="전체" checked/>
					  	<input class="boardType join-item btn btn-sm text-xs" type="radio" name="boardType" value="2" aria-label="공지" />
					  	<input class="boardType join-item btn btn-sm text-xs" type="radio" name="boardType" value="3" aria-label="자유" />
					  	<input class="boardType join-item btn btn-sm text-xs" type="radio" name="boardType" value="4" aria-label="반려" />
					  	<input class="boardType join-item btn btn-sm text-xs" type="radio" name="boardType" value="5" aria-label="거래" />
					  	<input class="boardType join-item btn btn-sm text-xs" type="radio" name="boardType" value="6" aria-label="모임" />
					</div>
					
					<label class="form-control w-full flex-row items-center justify-between">
						<div class="label">
						    <span class="label-text text-xs pr-1.5">정렬순서</span>
						  	<input id="order" type="checkbox" class="checkbox checkbox-sm" />
					  	</div>
					  	<div class="">
					  		<span class="label-text text-xs"><span class="text-red-700">*</span> 기본: 내림차순, 선택: 오름차순</span>
					  	</div>
					</label>
					
					
					<div class="absolute text-center bottom-14 w-full">
						<button class="btn btn-sm w-full" onclick="admGetArticles()">검색</button>
					</div>
				</div>
			</div>
			
			<div class="w-full h-full overflow-x-auto">
				<div class="h-full">
				  	<table class="table table-xs adm-member-table text-center">
					    <thead>
					      	<tr>
					        	<th>번호</th>
					        	<th>게시글 번호</th>
								<th class="[width:250px] [max-width:250px]">제목</th>
								<th>작성자</th>
								<th>게시일</th>
								<th>댓글 수</th>
								<th>조회 수</th>
								<th>좋아요 수</th>
								<th>싫어요 수</th>
					      	</tr>
				    	</thead>
				    	
				    	<!-- ajax 사용 -->
					    <tbody class="articles"></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
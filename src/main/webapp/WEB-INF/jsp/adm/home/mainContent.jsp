<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="/js/adm/home/pieChart.js"></script>
<script>
const getNoticeArticle = function(){
	$.ajax({
		url: '/adm/getArticle/notice',
	    method: 'GET',
	    dataType: 'json',
	    success: function(data) {
	    	if(data.success) {
	    		const articles = data.data;
		    	
		    	for(let i = 0; i < articles.length; i++) {
		    		const article = `
			    		<tr class="hover:bg-gray-50">
					        <th>\${i + 1}</th> 
					        <td>\${articles[i].id}</td> 
					        <td class="hover:underline text-left truncate [max-width:465px]">
					        	<a href="../../usr/article/detail?boardId=2&id=\${articles[i].id}">\${articles[i].title}</a>
					        </td> 
					        <td>\${articles[i].writerName}</td>
					        <td>\${articles[i].formattedUpdateDate}</td> 
				      	</tr>
			    	`;
			    	
		    		$(".notice-articles").append(article);
		    	}
	    	} else {
	    		$(".notice-articles").append(`
	    			<tr class="text-center">
				        <th colspan=4>\${data.msg}</th>
			      	</tr>
		    	`);
	    	}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
	});
}

$(function(){
	getNoticeArticle();
})
</script>

<div class="grid grid-cols-3 grid-rows-3 p-4 gap-4 h-full">
	<div class="border-2 rounded-lg col-start-1 col-end-3 row-start-1 row-end-3 p-1 relative overflow-scroll">
		<div id="pieChart" class="w-full h-full"></div>
		<div class="absolute bottom-2 right-2 text-xs text-blue-600">* 10분마다 자동으로 갱신됨</div>
	</div>

	<div class="border-2 rounded-lg">
		<div class="font-bold flex items-center justify-between px-3">
			<div>날짜</div>
			<div><i class="fa-solid fa-plus"></i></div>
		</div>
		<div>
			<ul>
				<li><a href="">1</a></li>
				<li><a href="">2</a></li>
				<li><a href="">3</a></li>
				<li><a href="">4</a></li>
			</ul>
		</div>
	</div>
	
	<div class="border-2 rounded-lg">
		<div>신고 접수 내역</div>
		<div>
			<ul>
				<li><a href="">1</a></li>
				<li><a href="">2</a></li>
				<li><a href="">3</a></li>
				<li><a href="">4</a></li>
			</ul>
		</div>
	</div>
	
	<div class="border-2 rounded-lg col-start-1 col-end-3 h-full grid overflow-y-scroll" style="grid-template-rows: 45px 1fr">
		<div class="font-bold flex items-center justify-between px-3">
			<div>공지사항</div>
			<div class="hover:scale-110 cursor-pointer" style="transition: transform .2s">
				<a href="../../usr/article/list?boardId=2" target="_blank"><i class="fa-solid fa-plus"></i></a>
			</div>
		</div>
		
  		<table class="table table-sm">
    		<thead>
	      		<tr height=32>
		        	<th width=5%>번호</th>
		        	<th width=5%>글번호</th>
		        	<th width=465>제목</th>
		        	<th width=20%>작성자</th>
		        	<th width=20%>작성일</th>
		      	</tr>
    		</thead>
    		
    		<!-- ajax 사용 -->
    		<tbody class="notice-articles"></tbody>
		</table>
	</div>
	
	<div class="border-2 rounded-lg h-full grid overflow-y-scroll" style="grid-template-rows: 45px 1fr">
		<div class="font-bold flex items-center justify-between px-3">
			<div>쪽지</div>
			<div><i class="fa-solid fa-plus"></i></div>
		</div>
		
  		<table class="table table-sm">
    		<thead>
	      		<tr height=32>
		        	<th width=5%>번호</th> 
		        	<th width=250>제목</th> 
		        	<th width=20%>작성자</th> 
		      	</tr>
    		</thead>
    		<tbody>
		      	<tr class="hover:bg-gray-50">
			        <th>1</th>
			        <td class="hover:underline text-left truncate [max-width:250px]"><a href="">1번 입니다.</a></td> 
			        <td>관리자</td>
		      	</tr>
		      	<tr class="hover:bg-gray-50">
			        <th>2</th> 
			        <td class="hover:underline text-left truncate"><a href="">2번 입니다.</a></td> 
			        <td>관리자2</td> 
		      	</tr>
		      	<tr class="hover:bg-gray-50">
			        <th>3</th> 
			        <td class="hover:underline text-left truncate"><a href="">3번 입니다.</a></td> 
			        <td>관리자3</td> 
		      	</tr>
		      	<tr class="hover:bg-gray-50">
			        <th>4</th> 
			        <td class="hover:underline text-left truncate"><a href="">4번 입니다.</a></td> 
			        <td>관리자4</td> 
		      	</tr>
		      	<tr class="hover:bg-gray-50">
			        <th>5</th> 
			        <td class="hover:underline text-left truncate"><a href="">공지 5번 입니다.</a></td> 
			        <td>관리자5</td> 
		      	</tr>
			</tbody>
		</table>
	</div>
</div>
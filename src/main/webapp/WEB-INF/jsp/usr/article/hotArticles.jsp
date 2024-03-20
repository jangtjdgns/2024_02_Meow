<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 
	좋아요가 많은 게시글 표시용 jsp
	최대 6개의 게시글 표시
-->

<script>
	const getHotArticles = function(){
		
		$.ajax({
			url: "../article/getHotArticles",
			method: "get",
			dataType: "json",
			success: function(data) {
				if (data.success) {
					console.log(data);
					
					const hotArticles = data.data;
					
					for(let i = 0; i < hotArticles.length; i++) {
						const replyCntTag = `<span class="text-blue-600">&nbsp;(\${hotArticles[i].replyCnt })</span>`;
						
						// 순위 새기는것도 좋을 듯??
						// 게시글 목록 스타일 1
						$("#firstArticle-1").before(`
							<tr class=bg-blue-50 hotArticles">
								<td class="relative">
									<img src="/images/article/medal.png" class="scale-75 absolute top-1 -left-4" />
									\${hotArticles[i].id }
								</td>
								<td class="hover:underline text-left px-5 flex" style="max-width: 512px">
									<div class="truncate"><a href="detail?boardId=\${hotArticles[i].boardId}&id=\${hotArticles[i].id }">\${hotArticles[i].title }</a></div>
									\${hotArticles[i].replyCnt > 0 ? replyCntTag : ''}
								</td>
								<td>\${hotArticles[i].writerName }</td>
								<td class="text-center">\${hotArticles[i].formattedRegDate }</td>
								<td class="reactionLikeCnt font-bold">\${hotArticles[i].reactionLikeCnt }</td>
								<td class="hitCnt">\${hotArticles[i].hitCnt }</td>
							</tr>
						`);
						
						// 게시글 목록 스타일 2
						$("#firstArticle-2").before(`
							<div id="${status.first ? 'firstArticle-2' : ''}"">
								<a href="detail?id=\${hotArticles[i].id }&boardId=${boardId }">
									<div class="h-72 overflow-hidden border-2 border-blue-200 rounded-lg grid list-style-2 scale" style="grid-template-rows: 3fr 1fr;">
										<div class="bg-gray-200 relative">
											<img src="/images/article/medal.png" class="scale-110 absolute top-4 right-2"/>
											<div>IMG</div>
										</div>
										
										<div class="flex flex-col justify-center p-1">
											<div class="flex justify-between">
												<div>\${hotArticles[i].id }.</div>
												<div>
													<span class="text-xs"><i class="fa-regular fa-clock"></i></span>
													<span>\${hotArticles[i].formattedRegDate }</span>
												</div>
											</div>
											
											<div class="pb-1">
												<span>\${hotArticles[i].title }</span>
											</div>
											
											<div class="flex justify-between">
												<div>
													<span class="text-xs"><i class="fa-regular fa-user"></i></span>		
													<span>\${hotArticles[i].writerName }</span>
												</div>
												
												<div class="flex gap-1">
													<!-- 게시글 댓글수 -->
													<div>
														<span class="text-xs"><i class="fa-regular fa-comment-dots"></i></span>
														<span class="text-gray-600 replyCnt">\${hotArticles[i].replyCnt }</span>
													</div>
													<!-- 게시글 좋아요수 -->
													<div>
														<span class="text-xs"><i class="fa-regular fa-thumbs-up"></i></span>
														<span class="text-gray-600 font-bold">\${hotArticles[i].reactionLikeCnt }</span>
													</div>
													<!-- 게시글 조회수 -->
													<div>
														<span class="text-xs"><i class="fa-regular fa-eye"></i></span>
														<span class="text-gray-600">\${hotArticles[i].hitCnt }</span>
													</div>
												</div>
											</div>
										</div>
									</div>
								</a>
							</div>
						`);
						
					}
				}
			},
			error: function(xhr, status, error){
				console.error("ERROR : " + status + " - " + error);
			}
		})
	}
	
	$(function(){
		getHotArticles();
	})
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
	function showDetail(receiptId, itemNo, nickname){
		
		$.ajax({
			url: '../customer/showDetail',
		    method: 'GET',
		    data: {
		    	receiptId: receiptId,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	if(data.success) {
		    		const result = data.data;

		    		$("#itemNo").text(itemNo);
		    		$("#receiptId").text(result.id);
		    		$("#nickname").text(nickname);
		    		$("#regDate").text(result.regDate);
 		    		$("#title").text(result.title);
		    		$("#body").text(result.body);
		    		$("#status").text(result.status);
		    		
		    		if(result.status == '처리완료') {
		    			$(".updateDate-wrap").removeClass("hidden");
		    			$("#updateDate").text(result.updateDate);
		    			$("#answerBody").text(result.answerBody);
		    		} else {
		    			$(".updateDate-wrap").addClass("hidden");
		    			$("#answerBody").text("-");
		    		}
		    		
		    		const image = result.imagePath;
		    		$("#image").html(image.length == 0 ? '등록된 이미지가 없습니다.' : `<img src="\${image}" />`);
		    		
		    		my_modal_1.showModal();
		    	}
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
</script>

<div id="customer-history-modal">
	<dialog id="my_modal_1" class="modal">
	  	<div class="modal-box">
	      	<form method="dialog">
      			<button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
    		</form>
	    	<h3 class="font-bold text-lg"><span id="itemNo"></span>번 내역 상세보기</h3>
	    	<p class="py-4 text-sm"><span class="text-red-700">*</span> 작성한 내역에 이상이 있으면 언제든지 알려주세요!</p>
	    	<table class="table">
    			<tr>
    				<th class="w-1/5 bg-gray-50">접수번호</th>
    				<td id="receiptId" class="w-1/5"></td>
    			</tr>
    			<tr>
    				<th class="w-1/5 bg-gray-50">닉네임</th>
    				<td id="nickname" class="w-1/5"></td>
    			</tr>
    			<tr>
    				<th class="w-1/5 bg-gray-50">접수일</th>
    				<td id="regDate" class="w-4/5"></td>
    			</tr>
    			<tr class="updateDate-wrap hidden">
    				<th class="w-1/5 bg-gray-200">처리일</th>
    				<td id="updateDate" class="w-4/5"></td>
    			</tr>
    			<tr>
    				<th class="w-1/5 bg-gray-50">제목</th>
    				<td id="title" class="w-4/5 break-all [max-width:371.2px]"></td>
    			</tr>
    			<tr>
    				<th class="w-1/5 bg-gray-50 align-top">내용</th>
    				<td class="w-4/5 h-52">
    					<textarea id="body" class="focus:outline-none w-full h-full resize-none" readonly></textarea>
    				</td>
    			</tr>
    			<tr>
    				<th class="w-1/5 bg-gray-50">처리내역</th>
    				<td id="status" class="w-4/5"></td>
    			</tr>
    			<tr>
    				<th class="w-1/5 bg-gray-200">답변내용</th>
    				<td id=answerBody class="w-4/5">-</td>
    			</tr>
    			<tr>
    				<th class="w-1/5 bg-gray-50">이미지</th>
    				<td id="image" class="w-4/5"></td>
    			</tr>
	    	</table>
		</div>
	</dialog>
</div>

<div class="border-2 shadow-xl rounded-2xl p-10">
	<div class="pb-4">접수 횟수: ${inquiries.size() }</div>

	<div class="overflow-x-auto [max-height:70vh]">
		<table class="table table-sm">
			<thead class="text-base">
				<tr>
					<th></th>
					<th>닉네임</th>
					<th>유형</th>
					<th>제목</th>
					<th>접수일</th>
					<th class="w-24">처리내역</th>
					<th class="text-center"></th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${inquiries.size() == 0}">
					<tr>
						<td class="text-center" colspan=7>현재 접수한 내역이 없습니다.</td>
					</tr>
				</c:if>
				<c:forEach var="inquiry" items="${inquiries }" varStatus="status">
					<tr class="hover:bg-base-200">
						<th>${status.count }</th>
						<td>${inquiry.nickname }</td>
						<td>${inquiry.type }</td>
						<td class="truncate" style="max-width: 150px;">${inquiry.title }</td>
						<td>${inquiry.regDate.substring(2, 10) }</td>
						<td>
							<span><i class="fa-solid fa-circle" style="color:${inquiry.status == '처리중' ? '#ffcc00' : '#00cc00'}; font-size: 8px;"></i></span>
							<span>${inquiry.status }</span>
						</td>
						<td class="text-center"><button class="btn btn-xs btn-ghost" onclick="showDetail(${inquiry.id }, ${status.count }, '${inquiry.nickname }')">상세보기</button></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>
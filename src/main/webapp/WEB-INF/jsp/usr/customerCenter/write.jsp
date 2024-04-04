<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	bindFormInputEvent($(".customer-title").eq(1), "input-error");
	bindFormInputEvent($(".customer-body").eq(1), "textarea-error");
</script>

<div class="border-2 shadow-xl rounded-2xl p-10 relative overflow-hidden">
	<div class="grid grid-cols-10">
		<div class="col-start-1 col-end-2 self-center">
			<span class="text-lg"><span class="text-red-700">* </span>제목</span>
		</div>
		
	   	<div class="col-start-2 col-end-10 grid grid-cols-7 gap-6">
	   		<input class="customer-title input input-bordered w-full col-start-1 col-end-5" placeholder="2 ~ 50 글자 입력이 가능합니다." type="text" minlength="2" maxlength="50" />
			<select class="customer-type select select-bordered col-start-5 col-end-7">
	    		<option value="inquiry">문의</option>
	    		<option value="report">신고</option>
	    		<option value="bug">버그 제보</option>
	    		<option value="suggestion">기타 건의 사항</option>
	    	</select>
	   	</div>
	</div>
	  	
	<div class="py-8 grid grid-cols-10">
	  	<div class="col-start-1 col-end-2">
			<span class="text-lg"><span class="text-red-700">* </span>내용</span>
		</div>
	   	<textarea class="customer-body textarea textarea-bordered resize-none w-full h-56 col-start-2 col-end-11" placeholder="문의하실 내용을 입력해주세요."></textarea>
	</div>
	   
	<div class="grid grid-cols-10">
	  	<div class="col-start-1 col-end-2 self-center">
			<span class="text-base">이미지<br />업로드</span>
		</div>
		<input type="file" class="customer-image file-input file-input-bordered col-start-2 col-end-6" accept="image/gif, image/jpeg, image/png" />
	</div>
	   
	<div class="py-2 text-right">
		<button class="btn" onclick="submitRequest(1);">접수</button>
	</div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../common/header.jsp"%>
<script>

	// deleteCat
	function deleteCat(btn) {
		// 클릭한 카드 idx
		const cardIdx = $(btn).closest(".card-scale").index();
		
		if(!confirm("정말 삭제 하시곘습니까?")) {
			return alert("취소합니다.");
		}
		
		const catId= $(".companion-cat-id").eq(cardIdx).val();
		$(".card-scale").eq(cardIdx).remove();
		doDeleteCat(loginedMemberId, catId);
	}
	
	// doDeleteCat
	function doDeleteCat(memberId, catId) {
		
		if($(".card-scale").length < 8) {
			$("#companionCatRegBtn").empty();
			$("#companionCatRegBtn").append(`
				<div class="card card-compact w-96 p-2 overflow-hidden">
					<a href="../companionCat/register" class="card-body w-full companion-cat-reg border flex items-center justify-center hover:border-4">
						<i class="fa-solid fa-plus"></i>
					</a>
				</div>
			`);
		}
		console.log("1")
		$.ajax({
			url: '../companionCat/doDelete',
		    method: 'GET',
		    data: {
		    	"memberId": memberId,
		    	"catId": catId,
		    },
		    dataType: 'json',
		    success: function(data) {
		    	console.log("2")
		    	alertMsg(data.msg, data.success ? "success" : "error");
			},
		      	error: function(xhr, status, error) {
		      	console.error('Ajax error:', status, error);
			}
		});
	}
	
	
	// 옵션 버튼 토글 함수
	function toggleOption($this) {
		const border = `
			<span class="card-border card-border-1 border-indigo-300 absolute top-0 -left-full border-8 w-full z-10"></span>
		  	<span class="card-border card-border-2 border-indigo-300 absolute -top-full left-0 border-8 h-full z-10"></span>
		  	<span class="card-border card-border-3 border-indigo-300 absolute -bottom-full right-0 border-8 h-full z-10"></span>
		  	<span class="card-border card-border-4 border-indigo-300 absolute bottom-0 -right-full border-8 w-full z-10"></span>
		`;
		
		const cardOptionBtn = `
			<div class="card-optionBtn absolute -top-16 left-1/2 -translate-x-1/2 z-30 flex gap-2 p-2 border rounded-box glass bg-white bg-opacity-90">
				<button class="btn btn-ghost text-lg"><i class="fa-solid fa-pen text-green-400"></i></button>
				<button class="btn btn-ghost text-lg" onclick="deleteCat(this)"><i class="fa-solid fa-trash text-red-400"></i></button>
			</div>
		`;
		
		// 옵션 버튼을 체크했는지 확인
		if($this.is(":checked")) {
			$(".card-wrap").append(border);
			$(".card-wrap").prepend(cardOptionBtn);
		} else {
			$(".card-border").remove();
			$(".card-optionBtn").remove();
		}
		
		$(".card-scale").toggleClass("pulsate-fwd-bf");
		$(".card-wrap").toggleClass("pulsate-fwd");
	}
	
	
	$(function(){
		// 나이 변환 함수 호출
		$(".ages").each(function(idx, ages){
			const age = getAgeByDate($(ages).text());
			$(ages).text(age + "살");
		})
		
		// 옵션 버튼 체크
		$(".optionBtn").change(function(){
			toggleOption($(this));
		})
	})
</script>

<section class="border-t b-mh">
	<div class="grid" style="grid-template-columns: 384px 1fr">
		<div class="p-10 border b-mh">사이드</div>
		<div class="px-12">
			<div class="flex items-center justify-between pt-12 mx-auto [width:90%] [max-width:1260px]">
				<div class="font-bold text-3xl">
					<img src="/images/companionCat/cat.png" class="pointer-events-none">내 반려묘
				</div>
				
				<c:if test="${companionCats.size() == 0 }">
					<div></div>
				</c:if>
				<c:if test="${companionCats.size() > 0 }">
					<label class="btn btn-sm btn-ghost btn-circle swap swap-rotate">
					  	<input class="optionBtn" type="checkbox" autocomplete="off" />
					  	<i class="fa-solid fa-gear fa-lg swap-off fill-current"></i>
					  	<svg class="swap-on fill-current" xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 512 512"><polygon points="400 145.49 366.51 112 256 222.51 145.49 112 112 145.49 222.51 256 112 366.51 145.49 400 256 289.49 366.51 400 400 366.51 289.49 256 400 145.49"/></svg>
					</label>
				</c:if>
			</div>
			
			<div class="grid grid-cols-3 grid-rows-1  w-full">
				<!-- 반려묘 추가 -->
				<c:forEach var="cat" items="${companionCats }" varStatus="status">
					<div class="card-scale [transform:scale(0.75)] flex justify-center">
						<input class="companion-cat-id" type="hidden" value="${cat.id }" />
						<div class="card card-compact card-wrap w-96 bg-base-100 shadow-xl p-2 overflow-hidden bg-indigo-50">
					  		<figure><img src="https://cdn.pixabay.com/photo/2016/01/20/13/05/cat-1151519_1280.jpg" alt="cat" class="h-64 z-20 rounded-tl-xl rounded-tr-xl" /></figure>
						  	<div class="card-body rounded-bl-xl rounded-br-xl z-20 bg-white">
						    	<h2 class="card-title text-2xl">${cat.name }</h2>
						    	<div class="text-lg">
						    		<p>성 별:
						    			<c:if test="${cat.gender == 'F' }"><i class="fa-solid fa-mars text-xs text-blue-600"></i></c:if>
						    			<c:if test="${cat.gender == 'M' }"><i class="fa-solid fa-venus text-xs text-red-600"></i></c:if>
						    		</p>
						    		<p>나 이: <span class="ages">${cat.birthDate }</span></p>
						    		<p>생 일: ${cat.birthDate }</p>
						    		<textarea rows="3" class="textarea textarea-bordered border-2 w-full text-lg my-2 resize-none focus:outline-none" placeholder="현재 작성한 소개말이 없습니다." readonly>${cat.aboutCat }</textarea>
						    	</div>
						  	</div>
						</div>
					</div>
				</c:forEach>
				
				<!-- 추가된 반려묘가 8마리 미만일 때 -->
				<div id="companionCatRegBtn" class="[transform:scale(0.75)] flex justify-center [min-height:570px]">
					<c:if test="${companionCats.size() < 8 }">
							<div class="card card-compact w-96 p-2 overflow-hidden">
								<a href="../companionCat/register" class="card-body w-full companion-cat-reg border flex items-center justify-center hover:border-4">
									<i class="fa-solid fa-plus"></i>
								</a>
							</div>
					</c:if>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>
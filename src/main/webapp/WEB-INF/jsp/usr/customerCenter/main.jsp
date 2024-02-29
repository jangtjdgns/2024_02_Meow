<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../common/header.jsp"%>

<script>
let widthToggle = false;
let tempWt = 0;
$(function(){
// 	textWriterAnimation();
	$(".customer-center>.grid>.grid").click(function(){
		customerBtnClick($(this));
	})
})

/* 글 작성하는 함수 
function textWriterAnimation() {
	const text = "여러분의 편의를 최우선으로 하는 고객센터에 오신 것을 환영합니다.|다양한 의견을 기다리고, 궁금한 점이 있으면 언제든지 물어주세요.|우리는 항상 여러분을 도와드리기 위해 여기 있습니다.";
	let idx = 0;
	
	function write() {
        if (idx < text.length) {
        	if(text[idx] == "|") {
        		$("#customer-text").append(`<br />`);
        		idx++;
        	}
        	
            $("#customer-text").append(text[idx]);
            idx++;
            setTimeout(write, 70);
        }
    }
	write();
}
 */
 
function customerBtnClick($this){
	
	const idx = $this.index();
	let wt = 0;
	let ht = 0;
	
	$('#customer-content').toggleClass("opacity-0");
	$this.toggleClass("rounded-2xl");
	$this.toggleClass("btn-active");
	$(".customer-subtitle>.btn").eq(idx).toggleClass("btn-active");
	$(".customer-center>.grid>.grid").not($this).toggleClass("opacity-0");
	$(".customer-center>.grid>.grid").not($this).toggleClass("pointer-events-none");
	
	if(!widthToggle) {
		tempWt = $this.css("width");
		if(idx == 1 || idx == 3 || idx == 4) {
			wt = idx == 1 || idx == 3 ? parseFloat($this.css("width")) + 16 : parseFloat($this.css("width")) * 2 + 32;
		}
		$this.css("width", "864px");
		
		if(idx == 0 || idx == 1) {
			ht = parseFloat($this.css("height")) - 50;
		} else {
			ht = parseFloat($this.css("height")) * 2 + 16 - 50;	// 하단 버튼 높이 * 2 + padding - 50
		}
		
		$this.css("transform", `translate(\${-wt}px, \${-ht}px)`);
		
		getCustomerContent(idx);
		
		
		$('html, body').animate({
				scrollTop: parseFloat($(".h-mh").css("height")),
		}, 400);
	} else {
		$('html, body').animate({
				scrollTop: 0,
		}, 400);
		
		$this.css({
			"transform": "translate(0, 0)",
			"width": tempWt,
		});
		
		setTimeout(() => {
			$("#customer-content").text("");
		}, 400);
	}
	
	widthToggle = !widthToggle;
}

function getCustomerContent(contentId) {
	$.ajax({
		url: '../customer/getContent',
	    method: 'get',
	    data: {
	    	contentId: contentId,
	    	memberId: loginedMemberId,	    	
	    },
	    dataType: 'html',
	    success: function(data) {
	    	$("#customer-content").html(data);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		}
	});
}
</script>

<section class="border-t b-mh">
	<div class="mx-auto max-w-4xl">
		<div class="text-4xl pt-16 pb-4 px-4 font-Jalnan">고객센터</div>
		
		<div class="customer-subtitle p-4 grid grid-cols-6 gap-3 text-base">
<!-- 			<button class="btn btn-circle btn-outline btn-active w-full">메 인</button> -->
			<button class="btn btn-circle btn-outline w-full">문 의</button>
			<button class="btn btn-circle btn-outline w-full">내 역</button>
			<button class="btn btn-circle btn-outline w-full ">자주 묻는 질문</button>
			<button class="btn btn-circle btn-outline w-full">고객 의견 수렴</button>
			<button class="btn btn-circle btn-outline w-full">바로가기</button>
		</div>
		
		<div id="customer-text" class="p-4 text-lg">
			<div>여러분의 편의를 최우선으로 하는 고객센터에 오신 것을 환영합니다.</div>
			<div>다양한 의견을 기다리고, 궁금한 점이 있으면 언제든지 물어주세요.</div>
			<div>우리는 항상 여러분을 도와드리기 위해 여기 있습니다.</div>
		</div>
		
		<div class="customer-center relative">
			<div class="grid grid-cols-6 grid-rows-6 gap-4 px-4 h-80">
				<div class="btn btn-outline bg-white h-full rounded-none rounded-tl-2xl col-start-1 col-end-4 row-start-1 row-end-4 grid grid-cols-10 items-center text-left w-full z-20">
					<div class="text-7xl col-start-2 col-end-4"><i class="fa-solid fa-file-pen fa-xs" style="color: #c8c8c8;"></i></div>
					<div class="col-start-4 col-end-10">
						<div class="text-lg pb-1.5">문의하기</div>
						<div class="text-sm">간편한 양식을 통해 문의, 신고, 버그제보, 건의사항 등을 제출하세요.</div>
					</div>
				</div>
				
				<div class="btn btn-outline bg-white h-full rounded-none rounded-tr-2xl row-start-1 row-end-4 col-start-4 col-end-7 grid grid-cols-10 items-center text-left w-full z-20">
					<div class="text-7xl col-start-2 col-end-4"><i class="fa-solid fa-file-lines fa-xs" style="color: #c8c8c8;"></i></div>
					<div class="col-start-4 col-end-10">
						<div class="text-lg pb-1.5">접수 내역 확인하기</div>
						<div class="text-sm">처리 상태 및 업데이트를 실시간으로 받아보세요.</div>
					</div>
				</div>
				
				<div class="btn btn-outline h-full rounded-none rounded-bl-2xl row-start-4 row-end-7 col-start-1 col-end-3 grid grid-cols-10 items-center text-left w-full z-20">
					<div class="text-7xl col-start-2 col-end-4"><i class="fa-solid fa-clipboard-question fa-xs" style="color: #c8c8c8;"></i></div>
					<div class="col-start-5 col-end-10">
						<div class="text-base pb-1.5">자주 묻는 질문 (FAQ)</div>
						<div class="text-sm">자주 묻는 질문들과 답변을 통해 빠르게 도움을 받아보세요.</div>
					</div>
				</div>
				
				<div class="btn btn-outline h-full rounded-none col-start-3 row-start-4 row-end-7 col-end-5 grid grid-cols-10 items-center text-left w-full z-20">
					<div class="text-7xl col-start-2 col-end-4"><i class="fa-solid fa-comments fa-2xs" style="color: #c8c8c8;"></i></div>
					<div class="col-start-5 col-end-10">
						<div class="text-lg pb-1.5">고객 의견 수렴</div>
						<div class="text-sm">개선 제안이나 피드백을 언제든지 보내주세요.</div>
					</div>
				</div>
				
				<div class="btn btn-outline bg-white rounded-none h-full rounded-br-2xl row-start-4 row-end-7 col-start-5 col-end-7 grid grid-cols-10 items-center text-left w-full z-20">
					<div class="text-7xl col-start-2 col-end-4"><i class="fa-solid fa-folder-tree fa-2xs" style="color: #c8c8c8;"></i></div>
					<div class="col-start-5 col-end-10">
						<div class="text-lg pb-1.5">바로가기</div>
						<div class="text-sm">모든 페이지를 한눈에 볼 수 있어요.</div>
					</div>
				</div>
				
				<!-- 부제목 버튼 클릭 시 나타낼 고객센터 컨텐츠 컨테이너 -->
				<div id="customer-content" class="bg-white absolute top-20 left-0 mx-4 pb-20 [width:calc(100%-2rem)] z-0 opacity-0" style="transition: opacity .4s;"></div>
			</div>
			
<!-- 			<div>asdasd</div> -->
		</div>
	</div>
</section>

<%@ include file="../common/footer.jsp"%>
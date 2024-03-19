<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
var address = ${member.address};

$(function(){
	unsavedChanges = false;
	
	setAddressInfo();
	
	$("#detailAddress").change(function(){
		address.detailAddress = $("#detailAddress").val();
		$("#addressInput").val(JSON.stringify(address));
	})
	
	// 텍스트 영역이 수정되었을 때 플래그를 설정
    $('input').on('input', function() {
		unsavedChanges = true;
    });

	// input 태그에 변경사항이 있을 때 확인 메시지 표시
	$(window).on('beforeunload', function() {
		if (unsavedChanges) {
        	return ' ';
      	}
    });
	
	form.submit();
})

// 주소 정보를 필드에 대입
function setAddressInfo() {
	$("#postcode").val(address.zonecode);
	$("#roadAddress").val(address.roadAddress);
	$("#jibunAddress").val(address.jibunAddress);
	$("#detailAddress").val(address.detailAddress);
	$("#addressInput").val(JSON.stringify(address));
}


//주소 API
function getPostInfo() {
    new daum.Postcode({
        oncomplete: function(data) {
            var roadAddr = data.roadAddress; // 도로명 주소 변수

            // 우편번호와 주소 정보를 해당 필드에 기입
            $("#postcode").val(data.zonecode);
            $("#roadAddress").val(data.roadAddress);
            $("#jibunAddress").val(data.jibunAddress);
            
            // 주소 객체에 값 추가
           	address.zonecode = data.zonecode;
            address.sido = data.sido;
            address.sigungu = data.sigungu;
            address.bname = data.bname;
            address.jibunAddress = data.jibunAddress;
            address.roadAddress = data.roadAddress;
            address.detailAddress = '';
            
            $("#detailAddress").val('');
            
        	$("#addressInput").val(JSON.stringify(address));
        }
    }).open();
}
</script>

<div class="bg-white border shadow-2xl rounded-3xl">
	<div class="p-10 text-3xl">계정 정보 수정</div>
	<div class="p-6">
		<form action="doModify" method="post" class="card-body" onsubmit="modifyFormOnSubmit(this); return false;">
			<input name="memberId" type="hidden" value="${member.id }" />
			<div class="flex gap-14">
				<div class="form-control w-full">
			        <label class="label">
			            <span class="label-text">아이디</span>
			        </label>
				    <input type="text" placeholder="LoginId" id="loginId" class="input input-bordered" value="${member.loginId }" readonly />
		        </div>
		        <div class="form-control w-full">
		            <label class="label">
		                <span class="label-text">비밀번호</span>
		            </label>
		            <button type="button" class="btn">비밀번호 재설정</button>
		        </div>
			</div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이름</span>
	            </label>
	            <input name="name" type="text" placeholder="Name" class="input input-bordered border-2" value="${member.name }" required/>
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">닉네임</span>
	            </label>
	            <input type="text" placeholder="Nickname" class="input input-bordered" value="${member.nickname }" readonly />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">나이</span>
	            </label>
	            <input name="age" type="text" placeholder="Age" class="input input-bordered border-2" value="${member.age }" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">주소</span>
	            </label>
	            <div id="address" class="flex flex-col gap-2">
	            	<input id="addressInput" type="hidden" name="address" value="" />
		            <div class="flex gap-2">
		            	<input type="text" id="postcode" placeholder="우편번호" class="input input-bordered w-1/3" readonly>
		            	<button type="button" onclick="getPostInfo()" class="btn">우편번호 찾기</button>
		            </div>
	            	<input type="text" id="roadAddress" placeholder="도로명주소" class="input input-bordered w-full" readonly>
					<input type="text" id="jibunAddress" placeholder="지번주소" class="input input-bordered w-full" readonly>
		            <input type="text" id="detailAddress" placeholder="상세주소" class="input input-bordered border-2 w-full">
	            </div>
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">전화번호</span>
	            </label>
	            <input name="cellphoneNum" type="text" placeholder="Mobile" class="input input-bordered border-2" value="${member.cellphoneNum }" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">이메일</span>
	            </label>
	            <input name="email" type="email" placeholder="Email" class="input input-bordered border-2" value="${member.email }" required />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">프로필 사진</span>
	                <span class="label-text text-red-700">* 프로필 페이지에서 변경가능합니다.</span>
	            </label>
	            <input id="profileImage" type="file" class="file-input file-input-bordered w-full" accept="image/gif, image/jpeg, image/png" disabled />
	        </div>
	        
	        <div class="form-control">
	            <label class="label">
	                <span class="label-text">소개말</span>
	                <span class="label-text text-red-700">* 프로필 페이지에서 변경가능합니다.</span>
	            </label>
	            <textarea placeholder="Introduce me" rows="5" class="textarea textarea-bordered resize-none" disabled>${member.aboutMe }</textarea>
	        </div>
	        
	        <div class="grid grid-cols-2 gap-12 mt-6">
	            <button class="btn btn-primary">수정</button>
	            <button type="button" class="btn" onclick="history.back()">취소</button>
	        </div>
	    </form>
	</div>
</div>
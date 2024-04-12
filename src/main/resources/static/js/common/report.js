// report(신고) js

// 신고 관련 모달창 열기
function showReportModal(relTypeCode, relId, reportType) {
	const report_modal = document.getElementById('report_modal');
	
	// 초기화
	$(report_modal).find("#relTypeCode").val(relTypeCode);
	$(report_modal).find("#relId").val("");
	$(report_modal).find("#reportType").val(reportType);
	$(report_modal).find("#report-body").val("");
	
	/* 각 매개변수가 기본 값이 아니면 미리 선택 */
	if(relTypeCode != 'none') {
		$(report_modal).find("#relTypeCode").val(relTypeCode);
	}
	if(relId > 0) {
		$(report_modal).find("#relId").val(relId);
	}
	
	// 신고 유형은 미리 선택될 일은 없을 듯
	if(reportType != 0) {
		$(report_modal).find("#reportType").val(reportType);
	}
	
	report_modal.showModal();
}


// 신고 버튼 클릭 시
function doReport() {
	
	const report_modal = document.getElementById('report_modal');		// 신고 모달창
	const relTypeCode = $(report_modal).find("#relTypeCode").val();		// 관련 코드명
	const relId = $(report_modal).find("#relId").val();					// 관련 번호
	const reportBody = $(report_modal).find("#report-body").val();		// 신고 내용
	const reportType = $(report_modal).find("#reportType").val();		// 신고 유형
	
	// 검사
	if(checkReportInfo(relTypeCode, relId, reportType, reportBody)) return false;
	
	$.ajax({
        url: '../report/doReport',
        method: 'POST',
        data: {
            reporterId: loginedMemberId,
            relTypeCode: relTypeCode,
            relId: relId,
            reportBody: reportBody,
            reportType: reportType,
        },
        dataType: 'json',
        success: function (data) {
            return alertMsg(data.msg, data.success ? 'success' : 'error');
        },
        error: function (xhr, status, error) {
            console.error('Ajax error:', status, error);
        }
    });
    
}


// 신고 관련 정보 검사, 문제 있을 시 true 반환
function checkReportInfo(relTypeCode, relId, reportType, reportBody) {
	
	if(relTypeCode == 'none') {
		alertMsg("관련 항목 유형을 선택해주세요.", "error");
		return true;
	}
	
	// 관련 코드가 member이며, 관련 번호란이 비었을 때
	if(relTypeCode == 'member') {
		
		if(relId.length == 0) {
			alertMsg("관련 항목 번호 또는 닉네임을 입력해주세요.", "error");
			return true;
		}
		
		// 만약 닉네임을 입력했을 때 2글자 미만 검증
		if(isNaN(parseInt(relId)) && relId.length < 2) {
			alertMsg("닉네임은 두 글자 이상 입력이 가능합니다.", "error");
			return true;
		}
	} 
	// 그 외
	else {
		if(isNaN(parseInt(relId))) {
			alertMsg("회원 신고를 제외한 나머지 유형의 관련 항목 번호는 숫자만 입력 가능합니다.", "error");
			return true;
		}
	}
	
	if(relId.length == 0) {
		alertMsg("관련 항목 번호를 입력해주세요.", "error");
		return true;
	}
	
	if(reportType == 0) {
		alertMsg("신고 유형을 선택해주세요.", "error");
		return true;
	}
	
	if(reportBody.trim().length < 2) {
		alertMsg("신고 내용을 입력해주세요.<br /> (2글자 이상)", "error");
		return true;
	}
}
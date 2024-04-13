/**
 *  관리자 페이지
 * 회원, 게시글, 댓글 공용 report js
 */

// 신고 내역 목록 가져오기
function getReports(relTypeCode, status) {
	
	// 처리상태에 따라 버튼 막기
	const isProcessed = (status == 'processed');
	$('.reportType-select, .reportProcessingbtn').prop('disabled', isProcessed);
	
	// 체크박스 초기화
	$('.checkboxAll').prop('checked', false);
	$('.checkbox-checked-len').text('0');
	
	$.ajax({
		url: '/adm/report/getReports',
	    method: 'GET',
	    data: {
	    	relTypeCode: relTypeCode,
	    	status: status,
	    },
	    dataType: 'json',
	    success: function(data) {
			switch(relTypeCode) {
				case 'member': return showMemberReports(data);
			}
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
	});
}


// 신고 내역 가져오기(상세보기)
function getReport(reportId, report_modal) {
	
	$.ajax({
		url: '/adm/report/getReport',
	    method: 'GET',
	    data: {
	    	reportId: reportId,
	    },
	    dataType: 'json',
	    success: function(data) {
			const reportInfo = data.data;
			$(".reportId").text(reportInfo.id);
			$(".reporterNickname").text(reportInfo.reporterNickname);
			$(".reportedTargetNickname").text(reportInfo.reportedTargetNickname);
			$(".regDate").text(reportInfo.regDate);
			$(".updateDate").text(reportInfo.updateDate);
			$(".relTypeCode").text(reportInfo.relTypeCode);
			$(".relId").text(reportInfo.relId);
			$(".reportType").text(reportInfo.reportType);
			$(".processing").text(reportInfo.processing);
			$(".reportBody").val(reportInfo.body);
			$(".processingBody").val(reportInfo.processingBody);
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
	});
}

// 상세보기 모달창 열기
function showDetailReportModal(reportId) {
	const report_modal = document.getElementById('report_modal');
	
	getReport(reportId, report_modal);
	
	report_modal.showModal();
}


// 1. 회원 신고 목록 표시
function showMemberReports(data) {
	const reports = data.data;
	
	$(".report-body").empty();
	
	for(let i = 0; i < reports.length; i++) {
		
		const report = `
			<tr class="text-center z-40">
				<th class="text-left"><input type="checkbox" class="checkbox checkboxes" value="${reports[i].id}" /></th>
				<td class="text-left">
					${reports[i].reporterNickname} <br />
					<span class="badge badge-ghost badge-sm">${reports[i].reporterId}번 회원</span>
				</td>
				<td class="text-left">
					${reports[i].reportedTargetNickname} <br />
					<span class="badge badge-ghost badge-sm">${reports[i].reportedTargetId}번 회원</span>
				</td>
				<td>${reports[i].reportType}</td>
				<td >${reports[i].regDate}</td>
				<td>${reports[i].updateDate === null ? '-' : reports[i].updateDate}</td>
				<td>${reports[i].processing}</td>
				<th class="text-right">
					<button class="btn btn-ghost btn-xs" onclick="showDetailReportModal(${reports[i].id})">상세보기</button>
				</th>
			</tr>
		`;
		
		$(".report-body").append(report);
	}
	checkedBoxes();
}

// 메모 저장
function saveMemo() {
	const processingBody = $(".processingBody").val();
	
	$.ajax({
		url: '/adm/report/saveMemo',
	    method: 'GET',
	    data: {
	    	reportId: reportId,
	    	processingBody: processingBody,
	    },
	    dataType: 'json',
	    success: function(data) {
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
	});
}

// 체크박스 선택 감지 함수
function checkedBoxes() {
	// 모두선택 체크박스 선택 시
	$(".checkboxAll").change(function(){
		$(".checkboxes").prop("checked", $(this).prop("checked"));
		$('.checkbox-checked-len').text($(".checkboxes:checked").length);
	})
	
	
	// 일반 체크박스 선택 시
	$(".checkboxes").change(function() {
		$('.checkbox-checked-len').text($(".checkboxes:checked").length);
		
		// 일반 체크박스 선택으로 모두 선택 했을 때
		const isCheckedAll = $(".checkboxes:checked").length == $(".checkboxes").length;
		$(".checkboxAll").prop("checked", isCheckedAll);
	})
}


/* 신고 처리 */
// 저장 버튼 클릭 시 (조치 버튼)
function reportProcessingBtn(relTypeCode) {
	
	if($(".checkboxes:checked").length == 0) return alertMsg("조치하실 신고 내역을 선택해주세요.", "warning");
	if(!confirm(`${$(".checkboxes:checked").length}개의 신고에 대한 조치를 진행하시곘습니까?`)) return false;
	
	const processingType = $(".processingType-select").val();
	if(processingType == 0) return alertMsg("신고 조치 유형을 선택해주세요.", "warning");
	
	// 선택된 체크박스의 id 확인
	for(let i = 0; i < $(".checkboxes:checked").length; i++) {
		reportProcessing($(".checkboxes:checked").eq(i).val(), processingType);
	}
	
	alertMsg("신고 조치 완료 되었습니다.", "success");
	getReports(relTypeCode, 'unprocessed');
}
// 신고 처리 진행
function reportProcessing(reportId, processingType) {
	$.ajax({
		url: '/adm/report/reportProcessing',
	    method: 'GET',
	    data: {
	    	reportId: reportId,
	    	processingType: processingType,
	    },
	    dataType: 'json',
	    success: function(data) {
		},
	      	error: function(xhr, status, error) {
	      	console.error('Ajax error:', status, error);
		},
	});
}
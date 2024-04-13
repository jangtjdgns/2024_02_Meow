<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script src="/js/adm/common/report.js"></script>
<script>
	$(function() {
		getReports('member', 'unprocessed');
	});
</script>

<div id="report-container" class="w-full h-full p-4 overflow-y-auto">
	<!-- <div class="border-2 rounded-lg w-full h-full flex items-center justify-center text-lg">현재 신고된 회원이 없습니다.</div> -->
	<!-- 상세보기 -->
	<div id="modal-container">
		<dialog id="report_modal" class="modal">
			<div class="modal-box [max-width:42rem]">
				<form method="dialog">
					<button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
				</form>
				<h3 class="font-bold text-lg pb-4">신고 내역 상세보기</h3>
				<table class="table">
        			<tbody>
        				<tr>
        					<td class="text-center bg-gray-50">번호</td>
        					<td class="reportId" colspan=4></td>
        				</tr>
        				<t>
        					<td class="w-1/6 text-center bg-gray-50">신고자</td>
        					<td class="w-2/6 reporterNickname"></td>
        					<td class="w-1/6 text-center bg-gray-50">대상자</td>
        					<td class="w-2/6 reportedTargetNickname"></td>
        				</tr>
        				<tr>
        					<td class="text-center bg-gray-50">신고일</td>
        					<td class="regDate"></td>
        					<td class="text-center bg-gray-50">처리일</td>
        					<td class="updateDate"></td>
        				</tr>
        				<tr>
        					<td class="text-center bg-gray-50">관련 항목</td>
        					<td class="relTypeCode"></td>
        					<td class="text-center bg-gray-50">관련 번호</td>
        					<td class="relId"></td>
        				</tr>
        				<tr>
        					<td class="text-center bg-gray-50">신고 유형</td>
        					<td class="reportType"></td>
        					<td class="text-center bg-gray-50 text-sm">신고 처리</td>
        					<td class="processing">-</td>
        				</tr>
        				<tr>
        					<td class="text-center bg-gray-50 align-top">신고 내용</td>
        					<td class="h-36" colspan=4>
        						<textarea class="reportBody w-full h-full textarea resize-none focus:outline-none focus:border-0 p-0" readonly></textarea>
        					</td>
        				</tr>
        				<tr>
        					<td class="text-center bg-gray-50 align-top">처리 내용<br />(메모)</td>
        					<td class="h-36 p-0" colspan=4>
        						<div class="textarea w-full h-full relative overflow-hidden">
        							<textarea class="processingBody w-full h-full textarea resize-none focus:outline-none focus:border-0 p-0"></textarea>
        							<div class="absolute bottom-0 right-0 bg-white">
        								<button class="saveMemoBtn btn btn-sm w-16 rounded-none rounded-tl-lg" onclick="saveMemo()">저장</button>
        							</div>
        						</div>
        					</td>
        				</tr>
	    	    	</tbody>
    	    	</table>
			</div>
		</dialog>
	</div>
	
	
	<div>
		<table class="table">
			<!-- head -->
			<thead>
				<tr class="h-16"></tr>
				<tr class="border-0 bg-gray-50 shadow-sm fixed z-20 [width:calc(100%-416px)] flex items-center justify-between" style="transform: translateY(-64px);">
					<th class="border-0">
						<label class="label justify-start gap-2">
							<input type="checkbox" class="checkbox checkboxAll bg-white" autocomplete="off" />
							<span class="label-text cursor-pointer">모두선택</span>
						</label>
					</th>
					<th class="border-0 w-1/2 justify-self-start">
						<div class="join border">
							<input class="join-item btn btn-sm glass w-20" type="radio" name="processing" value="unprocessed" aria-label="미처리" onchange="getReports('member', 'unprocessed')" autocomplete="off" checked />
							<input class="join-item btn btn-sm glass w-20" type="radio" name="processing" value="processed" aria-label="처리완료" onchange="getReports('member', 'processed')" autocomplete="off" />
						</div>
					</th>
					<th class="border-0">
						<span class="text-black text-sm mr-2">신고 조치</span>
						<select class="processingType-select select select-sm text-black mr-2" autocomplete="off">
							<option value="0">선택</option>
							<option value="1">경고</option>
							<option value="2">정지</option>
							<option value="3">강제탈퇴</option>
							<option value="4">잘못된 신고</option>
						</select>
						<button class="btn btn-sm reportProcessingbtn" onclick="reportProcessingBtn('member')">저장</button>
					</th>
				</tr>
				
				<tr class="text-center">
					<th class="text-left">선택 (<span class="checkbox-checked-len">0</span>)</th>
					<th class="text-left">신고자</th>
					<th class="text-left">신고 대상자</th>
					<th>신고사유</th>
					<th class="w-52">신고일시</th>
					<th class="w-52">처리일시</th>
					<th>처리 상태</th>
					<th>처리 내용(메모)</th>
				</tr>
			</thead>
			
			<!-- 신고 목록 -->
			<tbody class="report-body"></tbody>
		</table>
	</div>
</div>
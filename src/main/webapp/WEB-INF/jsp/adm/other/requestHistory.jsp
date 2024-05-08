<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="/js/adm/other/requestHistory.js"></script>

<div id="request-container" class="w-full h-full p-4 overflow-y-hidden relative">
	<div class="t-head absolute left-1/2 -translate-x-1/2 h-10 -translate-y-16 z-20 bg-white border flex items-center shadow rounded-box" style="transition: transform .4s">
		<div class="grid text-xs text-center text-gray-500 font-bold" style="grid-template-columns: 56px 288px 288px 1fr 1fr 96px 96px 42px;">
			<div class="border-r border-gray-200 flex justify-center items-center">번호
				<label class="swap pl-1">
					<input type="checkbox" class="sort-btn" autocomplete="off" />
					<div class="swap-on"><i class="fa-solid fa-sort-up"></i></div>
					<div class="swap-off"><i class="fa-solid fa-sort-down"></i></div>
				</label>
			</div>
			<div class="border-r border-gray-200">요청일</div>
			<div class="border-r border-gray-200">응답일</div>
			<div class="border-r border-gray-200">요청자(번호)</div>
			<div class="border-r border-gray-200">응답자(번호)</div>
			<div class="border-r border-gray-200">응답상태</div>
			<div class="border-r border-gray-200">관련 항목</div>
			<div><button class="btn btn-xs btn-circle btn-ghost" onclick="showReqHistory()"><i class="fa-solid fa-sm fa-rotate-right"></i></button></div>
		</div>
	</div>
	<div class="border h-full overflow-y-auto">
		<table class="table text-center">
			<thead>
				<tr class="text-center h-10">
					<th class="w-14 [min-width:56px] flex items-center">번호
						<label class="swap pl-1">
							<input type="checkbox" class="sort-btn" autocomplete="off" />
							<div class="swap-on"><i class="fa-solid fa-sort-up"></i></div>
							<div class="swap-off"><i class="fa-solid fa-sort-down"></i></div>
						</label>
					</th>
					<th class="w-72 [min-width:288px]">요청일</th>
					<th class="w-72 [min-width:288px]">응답일</th>
					<th>요청자(번호)</th>
					<th>응답자(번호)</th>
					<th class="w-24 [min-width:96px]">응답상태</th>
					<th class="w-24 [min-width:96px]">관련 항목</th>
					<th class="[width:42px] pl-0 pr-4">
						<button class="btn btn-xs btn-circle btn-ghost" onclick="showReqHistory()"><i class="fa-solid fa-sm fa-rotate-right"></i></button>
					</th>
				</tr>
			</thead>
			
			<tbody class="request-body">
				<tr><th class="text-center" colspan=8>현재 조회되는 요청기록이 없습니다.</th></tr>
			</tbody>
		</table>
	</div>
</div>
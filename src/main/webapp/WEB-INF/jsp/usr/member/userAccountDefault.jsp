<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="bg-white border shadow-2xl rounded-3xl pb-10">
	<div class="p-10 text-3xl">
		<i class="fa-solid fa-screwdriver-wrench pr-1"></i>
		<span>계정 관리</span>
	</div>
	<div class="p-6 w-4/5 mx-auto">
		<div class="grid grid-cols-3 gap-10">
			<button class="flex flex-row btn btn-outline h-32 pt-4 pb-2.5" onclick="getUserAccountJsp(0)">
				<div class="w-full flex items-center justify-center text-5xl">
					<i class="fa-solid fa-user-pen"></i>
				</div>
				<div>계정 정보 수정</div>
			</button>
			<button class="flex flex-row btn btn-outline h-32 pt-4 pb-2.5" onclick="getUserAccountJsp(1)">
				<div class="w-full flex items-center justify-center text-5xl">
					<i class="fa-solid fa-unlock-keyhole"></i>
				</div>
				<div>비밀번호 재설정</div>
			</button>
			<button class="flex flex-row btn btn-outline h-32 pt-4 pb-2.5" onclick="getUserAccountJsp(2)">
				<div class="w-full flex items-center justify-center text-5xl">
					<i class="fa-solid fa-user-slash"></i>
				</div>
				<div>계정 탈퇴</div>
			</button>
		</div>
	</div>
</div>
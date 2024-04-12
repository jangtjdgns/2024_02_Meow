<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
	
</script>

<!-- 신고 조치는 문의 관리에서도 가능함, 해당 페이지는 신고 조치만 가능한 페이지임 -->
<div class="w-full h-full p-4">
	<!-- <div class="border-2 rounded-lg w-full h-full flex items-center justify-center text-lg">현재 신고된 회원이 없습니다.</div> -->

	<div class="overflow-x-auto">
		<table class="table">
			<!-- head -->
			<thead>
				<tr>
					<th><label> <input type="checkbox" class="checkbox checkboxAll" /></label></th>
					<th>이름</th>
					<th>Job</th>
					<th>Favorite Color</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<!-- row 1 -->
				<tr>
					<th><label> <input type="checkbox" class="checkbox" /></label></th>
					<td>
						<div class="flex items-center gap-3">
							<div class="avatar">
								<div class="mask mask-squircle w-12 h-12">
									<img src="/tailwind-css-component-profile-2@56w.png" alt="Avatar Tailwind CSS Component" />
								</div>
							</div>
							<div>
								<div class="font-bold">Hart Hagerty</div>
								<div class="text-sm opacity-50">United States</div>
							</div>
						</div>
					</td>
					<td>Zemlak, Daniel and Leannon <br /> <span
						class="badge badge-ghost badge-sm">Desktop Support
							Technician</span>
					</td>
					<td>Purple</td>
					<th>
						<button class="btn btn-ghost btn-xs">details</button>
					</th>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- <script>
	$(function(){
		showMap();
	})
</script> -->

<div class="relative overflow-hidden h-full">
	<!-- 지도 -->
	<div id="map" class="shadow" style="width:100%; height: 100%;"></div>
	
	<!-- 범위 지정 버튼 -->
	<div class="absolute z-20 top-2 left-2 w-96 h-8 overflow-hidden rounded-l-lg">
		<div id="radioBtn" class="swap-wrap join absolute top-0 left-0">
		  	<input class="join-item btn btn-sm glass text-xs w-12" type="radio" name="options" value="1000" aria-label="1km" autocomplete="off" />
		  	<input class="join-item btn btn-sm glass text-xs w-12" type="radio" name="options" value="2000" aria-label="2km" autocomplete="off" checked />
		  	<input class="join-item btn btn-sm glass text-xs w-12" type="radio" name="options" value="3000" aria-label="3km" autocomplete="off" />
		  	<input class="join-item btn btn-sm glass text-xs w-12" type="radio" name="options" value="4000" aria-label="4km" autocomplete="off" />
		  	<input class="join-item btn btn-sm glass text-xs w-12" type="radio" name="options" value="5000" aria-label="5km" autocomplete="off" />
		  	<input class="join-item btn btn-sm glass text-xs w-12" type="radio" name="options" value="10000" aria-label="10km" autocomplete="off" />
		  	<input class="join-item btn btn-sm glass text-xs w-12" type="radio" name="options" value="500000" aria-label="all" autocomplete="off" />
		  	<label class="swap join-item btn btn-sm text-xs z-20 btn-accent">
			  	<input type="checkbox" autocomplete="off" />
			  	<div class="swap-on"><i class="fa-solid fa-angle-right"></i></div>
			  	<div class="swap-off"><i class="fa-solid fa-angle-left"></i></div>
			</label>
		</div>
	</div>
	
	<!-- 옵션 -->
	<div class="absolute z-20 top-12 left-2 w-96 h-44 overflow-x-hidden">
		<div class="swap-wrap join absolute w-96 h-full top-0 left-0">
			<div class="join-item w-full bg-white text-xs p-4">
				<div class="text-center text-lg font-bold">지도 검색 옵션</div>
				<label class="form-control w-full">
					<div class="label">
						<span class="label-text">주소(지역)</span>
					</div>
					<input type="text" placeholder="주소 검색" class="input input-sm input-bordered w-full search-address" />
				</label>
				
				<div class="text-right mt-4">
					<button class="btn btn-sm optionBtn" data-defaultAddr="대전 둔산동">초기화</button>
					<button class="btn btn-sm optionBtn">검색</button>
				</div>
			</div>
			<label class="swap join-item btn btn-sm text-xs z-20 btn-accent">
			  	<input type="checkbox" autocomplete="off" />
			  	<div class="swap-on"><i class="fa-solid fa-angle-right"></i></div>
			  	<div class="swap-off"><i class="fa-solid fa-angle-left"></i></div>
			</label>
		</div>
	</div>
</div>
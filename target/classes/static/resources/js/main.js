function geocodeAddress(address, callback) {
	var geocoder = new kakao.maps.services.Geocoder();

	geocoder.addressSearch(address, function(result, status) {
		if (status === kakao.maps.services.Status.OK) {
			const cityGuDong = (result[0].address.region_1depth_name + " " + result[0].address.region_2depth_name + " " + result[0].address.region_3depth_name).trim();

			// 행정동 주소로 다시 검색
			geocoder.addressSearch(cityGuDong, function(result, status) {
				return callback(result);
			});
		} else {
			console.error('Geocoding failed for address:', address);
		}
	});
}
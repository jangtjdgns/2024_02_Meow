function getDateTime(type){
	const date = new Date();
	
	let returnDate;
	
	switch(type) {
		case 'year':
			returnDate = date.getFullYear();
			break;
		case 'month':
			returnDate = date.getMonth() + 1;
			breka;
		case 'day':
			returnDate = date.getDate();
			break;
		case 'hours':
			returnDate = date.getHours();
			break;
		case 'minutes':
			returnDate = date.getMinutes();
			break;
		case 'second':
			returnDate = date.getSeconds();
			break;
	}
	
	return returnDate < 10 ? '0' + returnDate : returnDate;
}
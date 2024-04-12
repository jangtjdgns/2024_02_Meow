// alert 창 띄우기 (메시지)
let alertTimeOut;
let alertIdx = 0;
function alertMsg(msg, type) {
	let alert;
	
	if (alertTimeOut) {
		clearTimeout(alertTimeOut);
	}
	
	if(type == "default") {
		alert = `
		    <div id="alert-${alertIdx}" role="alert" class="alert">
		      	<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-info shrink-0 w-6 h-6">
		        	<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
		      	</svg>
		      	<span class="mx-auto">${msg}</span>
		    </div>
		`;
	} else if(type == "success"){
		alert = `
			<div id="alert-${alertIdx}" role="alert" class="alert alert-success">
			  	<svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
			  	<span>${msg}</span>
			</div>
		`;
	} else if(type == "warning") {
		alert = `
			<div id="alert-${alertIdx}" role="alert" class="alert alert-warning">
			  	<svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
			  	<span class="mx-auto">${msg}</span>
			</div>
		`;
	} else if(type == "error") {
		alert = `
			<div id="alert-${alertIdx}" role="alert" class="alert alert-error">
			  	<svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
			  	<span class="mx-auto text-white">${msg}</span>
			</div>
		`;
	} else if(type == "loading") {
		alert = `
			<div id="alert-${alertIdx}" role="alert" class="alert [background-color:rgba(255,255,255,0)] border-0 w-full">
			  	<span class="loading loading-spinner loading-lg"></span>
			</div>
		`
	}
	
	$("#alert").append(alert);
	removeAlert(alertIdx++);
}

// alert 삭제 함수
function removeAlert(curAlertIdx) {
    setTimeout(function () {
        $(`#alert-${curAlertIdx}`).remove();
    }, 3000);
}
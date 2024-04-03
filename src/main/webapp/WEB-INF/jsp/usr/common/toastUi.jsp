<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../common/toastUiCdn.jsp"%>

<script>
	// editor
	function ToastEditor__init() {
		$('.toast-ui-editor').each(function(index, node) {
			const $node = $(node);
			const $initialValueEl = $node.find(' > script');
			const initialValue = $initialValueEl.length == 0 ? '' : $initialValueEl.html().trim();
			const $modifyVal = $("#body").val().trim(); // 수정
			const editor = new toastui.Editor({
				el : node,
				previewStyle : 'vertical',
				height : '500px',
				initialValue : $modifyVal.length != 0 ? $modifyVal : initialValue, // write or modify 체크
				hooks: {	// Base64 단점 보완을 위해 hooks의 addImageBlobHook 속성 사용
			    	addImageBlobHook: (blob, callback) => {
			    		// blob : Java Script 파일 객체
			    		const formData = new FormData();
			        	formData.append('articleImage', blob);
			        	
			   			$.ajax({
			           		type: 'POST',
			           		enctype: 'multipart/form-data',
			           		url: '../article/uploadImage',
			           		data: formData,
			           		dataType: 'json',
			           		processData: false,
			           		contentType: false,
			           		cache: false,
			           		success: function(data) {
			           			alertMsg("", "loading");
			           			setTimeout(function() {		// 타임아웃 속성이 동작을 안해서 따로 사용
			           	            if(data.success) {
			           	                const url = data.data;
			           	                callback(url, '사진 대체 텍스트 입력');
			           	            }
			           	        }, 3000);	// 3초
			           		},
			           		error: function(e) {
			           			//console.log(e.abort([statusText]));
			           			callback('image_load_fail', '사진 대체 텍스트 입력');
			           		} 
			           	})
			    	}
				},
				toolbarItems: [
				    ['heading', 'bold', 'italic', 'strike'],
				    ['hr', 'quote'],
				    ['ul', 'ol', 'task', 'indent', 'outdent'],
				    ['table', 'image', 'link'],
				  ],
				plugins : [toastui.Editor.plugin.colorSyntax],
			});
			
			$node.data('data-toast-editor', editor);
		});
	}
	
	// viewer
	function ToastEditorView__init() {
		const $initialValueEl = $("#body");
		const initialValue = $initialValueEl.val();
		
		var viewer = new toastui.Editor.factory({
			el : document.querySelector("#viewer"),
			initialValue : initialValue,
			viewer : true,
			plugins : [toastui.Editor.plugin.colorSyntax]
		});

		$("#viewer").data('viewer', viewer);
	}
	
	// submitForm 함수
	function submitForm(form) {
		form.title.value = form.title.value.trim();

		if (form.title.value.length == 0) {
			alert('제목을 입력해주세요');
			form.title.focus();
			return;
		}

		const editor = $(form).find('.toast-ui-editor').data(
				'data-toast-editor');
		/* const html = editor.getHTML(); */
		const markdown = editor.getMarkdown().trim();

		if (markdown.length == 0) {
			alert('내용을 입력해주세요');
			editor.focus();
			return;
		}

		form.body.value = markdown;

		form.submit();
	}
	
	
	
	$(function() {
		const filename = window.location.pathname.split('/').pop(); // 파일명 가져오기
		
		// viewer 페이지 경우 (detail)
		if(filename == "detail") {
			ToastEditorView__init();	
		}
		// editor 페이지 경우 (write, modify)
		else {
			ToastEditor__init();
			
			// toastUi 에디터 border 변경
			$(".toastui-editor-defaultUI").css({
				"border": "2px solid #F9FAFB",
				"border-left": 0,
			});
			
			// toastUi 에디터 툴바 배경색 변경
			$(".toastui-editor-defaultUI-toolbar").css({
				"background-color": "#F9FAFB",
			})
		}
	})
</script>
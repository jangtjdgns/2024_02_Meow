<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- dompurify -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/dompurify/2.3.0/purify.min.js"></script>

<!-- TOAST UI 에디터 코어 -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<!-- 토스트 UI 에디터 플러그인, 컬러피커 -->
<link rel="stylesheet" href="https://uicdn.toast.com/tui-color-picker/latest/tui-color-picker.css" />
<script src="https://uicdn.toast.com/tui-color-picker/latest/tui-color-picker.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor-plugin-color-syntax/latest/toastui-editor-plugin-color-syntax.min.css" />
<script src="https://uicdn.toast.com/editor-plugin-color-syntax/latest/toastui-editor-plugin-color-syntax.min.js"></script>

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
				initialValue : $modifyVal.length != 0 ? $modifyVal : initialValue, // write or modify 체크
				height : '500px',
				toolbarItems: [
				    ['heading', 'bold', 'italic', 'strike'],
				    ['hr', 'quote'],
				    ['ul', 'ol', 'task', 'indent', 'outdent'],
				    ['table', 'image', 'link'],
				  ],
				plugins : [ toastui.Editor.plugin.colorSyntax],
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
			plugins : [ toastui.Editor.plugin.colorSyntax]
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
			console.log("1")
			ToastEditorView__init();	
		}
		// editor 페이지 경우 (write, modify)
		else {
			console.log("2")
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
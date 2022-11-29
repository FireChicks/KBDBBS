<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/custom.css">
<script src="http://code.jquery.com/jquery-latest.js"></script>
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	String toID = null;
	if(request.getParameter("toID") != null) {
		toID = (String) request.getParameter("toID");
	}
%>
<script type="text/javascript">
	function autoClosingAlert(selector, delay) {
		var alert = $(selector).alert();
		alert.show();
		window.setTimeout((function(){ alert.hide() }, delay));
	}
	function submitFunction() {
		var fromID = '<%=userID%>';
		var toID = '<%=toID%>';
		var chatContent = $('#chatContent').val();
		$.ajax({
			type: "POST",
			url: "../ChatSubmitServlet",
			data: {
				fromID : encodeURIComponent(fromID),
				toID : encodeURIComponent(toID),
				chatContent : encodeURIComponent(chatContent),
			},
			success: function(result) {
				if(result == 1) {
					autoClosingAlert('#successMessage',2000);
				} else if (result == 0) {
					autoClosingAlert('#dangerMessage',2000);
				} else {
					autoClosingAlert('#warningMessage',2000);
				}
			}			
		});
		$('#chatContent').val('');
	}
	var lastID = 0;
	function chatListFunction(type) {
		var fromID = '<%= userID %>';
		var toID = '<%= toID %>';
		$.ajax( {
			type: "POST",
			url: "../ChatListServlet",
			data: {
				fromID: encodeURIComponent(fromID),
				toID: encodeURIComponent(toID),
				listType: type
			},
			success: function(data) {
				if(data == "") return;
				var parsed = JSON.parse(data);
				var result = parsed.result;
				for(var i = 0; i < result.length; i++) {
					addChat(result[i][0].value, result[i][2].value, result[i][5].value, result[i][3].value, result[i][4].value);
				}
				lastID = Number(parsed.last);
			}
		});
	}
	function addChat(chatName, chatContent, chatTime, chatInquiryID, chatInquiryType)  {
		var itemImagePath = "images/logo.png";
		if(chatInquiryID != "" && chatInquiryType == 0) {
			$.ajax({
				type: "POST",
				url: "../ItemImageServlet",
				async:false,
				data: {
					itemID : encodeURIComponent(chatInquiryID)
				},
				success: function(data) {
						itemImagePath = data;					
				}			
			});
			$('#chatList').append('<div class="row">' + 
					'<div class="col-lg-12">' +
					'<div class="media">' +
					'<a class="pull-left" href="#">' +
					'<img class="media-object img-circle" style="width: 30px; height : 30px;" src="../images/logo.png" alt="">' +
					'</a>' +
					'<div class="media-body">' +
					'<h4 class="media-heading" style="color:#1E82FF;"><b>' +
					chatName +
					'</b> <span class="small pull-right" style="color:black;">' +
					chatTime +
					'</span>' +
					'</h4>' +
					'<p>' +
					'<a href="itemUpdate.jsp?itemID=' + chatInquiryID  +'">' +
					'<img src="' + itemImagePath + '"bordr="2" width="150px" height="120px" alt="파일위치오류">' +			
					chatContent +
					'</a></p>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'<hr>');
					$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
					return;
		} else if (chatInquiryType == 1) {
			$('#chatList').append('<div class="row">' + 
					'<div class="col-lg-12">' +
					'<div class="media">' +
					'<a class="pull-left" href="#">' +
					'<img class="media-object img-circle" style="width: 30px; height : 30px;" src="../images/logo.png" alt="">' +
					'</a>' +
					'<div class="media-body">' +
					'<h4 class="media-heading" style="color:#1E82FF;"><b>' +
					chatName +
					'</b> <span class="small pull-right" style="color:black;">' +
					chatTime +
					'</span>' +
					'</h4>' +
					'<p>' +
					chatContent + '<a class="btn btn-primary" href="statusManage.jsp?orderID='+ chatInquiryID +'">주문 확인</a>' +
					'</p>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'<hr>');
					$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
			return;
		}
		
		if(chatName == 'admin') {
			$('#chatList').append('<div class="row">' + 
					'<div class="col-lg-12">' +
					'<div class="media">' +
					'<a class="pull-left" href="#">' +
					'<img class="media-object img-circle" style="width: 30px; height : 30px;" src="../images/logo.png" alt="">' +
					'</a>' +
					'<div class="media-body">' +
					'<h4 class="media-heading" style="color:#1E82FF;"><b>' +
					chatName +
					'</b> <span class="small pull-right" style="color:black;">' +
					chatTime +
					'</span>' +
					'</h4>' +
					'<p>' +
					chatContent +
					'</p>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'<hr>');
					$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
		} else {
		$('#chatList').append('<div class="row">' + 
				'<div class="col-lg-12">' +
				'<div class="media">' +
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width: 30px; height : 30px;" src="../images/logo.png" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				chatName +
				'<span class="small pull-right">' +
				chatTime +
				'</span>' +
				'</h4>' +
				'<p>' +
				chatContent +
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>');
				$('#chatList').scrollTop($('#chatList')[0].scrollHeight);		
		}
	}
	function getInfiniteChat(){
		setInterval(function() {
			chatListFunction(lastID);
		}, 3000);
	}	
</script>
</head>
<body>
  <div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>1:1 문의</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="pannel-collapse collapse in">
						<div id="chatList" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height:600px;">
						</div>
						<div class="portlet-footer">
							<div class="row" style="height:90px;">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px;" id="chatContent" name="chatContent" class="form-control" placeholder="메세지를 입력하세요." maxlength="300"></textarea>					
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right" onclick="submitFunction();">전송</button>	
									<div class="clearfix"></div>																	
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>  
  </div>
   <div class="alert alert-success" id="successMessage" style="display:none;">
  	<strong>메시지 전송에 성공했습니다.</strong> 
  </div>
  <div class="alert alert-danger" id="dangerMessage" style="display:none;">
  	<strong>내용을 입력해주세요</strong> 
  </div>
  <div class="alert alert-warning" id="warningMessage" style="display:none;">
  	<strong>데이터베이스 오류가 발생했습니다.</strong> 
  </div>
  <script type="text/javascript">
  $(document).ready(function() {
	  chatListFunction('ten');
	  getInfiniteChat();
  });
  </script>
</body>
</html>
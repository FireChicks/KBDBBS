<%@page import="java.io.PrintWriter"%>
<%@page import="message.Message"%>
<%@page import="message.MessageDAO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:include page="index.jsp"></jsp:include>
<% 
if(session.getAttribute("userID") != null) {
	MessageDAO messageDAO = new MessageDAO();
	 int pageNumber = 1;
    ArrayList<Message> messageList = messageDAO.getMassageList((String)session.getAttribute("userID"));  	  
%>
<style>
  tr td {
  	border:1px solid;
  	text-align:center;
  	margin-left: 50px;
  }
</style>
<script>
var count = 0;
var price = 0;
</script>
<div class="container">
		<div style="width:100%;">
		<div  style="width:2000px; margin: 0 auto;">
			<div class="jumbotron" style="padding-top : 50px; text-algin:center;">
				<h3>알림</h3>		
				<table>
					<tr>
						<td>
							번호
						</td>
						<td style="width:800px;">
							내용
						</td>
						<td  style="width:300px;">
							알림 시간
						</td>		
						<td>
							확인
						</td>			
					</tr>
					<%for(int i = 0; i < messageList.size(); i++) { %>
					<form action="deleteMessage.jsp">
					<tr>
						<td>
							 <%=i+1%>
						</td>						
						<td>
						<%=messageList.get(i).getMessageContent()%>
						</td>
						<td>
						<%=messageList.get(i).getMessageDate()%>
						</td>
						<td>
							<input class="btn btn-success" type="submit" value="읽음">
							<input type="hidden" name="messageID" value="<%=String.valueOf(messageList.get(i).getMessageID())%>">
						</td>
					</tr>
					</form>
					<%}%>				
				</table>
				<a class="btn btn-primary" href="deleteAllMessage.jsp">전부 읽음</a>	
			</div>		
			</div>
		</div>
	</div>
<%}else{ 
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('먼저 로그인 해주시기 바랍니다.')");
	script.println("history.back()");
	script.println("</script>");
}%>
</body>
</html>
	
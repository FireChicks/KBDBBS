<%@page import="message.MessageDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
if(session.getAttribute("userID") != null) {
	int messageID = 0;

	MessageDAO messageDAO = new MessageDAO();
	
	if(messageDAO.readingAllMessage((String) session.getAttribute("userID")) == 1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('성공적으로 메세지를 전부 읽음 처리했습니다.')");
			script.println("location.href='main.jsp'");
			script.println("</script>");		
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('성공적으로 메세지를 전부 읽음 처리했습니다.')");
		script.println("location.href='main.jsp'");
		script.println("</script>");
	}
%>

<%} else {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('먼저 로그인 해주시기 바랍니다.')");
	script.println("location.href='main.jsp'");
	script.println("</script>");
}
	%>

</body>
</html>
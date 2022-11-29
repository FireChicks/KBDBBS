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
	String userID = null;
	if(session.getAttribute("userID") != null && ((String)session.getAttribute("userID")).equals("admin")) {
		userID = (String)session.getAttribute("userID");
		
		String Url = "/WEB-INF/inquiryAdmin.jsp";
		RequestDispatcher dispathcer = null;
		dispathcer = request.getRequestDispatcher(Url);
		dispathcer.forward(request, response);
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('허가되지 않은 접근입니다!')");
		script.println("location.href = '../main.jsp'");
		script.println("</script>");
	}	
%>
</body>
</html>
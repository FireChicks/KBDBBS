<%@page import="order.OrdDAO"%>
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
	int orderID = 0;
	if(request.getParameter("orderID") != null) {
		orderID =  Integer.parseInt(request.getParameter("orderID"));
	}
	OrdDAO orderDAO = new OrdDAO();
	
	if(orderDAO.CancleOrder(orderID) == 1) {	
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('성공적으로 주문을 취소 처리했습니다.')");
			script.println("location.href='orderHistory.jsp'");
			script.println("</script>");
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.')");
		script.println("location.href='orderHistory.jsp'");
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
<%@page import="order.OrdDAO"%>
<%@page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>
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
	int orderID = 0;
	if(request.getParameter("orderID") != null) {
		orderID = Integer.parseInt(request.getParameter("orderID"));
	}	
	
	String userID = null;
	
	OrdDAO ordDAO = new OrdDAO();
	
	if(session.getAttribute("userID") != null && ((String)session.getAttribute("userID")).equals("admin")) {
	userID = (String)session.getAttribute("userID");		
		if(orderID != 0) {
				int resultStat = ordDAO.CancleOrder(orderID);
				if(resultStat == 1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('성공적으로 다음 단계로 이동했습니다.')");
					script.println("location.href = '../statusManage.jsp?orderID=" + orderID + "'");
					script.println("</script>");
				} else if (resultStat == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('데이터베이스 오류가 발생했습니다.')");
				script.println("location.href = '../statusManage.jsp?orderID=" + orderID + "'");
				script.println("</script>");
				} else if(resultStat == 2) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('이미 취소 단계입니다.')");
					script.println("location.href = '../statusManage.jsp?orderID=" + orderID + "'");
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('무언가 상정하지 않은 오류가 발생했습니다.')");
					script.println("location.href = '../ordManage.jsp?'");
					script.println("</script>");
				}
				
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 주문번호입니다.')");
				script.println("location.href = '../ordManage.jsp?'");
				script.println("</script>");
			}
	} else {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('허가되지 않은 접근입니다!')");
	script.println("location.href = '../../main.jsp'");
	script.println("</script>");
	}	
%>
</body>
</html>
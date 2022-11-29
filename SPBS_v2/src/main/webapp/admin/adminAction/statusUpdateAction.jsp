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
	OrdDAO orderDAO = new OrdDAO();
	String invoiceNumber = null;
	if(request.getParameter("invoiceNumber") != null) {
		invoiceNumber = request.getParameter("invoiceNumber");
	}
	
	String userID = null;
	
	OrdDAO ordDAO = new OrdDAO();
	if(session.getAttribute("userID") != null && ((String)session.getAttribute("userID")).equals("admin")) {
	if(invoiceNumber != null && invoiceNumber.equals("") && orderDAO.getOrder(orderID).getOrderStatus().charAt(0) == '0' && orderDAO.getOrder(orderID).getOrderStatus().charAt(1) == '3') {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('송장번호를 입력해주세요')");
		script.println("history.back()");
		script.println("</script>");
		return;
	}
	userID = (String)session.getAttribute("userID");		
		if(orderID != 0) {
				int resultStat = 0;
				if(request.getParameter("invoiceNumber") == null){
					resultStat = ordDAO.nextOrder(orderID);
				} else {
					resultStat = ordDAO.nextOrder(orderID, invoiceNumber);
				}
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
					script.println("alert('이미 최종 단계입니다.')");
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
		
}else {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('허가되지 않은 접근입니다!')");
	script.println("location.href = '../../main.jsp'");
	script.println("</script>");
}	
%>
</body>
</html>
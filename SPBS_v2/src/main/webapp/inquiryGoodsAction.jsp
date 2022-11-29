<%@page import="chat.ChatDAO"%>
<%@page import="item.Item"%>
<%@page import="item.ItemShowDAO"%>
<%@page import="cart.CartDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>   
<!DOCTYPE html>
<html>
<head>
<jsp:useBean id="cart" class="cart.Cart" scope="page" />
<jsp:setProperty name="cart" property="quantity" />	
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
		String itemID = null;
		if(request.getParameter("itemID") != null) {
			itemID = request.getParameter("itemID");
						
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");		
		
		ChatDAO chatDAO = new ChatDAO();	
			
		int result = chatDAO.submitInquiry("admin", userID, itemID + "번 상품의 문의를 시작합니다.", itemID, 0);
			
	    if (result == 1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('" + itemID +"번 상품의 문의를 성공하였습니다.')");
			script.println("location.href = 'clientInquiry.jsp?toID=admin'");
			script.println("</script>");
		} else if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
} else { 
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('먼저 로그인 해주시기 바랍니다.')");
	script.println("history.back()");
	script.println("</script>");
}
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비정상적인 아이템 ID입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
%>
</body>
</html>
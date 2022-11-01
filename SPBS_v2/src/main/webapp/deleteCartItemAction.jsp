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
		int itemID = 1;
		if(request.getParameter("itemID") != null) {
			itemID = Integer.parseInt(request.getParameter("itemID"));
		} 
		
		int cartID = 1;
		if(request.getParameter("cartID") != null) {
			cartID = Integer.parseInt(request.getParameter("cartID"));
		} 
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");		
		
		cart.setItemID(itemID);
		cart.setUserID(userID);
		
		CartDAO cartDAO = new CartDAO();		
		int result = cartDAO.deleteCart(cartID);
	    if (result == 1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('성공적으로 장바구니에서 물품을 제거했습니다.')");
			script.println("location.href = 'cart.jsp'");
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
%>
</body>
</html>
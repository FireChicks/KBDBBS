<%@page import="cart.Cart"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="item.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page import="cart.CartDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.outer-div {
  width : 1000px;
  height : 300px;
  background-color : blue;
}

.inner-div {
  width : 100px;
  height : 100px;
  background-color: red;
  margin: auto;
}
</style>
</head>
<body>
<jsp:include page="index.jsp"></jsp:include>
<% 
if(session.getAttribute("userID") != null) {
	CartDAO cartDAO = new CartDAO();
	ArrayList<Cart> cartLists = cartDAO.getCart((String) session.getAttribute("userID"));
    ArrayList<Item> ItemList = new ArrayList<Item>();
    
    for(int i = 0; i < cartLists.size(); i ++) {
    	ItemList.add(cartDAO.getItem(cartLists.get(i).getItemID()));
    }
	if(ItemList.size() != 0) {
%>
<style>
  tr td {
  	border-bottom:1px solid;
  }
</style>
<script>
var count = 0;
var price = 0;
</script>
<div class="container">
		<div style="width:100%;">
		<div  style="width:800px; margin: 0 auto;">
			<div class="jumbotron" style="padding-top : 50px;">
				<h3>장바구니</h3>
				<br>
				<form action="orderConfirm.jsp" method="post">
				<table style="border-bottom:1px solid;">
				<tr>
					<td>
						체크
					</td>
					<td colspan="2" style="text-align:center;">
						상품명
					</td>
					<td>
						재고
					</td>
					<td>
						가격
					</td>
					<td>
						삭제
					</td>
				</tr>				
				<%for(int i = 0 ; i < ItemList.size(); i ++) {%>
				<script>
			      $( document ).ready( function() {
			        $( '#quantity<%=i%>' ).change( function() {
			        	const checkbox = document.getElementById('checkbox<%=i%>');
			        	const is_checked = checkbox.checked;
			          if(is_checked) {
			          var a = document.getElementById('quantity<%=i%>').value;
			          if(a < 1) {
			        	  alert('1보다 작은 수를 주문하실수는 없습니다.');
			        	  document.getElementById('quantity<%=i%>').value = preQuantity<%=i%>;
			        	  return;
			          } else if (a > maxQuantity<%=i%>) {
			        	  alert('현재 재고 ' + maxQuantity<%=i%> + '보다 많이 주문하실수는 없습니다.');
			        	  document.getElementById('quantity<%=i%>').value = preQuantity<%=i%>;
			        	  return;
			          }
			          a = document.getElementById('quantity<%=i%>').value;
			          var c = preQuantity<%=i%>;
			          var b = <%=ItemList.get(i).getItemPrice()%>;
			          if(preQuantity<%=i%> > a) {
			        	  for(var i = 0; i < (c - a); i++) {
			        	  	price -= b;
			        	  	preQuantity<%=i%> -= 1;
			        	  	count -= 1;
			        	  } 	
			        	  alert(price + '/' + count + '/' + preQuantity<%=i%>);
			        	  document.getElementById('result').innerText = "총 가격 " + price+ "  원 총 "+ count + "개의 상품을";
			        	  return;
			          } else {
			        	  for(var i = 0; i < (a - c); i++) {
			        	  	price += b;
			        	  	preQuantity<%=i%> += 1;
			        	  	count += 1;			        	  	
			        	  }
			        	  alert(price + '/' + count + '/' + preQuantity<%=i%>);	
			        	  document.getElementById('result').innerText = "총 가격 " + price+ "  원 총 "+ count + "개의 상품을";
			        	  return;
			             }
			          } else {
			        	  alert('먼저 체크를 해주세요');
			        	  document.getElementById('quantity<%=i%>').value = preQuantity<%=i%>;
			        	  return;			          }
			          
			        } );
			      } );
    			</script>
				<tr>
					<td>
						<input type="checkbox" onclick='is_checked<%=i%>()' id="checkbox<%=i%>" name="checkbox" value="<%=ItemList.get(i).getItemID()%>" checked>
					</td>
					<td>
						<img src="<%if(ItemList.get(i).getItemContentImagePath() != null && !ItemList.get(i).getItemContentImagePath().equals("")) { %>							
											<%String[] imagePaths = ItemList.get(i)	.getItemContentImagePath().split("#");%><%=imagePaths[0]%><%}else{%><%="/SPBS/resources/이미지 없음.png"%><%}%>" bordr="2" width="100px" height="80px" alt="파일위치오류">
					</td>
					<td style="width:50%;">
						<a href="goodsView.jsp?itemID=<%=ItemList.get(i).getItemID()%>"><%=ItemList.get(i).getItemName()%></a>
					</td>
					<td>
						<%=ItemList.get(i).getItemPrice()%>원
						<input id="price<%=i%>" type="hidden" value="<%=ItemList.get(i).getItemPrice()%>">
					</td>
					<script>
						for(let i = 0; i < <%=cartLists.get(i).getQuantity()%>; i++) {
							price += <%=ItemList.get(i).getItemPrice()%>;
							count++;	
						}
					</script>
					<td>
						<input id="quantity<%=i%>" type="number" value="<%=cartLists.get(i).getQuantity()%>" name="quantity<%=i%>" min="1" max="<%=ItemList.get(i).getItemStock()%>"/>
					</td>
					<script>
						var preQuantity<%=i%> = <%=cartLists.get(i).getQuantity()%>;
						var maxQuantity<%=i%> = <%=ItemList.get(i).getItemStock()%>;
					</script>
					<td>
						<a class="btn btn-light" href="deleteCartItemAction.jsp?cartID=<%=cartLists.get(i).getCartID()%>">삭제</a>
					</td>
				</tr>
				<script>
					function is_checked<%=i%>() {
						const checkbox = document.getElementById('checkbox<%=i%>');
						const is_checked = checkbox.checked;
						if(is_checked){
						for(let i = 0; i < preQuantity<%=i%>; i++) {
							price += <%=ItemList.get(i).getItemPrice()%>
							count++;
						}
						document.getElementById('result').innerText = "총 가격 " + price+ "  원 총 "+ count + "개의 상품을";
						} else {
							for(let i = 0; i < preQuantity<%=i%>; i++) {
								price -= <%=ItemList.get(i).getItemPrice()%>
								count--;
							}
							document.getElementById('result').innerText = "총 가격 " + price+ "  원 총 "+ count + "개의 상품을";
						}
						if(count == 0) {
							document.getElementById('result').innerText = "";
							btn.disabled = true;
						} else {
							btn.disabled = false;
						}
					}
				</script>
				<%}%>				
				</table>
				<a id="result"></a>
				<input id="btn" class="btn btn-primary" type="submit" value="주문">
				</form>
				<script>
				document.getElementById('result').innerText = "총 가격 " + price+ "  원 총 "+ count + "개의 상품을";
				</script>
			</div>		
			</div>
		</div>
	</div>
<%} else {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('장바구니에 아무 상품도 존재하지 않습니다.')");
	script.println("history.back()");
	script.println("</script>");
}%>
<%}else{ 
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('먼저 로그인 해주시기 바랍니다.')");
	script.println("history.back()");
	script.println("</script>");
}%>
</body>
</html>
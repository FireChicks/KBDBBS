<%@page import="user.User"%>
<%@page import="user.UserDAO"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
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
	String userID = (String) session.getAttribute("userID");
	UserDAO userDAO = new UserDAO();
	User user = userDAO.getUser(userID);
	CartDAO cartDAO = new CartDAO();
	ArrayList<Cart> cartLists = cartDAO.getCart(userID);
    ArrayList<Item> ItemList = new ArrayList<Item>();
    
    for(int i = 0; i < cartLists.size(); i ++) {
    	ItemList.add(cartDAO.getItem(cartLists.get(i).getItemID()));
    }
    
    String[] itemIDs = request.getParameterValues("checkbox");    
    List<String> itemIDList = new ArrayList<>(Arrays.asList(itemIDs));
    
	String[] userAddress = user.getUserAddress().split("#"); 
%>
<%
	for(int i = 0; i < itemIDList.size(); i++) {
		request.setAttribute("itemID" + i, itemIDList.get(i));
	}
	request.setAttribute("itemIDSize", itemIDList.size());
%>
<style>
  tr td {
  	border-bottom:1px solid;
  }
</style>
<script>
var resultPrice = 0;
var count = 0;
var price = 0;
</script>
<div class="container">
		<div style="width:100%;">
		<div  style="width:800px; margin: 0 auto;">
			<div class="jumbotron" style="padding-top : 50px;">
				<h3>주문 확인</h3>
				<br>
				<form action="orderAction.jsp" method="post">
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
				</tr>
				<%ArrayList<Integer> indexs = new ArrayList<Integer>();
					int itemListSize = 0;
				%>
				<%for(int i = 0 ; i < ItemList.size(); i ++) {%>
				<%if(itemIDList.contains(Integer.toString(ItemList.get(i).getItemID()))){%>				
				<tr>
					<td>
						<input type="checkbox" onclick='is_checked<%=i%>()' id="checkbox<%=i%>" value="<%=ItemList.get(i).getItemID()%>" checked disabled>
					</td>
					<td>
						<img src="<%if(ItemList.get(i).getItemContentImagePath() != null && !ItemList.get(i).getItemContentImagePath().equals("")) { %>							
											<%String[] imagePaths = ItemList.get(i)	.getItemContentImagePath().split("#");%><%=imagePaths[0]%><%}else{%><%="/SPBS/resources/이미지 없음.png"%><%}%>" bordr="2" width="100px" height="80px" alt="파일위치오류">
					</td>
					<td style="width:50%;">
						<a><%=ItemList.get(i).getItemName()%></a>
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
						<input id="quantity<%=i%>" type="number" value="<%=request.getParameter("quantity"+i)%>" name="quantity<%=i%>" min="1" max="<%=ItemList.get(i).getItemStock()%>" disabled/>
					</td>
					<script>
						var preQuantity<%=i%> = <%=cartLists.get(i).getQuantity()%>;
						var maxQuantity<%=i%> = <%=ItemList.get(i).getItemStock()%>;
					</script>
				</tr>					
					<input type="hidden" name="quantitys<%=itemListSize%>" value="<%=request.getParameter("quantity" + i)%>"> 
					<input type="hidden" name="itemID<%=itemListSize%>" value="<%=ItemList.get(i).getItemID()%>"> 
					<%itemListSize++;%>
					<%}%>
				<%}%>
				<input type="hidden" name="itemListSize" value="<%=itemListSize%>"> 	
				<tr>
					<td>	
						<h4>포인트</h4>
					</td>
					<td>
						사용 가능한 포인트 <%=user.getUserPoint()%> <br>
						사용 포인트 <input type="number" id="point" name="point" min="0" max="<%=user.getUserPoint()%>" value="0">
					</td>
					<td>
						사용 가능한 포인트 단위는 10원 단위입니다.
					</td>
					<input type="hidden" id="usedPoint" name="usedPoint" value="0">
				</tr>			
				</table>
				<script>
			      $( document ).ready( function() {
			        $( '#point' ).change( function() {			        	
			          var usePoint = document.getElementById('point').value;
			          
			          if(usePoint % 10 != 0) {
			        	  usePoint = usePoint - (usePoint % 10); 
			          }
			          
			          if(usePoint < 0) {
			        	  alert('0보다 작은 포인트를 사용하실수는 없습니다.');
			        	  document.getElementById('point').value = 0;			        	  
			        	  return;
			          } else if (usePoint > <%=user.getUserPoint()%>) {
			        	  alert('현재 사용가능한 포인트 ' + <%=user.getUserPoint()%> + '보다 많이 사용하실수는 없습니다.');
			        	  document.getElementById('point').value = <%=user.getUserPoint()%>;
			        	  document.getElementById('usedPoint').value = resultPrice;
			        	  resultPrice = price -  <%=user.getUserPoint()%>;
			        	  document.getElementById('result').innerText = "총 가격 " + resultPrice+ "  원 총 "+ count + "개의 상품을";
			        	  return;
			          }
			          resultPrice = price -  usePoint;
			          if(resultPrice < 0) {
			        	  alert('전체가격 ' + price + '보다 많이 포인트를 사용하실수는 없습니다.');
			        	  document.getElementById('point').value = price; 
			        	  return;
			          } else {
			        	  alert('성공적으로 ' + usePoint + '만큼 포인트를 사용했습니다.');
			        	  btn.disabled = false;
			             }
			         
			          document.getElementById('result').innerText = "총 가격 " + resultPrice+ "  원 총 "+ count + "개의 상품을";
			          document.getElementById('point').value = usePoint;
			          document.getElementById('usedPoint').value = resultPrice;
			          return;
			        } );
			      } );
    			</script>							
				<div class="form-group">
						<b>주소</b>
						<div style="float:right;">
						<input type="text" id="sample4_postcode" name="postcode" placeholder="우편번호" value="<%=userAddress[0]%>">
						<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기">
						</div>
						<input type="text"  class="form-control" id="sample4_roadAddress" name="roadAddress" placeholder="도로명주소" value="<%=userAddress[1]%>">
						<input type="hidden" class="form-control" id="sample4_jibunAddress" name="jibunAddress" placeholder="지번주소">
						<span id="guide" style="color:#999;display:none"></span>
						<input type="text" class="form-control"  id="sample4_detailAddress" name="detailAddress" placeholder="상세주소" value="<%=userAddress[2]%>">
						<input type="hidden" id="sample4_extraAddress" name="extraAddress" placeholder="참고항목">

				<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<a id="result"></a>
				<input id="btn" class="btn btn-primary" type="submit" value="주문">
				</form>
				
				
				<script>
    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode;
                document.getElementById("sample4_roadAddress").value = roadAddr;
                document.getElementById("sample4_jibunAddress").value = data.jibunAddress;
                
                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                if(roadAddr !== ''){
                    document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("sample4_extraAddress").value = '';
                }

                var guideTextBox = document.getElementById("guide");
                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }
	</script>
				
				
				<script>
				document.getElementById('result').innerText = "총 가격 " + price+ "  원 총 "+ count + "개의 상품을";
				btn.disabled = true;
				</script>
					</div>
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
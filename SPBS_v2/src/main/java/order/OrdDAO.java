package order;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import item.Item;
import item.ItemDAO;
import message.MessageDAO;
import user.UserDAO;

public class OrdDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public OrdDAO() {
		try {
			String dbURL = "jdbc:mysql://192.168.123.111:3306/spbs";
			String dbID = "dldi1021";
			String dbPassword = "@Dlwodbs5025";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public int getNext() {
		String SQL = "SELECT orderID  FROM ord ORDER BY orderID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public boolean nextPage(int pageNumber,String search,String searchText) {
		if(searchText.equals("")) {
			String SQL = "select count(*) from ord";
			ArrayList<Item> list = new ArrayList<Item>();
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					int num = rs.getInt(1);
					if(num > (pageNumber - 1) * 10) {
						return true;
					} else {
						return false;
					}
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
			return false;
		}
		ArrayList<Order> orderList = null;
		orderList = checkListSize((pageNumber-1), search, searchText);
		int size = orderList.size() - ((pageNumber - 1) * 10);
		while(size > 0) {
			return true;
		}
		return false;
	}
	
	public boolean nextPage(String userID, int pageNumber) {
			String SQL = "select count(*) from ord WHERE userID = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					int num = rs.getInt(1);
					if(num > (pageNumber - 1) * 10) {
						return true;
					} else {
						return false;
					}
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
			return false;
	}
	
	public ArrayList<Order> checkListSize(int pageNumber, String search, String searchText) {				 	
		String SQL = " SELECT * FROM ord WHERE "+ search +" LIKE ? ORDER BY orderdate DESC";
		ArrayList<Order> list = new ArrayList<Order>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);			 				
			pstmt.setString(1, "%" + searchText + "%");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Order order = new Order();
				order.setOrderID(rs.getInt(1));
				order.setUserID(rs.getString(2));
				order.setOrderStatus(rs.getString(3));
				order.setOrderDate(rs.getString(4));
				order.setOrderCancleDate(rs.getString(5));
				order.setOrderCompleteDate(rs.getString(6));
				order.setOrderPrice(rs.getInt(7));
				order.setOrderUsePoint(rs.getInt(8));
				order.setOrderPaymentStatus(rs.getString(9));
				order.setOrderAddress(rs.getString(10));
				order.setInvoiceNumber(rs.getString(11));
				order.setOrdItemIDs(rs.getString(12));
				order.setOrdItemQuantitys(rs.getString(13));
				list.add(order);
			}			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int setInvoice(int orderID, String invoiceNumber) {
		String SQL = "UPDATE ord SET invoiceNumber = ? WHERE orderID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, invoiceNumber);
			pstmt.setInt(2, orderID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int setOrderCancleDate(int orderID) {
		String SQL = "UPDATE ord SET orderCancleDate = ? WHERE orderID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, getDate());
			pstmt.setInt(2, orderID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int setOrderCompleteDate(int orderID) {
		String SQL = "UPDATE ord SET orderCompleteDate = ? WHERE orderID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, getDate());
			pstmt.setInt(2, orderID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
			
	public Order getOrder(int orderID) {
		String SQL = "SELECT * FROM ord WHERE orderID = ?";
		ArrayList<Order> list = new ArrayList<Order>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, orderID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Order order = new Order();
				order.setOrderID(rs.getInt(1));
				order.setUserID(rs.getString(2));
				order.setOrderStatus(rs.getString(3));
				order.setOrderDate(rs.getString(4));
				order.setOrderCancleDate(rs.getString(5));
				order.setOrderCompleteDate(rs.getString(6));
				order.setOrderPrice(rs.getInt(7));
				order.setOrderUsePoint(rs.getInt(8));
				order.setOrderPaymentStatus(rs.getString(9));
				order.setOrderAddress(rs.getString(10));
				order.setInvoiceNumber(rs.getString(11));
				order.setOrdItemIDs(rs.getString(12));
				order.setOrdItemQuantitys(rs.getString(13));
				return order;
			}			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
}
	
	public ArrayList<Order> getOrders(String userID, int pageNumber) {
			String SQL = "SELECT * FROM ord WHERE userID = ? ORDER BY orderdate ASC LIMIT 10 OFFSET ?";
			ArrayList<Order> list = new ArrayList<Order>();
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				pstmt.setInt(2, (pageNumber - 1) * 10 );
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Order order = new Order();
					order.setOrderID(rs.getInt(1));
					order.setUserID(rs.getString(2));
					order.setOrderStatus(rs.getString(3));
					order.setOrderDate(rs.getString(4));
					order.setOrderCancleDate(rs.getString(5));
					order.setOrderCompleteDate(rs.getString(6));
					order.setOrderPrice(rs.getInt(7));
					order.setOrderUsePoint(rs.getInt(8));
					order.setOrderPaymentStatus(rs.getString(9));
					order.setOrderAddress(rs.getString(10));
					order.setInvoiceNumber(rs.getString(11));
					order.setOrdItemIDs(rs.getString(12));
					order.setOrdItemQuantitys(rs.getString(13));
					list.add(order);
				}			
			}catch(Exception e) {
				e.printStackTrace();
			}
			return list;
	}
		
	public ArrayList<Order> getOrders(int pageNumber) {
		String SQL = "SELECT * FROM ord ORDER BY orderdate ASC LIMIT 10 OFFSET ?";
		ArrayList<Order> list = new ArrayList<Order>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (pageNumber - 1) * 10 );
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Order order = new Order();
				order.setOrderID(rs.getInt(1));
				order.setUserID(rs.getString(2));
				order.setOrderStatus(rs.getString(3));
				order.setOrderDate(rs.getString(4));
				order.setOrderCancleDate(rs.getString(5));
				order.setOrderCompleteDate(rs.getString(6));
				order.setOrderPrice(rs.getInt(7));
				order.setOrderUsePoint(rs.getInt(8));
				order.setOrderPaymentStatus(rs.getString(9));
				order.setOrderAddress(rs.getString(10));
				order.setInvoiceNumber(rs.getString(11));
				order.setOrdItemIDs(rs.getString(12));
				order.setOrdItemQuantitys(rs.getString(13));
				list.add(order);
			}			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
}
	
	public int startOrder(String userID, int price, int usePoint, String paymentStyle, String address, String itemIDs, String itemQuantitys) {
		String SQL = "INSERT INTO ord (orderID, userID, orderStatus, orderdate, orderPrice, orderUsePoint, orderPaymentStatus, orderAddress, invoiceNumber, ordItemIDs, ordItemQuantitys)"
				+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {		
			MessageDAO messageDAO = new MessageDAO();
			int orderID = getNext();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, orderID);
			pstmt.setString(2, userID);
			pstmt.setString(3, "01");
			pstmt.setString(4, getDate());
			pstmt.setInt(5, price);
			pstmt.setInt(6, usePoint);
			pstmt.setString(7, paymentStyle);
			pstmt.setString(8, address);
			pstmt.setString(9, "");	
			pstmt.setString(10, itemIDs);
			pstmt.setString(11, itemQuantitys);
			messageDAO.create(userID, "포인트를 " + usePoint + "만큼 사용하여 성공적으로 주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문을 완료하였습니다.");
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int moveOrder(int orderID, char stat) {
		String SQL = "UPDATE ord SET orderStatus = ? WHERE orderID = ?";
		OrdDAO orderDAO = new OrdDAO();
		ItemDAO itemDAO = new ItemDAO();
		UserDAO userDAO = new UserDAO();
		MessageDAO messageDAO = new MessageDAO();
		Order order = orderDAO.getOrder(orderID);
		String[] ordItems     = order.getOrdItemIDs().split("#");
		String[] ordQuantitys = order.getOrdItemQuantitys().split("#");		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			if(stat == '1') {
				messageDAO.create(orderDAO.getOrder(orderID).getUserID(), "주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문의 상태가 결제완료 상태로 변경되었습니다.");
				pstmt.setString(1, "02");				
			}else if(stat== '2') {
				messageDAO.create(orderDAO.getOrder(orderID).getUserID(), "주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문의 상태가 배송준비중 상태로 변경되었습니다.");
				pstmt.setString(1, "03");
			}else if(stat == '3') {
				messageDAO.create(orderDAO.getOrder(orderID).getUserID(), "주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문의 상태가 배송중 상태로 변경되었습니다.");
				pstmt.setString(1, "04");
			}else if(stat == '4') {
				for(int i = 0; i < ordItems.length; i++) {
					itemDAO.updateSaleCount(Integer.parseInt(ordItems[i]), Integer.parseInt(ordQuantitys[i]));
				}
				userDAO.plusPoint(order.getUserID(), order.getOrderPrice());
				messageDAO.create(orderDAO.getOrder(orderID).getUserID(), "주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문의 상태가 배송완료 상태로 변경되었고  성공적으로 " + (order.getOrderPrice() / 100) +"만큼의 포인트가 추가되었습니다.");				
				setOrderCompleteDate(orderID);
				pstmt.setString(1, "05");
			}else if(stat == '5') {
				return 2;
			} else {
				return -1;
			}					
			pstmt.setInt(2, orderID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int moveCancleOrder(int orderID, char stat) {
		String SQL = "UPDATE ord SET orderStatus = ? WHERE orderID = ?";
		try {
			MessageDAO messageDAO = new MessageDAO();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			if(stat == '1') {
			messageDAO.create(getOrder(orderID).getUserID(), "주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문의 상태가 반품중 상태로 변경되었습니다.");
				pstmt.setString(1, "12");
			}else if(stat== '2') {
				messageDAO.create(getOrder(orderID).getUserID(), "주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문의 상태가 반품완료 상태로 변경되었습니다.");	
				setOrderCompleteDate(orderID);
				pstmt.setString(1, "13");
			}else if(stat == '3') {
				return 2;
			} else {
				return -1;
			}					
			pstmt.setInt(2, orderID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int CancleOrder(int orderID) {//반환값이 2일시 이미 취소중||
		String SQL = "UPDATE ord SET orderStatus = ? WHERE orderID = ?";
		OrdDAO orderDAO = new OrdDAO();
		UserDAO userDAO = new UserDAO();
		MessageDAO messageDAO = new MessageDAO();
		Order order     = orderDAO.getOrder(orderID);
		String[] ordItems     = order.getOrdItemIDs().split("#");
		String[] ordQuantitys = order.getOrdItemQuantitys().split("#");
		ItemDAO itemDAO = new ItemDAO();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			String stat = checkStatus(orderID);
			if(stat.charAt(0) == '0') {
				if(stat.charAt(1) == '1' || stat.charAt(1) == '2' || stat.charAt(1) == '3') {
					for(int i = 0; i < ordItems.length; i++) {
						itemDAO.returnStock(Integer.parseInt(ordItems[i]), Integer.parseInt(ordQuantitys[i]));
					}
					setOrderCancleDate(orderID);
					messageDAO.create(getOrder(orderID).getUserID(), "주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문의 상태가 취소완료 상태로 변경되었습니다.");
					pstmt.setString(1, "13");								
				}else if(stat.charAt(1) == '4' || stat.charAt(1) == '5') {
					userDAO.updateReturnCount(order.getUserID());
					setOrderCancleDate(orderID);
					messageDAO.create(getOrder(orderID).getUserID(), "주문번호 <a href='orderDetail.jsp?orderID="+ orderID +"'>"+ orderID +"</a>의 주문의 상태가 반품요청 상태로 변경되었습니다.");
					pstmt.setString(1, "11");
				} else {
					return -1;
				}
			}else if(stat.charAt(0) == '1') {
				return 2;
			} else {
				return -1;
			}					
			pstmt.setInt(2, orderID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public String checkStatus(int orderID) { 
		String SQL = "SELECT orderStatus FROM ord WHERE orderID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, orderID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public int nextOrder(int orderID) { // 2반환시 이동 불가능||1 반환시 성공||-1반환시 오류 발생
		String SQL = "SELECT orderStatus FROM ord WHERE orderID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, orderID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String stat = rs.getString(1);
				if(stat.charAt(0) == '0') {
					return moveOrder(orderID, stat.charAt(1));
				}else if(stat.charAt(0) == '1') {
					return moveCancleOrder(orderID, stat.charAt(1));
				} else {
					return -1;
				}

			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int nextOrder(int orderID, String invocieNumber) { // 2반환시 이동 불가능||1 반환시 성공||-1반환시 오류 발생
		String SQL = "SELECT orderStatus FROM ord WHERE orderID = ?";		
		OrdDAO orderDAO = new OrdDAO();
		try {
			orderDAO.setInvoice(orderID, invocieNumber);
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, orderID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String stat = rs.getString(1);
				if(stat.charAt(0) == '0') {
					return moveOrder(orderID, stat.charAt(1));
				}else if(stat.charAt(0) == '1') {
					return moveCancleOrder(orderID, stat.charAt(1));
				} else {
					return -1;
				}

			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}

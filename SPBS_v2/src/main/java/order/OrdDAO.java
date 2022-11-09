package order;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import item.Item;

public class OrdDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public OrdDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/SPBS";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.cj.jdbc.Driver");
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
	
	public int startOrder(String userID, int price, int usePoint, String paymentStyle, String address, String itemIDs, String itemQuantitys) {
		String SQL = "INSERT INTO ord (orderID, userID, orderStatus, orderdate, orderPrice, orderUsePoint, orderPaymentStatus, orderAddress, invoiceNumber, ordItemIDs, ordItemQuantitys)"
				+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {			
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
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
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int moveOrder(int orderID, char stat) {
		String SQL = "UPDATE ord SET ordstatus = ? WHERE orderID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			if(stat == '1') {
				pstmt.setString(1, "02");
			}else if(stat== '2') {
				pstmt.setString(1, "03");
			}else if(stat == '3') {
				pstmt.setString(1, "04");
			}else if(stat == '4') {
				pstmt.setString(1, "05");
			}else if(stat == '5') {
				return 2;
			} else {
				return -1;
			}					
			pstmt.setInt(2, orderID);
			rs = pstmt.executeQuery();
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int moveCancleOrder(int orderID, char stat) {
		String SQL = "UPDATE ord SET ordstatus = ? WHERE orderID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			
			if(stat == '1') {
				pstmt.setString(1, "02");
			}else if(stat== '2') {
				pstmt.setString(1, "03");
			}else if(stat == '3') {
				return 2;
			} else {
				return -1;
			}					
			pstmt.setInt(2, orderID);
			rs = pstmt.executeQuery();
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int CancleOrder(int orderID) {//반환값이 2일시 이미 취소중||
		String SQL = "UPDATE ord SET ordstatus = ? WHERE orderID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			String stat = checkStatus(orderID);
			if(stat.charAt(0) == '0') {
				if(stat.charAt(1) == '1' || stat.charAt(1) == '2') {
					pstmt.setString(1, "13");			
				}else if(stat.charAt(1) == '3' || stat.charAt(1) == '4' || stat.charAt(1) == '5') {
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
			rs = pstmt.executeQuery();
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
}

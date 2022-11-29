package message;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import order.Order;

public class MessageDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public MessageDAO() {
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
		String SQL = "SELECT messageID  FROM message ORDER BY messageID DESC";
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
	
	public int count(String userID) {
		String SQL = "SELECT count(messageID) FROM message where readStatus = 1 AND userID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
			return 0;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int readingMessage(int messageID) {
		String SQL = "UPDATE message SET readStatus = 0 WHERE messageID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, messageID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int readingAllMessage(String userID) {
		String SQL = "UPDATE message SET readStatus = 0 WHERE userID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int create(String userID, String messageContent) {
		String SQL = "INSERT INTO message (messageID, userID, messageContent, messageDate, readStatus)"
				+ " VALUES (?, ?, ?, ?, ?)";
		try {			
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, userID);
			pstmt.setString(3, messageContent);
			pstmt.setString(4, getDate());
			pstmt.setInt(5, 1);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public ArrayList<Message> getMassageList(String userID) {
		String SQL = "SELECT * FROM message WHERE userID = ? AND readStatus = 1 ORDER BY messageDate ASC";
		ArrayList<Message> list = new ArrayList<Message>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Message message = new Message();
				message.setMessageID(rs.getInt(1));
				message.setUserID(rs.getString(2));
				message.setMessageContent(rs.getString(3));
				message.setMessageDate(rs.getString(4));
				message.setReadStatus(rs.getInt(5));
				list.add(message);
			}			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}

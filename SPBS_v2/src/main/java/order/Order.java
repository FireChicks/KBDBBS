package order;

import java.util.Date;

public class Order {
	private int	   orderID;
	private String userID;
	private String orderStatus;
	private String   orderDate;
	private String   orderCancleDate;
	private String   orderCompleteDate;
	private int	   orderPrice;
	private int    orderUsePoint;
	private String orderPaymentStatus;
	private String orderAddress;
	private String invoiceNumber;
	private String ordItemIDs;
	private String ordItemQuantitys;
	
	public int getOrderID() {
		return orderID;
	}
	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getOrderStatus() {
		return orderStatus;
	}
	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}
	public int getOrderPrice() {
		return orderPrice;
	}
	public void setOrderPrice(int orderPrice) {
		this.orderPrice = orderPrice;
	}
	public int getOrderUsePoint() {
		return orderUsePoint;
	}
	public void setOrderUsePoint(int orderUsePoint) {
		this.orderUsePoint = orderUsePoint;
	}
	public String getOrderPaymentStatus() {
		return orderPaymentStatus;
	}
	public void setOrderPaymentStatus(String orderPaymentStatus) {
		this.orderPaymentStatus = orderPaymentStatus;
	}
	public String getOrderAddress() {
		return orderAddress;
	}
	public void setOrderAddress(String orderAddress) {
		this.orderAddress = orderAddress;
	}
	public String getInvoiceNumber() {
		return invoiceNumber;
	}
	public void setInvoiceNumber(String invoiceNumber) {
		this.invoiceNumber = invoiceNumber;
	}
	public String getOrdItemIDs() {
		return ordItemIDs;
	}
	public void setOrdItemIDs(String ordItemIDs) {
		this.ordItemIDs = ordItemIDs;
	}
	public String getOrdItemQuantitys() {
		return ordItemQuantitys;
	}
	public void setOrdItemQuantitys(String ordItemQuantitys) {
		this.ordItemQuantitys = ordItemQuantitys;
	}
	public String getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}
	public String getOrderCancleDate() {
		return orderCancleDate;
	}
	public void setOrderCancleDate(String orderCancleDate) {
		this.orderCancleDate = orderCancleDate;
	}
	public String getOrderCompleteDate() {
		return orderCompleteDate;
	}
	public void setOrderCompleteDate(String orderCompleteDate) {
		this.orderCompleteDate = orderCompleteDate;
	}
	
	
	
}

package chat;

public class Chat {
	private int chatID;
	private String fromID;
	private String toID;
	private String chatContent;
	private String chatTime;
	private String InquiryID;
	private int	   inquiryType;
	
	public int getChatID() {
		return chatID;
	}
	public void setChatID(int chatID) {
		this.chatID = chatID;
	}
	public String inquryID() {
		return fromID;
	}
	public String getFromID() {
		return fromID;
	}
	public void setFromID(String fromID) {
		this.fromID = fromID;
	}
	public String getToID() {
		return toID;
	}
	public void setToID(String toID) {
		this.toID = toID;
	}
	public String getChatContent() {
		return chatContent;
	}
	public void setChatContent(String chatContent) {
		this.chatContent = chatContent;
	}
	public String getChatTime() {
		return chatTime;
	}
	public void setChatTime(String chatTime) {
		this.chatTime = chatTime;
	}
	public String getInquiryID() {
		return InquiryID;
	}
	public void setInquiryID(String inquiryID) {
		InquiryID = inquiryID;
	}
	public int getInquiryType() {
		return inquiryType;
	}
	public void setInquiryType(int inquiryType) {
		this.inquiryType = inquiryType;
	}
	
	
}

package model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private String userName;    // Để hiển thị tên người dùng trong dashboard
    private double totalPrice;
    private String status;
    private String shippingAddress;
    private String phoneNumber;
    private Timestamp createdAt;
    private String paymentMethod;
    
    // Constructor mặc định
    public Order() {
    }
    
    // Constructor đầy đủ
    public Order(int orderId, int userId, String userName, double totalPrice, 
                String status, String shippingAddress, String phoneNumber, 
                Timestamp createdAt, String paymentMethod) {
        this.orderId = orderId;
        this.userId = userId;
        this.userName = userName;
        this.totalPrice = totalPrice;
        this.status = status;
        this.shippingAddress = shippingAddress;
        this.phoneNumber = phoneNumber;
        this.createdAt = createdAt;
        this.paymentMethod = paymentMethod;
    }
    
    // Getters và Setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
}

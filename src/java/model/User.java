/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author IUHADU
 */


public class User {
    // Constants cho các role
    public static final int ROLE_ADMIN = 1;
    public static final int ROLE_STAFF = 2;  // Thêm nếu cần
    public static final int ROLE_USER = 3;
    
    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private int roleId;
    private boolean isActive;
    private Date createdAt;
    private String address;

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
    
    // Constructor mặc định
    public User() {
        this.isActive = true;
        this.roleId = ROLE_USER; // Sử dụng constant thay vì số trực tiếp
        this.createdAt = new Date(); // Tự động set thời gian tạo
    }
    
    // Constructor đầy đủ
    public User(int userId, String fullName, String email, String phone, 
                String password, int roleId, boolean isActive, Date createdAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.roleId = roleId;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // Các phương thức kiểm tra role
    public boolean isAdmin() {
        return roleId == ROLE_ADMIN;
    }
    
    public boolean isUser() {
        return roleId == ROLE_USER;
    }
    
    public boolean isStaff() {
        return roleId == ROLE_STAFF;
    }
    
    // Phương thức validate
    public boolean isValidEmail() {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
    
    public boolean isValidPhone() {
        return phone != null && phone.matches("^\\d{10}$");
    }
    
    // Phương thức toString() để debug
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", roleId=" + roleId +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }

    // Getters and Setters giữ nguyên
    // ... (phần code getters/setters của bạn)
    
    // Thêm phương thức equals và hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return userId == user.userId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(userId);
    }


    // Getters and Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}

package model;

import java.sql.Timestamp;
import java.util.Date;

public class Product {
    private int productId;
    private String name;
    private String description;
    private double price;
    private int stockQuantity;
    private int categoryId;
    private String imageUrl;
    private Timestamp createdAt;
    
    // Thêm các thuộc tính mới cho sản phẩm nổi bật
    private boolean isFeatured;
    private int featuredOrder;
    private Date featuredUntil;
    private int roleid;
    
    // Constructor mặc định
    public Product() {
    }
    
    // Constructor đầy đủ hiện tại
    public Product(int productId, String name, String description, double price, 
                  int stockQuantity, int categoryId, String imageUrl, Timestamp createdAt, int roleid) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.categoryId = categoryId;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
        this.roleid = roleid;
    }

    public int getRoleid() {
        return roleid;
    }

    public void setRoleid(int roleid) {
        this.roleid = roleid;
    }
    
    // Constructor đầy đủ với các thuộc tính nổi bật
    public Product(int productId, String name, String description, double price, 
                  int stockQuantity, int categoryId, String imageUrl, Timestamp createdAt,
                  boolean isFeatured, int featuredOrder, Date featuredUntil) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.categoryId = categoryId;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
        this.isFeatured = isFeatured;
        this.featuredOrder = featuredOrder;
        this.featuredUntil = featuredUntil;
    }
    
    // Getters và Setters hiện có
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    // Thêm getters và setters cho các thuộc tính mới
    public boolean getIsFeatured() {
        return isFeatured;
    }
    
    public void setIsFeatured(boolean isFeatured) {
        this.isFeatured = isFeatured;
    }
    
    public int getFeaturedOrder() {
        return featuredOrder;
    }
    
    public void setFeaturedOrder(int featuredOrder) {
        this.featuredOrder = featuredOrder;
    }
    
    public Date getFeaturedUntil() {
        return featuredUntil;
    }
    
    public void setFeaturedUntil(Date featuredUntil) {
        this.featuredUntil = featuredUntil;
    }
}

package model;

import java.sql.Timestamp;
import java.util.Date;
import java.math.BigDecimal;

public class Product {

    private int productId;
    private String name;
    private String description;
    private BigDecimal price; // Đã thay đổi từ double sang BigDecimal
    private int stockQuantity;
    private int categoryId;
    private String imageUrl;
    private Timestamp createdAt;

    // Thêm các thuộc tính mới cho sản phẩm nổi bật
    private boolean isFeatured;
    private Integer featuredOrder;
    private Date featuredUntil;
    private int roleid;
    private int soldQuantity;
    private boolean featured;
    
    // Thêm thuộc tính categoryName
    private String categoryName;

    // Constructor mặc định
    public Product() {
    }

    // Constructor đầy đủ hiện tại (đã cập nhật)
    public Product(int productId, String name, String description, BigDecimal price,
            int stockQuantity, int categoryId, String imageUrl, Timestamp createdAt) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.categoryId = categoryId;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    // Constructor đầy đủ với các thuộc tính nổi bật (đã cập nhật)
    public Product(int productId, String name, String description, BigDecimal price,
            int stockQuantity, int categoryId, String imageUrl, Timestamp createdAt,
            boolean isFeatured, Integer featuredOrder, Date featuredUntil) {
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

    // Constructor đầy đủ với tất cả các thuộc tính (đã cập nhật)
    public Product(int productId, String name, String description, BigDecimal price,
            int stockQuantity, int categoryId, String imageUrl, Timestamp createdAt,
            boolean isFeatured, Integer featuredOrder, Date featuredUntil, String categoryName) {
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
        this.categoryName = categoryName;
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

    // Đã cập nhật getter và setter cho price
    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
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

    public Integer getFeaturedOrder() {
        return featuredOrder;
    }

    public void setFeaturedOrder(Integer featuredOrder) {
        this.featuredOrder = featuredOrder;
    }

    public Date getFeaturedUntil() {
        return featuredUntil;
    }

    public void setFeaturedUntil(Date featuredUntil) {
        this.featuredUntil = featuredUntil;
    }

    public int getRoleid() {
        return roleid;
    }

    public void setRoleid(int roleid) {
        this.roleid = roleid;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    // Getter và setter cho categoryName
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public String toString() {
        return "Product{"
                + "productId=" + productId
                + ", name='" + name + '\''
                + ", description='" + description + '\''
                + ", price=" + price
                + ", stockQuantity=" + stockQuantity
                + ", categoryId=" + categoryId
                + ", categoryName='" + categoryName + '\''
                + ", imageUrl='" + imageUrl + '\''
                + ", createdAt=" + createdAt
                + ", isFeatured=" + isFeatured
                + ", featuredOrder=" + featuredOrder
                + ", featuredUntil=" + featuredUntil
                + '}';
    }
}

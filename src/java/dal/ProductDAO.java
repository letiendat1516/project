package dal;

import context.DBContext;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDAO {

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setImageUrl(rs.getString("image_url"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        product.setRoleid(rs.getInt("role_id"));

        // Thêm các trường mới cho sản phẩm nổi bật
        try {
            // Kiểm tra nếu cột tồn tại trong ResultSet
            rs.findColumn("is_featured");
            product.setIsFeatured(rs.getBoolean("is_featured"));

            // Cột featured_order có thể NULL
            int featuredOrder = rs.getInt("featured_order");
            if (!rs.wasNull()) {
                product.setFeaturedOrder(featuredOrder);
            }

            // Cột featured_until có thể NULL
            Date featuredUntil = rs.getDate("featured_until");
            if (featuredUntil != null) {
                product.setFeaturedUntil(featuredUntil);
            }
        } catch (SQLException e) {
            // Nếu cột không tồn tại, bỏ qua lỗi
            // Điều này giúp phương thức vẫn hoạt động với các truy vấn không chứa các cột mới
        }

        return product;
    }

    // Phương thức mới để lấy sản phẩm nổi bật thực sự
    public List<Product> getFeaturedProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products "
                + "WHERE is_featured = 1 "
                + "AND (featured_until IS NULL OR featured_until >= GETDATE()) "
                + "ORDER BY featured_order ASC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    // Phương thức hiện tại - lấy sản phẩm mới nhất (đổi tên để tránh xung đột)
    public List<Product> getNewestProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT TOP (?) * FROM Products ORDER BY created_at DESC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    public List<Product> SearchProduct(String p) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products WHERE name LIKE ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + p + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    public Product getProductById(int productId) {
        String query = "SELECT * FROM Products WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products WHERE category_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    public List<Product> getALLProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    // Thêm phương thức để đánh dấu sản phẩm là nổi bật
    public boolean markProductAsFeatured(int productId, int featuredOrder, Date featuredUntil) {
        String query = "UPDATE Products SET is_featured = 1, featured_order = ?, featured_until = ? "
                + "WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, featuredOrder);

            if (featuredUntil != null) {
                ps.setDate(2, new java.sql.Date(featuredUntil.getTime()));
            } else {
                ps.setNull(2, java.sql.Types.DATE);
            }

            ps.setInt(3, productId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Thêm phương thức để bỏ đánh dấu sản phẩm nổi bật
    public boolean unmarkProductAsFeatured(int productId) {
        String query = "UPDATE Products SET is_featured = 0, featured_order = NULL, featured_until = NULL "
                + "WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> getAllProductsWithPagination(int page, int productsPerPage, String sortBy) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products";

        // Thêm điều kiện sắp xếp
        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc":
                    query += " ORDER BY price ASC";
                    break;
                case "price_desc":
                    query += " ORDER BY price DESC";
                    break;
                case "name_asc":
                    query += " ORDER BY name ASC";
                    break;
                case "newest":
                    query += " ORDER BY created_at DESC";
                    break;
                default:
                    // Mặc định sắp xếp theo đề xuất (sản phẩm nổi bật trước)
                    query += " ORDER BY CASE WHEN is_featured = 1 AND (featured_until IS NULL OR featured_until >= GETDATE()) "
                            + "THEN 0 ELSE 1 END, featured_order ASC, created_at DESC";
            }
        } else {
            // Mặc định sắp xếp theo đề xuất
            query += " ORDER BY CASE WHEN is_featured = 1 AND (featured_until IS NULL OR featured_until >= GETDATE()) "
                    + "THEN 0 ELSE 1 END, featured_order ASC, created_at DESC";
        }

        // Thêm phân trang
        int offset = (page - 1) * productsPerPage;
        query += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, offset);
            ps.setInt(2, productsPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    // Thêm phương thức để lấy tổng số sản phẩm
    public int getTotalProducts() {
        String query = "SELECT COUNT(*) AS total FROM Products";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Thêm phương thức để lấy tổng số sản phẩm theo danh mục
    public int getTotalProductsByCategory(int categoryId) {
        String query = "SELECT COUNT(*) AS total FROM Products WHERE category_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    /*/**
 * Lấy danh sách sản phẩm theo loại (role_id)
 *
 * @param roleId ID của loại sản phẩm (1: mô hình, 2: túi mù, 3: lego)
 * @return Danh sách các sản phẩm thuộc loại đó
     */
    public List<Product> getProductsByRole(Integer roleId) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products WHERE role_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    /**
     * Lấy tên loại sản phẩm dựa trên role_id
     *
     * @param roleId ID của loại sản phẩm
     * @return Tên loại sản phẩm
     */
    public String getRoleName(int roleId) {
        switch (roleId) {
            case 1:
                return "Mô hình";
            case 2:
                return "Túi mù";
            case 3:
                return "Lego";
            default:
                return "Không xác định";
        }
    }

    /**
     * Lấy danh sách tất cả các loại sản phẩm
     *
     * @return Map chứa role_id và tên loại sản phẩm
     */
    public Map<Integer, String> getAllRoles() {
        Map<Integer, String> roles = new HashMap<>();
        roles.put(1, "Mô hình");
        roles.put(2, "Túi mù");
        roles.put(3, "Lego");
        return roles;
    }

    /**
     * Đếm số lượng sản phẩm theo từng loại
     *
     * @return Map chứa role_id và số lượng sản phẩm
     */
    public Map<Integer, Integer> countProductsByRole() {
        Map<Integer, Integer> counts = new HashMap<>();
        String query = "SELECT role_id, COUNT(*) as count FROM Products GROUP BY role_id";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int roleId = rs.getInt("role_id");
                int count = rs.getInt("count");
                counts.put(roleId, count);
            }
        } catch (Exception e) {
            System.out.println("Error when counting products by role: " + e.getMessage());
            e.printStackTrace();
        }

        return counts;
    }

    /**
     * Cập nhật role_id cho sản phẩm
     *
     * @param productId ID của sản phẩm
     * @param roleId ID của loại sản phẩm mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateProductRole(int productId, int roleId) {
        String query = "UPDATE Products SET role_id = ? WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, roleId);
            ps.setInt(2, productId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error when updating product role: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật role_id cho nhiều sản phẩm cùng lúc
     *
     * @param productIds Danh sách ID của các sản phẩm
     * @param roleId ID của loại sản phẩm mới
     * @return số lượng sản phẩm được cập nhật thành công
     */
    public int updateMultipleProductRoles(List<Integer> productIds, int roleId) {
        if (productIds == null || productIds.isEmpty()) {
            return 0;
        }

        // Tạo chuỗi placeholders (?, ?, ?)
        String placeholders = String.join(",", Collections.nCopies(productIds.size(), "?"));
        String query = "UPDATE Products SET role_id = ? WHERE product_id IN (" + placeholders + ")";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, roleId);

            // Thiết lập các giá trị cho placeholders
            for (int i = 0; i < productIds.size(); i++) {
                ps.setInt(i + 2, productIds.get(i));
            }

            return ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error when updating multiple product roles: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public List<Product> getProductsByRoleAndSort(Integer roleId, String sortBy) {
        List<Product> products = new ArrayList<>();

        // Xây dựng câu query SQL với điều kiện và ORDER BY
        String sql = "SELECT * FROM Products";
        if (roleId != null) {
            sql += " WHERE role_id = ?";
        }

        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc":
                    sql += " ORDER BY price ASC";
                    break;
                case "price_desc":
                    sql += " ORDER BY price DESC";
                    break;
                case "name_asc":
                    sql += " ORDER BY name ASC";
                    break;
                case "newest":
                    sql += " ORDER BY created_at DESC"; // Chú ý: created_date -> created_at để phù hợp với schema
                    break;
                default:
                    // Mặc định sắp xếp theo đề xuất
                    sql += " ORDER BY CASE WHEN is_featured = 1 AND (featured_until IS NULL OR featured_until >= GETDATE()) "
                            + "THEN 0 ELSE 1 END, featured_order ASC, created_at DESC";
                    break;
            }
        } else {
            // Mặc định sắp xếp theo đề xuất
            sql += " ORDER BY CASE WHEN is_featured = 1 AND (featured_until IS NULL OR featured_until >= GETDATE()) "
                    + "THEN 0 ELSE 1 END, featured_order ASC, created_at DESC";
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Thiết lập tham số nếu có roleId
            if (roleId != null) {
                ps.setInt(1, roleId);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

}

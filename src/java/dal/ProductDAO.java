package dal;

import context.DBContext;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
}

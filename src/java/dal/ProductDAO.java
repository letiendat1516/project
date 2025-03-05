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
        product.setPrice(rs.getBigDecimal("price"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setImageUrl(rs.getString("image_url"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        product.setCategoryName(rs.getString("category_name"));


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
        
        // Thêm tên danh mục nếu có
        try {
            if (rs.findColumn("category_name") > 0) {
                product.setCategoryName(rs.getString("category_name"));
            }
        } catch (SQLException e) {
            // Bỏ qua nếu không có cột category_name
        }

        return product;
    }

    // Phương thức mới để lấy sản phẩm nổi bật thực sự
    public List<Product> getFeaturedProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.is_featured = 1 "
                + "AND (p.featured_until IS NULL OR p.featured_until >= GETDATE()) "
                + "ORDER BY p.featured_order ASC";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

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
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "ORDER BY p.created_at DESC";
                
        if (limit > 0) {
            query = "SELECT TOP (?) " + query.substring(7); // Thay "SELECT " bằng "SELECT TOP (?) "
        }

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            if (limit > 0) {
                ps.setInt(1, limit);
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

    public List<Product> SearchProduct(String p) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.name LIKE ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

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
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.product_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

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
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.category_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

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
    String query = "SELECT p.*, c.category_name FROM Products p "
            + "LEFT JOIN Categories c ON p.category_id = c.category_id";

    try (Connection conn = new DBContext().getConnection(); 
         PreparedStatement ps = conn.prepareStatement(query)) {

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

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

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

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

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
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id";

        // Thêm điều kiện sắp xếp
        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc":
                    query += " ORDER BY p.price ASC";
                    break;
                case "price_desc":
                    query += " ORDER BY p.price DESC";
                    break;
                case "name_asc":
                    query += " ORDER BY p.name ASC";
                    break;
                case "newest":
                    query += " ORDER BY p.created_at DESC";
                    break;
                default:
                    // Mặc định sắp xếp theo đề xuất (sản phẩm nổi bật trước)
                    query += " ORDER BY CASE WHEN p.is_featured = 1 AND (p.featured_until IS NULL OR p.featured_until >= GETDATE()) "
                            + "THEN 0 ELSE 1 END, p.featured_order ASC, p.created_at DESC";
            }
        } else {
            // Mặc định sắp xếp theo đề xuất
            query += " ORDER BY CASE WHEN p.is_featured = 1 AND (p.featured_until IS NULL OR p.featured_until >= GETDATE()) "
                    + "THEN 0 ELSE 1 END, p.featured_order ASC, p.created_at DESC";
        }

        // Thêm phân trang
        int offset = (page - 1) * productsPerPage;
        query += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

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

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

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

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

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

    /**
     * Lấy tên loại sản phẩm dựa trên category_id
     * @param categoryId ID của loại sản phẩm
     * @return Tên loại sản phẩm
     * @deprecated Sử dụng CategoryDAO.getCategoryById() thay thế
     */
    @Deprecated
    public String getCategoryName(int categoryId) {
        // Sử dụng CategoryDAO thay vì hardcode
        CategoryDAO categoryDAO = new CategoryDAO();
        try {
            model.Category category = categoryDAO.getCategoryById(categoryId);
            if (category != null) {
                return category.getCategoryName();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Không xác định";
    }

    /**
     * Lấy danh sách tất cả các danh mục sản phẩm từ database
     * @return Map chứa category_id và tên danh mục
     * @deprecated Sử dụng CategoryDAO.getAllCategories() thay thế
     */
    @Deprecated
    public Map<Integer, String> getAllCategories() {
        Map<Integer, String> categories = new HashMap<>();
        String query = "SELECT category_id, category_name FROM Categories";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int categoryId = rs.getInt("category_id");
                String categoryName = rs.getString("category_name");
                categories.put(categoryId, categoryName);
            }
        } catch (Exception e) {
            System.out.println("Error when getting all categories: " + e.getMessage());
            e.printStackTrace();
        }

        return categories;
    }

    /**
     * Đếm số lượng sản phẩm theo từng loại
     * @return Map chứa category_id và số lượng sản phẩm
     */
    public Map<Integer, Integer> countProductsByCategory() {
        Map<Integer, Integer> counts = new HashMap<>();
        String query = "SELECT category_id, COUNT(*) as count FROM Products GROUP BY category_id";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int categoryId = rs.getInt("category_id");
                int count = rs.getInt("count");
                counts.put(categoryId, count);
            }
        } catch (Exception e) {
            System.out.println("Error when counting products by category: " + e.getMessage());
            e.printStackTrace();
        }

        return counts;
    }

    /**
     * Cập nhật category_id cho sản phẩm
     * @param productId ID của sản phẩm
     * @param categoryId ID của loại sản phẩm mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateProductCategory(int productId, int categoryId) {
        String query = "UPDATE Products SET category_id = ? WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, productId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error when updating product category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật category_id cho nhiều sản phẩm cùng lúc
     * @param productIds Danh sách ID của các sản phẩm
     * @param categoryId ID của loại sản phẩm mới
     * @return số lượng sản phẩm được cập nhật thành công
     */
    public int updateMultipleProductCategories(List<Integer> productIds, int categoryId) {
        if (productIds == null || productIds.isEmpty()) {
            return 0;
        }

        // Tạo chuỗi placeholders (?, ?, ?)
        String placeholders = String.join(",", Collections.nCopies(productIds.size(), "?"));
        String query = "UPDATE Products SET category_id = ? WHERE product_id IN (" + placeholders + ")";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);

            // Thiết lập các giá trị cho placeholders
            for (int i = 0; i < productIds.size(); i++) {
                ps.setInt(i + 2, productIds.get(i));
            }

            return ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error when updating multiple product categories: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public List<Product> getProductsByCategoryAndSort(Integer categoryId, String sortBy) {
        List<Product> products = new ArrayList<>();

        // Xây dựng câu query SQL với điều kiện và ORDER BY
        String sql = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id";
                
        if (categoryId != null) {
            sql += " WHERE p.category_id = ?";
        }

        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc":
                    sql += " ORDER BY p.price ASC";
                    break;
                case "price_desc":
                    sql += " ORDER BY p.price DESC";
                    break;
                case "name_asc":
                    sql += " ORDER BY p.name ASC";
                    break;
                case "newest":
                    sql += " ORDER BY p.created_at DESC";
                    break;
                default:
                    // Mặc định sắp xếp theo đề xuất
                    sql += " ORDER BY CASE WHEN p.is_featured = 1 AND (p.featured_until IS NULL OR p.featured_until >= GETDATE()) "
                            + "THEN 0 ELSE 1 END, p.featured_order ASC, p.created_at DESC";
                    break;
            }
        } else {
            // Mặc định sắp xếp theo đề xuất
            sql += " ORDER BY CASE WHEN p.is_featured = 1 AND (p.featured_until IS NULL OR p.featured_until >= GETDATE()) "
                    + "THEN 0 ELSE 1 END, p.featured_order ASC, p.created_at DESC";
        }

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Thiết lập tham số nếu có categoryId
            if (categoryId != null) {
                ps.setInt(1, categoryId);
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

    public boolean updateStock(int productId, int quantity) {
        String sql = "UPDATE Products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, productId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy danh sách sản phẩm sắp hết hàng (stock_quantity < 10)
     * @param limit Số lượng sản phẩm tối đa cần lấy
     * @return Danh sách các sản phẩm sắp hết hàng
     */
    public List<Product> getLowStockProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.stock_quantity < 10 AND p.stock_quantity > 0 "
                + "ORDER BY p.stock_quantity ASC";
        
        if (limit > 0) {
            query = "SELECT TOP (?) " + query.substring(7); // Thay "SELECT " bằng "SELECT TOP (?) "
        }

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            if (limit > 0) {
                ps.setInt(1, limit);
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

    /**
     * Thêm sản phẩm mới vào database
     * @param product Đối tượng Product cần thêm
     * @return ID của sản phẩm vừa thêm, hoặc -1 nếu thất bại
     */
    public int addProduct(Product product) {
        String query = "INSERT INTO Products (name, description, price, stock_quantity, category_id, image_url, is_featured) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setInt(5, product.getCategoryId());
            ps.setString(6, product.getImageUrl());
            ps.setBoolean(7, product.getIsFeatured());

            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Cập nhật thông tin sản phẩm trong database
     * @param product Đối tượng Product cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateProduct(Product product) {
        String query = "UPDATE Products SET name = ?, description = ?, price = ?, "
                + "stock_quantity = ?, category_id = ?, image_url = ?, is_featured = ? "
                + "WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setInt(5, product.getCategoryId());
            ps.setString(6, product.getImageUrl());
            ps.setBoolean(7, product.getIsFeatured());
            ps.setInt(8, product.getProductId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa sản phẩm khỏi database
     * @param productId ID của sản phẩm cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteProduct(int productId) {
        String query = "DELETE FROM Products WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật trạng thái nổi bật của sản phẩm
     * @param productId ID của sản phẩm
     * @param featured true nếu muốn đánh dấu là nổi bật, false nếu không
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateFeaturedStatus(int productId, boolean featured) {
        String query = "UPDATE Products SET is_featured = ?, "
                + "featured_order = ?, featured_until = ? "
                + "WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setBoolean(1, featured);
            
            if (featured) {
                // Nếu đánh dấu là nổi bật, đặt featured_order là 999 (cuối cùng) và featured_until là null (không hết hạn)
                ps.setInt(2, 999);
                ps.setNull(3, java.sql.Types.DATE);
            } else {
                // Nếu bỏ đánh dấu, đặt featured_order và featured_until là null
                ps.setNull(2, java.sql.Types.INTEGER);
                ps.setNull(3, java.sql.Types.DATE);
            }
            
            ps.setInt(4, productId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy số lượng tồn kho của sản phẩm
     * @param productId ID của sản phẩm
     * @return Số lượng tồn kho, hoặc 0 nếu không tìm thấy sản phẩm
     */
    public int getProductStockById(int productId) {
        String query = "SELECT stock_quantity FROM Products WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("stock_quantity");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Cập nhật số lượng tồn kho của sản phẩm
     * @param productId ID của sản phẩm
     * @param stockQuantity Số lượng tồn kho mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateProductStock(int productId, int stockQuantity) {
        String query = "UPDATE Products SET stock_quantity = ? WHERE product_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, stockQuantity);
            ps.setInt(2, productId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy danh sách sản phẩm theo danh mục với phân trang
     * @param categoryId ID của danh mục
     * @param page Số trang hiện tại
     * @param productsPerPage Số sản phẩm trên mỗi trang
     * @param sortBy Tiêu chí sắp xếp
     * @return Danh sách sản phẩm đã phân trang
     */
    public List<Product> getProductsByCategoryWithPagination(int categoryId, int page, int productsPerPage, String sortBy) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.category_id = ?";

        // Thêm điều kiện sắp xếp
        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc":
                    query += " ORDER BY p.price ASC";
                    break;
                case "price_desc":
                    query += " ORDER BY p.price DESC";
                    break;
                case "name_asc":
                    query += " ORDER BY p.name ASC";
                    break;
                case "newest":
                    query += " ORDER BY p.created_at DESC";
                    break;
                default:
                    // Mặc định sắp xếp theo đề xuất (sản phẩm nổi bật trước)
                                        // Mặc định sắp xếp theo đề xuất (sản phẩm nổi bật trước)
                    query += " ORDER BY CASE WHEN p.is_featured = 1 AND (p.featured_until IS NULL OR p.featured_until >= GETDATE()) "
                            + "THEN 0 ELSE 1 END, p.featured_order ASC, p.created_at DESC";
            }
        } else {
            // Mặc định sắp xếp theo đề xuất
            query += " ORDER BY CASE WHEN p.is_featured = 1 AND (p.featured_until IS NULL OR p.featured_until >= GETDATE()) "
                    + "THEN 0 ELSE 1 END, p.featured_order ASC, p.created_at DESC";
        }

        // Thêm phân trang
        int offset = (page - 1) * productsPerPage;
        query += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, productsPerPage);
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
     * Kiểm tra xem danh mục có sản phẩm nào không
     * @param categoryId ID của danh mục
     * @return true nếu danh mục có ít nhất một sản phẩm, false nếu không
     */
    public boolean categoryHasProducts(int categoryId) {
        String query = "SELECT COUNT(*) AS count FROM Products WHERE category_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    /**
     * Lấy danh sách sản phẩm cho trang admin với thông tin danh mục
     * @return Danh sách sản phẩm kèm thông tin danh mục
     */
    public List<Product> getProductsForAdmin() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "ORDER BY p.product_id DESC";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }
    
    /**
     * Lấy danh sách sản phẩm cho trang admin với phân trang và tìm kiếm
     * @param page Số trang hiện tại
     * @param productsPerPage Số sản phẩm trên mỗi trang
     * @param searchTerm Từ khóa tìm kiếm (có thể null)
     * @param categoryId ID danh mục lọc (có thể null)
     * @return Danh sách sản phẩm đã phân trang và lọc
     */
    public List<Product> getProductsForAdminWithPagination(int page, int productsPerPage, String searchTerm, Integer categoryId) {
        List<Product> products = new ArrayList<>();
        StringBuilder queryBuilder = new StringBuilder(
                "SELECT p.*, c.category_name FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id WHERE 1=1");
        
        // Thêm điều kiện tìm kiếm nếu có
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            queryBuilder.append(" AND p.name LIKE ?");
        }
        
        // Thêm điều kiện lọc theo danh mục nếu có
        if (categoryId != null && categoryId > 0) {
            queryBuilder.append(" AND p.category_id = ?");
        }
        
        // Thêm sắp xếp
        queryBuilder.append(" ORDER BY p.product_id DESC");
        
        // Thêm phân trang
        queryBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        String query = queryBuilder.toString();
        
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            int paramIndex = 1;
            
            // Thiết lập tham số tìm kiếm
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchTerm + "%");
            }
            
            // Thiết lập tham số lọc danh mục
            if (categoryId != null && categoryId > 0) {
                ps.setInt(paramIndex++, categoryId);
            }
            
            // Thiết lập tham số phân trang
            int offset = (page - 1) * productsPerPage;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, productsPerPage);
            
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
     * Đếm tổng số sản phẩm theo điều kiện tìm kiếm và lọc
     * @param searchTerm Từ khóa tìm kiếm (có thể null)
     * @param categoryId ID danh mục lọc (có thể null)
     * @return Tổng số sản phẩm thỏa mãn điều kiện
     */
    public int countProductsWithFilter(String searchTerm, Integer categoryId) {
        StringBuilder queryBuilder = new StringBuilder(
                "SELECT COUNT(*) AS total FROM Products WHERE 1=1");
        
        // Thêm điều kiện tìm kiếm nếu có
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            queryBuilder.append(" AND name LIKE ?");
        }
        
        // Thêm điều kiện lọc theo danh mục nếu có
        if (categoryId != null && categoryId > 0) {
            queryBuilder.append(" AND category_id = ?");
        }
        
        String query = queryBuilder.toString();
        
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            int paramIndex = 1;
            
            // Thiết lập tham số tìm kiếm
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchTerm + "%");
            }
            
            // Thiết lập tham số lọc danh mục
            if (categoryId != null && categoryId > 0) {
                ps.setInt(paramIndex, categoryId);
            }
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return 0;
    }
     /**
     * Lấy danh sách tất cả sản phẩm
     * @return Danh sách sản phẩm
     */
    public List<Product> getAllProducts() throws Exception {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM Products p JOIN Categories c ON p.category_id = c.category_id";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCategoryName(rs.getString("category_name"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Các trường bổ sung
                product.setFeatured(rs.getBoolean("is_featured"));
                product.setFeaturedOrder(rs.getInt("featured_order"));
                product.setFeaturedUntil(rs.getDate("featured_until"));
                
                // Kiểm tra nếu có role_id
                if (rs.getObject("role_id") != null) {
                    product.setRoleid(rs.getInt("role_id"));
                }
                
                products.add(product);
            }
            
        } catch (SQLException e) {
            System.out.println("Error in getAllProducts: " + e.getMessage());
        }
        
        return products;
    }

}

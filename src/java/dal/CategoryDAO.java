package dal;

import context.DBContext;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    private DBContext db;
    
    public CategoryDAO() {
        db = new DBContext();
    }
    
    /**
     * Lấy danh sách tất cả các danh mục (READ)
     * @return Danh sách các danh mục
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM Categories ORDER BY category_name";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                categories.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categories;
    }
    
    /**
     * Lấy danh sách tất cả các danh mục kèm theo số lượng sản phẩm (READ)
     * @return Danh sách các danh mục
     */
    public List<Category> getAllCategoriesWithProductCount() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT c.category_id, c.category_name, COUNT(p.product_id) AS product_count " +
                       "FROM Categories c " +
                       "LEFT JOIN Products p ON c.category_id = p.category_id " +
                       "GROUP BY c.category_id, c.category_name " +
                       "ORDER BY c.category_name";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setProductCount(rs.getInt("product_count"));
                categories.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categories;
    }
    
    /**
     * Lấy thông tin của một danh mục theo ID (READ)
     * @param categoryId ID của danh mục
     * @return Đối tượng Category, hoặc null nếu không tìm thấy
     */
    public Category getCategoryById(int categoryId) {
        String query = "SELECT * FROM Categories WHERE category_id = ?";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    return category;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
    /**
     * Lấy thông tin danh mục theo tên (READ)
     * @param categoryName Tên danh mục
     * @return Đối tượng Category, hoặc null nếu không tìm thấy
     */
    public Category getCategoryByName(String categoryName) {
        String query = "SELECT * FROM Categories WHERE category_name = ?";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    return category;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
    /**
     * Thêm danh mục mới (CREATE)
     * @param categoryName Tên danh mục
     * @return ID của danh mục vừa thêm, hoặc -1 nếu thất bại
     */
    public int addCategory(String categoryName) {
        String query = "INSERT INTO Categories (category_name) VALUES (?)";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, categoryName);
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
     * Thêm danh mục mới từ đối tượng Category (CREATE)
     * @param category Đối tượng Category cần thêm
     * @return ID của danh mục vừa thêm, hoặc -1 nếu thất bại
     */
    public int addCategory(Category category) {
        return addCategory(category.getCategoryName());
    }
    
    /**
     * Cập nhật tên danh mục (UPDATE)
     * @param categoryId ID của danh mục
     * @param categoryName Tên mới của danh mục
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateCategory(int categoryId, String categoryName) {
        String query = "UPDATE Categories SET category_name = ? WHERE category_id = ?";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, categoryName);
            ps.setInt(2, categoryId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật danh mục từ đối tượng Category (UPDATE)
     * @param category Đối tượng Category cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateCategory(Category category) {
        return updateCategory(category.getCategoryId(), category.getCategoryName());
    }
    
    /**
     * Xóa danh mục (DELETE)
     * @param categoryId ID của danh mục cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteCategory(int categoryId) {
        String query = "DELETE FROM Categories WHERE category_id = ?";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xóa danh mục từ đối tượng Category (DELETE)
     * @param category Đối tượng Category cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteCategory(Category category) {
        return deleteCategory(category.getCategoryId());
    }
    
    /**
     * Kiểm tra xem danh mục có sản phẩm nào không
     * @param categoryId ID của danh mục
     * @return true nếu danh mục có sản phẩm, false nếu không
     */
    public boolean hasCategoryProducts(int categoryId) {
        String query = "SELECT COUNT(*) AS count FROM Products WHERE category_id = ?";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    /**
     * Đếm số lượng sản phẩm trong một danh mục
     * @param categoryId ID của danh mục
     * @return Số lượng sản phẩm, hoặc -1 nếu có lỗi
     */
    public int countProductsInCategory(int categoryId) {
        String query = "SELECT COUNT(*) AS count FROM Products WHERE category_id = ?";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }
    
    /**
     * Kiểm tra xem tên danh mục đã tồn tại chưa
     * @param categoryName Tên danh mục cần kiểm tra
     * @return true nếu tên đã tồn tại, false nếu chưa
     */
    public boolean isCategoryNameExists(String categoryName) {
        String query = "SELECT COUNT(*) AS count FROM Categories WHERE category_name = ?";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    /**
     * Kiểm tra xem tên danh mục đã tồn tại chưa (trừ danh mục hiện tại)
     * @param categoryName Tên danh mục cần kiểm tra
     * @param categoryId ID của danh mục hiện tại (để loại trừ)
     * @return true nếu tên đã tồn tại ở danh mục khác, false nếu chưa
     */
    public boolean isCategoryNameExistsExcept(String categoryName, int categoryId) {
        String query = "SELECT COUNT(*) AS count FROM Categories WHERE category_name = ? AND category_id != ?";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, categoryName);
            ps.setInt(2, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    /**
     * Lấy tổng số danh mục trong hệ thống
     * @return Tổng số danh mục
     */
    public int getTotalCategories() {
        String query = "SELECT COUNT(*) AS count FROM Categories";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query); 
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    
    /**
     * Tìm kiếm danh mục theo tên
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách các danh mục phù hợp
     */
    public List<Category> searchCategories(String keyword) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM Categories WHERE category_name LIKE ? ORDER BY category_name";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    categories.add(category);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categories;
    }
    
    /**
     * Lấy danh sách các danh mục phân trang
     * @param pageNumber Số trang
     * @param pageSize Kích thước trang
     * @return Danh sách các danh mục trong trang
     */
    public List<Category> getCategoriesWithPagination(int pageNumber, int pageSize) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM Categories ORDER BY category_name OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            int offset = (pageNumber - 1) * pageSize;
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    categories.add(category);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categories;
    }
    
    /**
     * Lấy danh sách danh mục được sử dụng nhiều nhất (có nhiều sản phẩm nhất)
     * @param limit Số lượng danh mục cần lấy
     * @return Danh sách danh mục
     */
    public List<Category> getMostUsedCategories(int limit) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT c.category_id, c.category_name, COUNT(p.product_id) AS product_count " +
                       "FROM Categories c " +
                       "LEFT JOIN Products p ON c.category_id = p.category_id " +
                       "GROUP BY c.category_id, c.category_name " +
                       "ORDER BY product_count DESC " +
                       "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    category.setProductCount(rs.getInt("product_count"));
                    categories.add(category);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categories;
    }
    
    /**
     * Chuyển tất cả sản phẩm từ một danh mục sang danh mục khác và xóa danh mục cũ
     * @param oldCategoryId ID của danh mục cũ
     * @param newCategoryId ID của danh mục mới
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean moveProductsAndDeleteCategory(int oldCategoryId, int newCategoryId) {
        Connection conn = null;
        try {
            conn = db.getConnection();
            conn.setAutoCommit(false);
            
            // Chuyển sản phẩm sang danh mục mới
            String updateQuery = "UPDATE Products SET category_id = ? WHERE category_id = ?";
            try (PreparedStatement updatePs = conn.prepareStatement(updateQuery)) {
                updatePs.setInt(1, newCategoryId);
                updatePs.setInt(2, oldCategoryId);
                updatePs.executeUpdate();
            }
            
            // Xóa danh mục cũ
            String deleteQuery = "DELETE FROM Categories WHERE category_id = ?";
            try (PreparedStatement deletePs = conn.prepareStatement(deleteQuery)) {
                deletePs.setInt(1, oldCategoryId);
                deletePs.executeUpdate();
            }
            
            conn.commit();
            return true;
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

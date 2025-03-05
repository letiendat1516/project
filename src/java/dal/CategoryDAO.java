package dal;

import context.DBContext;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    /**
     * Lấy danh sách tất cả các danh mục
     * @return Danh sách các danh mục
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM Categories ORDER BY category_name";

        try (Connection conn = new DBContext().getConnection(); 
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
     * Lấy danh sách tất cả các danh mục kèm theo số lượng sản phẩm
     * @return Danh sách các danh mục
     */
    public List<Category> getAllCategoriesWithProductCount() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT c.category_id, c.category_name, COUNT(p.product_id) AS product_count " +
                       "FROM Categories c " +
                       "LEFT JOIN Products p ON c.category_id = p.category_id " +
                       "GROUP BY c.category_id, c.category_name " +
                       "ORDER BY c.category_name";

        try (Connection conn = new DBContext().getConnection(); 
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
     * Lấy thông tin của một danh mục theo ID
     * @param categoryId ID của danh mục
     * @return Đối tượng Category, hoặc null nếu không tìm thấy
     */
    public Category getCategoryById(int categoryId) {
        String query = "SELECT * FROM Categories WHERE category_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                return category;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
    /**
     * Thêm danh mục mới
     * @param categoryName Tên danh mục
     * @return ID của danh mục vừa thêm, hoặc -1 nếu thất bại
     */
    public int addCategory(String categoryName) {
        String query = "INSERT INTO Categories (category_name) VALUES (?)";

        try (Connection conn = new DBContext().getConnection(); 
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
     * Cập nhật tên danh mục
     * @param categoryId ID của danh mục
     * @param categoryName Tên mới của danh mục
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateCategory(int categoryId, String categoryName) {
        String query = "UPDATE Categories SET category_name = ? WHERE category_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
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
     * Xóa danh mục
     * @param categoryId ID của danh mục cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteCategory(int categoryId) {
        String query = "DELETE FROM Categories WHERE category_id = ?";

        try (Connection conn = new DBContext().getConnection(); 
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
     * Kiểm tra xem danh mục có sản phẩm nào không
     * @param categoryId ID của danh mục
     * @return true nếu danh mục có sản phẩm, false nếu không
     */
    public boolean hasCategoryProducts(int categoryId) {
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
     * Kiểm tra xem tên danh mục đã tồn tại chưa
     * @param categoryName Tên danh mục cần kiểm tra
     * @return true nếu tên đã tồn tại, false nếu chưa
     */
    public boolean isCategoryNameExists(String categoryName) {
        String query = "SELECT COUNT(*) AS count FROM Categories WHERE category_name = ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, categoryName);
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
     * Kiểm tra xem tên danh mục đã tồn tại chưa (trừ danh mục hiện tại)
     * @param categoryName Tên danh mục cần kiểm tra
     * @param categoryId ID của danh mục hiện tại (để loại trừ)
     * @return true nếu tên đã tồn tại ở danh mục khác, false nếu chưa
     */
    public boolean isCategoryNameExistsExcept(String categoryName, int categoryId) {
        String query = "SELECT COUNT(*) AS count FROM Categories WHERE category_name = ? AND category_id != ?";

        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, categoryName);
            ps.setInt(2, categoryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}

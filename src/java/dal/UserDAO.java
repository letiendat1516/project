package dal;

import context.DBContext;
import model.User;
import utils.PasswordHash;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class UserDAO {
    private DBContext db;

    public UserDAO() {
        db = new DBContext();
    }

    public boolean isEmailExists(String email) throws Exception {
        try (Connection conn = db.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_CheckEmailExists(?)}")) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    public boolean isPhoneExists(String phone) throws Exception {
        try (Connection conn = db.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_CheckPhoneExists(?)}")) {
            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    public int register(User user) throws Exception {
        try (Connection conn = db.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_RegisterUser(?, ?, ?, ?, ?, ?)}")) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, PasswordHash.hashPassword(user.getPassword())); // Mã hóa mật khẩu
            stmt.setInt(6, 3); // Mặc định role_id = 3 (Customer)

            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt("userId") : -1;
        }
    }

    public User login(String email, String password) throws Exception {
        String sql = "EXEC sp_LoginUser @email=?, @password=?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, PasswordHash.hashPassword(password));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setIsActive(rs.getBoolean("is_active"));
                    // Không set password vì lý do bảo mật
                    return user;
                }
            }
            return null;
        }
    }

    public List<Product> GetAllPproduct() {
        List<Product> list = new ArrayList<>();
        String query = "SELECT TOP 3 * FROM products ORDER BY product_id DESC";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                list.add(new Product(
                    rs.getInt("product_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getInt("category_id"),
                    rs.getString("image_url"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm phương thức để lấy role name từ role_id
    public String getRoleName(int roleId) throws Exception {
        String sql = "SELECT role_name FROM Roles WHERE role_id = ?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roleId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getString("role_name") : null;
            }
        }
    }

    // Thêm phương thức cập nhật thông tin user
    public boolean updateUser(User user) throws Exception {
        String sql = "UPDATE Users SET full_name=?, phone=?, address=? WHERE user_id=?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getEmail());
            stmt.setInt(4, user.getUserId());
            
            return stmt.executeUpdate() > 0;
        }
    }
}

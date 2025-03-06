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

    /**
     * Thêm người dùng mới (CREATE)
     * @param user Đối tượng User cần thêm
     * @return ID của người dùng vừa thêm, -1 nếu thất bại
     */
    public int addUser(User user) throws Exception {
        String sql = "INSERT INTO Users (full_name, email, phone, password, address, role_id, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?) " +
                     "SELECT SCOPE_IDENTITY() AS user_id";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            
            // Mã hóa mật khẩu trước khi lưu vào database
            stmt.setString(4, PasswordHash.hashPassword(user.getPassword()));
            
            stmt.setString(5, user.getAddress());
            stmt.setInt(6, user.getRoleId());
            stmt.setBoolean(7, user.isIsActive());
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
            return -1;
        }
    }

    /**
     * Đăng ký người dùng mới (phương thức cũ)
     */
    public int register(User user) throws Exception {
        try (Connection conn = db.getConnection(); 
             CallableStatement stmt = conn.prepareCall("{CALL sp_RegisterUser(?, ?, ?, ?)}")) {

            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getPassword());
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("userId");
            }
            return -1;
        }
    }

    /**
     * Đăng nhập
     */
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

    /**
     * Lấy tên vai trò từ role_id
     */
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

    /**
     * Cập nhật thông tin người dùng (UPDATE)
     * @param user Đối tượng User cần cập nhật
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateUser(User user) throws Exception {
        String sql = "UPDATE Users SET full_name=?, phone=?, address=?, email=?, role_id=?, is_active=? WHERE user_id=?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getAddress());
            stmt.setString(4, user.getEmail());
            stmt.setInt(5, user.getRoleId());
            stmt.setBoolean(6, user.isIsActive());
            stmt.setInt(7, user.getUserId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Cập nhật mật khẩu người dùng
     * @param userId ID người dùng
     * @param newPassword Mật khẩu mới
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updatePassword(int userId, String newPassword) throws Exception {
        String sql = "UPDATE Users SET password=? WHERE user_id=?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, PasswordHash.hashPassword(newPassword));
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Xóa người dùng (DELETE)
     * @param userId ID người dùng cần xóa
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteUser(int userId) throws Exception {
        String sql = "DELETE FROM Users WHERE user_id=?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Vô hiệu hóa tài khoản người dùng (Soft delete)
     * @param userId ID người dùng cần vô hiệu hóa
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deactivateUser(int userId) throws Exception {
        String sql = "UPDATE Users SET is_active=0 WHERE user_id=?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Kích hoạt lại tài khoản người dùng
     * @param userId ID người dùng cần kích hoạt
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean activateUser(int userId) throws Exception {
        String sql = "UPDATE Users SET is_active=1 WHERE user_id=?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Lấy tổng số người dùng trong hệ thống (READ)
     * @return Tổng số người dùng
     */
    public int getTotalUsers() throws Exception {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Users";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.out.println("Error in getTotalUsers: " + e.getMessage());
        }
        
        return count;
    }
    
    /**
     * Lấy danh sách tất cả người dùng (READ)
     * @return Danh sách người dùng
     */
    public List<User> getAllUsers() throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM Users u LEFT JOIN Roles r ON u.role_id = r.role_id";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("Executing SQL: " + sql);
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                
                // Xử lý address nếu có
                String address = rs.getString("address");
                if (!rs.wasNull()) {
                    user.setAddress(address);
                }
                
                // Xử lý role_id có thể null
                int roleId = rs.getInt("role_id");
                if (!rs.wasNull()) {
                    user.setRoleId(roleId);
                }
                
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setIsActive(rs.getBoolean("is_active"));
                
                users.add(user);
            }
            
            System.out.println("Found " + users.size() + " users");
            
        } catch (SQLException e) {
            System.out.println("Error in getAllUsers: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Lỗi khi lấy danh sách người dùng: " + e.getMessage());
        }
        
        return users;
    }

    /**
     * Lấy thông tin người dùng theo ID (READ)
     * @param userId ID người dùng cần lấy thông tin
     * @return Đối tượng User, null nếu không tìm thấy
     */
    public User getUserById(int userId) throws Exception {
        String sql = "SELECT u.*, r.role_name FROM Users u LEFT JOIN Roles r ON u.role_id = r.role_id WHERE u.user_id = ?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    
                    // Xử lý address nếu có
                    String address = rs.getString("address");
                    if (!rs.wasNull()) {
                        user.setAddress(address);
                    }
                    
                    // Xử lý role_id có thể null
                    int roleId = rs.getInt("role_id");
                    if (!rs.wasNull()) {
                        user.setRoleId(roleId);
                    }
                    
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setIsActive(rs.getBoolean("is_active"));
                    // Không lấy mật khẩu vì lý do bảo mật
                    
                    return user;
                }
            }
            return null;
        }
    }
    
    /**
     * Lấy thông tin người dùng theo email (READ)
     * @param email Email cần tìm
     * @return Đối tượng User, null nếu không tìm thấy
     */
    public User getUserByEmail(String email) throws Exception {
        String sql = "SELECT u.*, r.role_name FROM Users u LEFT JOIN Roles r ON u.role_id = r.role_id WHERE u.email = ?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    
                    // Xử lý address nếu có
                    String address = rs.getString("address");
                    if (!rs.wasNull()) {
                        user.setAddress(address);
                    }
                    
                    // Xử lý role_id có thể null
                    int roleId = rs.getInt("role_id");
                    if (!rs.wasNull()) {
                        user.setRoleId(roleId);
                    }
                    
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setIsActive(rs.getBoolean("is_active"));
                    // Không lấy mật khẩu vì lý do bảo mật
                    
                    return user;
                }
            }
            return null;
        }
    }
    
    /**
     * Tìm kiếm người dùng theo tên hoặc email (READ)
     * @param keyword Từ khóa tìm kiếm
     * @return Danh sách người dùng phù hợp
     */
    public List<User> searchUsers(String keyword) throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM Users u LEFT JOIN Roles r ON u.role_id = r.role_id " +
                     "WHERE u.full_name LIKE ? OR u.email LIKE ?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    
                    // Xử lý address nếu có
                    String address = rs.getString("address");
                    if (!rs.wasNull()) {
                        user.setAddress(address);
                    }
                    
                    // Xử lý role_id có thể null
                    int roleId = rs.getInt("role_id");
                    if (!rs.wasNull()) {
                        user.setRoleId(roleId);
                    }
                    
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setIsActive(rs.getBoolean("is_active"));
                    
                    users.add(user);
                }
            }
            
            return users;
        }
    }
}
package dal;

import context.DBContext;
import model.User;
import utils.PasswordHash;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class UserDAO {

    private DBContext db;

    public UserDAO() {
        db = new DBContext(); // Khởi tạo DBContext trong constructor
    }

    public boolean isEmailExists(String email) throws Exception {
        try (Connection conn = db.getConnection(); // Sử dụng instance db để gọi getConnection
                 CallableStatement stmt = conn.prepareCall("{CALL sp_CheckEmailExists(?)}")) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public boolean isPhoneExists(String phone) throws Exception {
        try (Connection conn = db.getConnection(); CallableStatement stmt = conn.prepareCall("{CALL sp_CheckPhoneExists(?)}")) {

            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    public int register(User user) throws Exception {
        try (Connection conn = db.getConnection(); CallableStatement stmt = conn.prepareCall("{CALL sp_RegisterUser(?, ?, ?, ?)}")) {

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

    public User login(String email, String password) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = db.getConnection();
            System.out.println("Connected to database successfully");

            String sql = "SELECT * FROM Users WHERE email = ? AND password = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, PasswordHash.hashPassword(password));

            System.out.println("Executing query for email: " + email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                // Map data từ ResultSet vào user object
                System.out.println("User found: " + rs.getString("email"));
                return user;
            }

            System.out.println("No user found with provided credentials");
            return null;

        } catch (Exception e) {
            System.out.println("Error in login method: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            // Close resources
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    public List<Product> GetAllPproduct() {
        List<Product> list = new ArrayList<>();
        String query = "SELECT TOP 3 *\n"
                + "FROM products\n"
                + "ORDER BY product_id DESC;";
        try {
            conn = new DBContext().getConnection();
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("product_id"), // id từ database
                        rs.getString("name"), // tên sản phẩm
                        rs.getString("description"), // mô tả sản phẩm
                        rs.getDouble("price"), // giá
                        rs.getInt("stock_quantity"), // số lượng tồn kho
                        rs.getInt("category_id"), // id danh mục
                        rs.getString("image_url"), // đường dẫn ảnh
                        rs.getTimestamp("created_at") // thời gian tạo
                ));

            }
        } catch (Exception e) {
        }

        return list;

    }

}

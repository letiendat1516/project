package dal;

import context.DBContext;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;

public class OrderDAO {
    
    // Lấy tất cả đơn hàng
    public List<Order> getAllOrders() throws Exception {
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM Orders ORDER BY created_at DESC")) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalPrice(rs.getBigDecimal("total_price"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDiscountId(rs.getInt("discount_id"));
                if (rs.wasNull()) {
                    order.setDiscountId(null);
                }
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // Lấy đơn hàng theo ID
    public Order getOrderById(int orderId) throws Exception {
        Order order = null;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM Orders WHERE order_id = ?")) {
            
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalPrice(rs.getBigDecimal("total_price"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDiscountId(rs.getInt("discount_id"));
                if (rs.wasNull()) {
                    order.setDiscountId(null);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return order;
    }
    
    // Lấy chi tiết đơn hàng theo order_id
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) throws Exception {
        List<OrderDetail> orderDetails = new ArrayList<>();
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT od.*, p.name as product_name, p.image_url as product_image " +
                "FROM OrderDetails od " +
                "JOIN Products p ON od.product_id = p.product_id " +
                "WHERE od.order_id = ?")) {
            
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailId(rs.getInt("order_detail_id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setProductId(rs.getInt("product_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setUnitPrice(rs.getBigDecimal("unit_price"));
                detail.setProductName(rs.getString("product_name"));
                detail.setProductImage(rs.getString("product_image"));
                
                orderDetails.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orderDetails;
    }
    
    // Cập nhật trạng thái đơn hàng
    public boolean updateOrderStatus(int orderId, String status) throws Exception {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE Orders SET status = ? WHERE order_id = ?")) {
            
            ps.setString(1, status);
            ps.setInt(2, orderId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy trạng thái đơn hàng
    public String getOrderStatus(int orderId) throws Exception {
        String status = null;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT status FROM Orders WHERE order_id = ?")) {
            
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                status = rs.getString("status");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return status;
    }
    
    // Lấy đơn hàng theo user_id
    public List<Order> getOrdersByUserId(int userId) throws Exception {
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM Orders WHERE user_id = ? ORDER BY created_at DESC")) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalPrice(rs.getBigDecimal("total_price"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDiscountId(rs.getInt("discount_id"));
                if (rs.wasNull()) {
                    order.setDiscountId(null);
                }
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // Lấy tổng doanh thu
    public BigDecimal getTotalRevenue() throws Exception {
        BigDecimal totalRevenue = BigDecimal.ZERO;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT SUM(total_price) as total_revenue FROM Orders WHERE status IN ('Delivered', 'Shipped')")) {
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                totalRevenue = rs.getBigDecimal("total_revenue");
                if (totalRevenue == null) {
                    totalRevenue = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return totalRevenue;
    }
    
    // Lấy số lượng đơn hàng mới (Pending)
    public int getNewOrdersCount() throws Exception {
        int count = 0;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) as count FROM Orders WHERE status = 'Pending'")) {
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // Lấy danh sách đơn hàng gần đây
    public List<Order> getRecentOrders(int limit) throws Exception {
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT TOP (?) * FROM Orders ORDER BY created_at DESC")) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalPrice(rs.getBigDecimal("total_price"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDiscountId(rs.getInt("discount_id"));
                if (rs.wasNull()) {
                    order.setDiscountId(null);
                }
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
     /**
     * Tạo đơn hàng mới và trả về ID của đơn hàng vừa tạo
     * @param order Đối tượng Order cần lưu vào database
     * @return ID của đơn hàng vừa tạo, hoặc -1 nếu có lỗi
     */
    public int createOrder(Order order) throws Exception, Exception, Exception, Exception {
        int orderId = -1;
        String sql = "INSERT INTO orders (user_id, total_price, status, created_at, discount_id) "
                + "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = new DBContext().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Kiểm tra nếu có user_id
            if (order.getUserId() > 0) {
                ps.setInt(1, order.getUserId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            
            // Thiết lập các giá trị khác
            ps.setBigDecimal(2, order.getTotalPrice());
            ps.setString(3, order.getStatus());
            ps.setTimestamp(4, (Timestamp) order.getCreatedAt());
            
            // Kiểm tra nếu có discount_id
            if (order.getDiscountId() > 0) {
                ps.setInt(5, order.getDiscountId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                // Lấy ID của đơn hàng vừa tạo
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
                rs.close();
            }
            
        } catch (SQLException e) {
            System.out.println("Error in createOrder: " + e.getMessage());
        }
        
        return orderId;
    }
   
}

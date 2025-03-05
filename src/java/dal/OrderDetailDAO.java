package dal;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.OrderDetail;
import model.Product;

public class OrderDetailDAO {

    /**
     * Tạo chi tiết đơn hàng mới
     *
     * @param detail Chi tiết đơn hàng cần tạo
     * @return true nếu tạo thành công, false nếu thất bại
     */
    public boolean createOrderDetail(OrderDetail detail) {
        String sql = "INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detail.getOrderId());
            ps.setInt(2, detail.getProductId());
            ps.setInt(3, detail.getQuantity());
            ps.setBigDecimal(4, detail.getUnitPrice());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy tất cả chi tiết của một đơn hàng
     *
     * @param orderId ID của đơn hàng
     * @return Danh sách chi tiết đơn hàng
     */
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.*, p.name as product_name, p.image_url "
                + "FROM OrderDetails od "
                + "JOIN Products p ON od.product_id = p.product_id "
                + "WHERE od.order_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailId(rs.getInt("order_detail_id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setProductId(rs.getInt("product_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setUnitPrice(rs.getBigDecimal("unit_price"));

                // Thêm thông tin sản phẩm (nếu cần)
                detail.setProductName(rs.getString("product_name"));
                detail.setProductImage(rs.getString("image_url"));

                details.add(detail);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return details;
    }

    /**
     * Cập nhật chi tiết đơn hàng
     *
     * @param detail Chi tiết đơn hàng cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateOrderDetail(OrderDetail detail) {
        String sql = "UPDATE OrderDetails SET quantity = ?, unit_price = ? "
                + "WHERE order_detail_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detail.getQuantity());
            ps.setBigDecimal(2, detail.getUnitPrice());
            ps.setInt(3, detail.getOrderDetailId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa chi tiết đơn hàng
     *
     * @param orderDetailId ID của chi tiết đơn hàng cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteOrderDetail(int orderDetailId) {
        String sql = "DELETE FROM OrderDetails WHERE order_detail_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderDetailId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa tất cả chi tiết của một đơn hàng
     *
     * @param orderId ID của đơn hàng
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteOrderDetailsByOrderId(int orderId) {
        String sql = "DELETE FROM OrderDetails WHERE order_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách sản phẩm bán chạy nhất
     *
     * @param limit Số lượng sản phẩm cần lấy
     * @return Danh sách sản phẩm bán chạy
     */
    public List<Product> getBestSellingProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, SUM(od.quantity) as total_sold "
                + "FROM OrderDetails od "
                + "JOIN Products p ON od.product_id = p.product_id "
                + "JOIN Orders o ON od.order_id = o.order_id "
                + "WHERE o.status IN ('Delivered', 'Shipped') "
                + "GROUP BY p.product_id, p.name, p.description, p.price, p.image_url, "
                + "p.stock_quantity, p.category_id, p.is_featured "
                + "ORDER BY total_sold DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setImageUrl(rs.getString("image_url"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setFeatured(rs.getBoolean("is_featured"));

                // Thêm số lượng đã bán
                product.setSoldQuantity(rs.getInt("total_sold"));

                products.add(product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    /**
     * Lấy doanh thu theo sản phẩm
     *
     * @return Map với key là ID sản phẩm và value là doanh thu
     */
    public Map<Integer, Double> getRevenueByProduct() throws Exception {
        Map<Integer, Double> revenueMap = new HashMap<>();
        String sql = "SELECT od.product_id, SUM(od.quantity * od.unit_price) as revenue "
                + "FROM OrderDetails od "
                + "JOIN Orders o ON od.order_id = o.order_id "
                + "WHERE o.status IN ('Delivered', 'Shipped') "
                + "GROUP BY od.product_id";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int productId = rs.getInt("product_id");
                double revenue = rs.getDouble("revenue");
                revenueMap.put(productId, revenue);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return revenueMap;
    }

    /**
     * Lấy doanh thu theo danh mục sản phẩm
     *
     * @return Map với key là ID danh mục và value là doanh thu
     */
    public Map<Integer, Double> getRevenueByCategory() throws Exception {
        Map<Integer, Double> revenueMap = new HashMap<>();
        String sql = "SELECT p.category_id, SUM(od.quantity * od.unit_price) as revenue "
                + "FROM OrderDetails od "
                + "JOIN Products p ON od.product_id = p.product_id "
                + "JOIN Orders o ON od.order_id = o.order_id "
                + "WHERE o.status IN ('Delivered', 'Shipped') "
                + "GROUP BY p.category_id";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int categoryId = rs.getInt("category_id");
                double revenue = rs.getDouble("revenue");
                revenueMap.put(categoryId, revenue);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return revenueMap;
    }
}

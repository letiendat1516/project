package controller;

import context.DBContext;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.Product;
import model.User;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final DBContext dbContext = new DBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Kiểm tra quyền admin (role_id = 1)
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRoleId() != 1) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Lấy thống kê tổng quan
            getTotalStatistics(request);

            // Lấy đơn hàng gần đây
            getRecentOrders(request);

            // Lấy sản phẩm sắp hết hàng
            getLowStockProducts(request);

            // Lấy dữ liệu biểu đồ doanh thu
            getChartData(request);

            request.getRequestDispatcher("/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }

    private void getTotalStatistics(HttpServletRequest request) throws Exception {
        try (Connection conn = dbContext.getConnection()) {
            // Tổng doanh thu
            String revenueSql = "SELECT ISNULL(SUM(total_price), 0) FROM Orders WHERE status != 'Cancelled'";
            try (PreparedStatement stmt = conn.prepareStatement(revenueSql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("totalRevenue", rs.getDouble(1));
                }
            }

            // Số đơn hàng mới (Pending)
            String newOrdersSql = "SELECT COUNT(*) FROM Orders WHERE status = 'Pending'";
            try (PreparedStatement stmt = conn.prepareStatement(newOrdersSql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("newOrdersCount", rs.getInt(1));
                }
            }

            // Tổng số sản phẩm
            String productsSql = "SELECT COUNT(*) FROM Products";
            try (PreparedStatement stmt = conn.prepareStatement(productsSql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("totalProducts", rs.getInt(1));
                }
            }

            // Tổng số khách hàng (role_id = 3)
            String customersSql = "SELECT COUNT(*) FROM Users WHERE role_id = 3";
            try (PreparedStatement stmt = conn.prepareStatement(customersSql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("totalCustomers", rs.getInt(1));
                }
            }
        }
    }

    private void getRecentOrders(HttpServletRequest request) throws Exception {
        try (Connection conn = dbContext.getConnection()) {
            String sql = "SELECT TOP 10 o.order_id, u.full_name, o.total_price, o.status, o.created_at "
                    + "FROM Orders o "
                    + "JOIN Users u ON o.user_id = u.user_id "
                    + "ORDER BY o.created_at DESC";

            List<Order> recentOrders = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));        // Thay đổi từ setOrder_id
                    order.setUserName(rs.getString("full_name"));   // Thay đổi từ setUser_name
                    order.setTotalPrice(rs.getDouble("total_price")); // Thay đổi từ setTotal_price
                    order.setStatus(rs.getString("status"));
                    order.setCreatedAt(rs.getTimestamp("created_at")); // Thay đổi từ setCreated_at
                    recentOrders.add(order);
                }
            }
            request.setAttribute("recentOrders", recentOrders);
        }
    }

    private void getLowStockProducts(HttpServletRequest request) throws Exception {
        try (Connection conn = dbContext.getConnection()) {
            String sql = "SELECT name, stock_quantity "
                    + "FROM Products "
                    + "WHERE stock_quantity <= 10 "
                    + "ORDER BY stock_quantity ASC";

            List<Product> lowStockProducts = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Product product = new Product();
                    product.setName(rs.getString("name"));
                    product.setStockQuantity(rs.getInt("stock_quantity")); // Sử dụng setStockQuantity thay vì setStock_quantity
                    lowStockProducts.add(product);
                }
            }
            request.setAttribute("lowStockProducts", lowStockProducts);
        }
    }

    private void getChartData(HttpServletRequest request) throws Exception {
        try (Connection conn = dbContext.getConnection()) {
            String sql = "SELECT CONVERT(date, created_at) as order_date, "
                    + "       ISNULL(SUM(total_price), 0) as daily_revenue "
                    + "FROM Orders "
                    + "WHERE created_at >= DATEADD(day, -7, GETDATE()) "
                    + "GROUP BY CONVERT(date, created_at) "
                    + "ORDER BY order_date";

            List<String> labels = new ArrayList<>();
            List<Double> data = new ArrayList<>();

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    labels.add(String.format("'%s'",
                            new SimpleDateFormat("dd/MM").format(rs.getDate("order_date"))));
                    data.add(rs.getDouble("daily_revenue"));
                }
            }

            request.setAttribute("chartLabels", String.join(",", labels));
            request.setAttribute("chartData", data.toString());
        }
    }
}

package controller;

import dal.CategoryDAO;
import dal.OrderDAO;
import dal.ProductDAO;
import dal.UserDAO;
import model.Order;
import model.Product;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin", "/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String page = request.getParameter("page");
        if (page == null) {
            page = "dashboard";
        }

        try {
            switch (page) {
                case "dashboard":
                    showDashboard(request, response);
                    break;
                case "products":
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                    break;
                case "orders":
                    response.sendRedirect(request.getContextPath() + "/admin/orders");
                    break;
                case "users":
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    break;
                case "categories":
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (Exception ex) {
            Logger.getLogger(AdminDashboardServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Lỗi khi tải trang: " + ex.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        UserDAO userDAO = new UserDAO();

        // Lấy dữ liệu thống kê
        BigDecimal totalRevenue = orderDAO.getTotalRevenue();
        int newOrdersCount = orderDAO.getNewOrdersCount();
        int totalProducts = productDAO.getTotalProducts();
        int totalUsers = userDAO.getTotalUsers();

        // Lấy danh sách đơn hàng gần đây
        List<Order> recentOrders = orderDAO.getRecentOrders(10);

        // Lấy danh sách sản phẩm sắp hết hàng
        List<Product> lowStockProducts = productDAO.getLowStockProducts(10);

        // Đặt các thuộc tính vào request
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("newOrdersCount", newOrdersCount);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("contextPath", request.getContextPath());

        // Chuyển hướng đến trang dashboard
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}

package controller;

import dal.ProductDAO;
import model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ProductDAO productDAO = new ProductDAO();
        
        // Lấy danh sách sản phẩm nổi bật
        List<Product> featuredProducts = productDAO.getFeaturedProducts();
        request.setAttribute("featuredProducts", featuredProducts);
        
        // Nếu không có sản phẩm nổi bật hoặc số lượng ít, bổ sung bằng sản phẩm mới nhất
        if (featuredProducts == null || featuredProducts.size() < 6) {
            // Lấy sản phẩm mới nhất để hiển thị (nếu cần)
            List<Product> newestProducts = productDAO.getNewestProducts(6 - (featuredProducts != null ? featuredProducts.size() : 0));
            request.setAttribute("newestProducts", newestProducts);
        }
        
        // Chuyển hướng đến trang index.jsp
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

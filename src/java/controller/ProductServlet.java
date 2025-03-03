package controller;

import dal.ProductDAO;
import model.Product;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Comparator;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO productDAO = new ProductDAO();

        // Lấy tham số phân trang (nếu có)
        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Giữ page = 1 nếu có lỗi
            }
        }

        // Lấy tham số lọc theo danh mục (nếu có)
        String categoryIdStr = request.getParameter("category");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                // Bỏ qua nếu có lỗi
            }
        }

        // Lấy tham số lọc theo role (nếu có)
        String roleIdStr = request.getParameter("role");
        Integer roleId = null;
        if (roleIdStr != null && !roleIdStr.isEmpty()) {
            try {
                roleId = Integer.parseInt(roleIdStr);
            } catch (NumberFormatException e) {
                // Bỏ qua nếu có lỗi
            }
        }

        // Lấy tham số sắp xếp (nếu có)
        String sortBy = request.getParameter("sort");

        // Số sản phẩm trên mỗi trang
        final int PRODUCTS_PER_PAGE = 12;

        // Lấy tổng số sản phẩm (để tính số trang)
        int totalProducts;

        // Lấy danh sách sản phẩm theo điều kiện lọc
        List<Product> products;

        if (roleId != null) {
            // Lọc theo role VÀ sắp xếp (thay đổi ở đây)
            products = productDAO.getProductsByRoleAndSort(roleId, sortBy);
            totalProducts = products.size();

            // Phân trang thủ công
            int startIndex = (page - 1) * PRODUCTS_PER_PAGE;
            int endIndex = Math.min(startIndex + PRODUCTS_PER_PAGE, totalProducts);

            if (startIndex < totalProducts) {
                products = products.subList(startIndex, endIndex);
            } else {
                products = List.of(); // Trả về danh sách rỗng nếu trang không hợp lệ
            }
        } else if (categoryId != null) {
            // Lọc theo danh mục
            products = productDAO.getProductsByCategory(categoryId);
            totalProducts = products.size();

            // Áp dụng sắp xếp thủ công nếu cần (thêm mới)
            if (sortBy != null) {
                switch (sortBy) {
                    case "price_asc":
                        products.sort(Comparator.comparing(Product::getPrice));
                        break;
                    case "price_desc":
                        products.sort(Comparator.comparing(Product::getPrice).reversed());
                        break;
                    case "name_asc":
                        products.sort(Comparator.comparing(Product::getName));
                        break;
                    case "newest":
                        products.sort(Comparator.comparing(Product::getCreatedAt).reversed());
                        break;
                    default:
                        // Không sắp xếp
                        break;
                }
            }

            // Phân trang thủ công
            int startIndex = (page - 1) * PRODUCTS_PER_PAGE;
            int endIndex = Math.min(startIndex + PRODUCTS_PER_PAGE, totalProducts);

            if (startIndex < totalProducts) {
                products = products.subList(startIndex, endIndex);
            } else {
                products = List.of(); // Trả về danh sách rỗng nếu trang không hợp lệ
            }
        } else {
            // Lấy tất cả sản phẩm
            products = productDAO.getAllProductsWithPagination(page, PRODUCTS_PER_PAGE, sortBy);
            totalProducts = productDAO.getTotalProducts();
        }

        // Tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);

        // Lấy danh sách sản phẩm nổi bật để hiển thị ở đầu trang (nếu cần)
        List<Product> featuredProducts = productDAO.getFeaturedProducts();

        // Tạo map chứa các role
        Map<Integer, String> roles = new HashMap<>();
        roles.put(1, "Mô hình");
        roles.put(2, "Túi mù");
        roles.put(3, "Lego");

        // Đặt các thuộc tính vào request
        request.setAttribute("products", products);
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("roleId", roleId);
        request.setAttribute("roles", roles);
        request.setAttribute("sortBy", sortBy);

        // Chuyển hướng đến trang product.jsp
        request.getRequestDispatcher("product.jsp").forward(request, response);
    }
}

package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import model.Category;
import model.Product;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import controller.ProductServlet;

@WebServlet(name = "AdminProductServlet", urlPatterns = {
    "/admin/products",
    "/admin/add-product",
    "/admin/update-product",
    "/admin/delete-product",
    "/admin/get-product",
    "/admin/toggle-featured",
    "/admin/get-product-stock",
    "/admin/update-stock"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ProductAdminServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "uploads/products";
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
    private static final Logger LOGGER = Logger.getLogger(ProductServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        LOGGER.info("GET request received: " + path);

        try {
            switch (path) {
                case "/admin/products":
                    showProducts(request, response);
                    break;
                case "/admin/get-product":
                    getProduct(request, response);
                    break;
                case "/admin/get-product-stock":
                    getProductStock(request, response);
                    break;
                default:
                    LOGGER.warning("Invalid GET path: " + path);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing GET request", e);
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        LOGGER.info("POST request received: " + path);

        try {
            switch (path) {
                case "/admin/add-product":
                    addProduct(request, response);
                    break;
                case "/admin/update-product":
                    updateProduct(request, response);
                    break;
                case "/admin/delete-product":
                    deleteProduct(request, response);
                    break;
                case "/admin/toggle-featured":
                    toggleFeatured(request, response);
                    break;
                case "/admin/update-stock":
                    updateStock(request, response);
                    break;
                default:
                    LOGGER.warning("Invalid POST path: " + path);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing POST request", e);
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    private void showProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Lấy danh sách tất cả sản phẩm
        List<Product> products = productDAO.getAllProducts();

        // Lấy danh sách tất cả danh mục
        List<Category> categories = categoryDAO.getAllCategoriesWithProductCount();

        // Đặt các thuộc tính vào request
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("contextPath", request.getContextPath());

        // Chuyển hướng đến trang products
        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy thông tin sản phẩm từ form
            String productName = request.getParameter("productName");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String description = request.getParameter("description");
            boolean featured = request.getParameter("featured") != null;

            // Xử lý file ảnh
            String imageUrl = "resources/no-image.png"; // Ảnh mặc định
            Part filePart = request.getPart("imageFile");

            if (filePart != null && filePart.getSize() > 0) {
                // Tạo thư mục uploads nếu chưa tồn tại
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Tạo tên file duy nhất
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);

                // Lưu file
                filePart.write(uploadPath + File.separator + fileName);

                // Cập nhật đường dẫn ảnh
                imageUrl = UPLOAD_DIRECTORY + "/" + fileName;
            }

            // Tạo đối tượng Product
            Product product = new Product();
            product.setName(productName);
            product.setCategoryId(categoryId);
            product.setPrice(price);
            product.setStockQuantity(stockQuantity);
            product.setDescription(description);
            product.setImageUrl(imageUrl);
            product.setFeatured(featured);

            // Lưu sản phẩm vào database
            ProductDAO productDAO = new ProductDAO();
            productDAO.addProduct(product);

            // Thêm thông báo thành công
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Thêm sản phẩm thành công!");

            // Chuyển hướng về trang sản phẩm
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding product", e);
            request.setAttribute("errorMessage", "Lỗi khi thêm sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin sản phẩm từ form
            int productId = Integer.parseInt(request.getParameter("productId"));
            String productName = request.getParameter("productName");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String description = request.getParameter("description");
            boolean featured = request.getParameter("featured") != null;
            String currentImageUrl = request.getParameter("currentImageUrl");

            // Xử lý file ảnh mới nếu có
            String imageUrl = currentImageUrl;
            Part filePart = request.getPart("imageFile");

            if (filePart != null && filePart.getSize() > 0) {
                // Tạo thư mục uploads nếu chưa tồn tại
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Tạo tên file duy nhất
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);

                // Lưu file
                filePart.write(uploadPath + File.separator + fileName);

                // Cập nhật đường dẫn ảnh
                imageUrl = UPLOAD_DIRECTORY + "/" + fileName;

                // Xóa ảnh cũ nếu không phải ảnh mặc định
                if (currentImageUrl != null && !currentImageUrl.equals("resources/no-image.png")) {
                    try {
                        Path oldImagePath = Paths.get(getServletContext().getRealPath("") + File.separator + currentImageUrl);
                        Files.deleteIfExists(oldImagePath);
                    } catch (Exception e) {
                        // Bỏ qua lỗi khi xóa file
                        LOGGER.log(Level.WARNING, "Could not delete old image", e);
                    }
                }
            }

            // Tạo đối tượng Product
            Product product = new Product();
            product.setProductId(productId);
            product.setName(productName);
            product.setCategoryId(categoryId);
            product.setPrice(price);
            product.setStockQuantity(stockQuantity);
            product.setDescription(description);
            product.setImageUrl(imageUrl);
            product.setFeatured(featured);

            // Cập nhật sản phẩm trong database
            ProductDAO productDAO = new ProductDAO();
            productDAO.updateProduct(product);

            // Thêm thông báo thành công
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");

            // Chuyển hướng về trang sản phẩm
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating product", e);
            request.setAttribute("errorMessage", "Lỗi khi cập nhật sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            LOGGER.info("Deleting product...");
            
            // Kiểm tra cả hai tham số có thể được sử dụng
            String productIdParam = request.getParameter("productId");
            if (productIdParam == null || productIdParam.isEmpty()) {
                productIdParam = request.getParameter("id");
            }
            
            LOGGER.info("Product ID parameter: " + productIdParam);
            
            if (productIdParam == null || productIdParam.isEmpty()) {
                throw new IllegalArgumentException("Product ID is required");
            }
            
            int productId = Integer.parseInt(productIdParam);
            LOGGER.info("Parsed product ID: " + productId);

            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);

            if (product != null) {
                // Xóa file ảnh nếu không phải ảnh mặc định
                if (product.getImageUrl() != null && !product.getImageUrl().equals("resources/no-image.png")) {
                    try {
                        Path imagePath = Paths.get(getServletContext().getRealPath("") 
                                + File.separator + product.getImageUrl());
                        Files.deleteIfExists(imagePath);
                        LOGGER.info("Deleted product image: " + imagePath);
                    } catch (Exception e) {
                        LOGGER.log(Level.WARNING, "Could not delete product image", e);
                    }
                }
                
                // Xóa sản phẩm từ database
                boolean success = productDAO.deleteProduct(productId);
                
                HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("successMessage", "Xóa sản phẩm thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể xóa sản phẩm. Vui lòng thử lại!");
                }
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Không tìm thấy sản phẩm để xóa!");
            }
            
            // Chuyển hướng về trang sản phẩm
            response.sendRedirect(request.getContextPath() + "/admin/products");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting product", e);
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi khi xóa sản phẩm: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private void getProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));

            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);

            if (product != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(product));
                out.flush();
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Không tìm thấy sản phẩm với ID: " + productId);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting product", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }

    private void toggleFeatured(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            boolean featured = Boolean.parseBoolean(request.getParameter("featured"));

            ProductDAO productDAO = new ProductDAO();
            productDAO.updateFeaturedStatus(productId, featured);

            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error toggling featured status", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }

    private void getProductStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));

            ProductDAO productDAO = new ProductDAO();
            int stockQuantity = productDAO.getProductStockById(productId);

            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(stockQuantity);
            out.flush();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting product stock", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }

    private void updateStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));

            ProductDAO productDAO = new ProductDAO();
            productDAO.updateProductStock(productId, stockQuantity);

            // Thêm thông báo thành công
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Cập nhật tồn kho thành công!");
            
            // Chuyển hướng về trang sản phẩm
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating stock", e);
            request.setAttribute("errorMessage", "Lỗi khi cập nhật tồn kho: " + e.getMessage());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    // Hàm hỗ trợ lấy tên file từ Part
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    // Thêm phương thức service để ghi log
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        LOGGER.info("Request method: " + request.getMethod());
        LOGGER.info("Request URI: " + request.getRequestURI());
        LOGGER.info("Servlet path: " + request.getServletPath());
        super.service(request, response);
    }
}

package controller;

import dal.CategoryDAO;
import dal.OrderDAO;
import dal.ProductDAO;
import dal.UserDAO;
import model.Category;
import model.Order;
import model.OrderDetail;
import model.Product;
import model.User;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin", "/admin/add-product", "/admin/update-product",
    "/admin/delete-product", "/admin/get-product", "/admin/toggle-featured",
    "/admin/add-category", "/admin/update-category", "/admin/delete-category",
    "/admin/get-order", "/admin/update-order-status", "/admin/get-order-status",
    "/admin/add-user", "/admin/update-user", "/admin/get-user",
    "/admin/get-product-stock", "/admin/update-stock"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AdminServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "uploads/products";
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // Không cần kiểm tra quyền admin ở đây nữa vì đã có AdminFilter
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
            case "/admin/add-category":
                addCategory(request, response);
                break;
            case "/admin/update-category":
                updateCategory(request, response);
                break;
            case "/admin/delete-category":
                deleteCategory(request, response);
                break;
            case "/admin/update-order-status":
                updateOrderStatus(request, response);
                break;
            case "/admin/update-user":
                updateUser(request, response);
                break;
            case "/admin/update-stock":
                updateStock(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // Không cần kiểm tra quyền admin ở đây nữa vì đã có AdminFilter
        switch (path) {
            case "/admin": {
                try {
                    showDashboard(request, response);
                } catch (Exception ex) {
                    Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, null, ex);
                    request.setAttribute("errorMessage", "Lỗi khi tải trang Dashboard: " + ex.getMessage());
                    request.getRequestDispatcher("/admin.jsp").forward(request, response);
                }
            }
            break;

            case "/admin/get-product":
                getProduct(request, response);
                break;
            case "/admin/get-order":
                getOrder(request, response);
                break;
            case "/admin/get-order-status":
                getOrderStatus(request, response);
                break;
            case "/admin/get-user":
                getUser(request, response);
                break;
            case "/admin/get-product-stock":
                getProductStock(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        UserDAO userDAO = new UserDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Lấy dữ liệu thống kê
        BigDecimal totalRevenue = orderDAO.getTotalRevenue();
        int newOrdersCount = orderDAO.getNewOrdersCount();
        int totalProducts = productDAO.getTotalProducts();
        int totalUsers = userDAO.getTotalUsers();

        // Lấy danh sách đơn hàng gần đây
        List<Order> recentOrders = orderDAO.getRecentOrders(10);

        // Lấy danh sách sản phẩm sắp hết hàng
        List<Product> lowStockProducts = productDAO.getLowStockProducts(10);

        // Lấy danh sách tất cả sản phẩm
        List<Product> products = productDAO.getAllProducts();

        // Lấy danh sách tất cả đơn hàng
        List<Order> orders = orderDAO.getAllOrders();

        // Lấy danh sách tất cả người dùng
        List<User> users = userDAO.getAllUsers();

        // Lấy danh sách tất cả danh mục
        List<Category> categories = categoryDAO.getAllCategoriesWithProductCount();

        // Đặt các thuộc tính vào request
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("newOrdersCount", newOrdersCount);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("products", products);
        request.setAttribute("orders", orders);
        request.setAttribute("users", users);
        request.setAttribute("categories", categories);

        // Thêm contextPath vào request để sử dụng trong JavaScript
        request.setAttribute("contextPath", request.getContextPath());

        // Chuyển hướng đến trang admin
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    /**
     * Phương thức hỗ trợ chuyển hướng với hash fragment
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param hash hash fragment (không cần bao gồm dấu #)
     * @throws IOException nếu có lỗi khi chuyển hướng
     */
    private void redirectWithHash(HttpServletRequest request, HttpServletResponse response, String hash) 
            throws IOException {
        String redirectUrl = request.getContextPath() + "/admin";
        if (hash != null && !hash.isEmpty()) {
            if (!hash.startsWith("#")) {
                hash = "#" + hash;
            }
            redirectUrl += hash;
        }
        response.sendRedirect(redirectUrl);
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
            
            // Chuyển hướng về trang admin với tab sản phẩm
            redirectWithHash(request, response, "products");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi thêm sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
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
                        e.printStackTrace();
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
            
            // Chuyển hướng về trang admin với tab sản phẩm
            redirectWithHash(request, response, "products");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));

            // Lấy thông tin sản phẩm để xóa ảnh
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);

            if (product != null) {
                // Xóa sản phẩm từ database
                productDAO.deleteProduct(productId);

                // Xóa ảnh nếu không phải ảnh mặc định
                if (product.getImageUrl() != null && !product.getImageUrl().equals("resources/no-image.png")) {
                    try {
                        Path imagePath = Paths.get(getServletContext().getRealPath("") + File.separator + product.getImageUrl());
                        Files.deleteIfExists(imagePath);
                    } catch (Exception e) {
                        // Bỏ qua lỗi khi xóa file
                        e.printStackTrace();
                    }
                }
                
                // Thêm thông báo thành công
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Xóa sản phẩm thành công!");
            }

            // Chuyển hướng về trang admin với tab sản phẩm
            redirectWithHash(request, response, "products");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi xóa sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
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
            e.printStackTrace();
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
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String categoryName = request.getParameter("categoryName");

            CategoryDAO categoryDAO = new CategoryDAO();
            categoryDAO.addCategory(categoryName);

            // Thêm thông báo thành công
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Thêm danh mục thành công!");
            
            // Chuyển hướng về trang admin với tab danh mục
            redirectWithHash(request, response, "categories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi thêm danh mục: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String categoryName = request.getParameter("categoryName");

            CategoryDAO categoryDAO = new CategoryDAO();
            categoryDAO.updateCategory(categoryId, categoryName);

            // Thêm thông báo thành công
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Cập nhật danh mục thành công!");
            
            // Chuyển hướng về trang admin với tab danh mục
            redirectWithHash(request, response, "categories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật danh mục: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            CategoryDAO categoryDAO = new CategoryDAO();
            categoryDAO.deleteCategory(categoryId);

            // Thêm thông báo thành công
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Xóa danh mục thành công!");
            
            // Chuyển hướng về trang admin với tab danh mục
            redirectWithHash(request, response, "categories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi xóa danh mục: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    private void getOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);

            if (order != null) {
                // Lấy chi tiết đơn hàng
                List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

                // Tạo đối tượng JSON chứa cả đơn hàng và chi tiết
                Map<String, Object> orderData = new HashMap<>();
                orderData.put("orderId", order.getOrderId());
                orderData.put("userId", order.getUserId());
                orderData.put("totalAmount", order.getTotalPrice());  // Đổi tên thành totalAmount để khớp với JSP
                orderData.put("status", order.getStatus());
                orderData.put("orderDate", order.getCreatedAt());    // Đổi tên thành orderDate để khớp với JSP
                orderData.put("discountId", order.getDiscountId());
                orderData.put("items", orderDetails);
                
                // Thêm thông tin khách hàng nếu có
                if (order.getUserId() > 0) {
                    UserDAO userDAO = new UserDAO();
                    User user = userDAO.getUserById(order.getUserId());
                    if (user != null) {
                        orderData.put("customerName", user.getFullName());
                        orderData.put("customerEmail", user.getEmail());
                        orderData.put("customerPhone", user.getPhone());
                        orderData.put("shippingAddress", user.getAddress());
                    }
                }

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(orderData));
                out.flush();
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Không tìm thấy đơn hàng với ID: " + orderId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");

            // Kiểm tra status có hợp lệ không (theo ràng buộc CHECK trong DB)
            if (!isValidStatus(status)) {
                request.setAttribute("errorMessage", "Trạng thái đơn hàng không hợp lệ");
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
                return;
            }

            OrderDAO orderDAO = new OrderDAO();
            orderDAO.updateOrderStatus(orderId, status);

            // Thêm thông báo thành công
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công!");
            
            // Chuyển hướng về trang admin với tab đơn hàng
            redirectWithHash(request, response, "orders");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật trạng thái đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    // Hàm kiểm tra trạng thái đơn hàng có hợp lệ không
    private boolean isValidStatus(String status) {
        return status != null && (status.equals("Chờ xử lý")
                || status.equals("Đang xử lý")
                || status.equals("Đang giao hàng")
                || status.equals("Hoàn thành")
                || status.equals("Đã hủy"));
    }

    private void getOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            OrderDAO orderDAO = new OrderDAO();
            String status = orderDAO.getOrderStatus(orderId);

            if (status != null) {
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(status);
                out.flush();
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Không tìm thấy đơn hàng với ID: " + orderId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String roleParam = request.getParameter("role");

            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);

            if (user != null) {
                // Cập nhật thông tin cơ bản
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPhone(phone);

                // Cập nhật mật khẩu nếu được cung cấp
                if (password != null && !password.isEmpty()) {
                    // Trong thực tế nên mã hóa mật khẩu
                    user.setPassword(password);
                }

                // Cập nhật role nếu được cung cấp
                if (roleParam != null && !roleParam.isEmpty()) {
                    int roleId;

                    // Nếu role là số (roleId)
                    if (roleParam.matches("\\d+")) {
                        roleId = Integer.parseInt(roleParam);
                    } // Nếu role là chuỗi (tên role)
                    else {
                        switch (roleParam.toLowerCase()) {
                            case "admin":
                                roleId = User.ROLE_ADMIN;
                                break;
                            case "staff":
                                roleId = User.ROLE_STAFF;
                                break;
                            case "user":
                            case "customer":
                                roleId = User.ROLE_USER;
                                break;
                            default:
                                request.setAttribute("errorMessage", "Role không hợp lệ: " + roleParam);
                                request.getRequestDispatcher("/admin.jsp").forward(request, response);
                                return;
                        }
                    }

                    // Kiểm tra roleId có hợp lệ không
                    if (roleId != User.ROLE_ADMIN && roleId != User.ROLE_STAFF && roleId != User.ROLE_USER) {
                        request.setAttribute("errorMessage", "Role ID không hợp lệ: " + roleId);
                        request.getRequestDispatcher("/admin.jsp").forward(request, response);
                        return;
                    }

                    // Cập nhật roleId
                    user.setRoleId(roleId);
                }

                // Cập nhật người dùng trong cơ sở dữ liệu
                userDAO.updateUser(user);

                // Thêm thông báo thành công
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Cập nhật người dùng thành công!");
                
                // Chuyển hướng về trang admin với tab người dùng
                redirectWithHash(request, response, "users");
            } else {
                // Xử lý nếu không tìm thấy người dùng
                request.setAttribute("errorMessage", "Không tìm thấy người dùng với ID: " + userId);
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật người dùng: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    private void getUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));

            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);

            if (user != null) {
                // Lấy lịch sử đơn hàng của người dùng
                OrderDAO orderDAO = new OrderDAO();
                List<Order> userOrders = orderDAO.getOrdersByUserId(userId);
                
                // Lấy tên vai trò từ roleId
                String roleName = "";
                switch (user.getRoleId()) {
                    case User.ROLE_ADMIN:
                        roleName = "admin";
                        break;
                    case User.ROLE_STAFF:
                        roleName = "staff";
                        break;
                    case User.ROLE_USER:
                    default:
                        roleName = "customer";
                        break;
                }
                
                // Tạo đối tượng JSON chứa cả thông tin người dùng và lịch sử đơn hàng
                Map<String, Object> userData = new HashMap<>();
                userData.put("userId", user.getUserId());
                userData.put("fullName", user.getFullName());
                userData.put("email", user.getEmail());
                userData.put("phone", user.getPhone());
                userData.put("role", roleName);  // Sử dụng tên vai trò
                userData.put("roleId", user.getRoleId()); // Thêm role
                                userData.put("createdAt", user.getCreatedAt());
                userData.put("address", user.getAddress());  // Lưu ý: thuộc tính address cũng cần được thêm vào lớp User
                userData.put("orders", userOrders);
               
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(userData));
                out.flush();
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Không tìm thấy người dùng với ID: " + userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
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
            e.printStackTrace();
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
            
            // Chuyển hướng về trang admin với tab sản phẩm
            redirectWithHash(request, response, "products");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật tồn kho: " + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
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
}

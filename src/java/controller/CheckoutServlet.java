package controller;

import context.DBContext;
import dal.OrderDAO;
import dal.OrderDetailDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.Order;
import model.OrderDetail;
import model.User;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang checkout.jsp
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy dữ liệu từ request
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String notes = request.getParameter("notes");
            String cartJson = request.getParameter("cart");
            
            // Parse JSON cart
            JSONArray cartArray = new JSONArray(cartJson);
            List<CartItem> cartItems = new ArrayList<>();
            
            for (int i = 0; i < cartArray.length(); i++) {
                JSONObject item = cartArray.getJSONObject(i);
                CartItem cartItem = new CartItem();
                cartItem.setProductId(item.getInt("id"));
                cartItem.setName(item.getString("name"));
                // Sử dụng BigDecimal thay vì double
                cartItem.setPrice(new BigDecimal(item.getString("price")));
                cartItem.setQuantity(item.getInt("quantity"));
                cartItems.add(cartItem);
            }
            
            // Tính tổng tiền sử dụng BigDecimal
            BigDecimal totalPrice = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                BigDecimal itemTotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
                totalPrice = totalPrice.add(itemTotal);
            }
            
            // Tạo đối tượng Order
            Order order = new Order();
            
            // Lấy thông tin người dùng nếu đã đăng nhập
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                order.setUserId(user.getUserId());
            }
            
            String fullAddress = address + ", " + ward + ", " + district + ", " + city;
            String fullName = firstName + " " + lastName;
            
            order.setTotalPrice(totalPrice);
            order.setStatus("Pending");
            order.setCreatedAt(new Timestamp(new Date().getTime()));
            // Không có discount_id, để null
            
            // Lưu đơn hàng vào database
            OrderDAO orderDAO = new OrderDAO();
            int orderId = orderDAO.createOrder(order);
            
            if (orderId > 0) {
                // Lưu chi tiết đơn hàng
                OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
                ProductDAO productDAO = new ProductDAO();
                
                for (CartItem item : cartItems) {
                    OrderDetail detail = new OrderDetail();
                    detail.setOrderId(orderId);
                    detail.setProductId(item.getProductId());
                    detail.setQuantity(item.getQuantity());
                    detail.setUnitPrice(item.getPrice());
                    
                    orderDetailDAO.createOrderDetail(detail);
                    
                    // Cập nhật số lượng sản phẩm trong kho
                    productDAO.updateStock(item.getProductId(), item.getQuantity());
                }
                
                // Trả về kết quả thành công
                JSONObject result = new JSONObject();
                result.put("success", true);
                result.put("orderId", orderId);
                result.put("orderNumber", "KT" + orderId);
                
                response.getWriter().write(result.toString());
            } else {
                // Trả về lỗi
                JSONObject result = new JSONObject();
                result.put("success", false);
                result.put("message", "Có lỗi xảy ra khi tạo đơn hàng");
                
                response.getWriter().write(result.toString());
            }
        } catch (Exception e) {
            // Xử lý lỗi
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
            
            response.getWriter().write(result.toString());
        }
    }
}

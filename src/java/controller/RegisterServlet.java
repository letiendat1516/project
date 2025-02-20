package controller;

import dal.UserDAO;
import model.User;
import utils.PasswordHash;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    // Xử lý GET request - hiển thị form đăng ký
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    }

    // Xử lý POST request - xử lý đăng ký
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword"); // Thêm confirm password

            // Validate dữ liệu
            if (fullName == null || fullName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || phone == null || phone.trim().isEmpty()
                    || password == null || password.trim().isEmpty()) {
                throw new Exception("Vui lòng điền đầy đủ thông tin");
            }

            // Validate password và confirmPassword
            if (!password.equals(confirmPassword)) {
                throw new Exception("Mật khẩu xác nhận không khớp");
            }

            // Validate độ dài và độ phức tạp của password
            if (password.length() < 6) {
                throw new Exception("Mật khẩu phải có ít nhất 6 ký tự");
            }

            // Validate email
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new Exception("Email không hợp lệ");
            }

            // Validate phone (số điện thoại Việt Nam)
            if (!phone.matches("^(0|\\+84)(3|5|7|8|9)[0-9]{8}$")) {
                throw new Exception("Số điện thoại không hợp lệ");
            }

            // Kiểm tra email và phone đã tồn tại
            if (userDAO.isEmailExists(email)) {
                throw new Exception("Email đã được sử dụng");
            }
            if (userDAO.isPhoneExists(phone)) {
                throw new Exception("Số điện thoại đã được sử dụng");
            }

            // Tạo user mới
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            // Mã hóa password trước khi lưu
            String hashedPassword = PasswordHash.hashPassword(password);
            user.setPassword(hashedPassword);

            // Thực hiện đăng ký
            userDAO.register(user);
            request.setAttribute("success", "Đăng ký thành công! Bạn sẽ được chuyển đến trang đăng nhập.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }

    }
}

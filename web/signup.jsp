<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký tài khoản</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <style>
            body {
                background-color: #f8f9fa;
            }
            
            .signup-container {
                max-width: 500px;
                margin: 50px auto;
                padding: 20px;
            }
            
            .signup-card {
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                padding: 30px;
            }
            
            .signup-header {
                text-align: center;
                margin-bottom: 30px;
            }
            
            .signup-header h1 {
                color: #333;
                font-size: 2rem;
                margin-bottom: 10px;
            }
            
            .form-floating {
                margin-bottom: 1rem;
            }
            
            .password-toggle {
                cursor: pointer;
                position: absolute;
                right: 15px;
                top: 15px;
            }
            
            .btn-signup {
                background-color: #0d6efd;
                border: none;
                padding: 12px;
                font-size: 1.1rem;
                font-weight: 500;
                width: 100%;
                margin-top: 20px;
            }
            
            .login-link {
                text-align: center;
                margin-top: 20px;
            }
            
            .error-message {
                color: #dc3545;
                font-size: 0.875rem;
                margin-top: 5px;
            }
        </style>
    </head>
    <body> 
        <div class="container signup-container">
            <div class="signup-card">
                <div class="signup-header">
                    <h1>Đăng ký tài khoản</h1>
                    <p class="text-muted">Vui lòng điền đầy đủ thông tin bên dưới</p>
                </div>
                
                <!-- Hiển thị thông báo lỗi nếu có -->
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <%= request.getAttribute("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>
                
                <form action="RegisterServlet" method="POST" id="signupForm">
                    <!-- Họ và tên -->
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Họ và tên" required>
                        <label for="fullName">Họ và tên</label>
                    </div>
                    
                    <!-- Email -->
                    <div class="form-floating mb-3">
                        <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                        <label for="email">Email</label>
                    </div>
                    
                    <!-- Số điện thoại -->
                    <div class="form-floating mb-3">
                        <input type="tel" class="form-control" id="phone" name="phone" placeholder="Số điện thoại" required>
                        <label for="phone">Số điện thoại</label>
                    </div>
                    
                    <!-- Mật khẩu -->
                    <div class="form-floating mb-3 position-relative">
                        <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
                        <label for="password">Mật khẩu</label>
                        <i class="fas fa-eye password-toggle" onclick="togglePassword('password')"></i>
                    </div>
                    
                    <!-- Xác nhận mật khẩu -->
                    <div class="form-floating mb-3 position-relative">
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <i class="fas fa-eye password-toggle" onclick="togglePassword('confirmPassword')"></i>
                    </div>
                    
                    <!-- Điều khoản -->
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="terms" required>
                        <label class="form-check-label" for="terms">
                            Tôi đồng ý với <a href="#">điều khoản</a> và <a href="#">chính sách bảo mật</a>
                        </label>
                    </div>
                    
                    <!-- Nút đăng ký -->
                    <button type="submit" class="btn btn-primary btn-signup">
                        Đăng ký
                    </button>
                    
                    <!-- Link đăng nhập -->
                    <div class="login-link">
                        Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Bootstrap JS và Popper.js -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Kiểm tra và hiển thị thông báo thành công nếu có
            <% String successMessage = (String) request.getAttribute("success");
               if (successMessage != null) { %>
                Swal.fire({
                    title: 'Thành công!',
                    text: '<%= successMessage %>',
                    icon: 'success',
                    showConfirmButton: false,
                    timer: 2000
                }).then(function() {
                    window.location.href = 'login';
                });
            <% } %>

            // Hàm toggle password
            function togglePassword(inputId) {
                const input = document.getElementById(inputId);
                const icon = input.nextElementSibling.nextElementSibling;
                
                if (input.type === "password") {
                    input.type = "text";
                    icon.classList.remove("fa-eye");
                    icon.classList.add("fa-eye-slash");
                } else {
                    input.type = "password";
                    icon.classList.remove("fa-eye-slash");
                    icon.classList.add("fa-eye");
                }
            }
            
            // Validate form trước khi submit
            document.getElementById('signupForm').addEventListener('submit', function(event) {
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                if (password !== confirmPassword) {
                    event.preventDefault();
                    Swal.fire({
                        title: 'Lỗi!',
                        text: 'Mật khẩu xác nhận không khớp!',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            });
        </script>
    </body>
</html>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Đăng nhập vào hệ thống">
        <meta name="robots" content="noindex, nofollow">
        <!-- Prevent caching of this page -->
        <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Expires" content="0">
        
        <title>Đăng nhập</title>
        
        <!-- CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
        
        <style>
            .login-container {
                max-width: 400px;
                margin: 0 auto;
                padding: 15px;
            }
            .error-message {
                color: #dc3545;
                font-size: 14px;
                margin-top: 5px;
            }
            .brand-logo {
                width: 120px;
                height: auto;
                margin-bottom: 20px;
            }
            .form-floating {
                margin-bottom: 1rem;
            }
            .password-toggle {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                z-index: 10;
            }
            /* Thêm loading spinner */
            .spinner-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.8);
                z-index: 9999;
            }
            .spinner-center {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }
        </style>
    </head>
    <body class="bg-light">
        <!-- Loading Spinner -->
        <div class="spinner-overlay" id="loadingSpinner">
            <div class="spinner-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Đang tải...</span>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="login-container mt-5">
                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/resources/logo.png" 
                         alt="Logo" class="brand-logo">
                    <h2 class="mb-3">Đăng nhập</h2>
                </div>

                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <!-- Sử dụng JSTL để hiển thị lỗi -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="POST" 
                              id="loginForm" novalidate autocomplete="off">
                            <!-- CSRF Token -->
                            <input type="hidden" name="csrf_token" value="${csrf_token}">
                            
                            <!-- Email input -->
                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="name@example.com" required
                                       pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                       value="${cookie.rememberedEmail.value}">
                                <label for="email">Email</label>
                                <div class="invalid-feedback">
                                    Vui lòng nhập email hợp lệ
                                </div>
                            </div>

                            <!-- Password input -->
                            <div class="form-floating mb-3 position-relative">
                                <input type="password" class="form-control" id="password" 
                                       name="password" placeholder="Mật khẩu" >
                                <label for="password">Mật khẩu</label>
                                <i class="bi bi-eye-slash password-toggle" id="togglePassword"
                                   role="button" tabindex="0"></i>
                            </div>

                               <!-- Submit button -->
                            <button type="submit" class="btn btn-primary w-100 mb-3" id="loginBtn">
                                <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                                Đăng nhập
                            </button>

                            <!-- Links -->
                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/forgot-password.jsp" 
                                   class="text-decoration-none">Quên mật khẩu?</a>
                                <span class="mx-2">|</span>
                                <a href="${pageContext.request.contextPath}/signup.jsp" 
                                   class="text-decoration-none">Đăng ký tài khoản mới</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.getElementById('loginForm');
                const loginBtn = document.getElementById('loginBtn');
                const loadingSpinner = document.getElementById('loadingSpinner');
                
                // Form validation
                form.addEventListener('submit', function(event) {
                    event.preventDefault();
                    
                    if (!form.checkValidity()) {
                        event.stopPropagation();
                        form.classList.add('was-validated');
                        return;
                    }
                    
                  
                    
                    // Show loading
                    loginBtn.disabled = true;
                    loginBtn.querySelector('.spinner-border').classList.remove('d-none');
                    loadingSpinner.style.display = 'block';
                    
                    // Submit form
                    form.submit();
                });

                // Password visibility toggle
                const togglePassword = document.getElementById('togglePassword');
                const passwordInput = document.getElementById('password');
                
                togglePassword.addEventListener('click', function() {
                    const type = passwordInput.type === 'password' ? 'text' : 'password';
                    passwordInput.type = type;
                    this.classList.toggle('bi-eye');
                    this.classList.toggle('bi-eye-slash');
                });
                
                // Keyboard accessibility for password toggle
                togglePassword.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        this.click();
                    }
                });
                
                // Success message handling
                <c:if test="${not empty success}">
                    Swal.fire({
                        title: 'Thành công!',
                        text: 'Đăng nhập thành công!',
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 1500
                    }).then(() => {
                        window.location.href = '${pageContext.request.contextPath}/dashboard';
                    });
                </c:if>
            });
            
            // Prevent form resubmission
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.href);
            }
        </script>
    </body>
</html>

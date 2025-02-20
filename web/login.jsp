<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <!-- SweetAlert2 CSS -->
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
        </style>
    </head>
    <body class="bg-light">
        <div class="container">
            <div class="login-container mt-5">
                <div class="text-center mb-4">
                    <img src="resources/logo.png" alt="Logo" class="brand-logo">
                    <h2 class="mb-3">Đăng nhập</h2>
                </div>

                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <!-- Hiển thị thông báo lỗi nếu có -->
                        <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" role="alert">
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>

                        <form action="login" method="POST" id="loginForm" novalidate>
                            <!-- Email input -->
                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="name@example.com" required>
                                <label for="email">Email</label>
                                <div class="invalid-feedback">
                                    Vui lòng nhập email hợp lệ
                                </div>
                            </div>

                            <!-- Password input -->
                            <div class="form-floating mb-3 position-relative">
                                <input type="password" class="form-control" id="password" 
                                       name="password" placeholder="Mật khẩu" required>
                                <label for="password">Mật khẩu</label>
                                <i class="bi bi-eye-slash password-toggle" id="togglePassword"></i>
                                <div class="invalid-feedback">
                                    Vui lòng nhập mật khẩu
                                </div>
                            </div>

                            <!-- Remember me checkbox -->
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                <label class="form-check-label" for="rememberMe">
                                    Ghi nhớ đăng nhập
                                </label>
                            </div>

                            <!-- Submit button -->
                            <button type="submit" class="btn btn-primary w-100 mb-3">
                                Đăng nhập
                            </button>

                            <!-- Links -->
                            <div class="text-center">
                                <a href="forgot-password.jsp" class="text-decoration-none">Quên mật khẩu?</a>
                                <span class="mx-2">|</span>
                                <a href="signup.jsp" class="text-decoration-none">Đăng ký tài khoản mới</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- SweetAlert2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            // Form validation
            (function () {
                'use strict';
                const form = document.getElementById('loginForm');

                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                });
            })();

            // Password visibility toggle
            document.getElementById('togglePassword').addEventListener('click', function () {
                const passwordInput = document.getElementById('password');
                const icon = this;

                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    icon.classList.remove('bi-eye-slash');
                    icon.classList.add('bi-eye');
                } else {
                    passwordInput.type = 'password';
                    icon.classList.remove('bi-eye');
                    icon.classList.add('bi-eye-slash');
                }
            });

            // Kiểm tra thông báo đăng nhập thành công từ session
            <% String successMessage = (String) request.getAttribute("success");
       if (successMessage != null) { %>
            Swal.fire({
                title: 'Thành công!',
                text: 'Đăng nhập thành công!',
                icon: 'success',
                showConfirmButton: false,
                timer: 2000
            }).then(function () {
                window.location.href = '/PROJECT';
            });
            <% } %>
        </script>
    </body>
</html>

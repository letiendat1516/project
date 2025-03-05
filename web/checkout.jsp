<%-- 
    Document   : checkout
    Created on : Mar 3, 2025, 5:36:00 PM
    Author     : IUHADU
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán - KINGDOMS TOYS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <style>
            :root {
                --primary-color: rgba(130, 119, 172, 1);
                --text-color: #212121;
                --price-color: #9B3C44;
            }

            body {
                font-family: 'Karla', sans-serif;
                color: #777;
                background-color: #f8f9fa;
                padding-top: 140px;
            }

            /* Navigation Styles */
            .navbar {
                padding: 15px 0;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                background-color: rgba(255, 255, 255, 0.98) !important;
            }

            .navbar-brand img {
                max-height: 100px;
                transition: transform 0.3s ease;
            }

            .navbar-brand:hover img {
                transform: scale(1.05);
            }

            .navbar-nav .nav-item {
                position: relative;
                margin: 0 5px;
            }

            .navbar-nav .nav-link {
                color: #333;
                font-weight: 500;
                padding: 8px 15px;
                transition: all 0.3s ease;
                position: relative;
                z-index: 1;
            }

            .navbar-nav .nav-link::before {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 2px;
                background-color: #B01E68;
                transform: scaleX(0);
                transform-origin: right;
                transition: transform 0.3s ease;
            }

            .navbar-nav .nav-link:hover::before {
                transform: scaleX(1);
                transform-origin: left;
            }

            .navbar-nav .nav-link:hover {
                color: #B01E68;
                transform: translateY(-2px);
            }

            .navbar-nav .auth-links .nav-link {
                border: 1px solid transparent;
                border-radius: 20px;
                padding: 6px 15px;
                margin: 0 5px;
                transition: all 0.3s ease;
            }

            .navbar-nav .auth-links .nav-link:hover {
                border-color: #B01E68;
                background-color: rgba(176, 30, 104, 0.05);
                color: #B01E68;
                transform: translateY(-2px);
            }

            /* Checkout Specific Styles */
            .checkout-container {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 30px;
                margin-bottom: 40px;
            }

            .checkout-header {
                margin-bottom: 30px;
                text-align: center;
            }

            .checkout-header h2 {
                color: var(--text-color);
                font-weight: 600;
            }

            .checkout-steps {
                display: flex;
                justify-content: space-between;
                margin-bottom: 30px;
                position: relative;
            }

            .checkout-steps::before {
                content: '';
                position: absolute;
                top: 25px;
                left: 0;
                right: 0;
                height: 2px;
                background-color: #e0e0e0;
                z-index: 1;
            }

            .step {
                position: relative;
                z-index: 2;
                background-color: #fff;
                padding: 0 15px;
                text-align: center;
            }

            .step-number {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background-color: #e0e0e0;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 10px;
                color: #777;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .step.active .step-number {
                background-color: var(--primary-color);
                color: white;
            }

            .step-title {
                font-size: 0.9rem;
                color: #777;
                transition: all 0.3s ease;
            }

            .step.active .step-title {
                color: var(--text-color);
                font-weight: 600;
            }

            .form-label {
                color: var(--text-color);
                font-weight: 500;
            }

            .form-control, .form-select {
                border-radius: 8px;
                padding: 10px 15px;
                border: 1px solid #ddd;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                box-shadow: 0 0 0 3px rgba(130, 119, 172, 0.2);
                border-color: var(--primary-color);
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background-color: #6f5caf;
                border-color: #6f5caf;
                transform: translateY(-2px);
            }

            .btn-outline-secondary {
                border-color: #ddd;
                color: #777;
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-outline-secondary:hover {
                background-color: #f8f9fa;
                color: var(--text-color);
                border-color: #ddd;
                transform: translateY(-2px);
            }

            .cart-summary {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 20px;
            }

            .cart-summary-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #e0e0e0;
            }

            .cart-summary-header h5 {
                color: var(--text-color);
                font-weight: 600;
                margin: 0;
            }

            .cart-summary-item {
                display: flex;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #e0e0e0;
            }

            .cart-summary-item img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 4px;
                margin-right: 15px;
            }

            .cart-summary-item-details {
                flex-grow: 1;
            }

            .cart-summary-item-title {
                color: var(--text-color);
                font-weight: 500;
                margin-bottom: 5px;
            }

            .cart-summary-item-price {
                color: var(--price-color);
                font-weight: 600;
            }

            .cart-summary-item-quantity {
                color: #777;
                font-size: 0.9rem;
            }

            .cart-summary-totals {
                padding-top: 15px;
            }

            .cart-summary-total-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .cart-summary-total-row.final {
                font-weight: 600;
                color: var(--text-color);
                border-top: 1px solid #e0e0e0;
                padding-top: 15px;
                margin-top: 15px;
            }

            .payment-methods {
                margin-top: 30px;
            }

            .payment-method {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .payment-method:hover {
                border-color: var(--primary-color);
                transform: translateY(-2px);
            }

            .payment-method.selected {
                border-color: var(--primary-color);
                background-color: rgba(130, 119, 172, 0.05);
            }

            .payment-method-header {
                display: flex;
                align-items: center;
            }

            .payment-method-header input[type="radio"] {
                margin-right: 10px;
            }

            .payment-method-title {
                font-weight: 500;
                color: var(--text-color);
                margin: 0;
            }

            .payment-method-description {
                margin-top: 10px;
                font-size: 0.9rem;
                color: #777;
            }

            /* Footer Styles */
            footer {
                background-color: #f8f9fa;
                color: #6c757d;
                width: 100%;
                margin: 0;
                padding: 0;
            }

            .footer-content {
                background-color: #f8f9fa;
                width: 100%;
                margin: 0;
                padding: 0;
            }

            .footer-copyright {
                background-color: #f8f9fa;
                border-top: 1px solid #dee2e6;
                width: 100%;
                margin: 0;
                padding: 0;
            }

            /* Reset container-fluid padding */
            .footer-content .container-fluid,
            .footer-copyright .container-fluid {
                padding-left: 0;
                padding-right: 0;
            }

            footer h5 {
                font-weight: 600;
                margin-bottom: 1.5rem;
            }

            .footer-links a {
                color: #6c757d;
                transition: all 0.3s ease;
                display: inline-block;
            }

            .footer-links a:hover {
                color: var(--primary-color);
                transform: translateX(5px);
            }

            .social-links a {
                color: #6c757d;
                transition: all 0.3s ease;
            }

            .social-links a:hover {
                color: var(--primary-color);
            }

            .footer-contact i {
                color: var(--primary-color);
            }

            .footer-contact p {
                color: #6c757d;
                margin-bottom: 0;
            }

            /* Responsive Adjustments */
            @media (max-width: 991.98px) {
                .navbar-collapse {
                    background: white;
                    padding: 1rem;
                    border-radius: 10px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    margin-top: 1rem;
                }

                .checkout-steps {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .checkout-steps::before {
                    display: none;
                }

                .step {
                    display: flex;
                    align-items: center;
                    margin-bottom: 15px;
                    width: 100%;
                    padding: 0;
                }

                .step-number {
                    margin: 0 15px 0 0;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
            <div class="container">
                <a class="navbar-brand" href="javascript:void(0);" onclick="window.location.href = '${pageContext.request.contextPath}/home';">
                    <img src="${pageContext.request.contextPath}/resources/logo.png" alt="Kingdoms Toys">
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link" href="home">Trang chủ</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="products">Sản phẩm</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="contact.jsp">Liên hệ</a>
                        </li>
                    </ul>

                    <ul class="navbar-nav auth-links">
                        <c:choose>
                            <c:when test="${empty sessionScope.user}">
                                <li class="nav-item">
                                    <a class="nav-link" href="login.jsp">Đăng nhập</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="signup.jsp">Đăng ký</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                        <i class="bi bi-person-circle"></i> ${sessionScope.user.fullName}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item" href="profile.jsp">Tài khoản của tôi</a></li>
                                        <li><a class="dropdown-item" href="orders.jsp">Đơn hàng</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="logout">Đăng xuất</a></li>
                                    </ul>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Checkout Content -->
        <div class="container">
            <div class="checkout-container">
                <div class="checkout-header">
                    <h2>Thanh toán</h2>
                    <p>Hoàn tất đơn hàng của bạn</p>
                </div>

                <div class="checkout-steps">
                    <div class="step active">
                        <div class="step-number">1</div>
                        <div class="step-title">Thông tin giao hàng</div>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <div class="step-title">Phương thức thanh toán</div>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <div class="step-title">Xác nhận đơn hàng</div>
                    </div>
                </div>

                <div class="row">
                    <!-- Checkout Form -->
                    <div class="col-lg-8">
                        <form id="checkout-form">
                            <!-- Step 1: Shipping Information -->
                            <div id="step-1" class="checkout-step-content">
                                <h4 class="mb-4">Thông tin giao hàng</h4>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="firstName" class="form-label">Họ</label>
                                        <input type="text" class="form-control" id="firstName" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="lastName" class="form-label">Tên</label>
                                        <input type="text" class="form-control" id="lastName" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" required>
                                </div>

                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" required>
                                </div>

                                <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <input type="text" class="form-control" id="address" required>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-5">
                                        <label for="city" class="form-label">Tỉnh/Thành phố</label>
                                        <input type="text" class="form-control" id="city" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="district" class="form-label">Quận/Huyện</label>
                                        <input type="text" class="form-control" id="district" required>
                                    </div>
                                    <div class="col-md-3">
                                        <label for="ward" class="form-label">Phường/Xã</label>
                                        <input type="text" class="form-control" id="ward" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="notes" class="form-label">Ghi chú đơn hàng (tùy chọn)</label>
                                    <textarea class="form-control" id="notes" rows="3"></textarea>
                                </div>

                                <button type="button" id="to-step-2" class="btn btn-primary">Tiếp tục</button>
                            </div>

                            <!-- Step 2: Payment Method -->
                            <div id="step-2" class="checkout-step-content" style="display: none;">
                                <h4 class="mb-4">Phương thức thanh toán</h4>

                                <div class="payment-methods">
                                    <div class="payment-method selected">
                                        <div class="payment-method-header">
                                            <input type="radio" name="payment-method" id="cod" value="cod" checked>
                                            <label for="cod" class="payment-method-title">Thanh toán khi nhận hàng (COD)</label>
                                        </div>
                                        <div class="payment-method-description">
                                            Bạn sẽ thanh toán bằng tiền mặt khi nhận hàng.
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-4">
                                    <button type="button" id="back-to-step-1" class="btn btn-outline-secondary me-2">Quay lại</button>
                                    <button type="button" id="to-step-3" class="btn btn-primary">Tiếp tục</button>
                                </div>
                            </div>


                            <!-- Step 3: Order Review -->
                            <div id="step-3" class="checkout-step-content" style="display: none;">
                                <h4 class="mb-4">Xác nhận đơn hàng</h4>

                                <div class="row">
                                    <div class="col-md-6 mb-4">
                                        <div class="card">
                                            <div class="card-body">
                                                <h5 class="card-title">Thông tin giao hàng</h5>
                                                <p class="mb-1"><strong>Họ tên:</strong> <span id="review-name"></span></p>
                                                <p class="mb-1"><strong>Email:</strong> <span id="review-email"></span></p>
                                                <p class="mb-1"><strong>Điện thoại:</strong> <span id="review-phone"></span></p>
                                                <p class="mb-1"><strong>Địa chỉ:</strong> <span id="review-address"></span></p>
                                                <p class="mb-0"><strong>Ghi chú:</strong> <span id="review-notes"></span></p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-4">
                                        <div class="card">
                                            <div class="card-body">
                                                <h5 class="card-title">Phương thức thanh toán</h5>
                                                <p class="mb-0" id="review-payment-method">Thanh toán khi nhận hàng (COD)</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="card mb-4">
                                    <div class="card-body">
                                        <h5 class="card-title">Thông tin đơn hàng</h5>
                                        <div id="review-cart-items" class="mb-3"></div>

                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Tạm tính:</span>
                                            <span id="review-subtotal"></span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Phí vận chuyển:</span>
                                            <span>30.000₫</span>
                                        </div>
                                        <div class="d-flex justify-content-between fw-bold">
                                            <span>Tổng cộng:</span>
                                            <span id="review-total"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-check mb-4">
                                    <input class="form-check-input" type="checkbox" id="terms-agree" required>
                                    <label class="form-check-label" for="terms-agree">
                                        Tôi đã đọc và đồng ý với <a href="#">điều khoản và điều kiện</a> của cửa hàng
                                    </label>
                                </div>

                                <div class="mt-4">
                                    <button type="button" id="back-to-step-2" class="btn btn-outline-secondary me-2">Quay lại</button>
                                    <button type="submit" class="btn btn-primary">Đặt hàng</button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Order Summary -->
                    <div class="col-lg-4">
                        <div class="cart-summary">
                            <div class="cart-summary-header">
                                <h5>Tóm tắt đơn hàng</h5>
                                <span id="cart-count"></span>
                            </div>

                            <div id="cart-summary-items">
                                <!-- Cart items will be dynamically added here -->
                            </div>

                            <div class="cart-summary-totals">
                                <div class="cart-summary-total-row">
                                    <span>Tổng tiền hàng:</span>
                                    <span id="cart-subtotal"></span>
                                </div>
                                <div class="cart-summary-total-row">
                                    <span>Phí vận chuyển:</span>
                                    <span>30.000₫</span>
                                </div>
                                <div class="cart-summary-total-row final">
                                    <span>Tổng thanh toán:</span>
                                    <span id="cart-total"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            <div class="footer-content">
                <div class="container-fluid p-0">
                    <div class="container py-5">
                        <div class="row g-4">
                            <div class="col-lg-4 col-md-6">
                                <h5 class="mb-4" style="color: var(--text-color);">Về Kingdoms Toys</h5>
                                <div class="footer-about">
                                    <img src="${pageContext.request.contextPath}/resources/logo.png" 
                                         alt="Kingdoms Toys" 
                                         class="mb-3" 
                                         style="max-height: 60px;">
                                    <p class="mb-4">Chúng tôi là đơn vị chuyên cung cấp các sản phẩm đồ chơi chất lượng cao, 
                                        mang đến niềm vui và trải nghiệm tuyệt vời cho người sưu tầm.</p>
                                    <div class="social-links">
                                        <a href="#" class="me-3 text-decoration-none">
                                            <i class="bi bi-facebook fs-5"></i>
                                        </a>
                                        <a href="#" class="me-3 text-decoration-none">
                                            <i class="bi bi-instagram fs-5"></i>
                                        </a>
                                        <a href="#" class="me-3 text-decoration-none">
                                            <i class="bi bi-tiktok fs-5"></i>
                                        </a>
                                        <a href="#" class="text-decoration-none">
                                            <i class="bi bi-youtube fs-5"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-4 col-md-6">
                                <h5 class="mb-4" style="color: var(--text-color);">Liên kết nhanh</h5>
                                <div class="row">
                                    <div class="col-6">
                                        <ul class="list-unstyled footer-links">
                                            <li class="mb-2">
                                                <a href="home" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Trang chủ
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="products" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Sản phẩm
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Về chúng tôi
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="contact.jsp" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Liên hệ
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-6">
                                        <ul class="list-unstyled footer-links">
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Chính sách
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Điều khoản
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>FAQs
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Blog
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-4 col-md-6">
                                <h5 class="mb-4" style="color: var(--text-color);">Thông tin liên hệ</h5>
                                <div class="footer-contact">
                                    <div class="d-flex mb-3">
                                        <i class="bi bi-geo-alt-fill me-3 fs-5"></i>
                                        <p class="mb-0">123 Đường ABC, Quận XYZ, TP.HCM</p>
                                    </div>
                                    <div class="d-flex mb-3">
                                        <i class="bi bi-envelope-fill me-3 fs-5"></i>
                                        <p class="mb-0">info@kingdomstoys.com</p>
                                    </div>
                                    <div class="d-flex mb-3">
                                        <i class="bi bi-telephone-fill me-3 fs-5"></i>
                                        <p class="mb-0">(84) 123-456-789</p>
                                    </div>
                                    <div class="d-flex">
                                        <i class="bi bi-clock-fill me-3 fs-5"></i>
                                        <div>
                                            <p class="mb-0">Thứ 2 - Thứ 6: 09:00 - 21:00</p>
                                            <p class="mb-0">Thứ 7 - Chủ nhật: 09:00 - 18:00</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Copyright -->
            <div class="footer-copyright">
                <div class="container-fluid p-0">
                    <div class="container">
                        <div class="row py-3">
                            <div class="col-md-6 text-center text-md-start">
                                <p class="mb-0">&copy; 2025 Kingdoms Toys. All rights reserved.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Success Modal -->
        <div class="modal fade" id="orderSuccessModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Đặt hàng thành công</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                        <h4 class="mt-3">Cảm ơn bạn đã đặt hàng!</h4>
                        <p>Đơn hàng của bạn đã được tiếp nhận và đang được xử lý.</p>
                        <p>Mã đơn hàng: <strong id="order-number"></strong></p>
                        <p>Nhân viên của chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất để xác nhận đơn hàng.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <a href="home" class="btn btn-primary">Tiếp tục mua sắm</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>

                    // Khởi tạo giỏ hàng từ localStorage
                    let cart = JSON.parse(localStorage.getItem('cart')) || [];
                    const SHIPPING_FEE = 30000; // 30.000₫

                    // Hiển thị giỏ hàng khi trang tải
                    document.addEventListener('DOMContentLoaded', function () {
                        if (cart.length === 0) {
                            // Nếu giỏ hàng trống, chuyển hướng về trang sản phẩm
                            window.location.href = 'products';
                            return;
                        }

                        updateCartSummary();

                        // Xử lý sự kiện cho các nút chuyển bước
                        document.getElementById('to-step-2').addEventListener('click', function () {
                            // Kiểm tra form
                            const form = document.getElementById('checkout-form');
                            const requiredFields = form.querySelectorAll('#step-1 [required]');
                            let isValid = true;

                            requiredFields.forEach(field => {
                                if (!field.value.trim()) {
                                    field.classList.add('is-invalid');
                                    isValid = false;
                                } else {
                                    field.classList.remove('is-invalid');
                                }
                            });

                            if (isValid) {
                                // Chuyển sang bước 2
                                document.getElementById('step-1').style.display = 'none';
                                document.getElementById('step-2').style.display = 'block';

                                // Cập nhật trạng thái các bước
                                document.querySelectorAll('.step')[0].classList.remove('active');
                                document.querySelectorAll('.step')[1].classList.add('active');
                            }
                        });

                        document.getElementById('back-to-step-1').addEventListener('click', function () {
                            document.getElementById('step-2').style.display = 'none';
                            document.getElementById('step-1').style.display = 'block';

                            document.querySelectorAll('.step')[1].classList.remove('active');
                            document.querySelectorAll('.step')[0].classList.add('active');
                        });

                        document.getElementById('to-step-3').addEventListener('click', function () {
                            document.getElementById('step-2').style.display = 'none';
                            document.getElementById('step-3').style.display = 'block';

                            document.querySelectorAll('.step')[1].classList.remove('active');
                            document.querySelectorAll('.step')[2].classList.add('active');

                            // Cập nhật thông tin xác nhận đơn hàng
                            updateOrderReview();
                        });

                        document.getElementById('back-to-step-2').addEventListener('click', function () {
                            document.getElementById('step-3').style.display = 'none';
                            document.getElementById('step-2').style.display = 'block';

                            document.querySelectorAll('.step')[2].classList.remove('active');
                            document.querySelectorAll('.step')[1].classList.add('active');
                        });

                        // Xử lý sự kiện submit form
                        document.getElementById('checkout-form').addEventListener('submit', function (e) {
                            e.preventDefault();

                            if (!document.getElementById('terms-agree').checked) {
                                alert('Vui lòng đồng ý với điều khoản và điều kiện để tiếp tục.');
                                return;
                            }

                            // Tạo mã đơn hàng ngẫu nhiên
                            const orderNumber = 'KT' + Date.now().toString().substring(6);
                            document.getElementById('order-number').textContent = orderNumber;

                            // Lưu thông tin đơn hàng (trong thực tế, bạn sẽ lưu vào database)
                            const firstName = document.getElementById('firstName').value;
                            const lastName = document.getElementById('lastName').value;
                            const customerName = firstName + ' ' + lastName;
                            const customerEmail = document.getElementById('email').value;
                            const customerPhone = document.getElementById('phone').value;
                            const address = document.getElementById('address').value;
                            const city = document.getElementById('city').value;
                            const district = document.getElementById('district').value;
                            const ward = document.getElementById('ward').value;
                            const notes = document.getElementById('notes').value;

                            // Tính tổng tiền đơn hàng
                            const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
                            const total = subtotal + SHIPPING_FEE;

                            // Tạo đối tượng đơn hàng
                            const orderInfo = {
                                orderId: orderNumber,
                                customerName: customerName,
                                customerEmail: customerEmail,
                                customerPhone: customerPhone,
                                shippingAddress: `${address}, ${ward}, ${district}, ${city}`,
                                                notes: notes,
                                                items: cart,
                                                subtotal: subtotal,
                                                shipping: SHIPPING_FEE,
                                                total: total,
                                                paymentMethod: 'cod',
                                                status: 'pending',
                                                orderDate: new Date().toISOString()
                                            };

                                            // Lưu đơn hàng vào localStorage (trong thực tế, bạn sẽ lưu vào database)
                                            const orders = JSON.parse(localStorage.getItem('orders') || '[]');
                                            orders.push(orderInfo);
                                            localStorage.setItem('orders', JSON.stringify(orders));

                                            // Hiển thị modal thành công
                                            const successModal = new bootstrap.Modal(document.getElementById('orderSuccessModal'));
                                            successModal.show();

                                            // Xóa giỏ hàng
                                            localStorage.removeItem('cart');
                                            cart = [];
                                        });
                                    });

                                    // Hàm định dạng tiền tệ
                                    function formatCurrency(amount) {
                                        return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(amount);
                                    }

                                    // Cập nhật tóm tắt giỏ hàng
                                    function updateCartSummary() {
                                        const cartSummaryItems = document.getElementById('cart-summary-items');
                                        const cartCount = document.getElementById('cart-count');
                                        let html = '';
                                        let subtotal = 0;

                                        cart.forEach(item => {
                                            html +=
                                                    '<div class="cart-summary-item">' +
                                                    '<img src="' + item.image + '" alt="' + item.name + '">' +
                                                    '<div class="cart-summary-item-details">' +
                                                    '<h6 class="cart-summary-item-title">' + item.name + '</h6>' +
                                                    '<p class="cart-summary-item-price">' + formatCurrency(item.price) + '</p>' +
                                                    '<p class="cart-summary-item-quantity">Số lượng: ' + item.quantity + '</p>' +
                                                    '</div>' +
                                                    '</div>';


                                            subtotal += item.price * item.quantity;
                                        });

                                        cartSummaryItems.innerHTML = html;
                                        cartCount.textContent = `${cart.length} sản phẩm`;

                                        document.getElementById('cart-subtotal').textContent = formatCurrency(subtotal);
                                        document.getElementById('cart-total').textContent = formatCurrency(subtotal + SHIPPING_FEE);
                                    }

                                    // Cập nhật thông tin xác nhận đơn hàng
                                    function updateOrderReview() {
                                        // Cập nhật thông tin giao hàng
                                        const firstName = document.getElementById('firstName').value;
                                        const lastName = document.getElementById('lastName').value;
                                        document.getElementById('review-name').textContent = `${firstName} ${lastName}`;
                                                document.getElementById('review-email').textContent = document.getElementById('email').value;
                                                document.getElementById('review-phone').textContent = document.getElementById('phone').value;

                                                // Xử lý địa chỉ để tránh hiển thị dấu phẩy dư thừa
                                                const address = document.getElementById('address').value;
                                                const city = document.getElementById('city').value;
                                                const district = document.getElementById('district').value;
                                                const ward = document.getElementById('ward').value;

                                                // Tạo mảng chứa các thành phần địa chỉ không rỗng
                                                const addressParts = [];
                                                if (address)
                                                    addressParts.push(address);
                                                if (ward)
                                                    addressParts.push(ward);
                                                if (district)
                                                    addressParts.push(district);
                                                if (city)
                                                    addressParts.push(city);

                                                // Nối các thành phần bằng dấu phẩy
                                                const fullAddress = addressParts.join(', ');
                                                document.getElementById('review-address').textContent = fullAddress || 'Chưa có địa chỉ';

                                                const notes = document.getElementById('notes').value;
                                                document.getElementById('review-notes').textContent = notes || 'Không có ghi chú';

                                                // Cập nhật phương thức thanh toán
                                                document.getElementById('review-payment-method').textContent = 'Thanh toán khi nhận hàng (COD)';

                                                // Cập nhật thông tin giỏ hàng
                                                const reviewCartItems = document.getElementById('review-cart-items');
                                                let html = '';
                                                let subtotal = 0;

                                                cart.forEach(item => {
                                                    html +=
                                                            '<div class="d-flex justify-content-between align-items-center mb-2">' +
                                                            '<div>' +
                                                            '<span class="fw-bold">' + item.name + '</span>' +
                                                            '<span class="text-muted"> x ' + item.quantity + '</span>' +
                                                            '</div>' +
                                                            '<span>' + formatCurrency(item.price * item.quantity) + '</span>' +
                                                            '</div>';

                                                    subtotal += item.price * item.quantity;
                                                });

                                                reviewCartItems.innerHTML = html;
                                                document.getElementById('review-subtotal').textContent = formatCurrency(subtotal);
                                                document.getElementById('review-total').textContent = formatCurrency(subtotal + SHIPPING_FEE);
                                            }
        </script>
    </body>
</html>


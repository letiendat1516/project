<%-- 
    Document   : index
    Created on : Feb 19, 2025, 10:24:07 AM
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
        <title>KINGDOMS TOYS - THIÊN ĐƯỜNG ĐỒ CHƠI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <style>
            /* CSS chính của bạn */
            :root {
                --primary-color: rgba(130, 119, 172, 1);
                --text-color: #212121;
                --price-color: #9B3C44;
            }

            body {
                font-family: 'Karla', sans-serif;
                color: #777;
                background-color: #fff;
                padding-top: 140px; /* Add padding for fixed navbar */
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

            /* Navigation Links Styling */
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

            /* Underline Effect */
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

            /* Hover Effect */
            .navbar-nav .nav-link:hover {
                color: #B01E68;
                transform: translateY(-2px);
            }

            /* Authentication Links Special Styling */
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

            /* Active Link Style */
            .navbar-nav .nav-link.active {
                color: #B01E68;
                font-weight: 600;
            }

            /* Search Form Styling */
            .search-form {
                width: 100%;
                max-width: 400px;
                transition: all 0.3s ease;
            }

            .search-form:focus-within {
                transform: translateY(-2px);
            }

            .search-form .input-group {
                width: 100%;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
            }

            .search-form:focus-within .input-group {
                box-shadow: 0 3px 8px rgba(176, 30, 104, 0.1);
            }

            .search-form .form-control {
                border-radius: 20px 0 0 20px;
                border: 1px solid #B01E68;
                padding-left: 20px;
                transition: all 0.3s ease;
            }

            .search-form .form-control:focus {
                box-shadow: none;
                border-color: #B01E68;
            }

            .search-form .btn {
                border-radius: 0 20px 20px 0;
                border: 1px solid #B01E68;
                color: #B01E68;
                transition: all 0.3s ease;
            }

            .search-form .btn:hover {
                background-color: #B01E68;
                color: white;
                transform: translateX(2px);
            }

            /* Cart Icon Styling */
            .cart-icon {
                position: relative;
                transition: all 0.3s ease;
            }

            .cart-icon:hover {
                transform: translateY(-2px);
            }

            .badge {
                font-size: 0.6rem;
                padding: 0.25em 0.6em;
                transition: all 0.3s ease;
            }

            /* Banner Slider */
            .banner-slider {
                position: relative;
                overflow: hidden;
            }

            .carousel-item img {
                width: 1901px;
                height: 658px;
                object-fit: cover;
            }

            .carousel-control-prev, .carousel-control-next {
                width: 5%;
                opacity: 0;
                transition: opacity 0.3s;
            }

            .carousel-control-prev-icon, .carousel-control-next-icon {
                background-color: rgba(0, 0, 0, 0.5);
                padding: 20px;
                border-radius: 50%;
            }

            .banner-slider:hover .carousel-control-prev,
            .banner-slider:hover .carousel-control-next {
                opacity: 1;
            }

            .carousel-indicators {
                margin-bottom: 1rem;
            }

            .carousel-indicators button {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                margin: 0 5px;
            }

            /* Product Card Styling */
            .product-card {
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                border-radius: 8px;
                overflow: hidden;
                transition: transform 0.3s;
                margin-bottom: 30px;
            }

            .product-card:hover {
                transform: translateY(-5px);
            }

            .product-image {
                position: relative;
                overflow: hidden;
                padding-top: 100%;
            }

            .product-image img {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .product-info {
                background: white;
                padding: 15px;
            }

            .product-title {
                font-size: 1.1rem;
                color: var(--text-color);
                margin: 15px 0 10px;
            }

            .product-price {
                color: var(--price-color);
                font-weight: 600;
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .add-to-cart {
                transition: all 0.3s;
            }

            .add-to-cart:hover {
                transform: translateY(-2px);
            }

            /* CSS cho banner slider */
            .banner-slider {
                width: 100%;
                position: relative;
                overflow: hidden;
            }

            .carousel-inner {
                width: 100%;
            }

            .carousel-item {
                width: 100%;
                height: auto;
            }

            .carousel-item img {
                width: 100%;
                height: auto;
                object-fit: cover;
            }

            /* Hero Section */
            .hero-section {
                background-color: #f8f9fa;
                padding: 60px 0;
                text-align: center;
            }

            /* Footer */
            footer {
                background-color: #f8f9fa;
                padding: 40px 0;
                margin-top: 60px;
            }

            /* Cart Offcanvas Styles - Phần CSS mới cho giỏ hàng */
            .offcanvas {
                width: 350px;
            }

            .cart-item {
                display: flex;
                align-items: center;
                padding: 10px 0;
                border-bottom: 1px solid #eee;
            }

            .cart-item img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                margin-right: 10px;
                border-radius: 4px;
            }

            .cart-item-details {
                flex-grow: 1;
            }

            .cart-item-title {
                font-size: 0.9rem;
                margin-bottom: 5px;
                color: var(--text-color);
            }

            .cart-item-price {
                color: var(--price-color);
                font-weight: 600;
                margin-bottom: 5px;
            }

            .cart-item-quantity {
                display: flex;
                align-items: center;
            }

            .quantity-btn {
                border: 1px solid #ddd;
                background: #f8f9fa;
                width: 25px;
                height: 25px;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-weight: bold;
                margin: 0 5px;
            }

            .cart-total {
                border-top: 1px solid #eee;
                padding-top: 15px;
            }

            .cart-total h6 {
                display: flex;
                justify-content: space-between;
                color: var(--text-color);
                font-weight: 600;
            }

            .total-amount {
                color: var(--price-color);
                font-weight: 700;
            }

            /* Toast notification */
            .toast {
                background-color: #fff;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            }

            /* Stock indicator styles */
            .stock {
                font-size: 0.9em;
                margin: 5px 0;
            }

            .in-stock {
                color: #2ecc71;
            }

            .low-stock {
                color: #f1c40f;
            }

            .out-stock {
                color: #e74c3c;
            }

            button.add-to-cart:disabled {
                background-color: #ccc;
                cursor: not-allowed;
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
                .search-form {
                    margin: 1rem 0;
                    max-width: 100%;
                }

                .navbar-nav {
                    text-align: center;
                }

                .navbar-nav .nav-link::before {
                    bottom: -2px;
                }

                .navbar-nav .auth-links .nav-link {
                    margin: 5px 0;
                }
            }

            @media (max-width: 768px) {
                .carousel-item {
                    height: 300px; /* Điều chỉnh chiều cao cho màn hình mobile */
                }

                .carousel-item img {
                    height: 100%;
                }
            }

            @media (min-width: 769px) and (max-width: 1024px) {
                .carousel-item {
                    height: 400px; /* Điều chỉnh chiều cao cho màn hình tablet */
                }

                .carousel-item img {
                    height: 100%;
                }
            }

            @media (min-width: 1025px) {
                .carousel-item {
                    height: 500px; /* Điều chỉnh chiều cao cho màn hình desktop */
                }

                .carousel-item img {
                    height: 100%;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
            <div class="container">
                <!-- Logo -->
                <a class="navbar-brand" href="javascript:void(0);" onclick="window.location.href = '${pageContext.request.contextPath}/home';">
                    <img src="${pageContext.request.contextPath}/resources/logo.png" alt="Kingdoms Toys">
                </a>

                <!-- Toggle Button -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Main Navigation Content -->
                <div class="collapse navbar-collapse" id="navbarNav">
                    <!-- Search Bar -->
                    <form action="search" method="post" class="d-flex mx-auto search-form">
                        <input type="hidden" name="source" value="index">
                        <div class="input-group">
                            <input name="txt" class="form-control" type="text" placeholder="Tìm kiếm sản phẩm..." aria-label="Search">
                            <button class="btn btn-outline-danger" type="submit">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </form>

                    <!-- tim kiem  -->
                    <!-- Center Navigation Links -->
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

                    <!-- Right Side Items -->
                    <!-- Right Side Items -->
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
                        <!-- Cart Icon -->
                        <li class="nav-item">
                            <a class="nav-link position-relative cart-icon" href="#" data-bs-toggle="offcanvas" data-bs-target="#cartOffcanvas">
                                <i class="bi bi-cart3"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    0
                                    <span class="visually-hidden">items in cart</span>
                                </span>
                            </a>
                        </li>
                    </ul>

                </div>
            </div>
        </nav>

        <!-- Banner Slider -->
        <div id="bannerSlider" class="carousel slide banner-slider" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#bannerSlider" data-bs-slide-to="0" class="active"></button>
                <button type="button" data-bs-target="#bannerSlider" data-bs-slide-to="1"></button>
                <button type="button" data-bs-target="#bannerSlider" data-bs-slide-to="2"></button>
            </div>

            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="${pageContext.request.contextPath}/resources/banner1.png" alt="Banner 1">
                </div>

                <div class="carousel-item">
                    <img src="${pageContext.request.contextPath}/resources/banner2.png" alt="Banner 2">
                </div>

                <div class="carousel-item">
                    <img src="${pageContext.request.contextPath}/resources/banner3.png" alt="Banner 3">
                </div>
            </div>

            <button class="carousel-control-prev" type="button" data-bs-target="#bannerSlider" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#bannerSlider" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <img src="${pageContext.request.contextPath}/resources/name.png" alt="name"/>
                <img src="${pageContext.request.contextPath}/resources/name2.PNG" alt="name 2"/>
            </div>
        </section>

        <!-- Products Section -->
        <!-- Products Section -->
        <section class="products-section py-5">
            <div class="container">
                <h2 class="text-center mb-5">Sản phẩm nổi bật</h2>
                <div class="row">
                    <c:choose>
                        <c:when test="${not empty featuredProducts}">
                            <c:forEach items="${featuredProducts}" var="product">
                                <div class="col-md-4 mb-4">
                                    <div class="product-card">
                                        <div class="product-image">
                                            <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}">
                                                <c:choose>
                                                    <c:when test="${not empty product.imageUrl}">
                                                        <img src="${pageContext.request.contextPath}/${product.imageUrl}" 
                                                             alt="${product.name}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/resources/images/no-image.jpg" 
                                                             alt="No image available">
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>
                                        </div>
                                        <div class="product-info">
                                            <h3 class="product-title">
                                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="text-decoration-none">
                                                    ${product.name}
                                                </a>
                                            </h3>
                                            <p class="product-price">
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                                            </p>

                                            <!-- Hiển thị trạng thái tồn kho -->
                                            <c:choose>
                                                <c:when test="${product.stockQuantity > 10}">
                                                    <p class="stock in-stock">Còn hàng (${product.stockQuantity})</p>
                                                </c:when>
                                                <c:when test="${product.stockQuantity > 0 && product.stockQuantity <= 10}">
                                                    <p class="stock low-stock">Sắp hết hàng (Còn ${product.stockQuantity})</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="stock out-stock">Hết hàng</p>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Nút thêm vào giỏ -->
                                            <c:choose>
                                                <c:when test="${product.stockQuantity > 0}">
                                                    <button class="btn btn-primary w-100 add-to-cart" 
                                                            data-id="${product.productId}">
                                                        <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-secondary w-100" disabled>
                                                        Hết hàng
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center">
                                <p>Hiện chưa có sản phẩm nổi bật.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>



        <!-- Cart Offcanvas -->
        <div class="offcanvas offcanvas-end" tabindex="-1" id="cartOffcanvas">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title">Giỏ hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
            </div>
            <div class="offcanvas-body">
                <div class="cart-items">
                    <!-- Cart items will be dynamically added here -->
                </div>
                <div class="cart-total mt-3">
                    <h6>Tổng cộng: <span class="total-amount">0₫</span></h6>
                </div>
                <button id="checkout-btn" class="btn btn-primary w-100 mt-3">Thanh toán</button>
            </div>
        </div>


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
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Trang chủ
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Sản phẩm
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Về chúng tôi
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
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
                                        <p class="mb-0">info@findingunicorn.com</p>
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

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Cart JavaScript -->
        <script>
                    // Khởi tạo giỏ hàng từ localStorage hoặc mảng rỗng nếu chưa có
                    let cart = JSON.parse(localStorage.getItem('cart')) || [];

                    // Cập nhật hiển thị giỏ hàng khi trang tải
                    document.addEventListener('DOMContentLoaded', function () {
                        updateCartDisplay();
                        updateCartBadge();
                    });

                    document.querySelectorAll('.add-to-cart').forEach(button => {
                        button.addEventListener('click', function () {
                            const productId = this.dataset.id;
                            const productCard = this.closest('.product-card');
                            const productName = productCard.querySelector('.product-title').textContent.trim();
                            const productPriceText = productCard.querySelector('.product-price').textContent.trim();
                            // Xử lý chuỗi giá tiền để lấy số
                            // Cách sửa lỗi
                            const productPrice = parseFloat(productPriceText.replace(/[₫,]/g, '').replace('.', ',').replace(',', '.'));
                            const productImage = productCard.querySelector('.product-image img').src;

                            const product = {
                                id: productId,
                                name: productName,
                                price: productPrice,
                                image: productImage,
                                quantity: 1
                            };

                            addToCart(product);

                            // Hiển thị thông báo đã thêm vào giỏ
                            const toast = document.createElement('div');
                            toast.className = 'position-fixed bottom-0 end-0 p-3';
                            toast.style.zIndex = '5';
                            toast.innerHTML = `
                <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header">
                        <strong class="me-auto">Thông báo</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body">
                        Đã thêm ${productName} vào giỏ hàng!
                    </div>
                </div>
            `;
                            document.body.appendChild(toast);

                            setTimeout(() => {
                                toast.remove();
                            }, 3000);

                            // Mở giỏ hàng
                            var cartOffcanvas = new bootstrap.Offcanvas(document.getElementById('cartOffcanvas'));
                            cartOffcanvas.show();
                        });
                    });

                    function addToCart(product) {
                        console.log('Adding to cart:', product);
                        const existingItem = cart.find(item => item.id === product.id);
                        if (existingItem) {
                            existingItem.quantity++;
                        } else {
                            cart.push(product);
                        }

                        // Lưu giỏ hàng vào localStorage
                        localStorage.setItem('cart', JSON.stringify(cart));
                        console.log('Cart after update:', JSON.parse(localStorage.getItem('cart')));

                        updateCartBadge();
                        updateCartDisplay();
                    }


                    function updateCartBadge() {
                        const badge = document.querySelector('.badge');
                        const total = cart.reduce((sum, item) => sum + item.quantity, 0);
                        badge.textContent = total;
                    }

                    function updateCartDisplay() {
                        const cartItems = document.querySelector('.cart-items');
                        console.log('Updating cart display, cart items:', cart);

                        if (cart.length === 0) {
                            cartItems.innerHTML = '<p class="text-center my-4">Giỏ hàng trống</p>';
                            const checkoutBtn = document.querySelector('.offcanvas-body .btn-primary');
                            if (checkoutBtn)
                                checkoutBtn.disabled = true;
                        } else {
                            let html = '';
                            cart.forEach(item => {
                                html += `
            <div class="cart-item">
                <img src="\${item.image}" alt="\${item.name}">
                <div class="cart-item-details">
                    <h6 class="cart-item-title">\${item.name}</h6>
                    <p class="cart-item-price">\${formatCurrency(item.price)}</p>
                    <div class="cart-item-quantity">
                        <button class="quantity-btn" onclick="updateQuantity('\${item.id}', -1)">-</button>
                        <span>\${item.quantity}</span>
                        <button class="quantity-btn" onclick="updateQuantity('\${item.id}', 1)">+</button>
                        <button class="btn btn-sm btn-danger ms-2" onclick="removeItem('\${item.id}')">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </div>
            </div>
            `;
                            });
                            cartItems.innerHTML = html;
                            console.log('Cart HTML:', html);

                            const checkoutBtn = document.querySelector('.offcanvas-body .btn-primary');
                            if (checkoutBtn)
                                checkoutBtn.disabled = false;
                        }

                        updateCartTotal();
                    }

                    function updateQuantity(id, change) {
                        const item = cart.find(item => item.id === id);
                        if (item) {
                            item.quantity += change;
                            if (item.quantity <= 0) {
                                cart = cart.filter(i => i.id !== id);
                            }

                            // Lưu giỏ hàng vào localStorage
                            localStorage.setItem('cart', JSON.stringify(cart));

                            updateCartDisplay();
                            updateCartBadge();
                        }
                    }

                    function removeItem(id) {
                        cart = cart.filter(item => item.id !== id);

                        // Lưu giỏ hàng vào localStorage
                        localStorage.setItem('cart', JSON.stringify(cart));

                        updateCartDisplay();
                        updateCartBadge();
                    }

                    function updateCartTotal() {
                        const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
                        document.querySelector('.total-amount').textContent = formatCurrency(total);
                    }

                    function formatCurrency(amount) {
                        return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(amount);
                    }

                    // Thêm sự kiện cho nút thanh toán
                    document.addEventListener('DOMContentLoaded', function () {
                        const checkoutBtn = document.querySelector('.offcanvas-body .btn-primary');
                        if (checkoutBtn) {
                            checkoutBtn.addEventListener('click', function () {
                                if (cart.length > 0) {
                                    // Chuyển đến trang thanh toán
                                    window.location.href = 'checkout.jsp';
                                }
                            });
                        }
                    });
        </script>
    </body>
</html>

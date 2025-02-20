<%-- 
    Document   : product
    Created on : Feb 20, 2025, 4:37:00 PM
    Author     : IUHADU
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sản phẩm - KINGDOMS TOYS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <style>
            :root {
                --primary-color: rgba(130, 119, 172, 1);
                --text-color: #212121;
                --price-color: #9B3C44;
            }

            body {
                font-family: 'Karla', sans-serif;
                color: #777;
                background-color: #fff;
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
            }

            .search-form .form-control {
                border-radius: 20px 0 0 20px;
                border: 1px solid #B01E68;
                padding-left: 20px;
            }

            .search-form .btn {
                border-radius: 0 20px 20px 0;
                border: 1px solid #B01E68;
                color: #B01E68;
            }

            /* Products Page Specific CSS */
            .products-header {
                text-align: center;
                margin-bottom: 40px;
            }
            .products-header img{
                width: 1080px;
                height: 600px;
                margin-bottom: 1cm;
            }

            .filter-section {
                margin-bottom: 30px;
                padding: 15px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }

            .products-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                margin-bottom: 40px;
            }

            .product-card {
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                border-radius: 8px;
                overflow: hidden;
                transition: transform 0.3s;
                background: white;
            }

            .product-card:hover {
                transform: translateY(-5px);
            }

            .product-image {
                position: relative;
                padding-top: 100%;
                overflow: hidden;
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
                padding: 15px;
            }

            .product-title {
                font-size: 1rem;
                color: var(--text-color);
                margin-bottom: 10px;
                height: 2.4em;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
            }

            .product-price {
                color: var(--price-color);
                font-weight: 600;
                margin-bottom: 15px;
            }

            .load-more {
                text-align: center;
                margin: 40px 0;
            }

            .load-more button {
                padding: 10px 30px;
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 25px;
                transition: all 0.3s ease;
            }

            .load-more button:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
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

            .btn-outline-secondary {
                border: 1px solid #dee2e6;
                color: #6c757d;
                background-color: white;
                padding: 0.5rem 1rem;
                font-size: 0.9rem;
            }

            .btn-outline-secondary:hover {
                background-color: #f8f9fa;
                border-color: #dee2e6;
                color: #6c757d;
            }

            .dropdown-menu {
                border: 1px solid #dee2e6;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                padding: 0.5rem 0;
            }

            .dropdown-item {
                padding: 0.5rem 1rem;
                color: #6c757d;
            }

            .dropdown-item:hover {
                background-color: #f8f9fa;
            }



            @media (max-width: 1200px) {
                .products-grid {
                    grid-template-columns: repeat(3, 1fr);
                }
            }

            @media (max-width: 991.98px) {
                .products-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .navbar-collapse {
                    background: white;
                    padding: 1rem;
                    border-radius: 10px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    margin-top: 1rem;
                }
            }

            @media (max-width: 575.98px) {
                .products-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
            <div class="container">
                <a class="navbar-brand" href="#">
                    <img src="${pageContext.request.contextPath}/resources/logo.png" alt="Kingdoms Toys">
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <form class="d-flex mx-auto search-form">
                        <div class="input-group">
                            <input class="form-control" type="search" placeholder="Tìm kiếm sản phẩm..." aria-label="Search">
                            <button class="btn btn-outline-danger" type="submit">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </form>

                    <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link" href="index.jsp">Trang chủ</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="products.jsp">Sản phẩm</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Liên hệ</a>
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
                        <li class="nav-item">
                            <a class="nav-link position-relative cart-icon" href="#" data-bs-toggle="offcanvas" data-bs-target="#cartOffcanvas">
                                <i class="bi bi-cart3"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    0
                                </span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Products Content -->
        <div class="container mt-5">
            <div class="products-header">
                <img src="${pageContext.request.contextPath}/resources/product.png" alt="product banner"/>
                <h1>Tất cả sản phẩm</h1>
                <p>Khám phá bộ sưu tập đồ chơi độc đáo của chúng tôi</p>
            </div>

            <!-- Filter Section -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="d-flex justify-content-start mb-4">
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-secondary d-flex align-items-center gap-2">
                            <i class="bi bi-funnel"></i>
                            Filter
                        </button>

                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                Loại sản phẩm
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Tất Cả</a></li>
                                <li><a class="dropdown-item" href="#">Túi Mù</a></li>
                                <li><a class="dropdown-item" href="#">Lego</a></li>
                                <li><a class="dropdown-item" href="#">Mô Hình</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="d-flex justify-content-end mb-4">
                    <div class="d-flex align-items-center gap-2">
                        <span class="text-secondary">Sắp Xếp</span>
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                Đề Xuất
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="#">Đề Xuất</a></li>
                                <li><a class="dropdown-item" href="#">Giá: Thấp Tới Cao</a></li>
                                <li><a class="dropdown-item" href="#">Giá: Cao Tới Thấp</a></li>
                                <li><a class="dropdown-item" href="#">Bảng chữ cái A-Z</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Products Grid -->
            <div class="products-grid">
                <c:forEach begin="1" end="36">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="${pageContext.request.contextPath}/resources/products/product${status.index}.jpg" 
                                 alt="Product ${status.index}">
                        </div>
                        <div class="product-info">
                            <h3 class="product-title">FINDING UNICORN Series ${status.index}</h3>
                            <p class="product-price">$12.90</p>
                            <button class="btn btn-primary w-100 add-to-cart" data-id="${status.index}">
                                <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </c:forEach>
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
                            <div class="col-md-6 text-center text-md-end">
                                <img src="${pageContext.request.contextPath}/resources/payment-methods.png" 
                                     alt="Payment Methods" 
                                     style="height: 30px;">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>


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
                    <h6>Tổng cộng: <span class="total-amount">0đ</span></h6>
                </div>
                <button class="btn btn-primary w-100 mt-3">Thanh toán</button>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            let cart = [];

            // Add to Cart Function
            document.querySelectorAll('.add-to-cart').forEach(button => {
                button.addEventListener('click', function () {
                    const productId = this.dataset.id;
                    const productCard = this.closest('.product-card');
                    const productName = productCard.querySelector('.product-title').textContent;
                    const productPrice = productCard.querySelector('.product-price').textContent;
                    const productImage = productCard.querySelector('.product-image img').src;

                    addToCart({
                        id: productId,
                        name: productName,
                        price: productPrice,
                        image: productImage,
                        quantity: 1
                    });
                });
            });

            function addToCart(product) {
                const existingItem = cart.find(item => item.id === product.id);

                if (existingItem) {
                    existingItem.quantity++;
                } else {
                    cart.push(product);
                }

                updateCartDisplay();
                updateCartBadge();
            }

            function updateCartDisplay() {
                const cartItems = document.querySelector('.cart-items');
                cartItems.innerHTML = '';
                let total = 0;

                cart.forEach(item => {
                    const itemTotal = parseFloat(item.price.replace('$', '')) * item.quantity;
                    total += itemTotal;

                    cartItems.innerHTML += `
                        <div class="cart-item mb-3">
                            <img src="${item.image}" alt="${item.name}" class="me-3" style="width: 50px; height: 50px; object-fit: cover;">
                            <div class="cart-item-details">
                                <h6 class="mb-0">${item.name}</h6>
                                <p class="mb-0">${item.price} x ${item.quantity}</p>
                            </div>
                        </div>
                    `;
                });

                document.querySelector('.total-amount').textContent = `$${total.toFixed(2)}`;
            }

            function updateCartBadge() {
                const badge = document.querySelector('.cart-icon .badge');
                const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
                badge.textContent = totalItems;
            }

            // Load More Functionality
            document.querySelector('.load-more button').addEventListener('click', function () {
                // Add your load more logic here
                this.textContent = 'Không còn sản phẩm';
                this.disabled = true;
            });
        </script>
    </body>
</html>

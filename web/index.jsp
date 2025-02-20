<%-- 
    Document   : index
    Created on : Feb 19, 2025, 10:24:07 AM
    Author     : IUHADU
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

            /* Cart styles */
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
            }

            .cart-item-details {
                flex-grow: 1;
            }

            .cart-item-title {
                font-size: 0.9rem;
                margin-bottom: 5px;
            }

            .cart-item-price {
                color: var(--price-color);
                font-weight: 600;
            }

            .cart-item-quantity {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .quantity-btn {
                border: none;
                background: none;
                padding: 0 5px;
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
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
            <div class="container">
                <!-- Logo -->
                <a class="navbar-brand" href="#">
                    <img src="${pageContext.request.contextPath}/resources/logo.png" alt="Kingdoms Toys">
                </a>

                <!-- Toggle Button -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Main Navigation Content -->
                <div class="collapse navbar-collapse" id="navbarNav">
                    <!-- Search Bar -->
                    <form class="d-flex mx-auto search-form">
                        <div class="input-group">
                            <input class="form-control" type="search" placeholder="Tìm kiếm sản phẩm..." aria-label="Search">
                            <button class="btn btn-outline-danger" type="submit">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </form>

                    <!-- Center Navigation Links -->
                    <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" href="#">Trang chủ</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="product.jsp">Sản phẩm</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Liên hệ</a>
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
        <section class="products-section py-5">
            <div class="container">
                <h2 class="text-center mb-5">Sản phẩm nổi bật</h2>
                <div class="row">
                    <!-- Product 1 -->
                    <div class="col-md-4 mb-4">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="${pageContext.request.contextPath}/resources/images/shinwoo.jpg" alt="ShinWoo">
                            </div>
                            <div class="product-info">
                                <h3 class="product-title">FINDING UNICORN ShinWoo The Cold Hug Series Plush Blind Box</h3>
                                <p class="product-price">$13.9</p>
                                <button class="btn btn-primary w-100 add-to-cart" data-id="1">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Product 2 -->
                    <div class="col-md-4 mb-4">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="${pageContext.request.contextPath}/resources/images/rico.jpg" alt="RICO">
                            </div>
                            <div class="product-info">
                                <h3 class="product-title">FINDING UNICORN Welcome! RICO Coco Mart Series Blind Box</h3>
                                <p class="product-price">$12.9</p>
                                <button class="btn btn-primary w-100 add-to-cart" data-id="2">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Product 3 -->
                    <div class="col-md-4 mb-4">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="${pageContext.request.contextPath}/resources/images/molinta.jpg" alt="Molinta">
                            </div>
                            <div class="product-info">
                                <h3 class="product-title">FINDING UNICORN Molinta Natural Series Blind Box</h3>
                                <p class="product-price">$12.9</p>
                                <button class="btn btn-primary w-100 add-to-cart" data-id="3">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </div>
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
                    <h6>Tổng cộng: <span class="total-amount">0đ</span></h6>
                </div>
                <button class="btn btn-primary w-100 mt-3">Thanh toán</button>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <h5>Về Kingdoms Toys</h5>
                        <p>Chúng tôi là đơn vị chuyên cung cấp các sản phẩm đồ chơi chất lượng cao.</p>
                    </div>
                    <div class="col-md-4">
                        <h5>Liên kết</h5>
                        <ul class="list-unstyled">
                            <li><a href="#">Trang chủ</a></li>
                            <li><a href="#">Sản phẩm</a></li>
                            <li><a href="#">Về chúng tôi</a></li>
                            <li><a href="#">Liên hệ</a></li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h5>Liên hệ</h5>
                        <ul class="list-unstyled">
                            <li>Email: info@findingunicorn.com</li>
                            <li>Phone: (84) 123-456-789</li>
                            <li>Địa chỉ: 123 Đường ABC, Quận XYZ</li>
                        </ul>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Cart JavaScript -->
        <script>
            let cart = [];

            document.querySelectorAll('.add-to-cart').forEach(button => {
                button.addEventListener('click', function () {
                    const productId = this.dataset.id;
                    const productCard = this.closest('.product-card');
                    const product = {
                        id: productId,
                        name: productCard.querySelector('.product-title').textContent,
                        price: productCard.querySelector('.product-price').textContent,
                        image: productCard.querySelector('.product-image img').src,
                        quantity: 1
                    };

                    addToCart(product);
                    updateCartDisplay();
                });
            });

            function addToCart(product) {
                const existingItem = cart.find(item => item.id === product.id);
                if (existingItem) {
                    existingItem.quantity++;
                } else {
                    cart.push(product);
                }
                updateCartBadge();
            }

            function updateCartBadge() {
                const badge = document.querySelector('.badge');
                const total = cart.reduce((sum, item) => sum + item.quantity, 0);
                badge.textContent = total;
            }

            function updateCartDisplay() {
                const cartItems = document.querySelector('.cart-items');
                cartItems.innerHTML = cart.map(item => `
                    <div class="cart-item">
                        <img src="${item.image}" alt="${item.name}">
                        <div class="cart-item-details">
                            <h6 class="cart-item-title">${item.name}</h6>
                            <p class="cart-item-price">${item.price}</p>
                            <div class="cart-item-quantity">
                                <button class="quantity-btn" onclick="updateQuantity('${item.id}', -1)">-</button>
                                <span>${item.quantity}</span>
                                <button class="quantity-btn" onclick="updateQuantity('${item.id}', 1)">+</button>
                            </div>
                        </div>
                    </div>
                `).join('');

                updateCartTotal();
            }

            function updateQuantity(id, change) {
                const item = cart.find(item => item.id === id);
                if (item) {
                    item.quantity += change;
                    if (item.quantity <= 0) {
                        cart = cart.filter(i => i.id !== id);
                    }
                    updateCartDisplay();
                    updateCartBadge();
                }
            }

            function updateCartTotal() {
                const total = cart.reduce((sum, item) => {
                    const price = parseFloat(item.price.replace('$', ''));
                    return sum + (price * item.quantity);
                }, 0);
                document.querySelector('.total-amount').textContent = `$${total.toFixed(2)}`;
            }
        </script>
    </body>
</html>

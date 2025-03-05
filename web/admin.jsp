<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - KINGDOMS TOYS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
        <style>
            .sidebar {
                min-height: 100vh;
                background-color: #212529;
            }
            .stat-card {
                transition: transform 0.3s;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .product-image-preview {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 4px;
            }
            .image-preview {
                max-width: 100%;
                max-height: 200px;
                margin-top: 10px;
                border-radius: 4px;
            }
            .status-badge {
                width: 10px;
                height: 10px;
                display: inline-block;
                border-radius: 50%;
                margin-right: 5px;
            }
            .status-in-stock {
                background-color: #2ecc71;
            }
            .status-low-stock {
                background-color: #f1c40f;
            }
            .status-out-stock {
                background-color: #e74c3c;
            }
            .tab-pane {
                padding: 20px 0;
            }
            .nav-tabs {
                margin-bottom: 20px;
            }
            .action-btn {
                margin-right: 5px;
            }
            .nav-link {
                color: rgba(255,255,255,.6);
                padding: 10px 15px;
                border-radius: 5px;
                margin-bottom: 5px;
                transition: all 0.3s;
            }
            .nav-link:hover, .nav-link.active {
                color: #fff;
                background-color: rgba(255,255,255,.1);
            }
            .nav-link i {
                margin-right: 10px;
            }
            .admin-header {
                background-color: #f8f9fa;
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
            .table-responsive {
                margin-bottom: 30px;
            }
            .form-section {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            .order-status {
                font-weight: bold;
            }
            .status-pending {
                color: #f39c12;
            }
            .status-processing {
                color: #3498db;
            }
            .status-completed {
                color: #2ecc71;
            }
            .status-cancelled {
                color: #e74c3c;
            }
            .logo-container {
                padding: 20px;
                text-align: center;
                margin-bottom: 20px;
                border-bottom: 1px solid rgba(255,255,255,.1);
            }
            .logo-container img {
                max-width: 80%;
            }
            .admin-title {
                color: white;
                font-size: 1.2rem;
                margin-bottom: 0;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav class="col-md-2 d-none d-md-block sidebar">
                    <div class="logo-container">
                        <img src="${pageContext.request.contextPath}/resources/logo.png" alt="Kingdoms Toys" class="img-fluid">
                        <h5 class="admin-title mt-3">Admin Panel</h5>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="#dashboard" data-bs-toggle="pill">
                                <i class="bi bi-speedometer2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#products" data-bs-toggle="pill">
                                <i class="bi bi-box-seam"></i> Quản lý sản phẩm
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#orders" data-bs-toggle="pill">
                                <i class="bi bi-cart3"></i> Quản lý đơn hàng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#users" data-bs-toggle="pill">
                                <i class="bi bi-people"></i> Quản lý người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#categories" data-bs-toggle="pill">
                                <i class="bi bi-tags"></i> Danh mục
                            </a>
                        </li>
                        <li class="nav-item mt-5">
                            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right"></i> Đăng xuất
                            </a>
                        </li>
                    </ul>
                </nav>

                <!-- Main content -->
                <main class="col-md-10 ms-sm-auto px-md-4 py-4">
                    <div class="tab-content">
                        <!-- Dashboard Tab -->
                        <div class="tab-pane fade show active" id="dashboard">
                            <div class="admin-header d-flex justify-content-between align-items-center">
                                <h1 class="h2">Dashboard</h1>
                                <div>
                                    <span class="me-2">Xin chào, Admin</span>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-house"></i> Về trang chủ
                                    </a>
                                </div>
                            </div>

                            <!-- Statistics Cards -->
                            <div class="row mb-4">
                                <div class="col-md-3 mb-3">
                                    <div class="card bg-primary text-white stat-card h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between">
                                                <div>
                                                    <h6 class="card-title">Tổng doanh thu</h6>
                                                    <h3 class="card-text">
                                                        <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/>
                                                    </h3>
                                                </div>
                                                <i class="bi bi-currency-dollar fs-1"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <div class="card bg-success text-white stat-card h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between">
                                                <div>
                                                    <h6 class="card-title">Đơn hàng mới</h6>
                                                    <h3 class="card-text">${newOrdersCount}</h3>
                                                </div>
                                                <i class="bi bi-bag fs-1"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <div class="card bg-warning text-white stat-card h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between">
                                                <div>
                                                    <h6 class="card-title">Sản phẩm</h6>
                                                    <h3 class="card-text">${totalProducts}</h3>
                                                </div>
                                                <i class="bi bi-box fs-1"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <div class="card bg-danger text-white stat-card h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between">
                                                <div>
                                                    <h6 class="card-title">Người dùng</h6>
                                                    <h3 class="card-text">${totalUsers}</h3>
                                                </div>
                                                <i class="bi bi-people fs-1"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Orders -->
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Đơn hàng gần đây</h5>
                                    <a href="#orders" data-bs-toggle="pill" class="btn btn-sm btn-primary">Xem tất cả</a>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Khách hàng</th>
                                                    <th>Ngày đặt</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${recentOrders}" var="order" end="4">
                                                    <tr>
                                                        <td>${order.orderId}</td>
                                                        <td>${order.customerName}</td>
                                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                                        <td>
                                                            <span class="badge ${order.status eq 'Đang xử lý' ? 'bg-warning' : 
                                                                                 order.status eq 'Hoàn thành' ? 'bg-success' : 
                                                                                 order.status eq 'Đã hủy' ? 'bg-danger' : 'bg-info'}">
                                                                      ${order.status}
                                                                  </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <!-- Low Stock Products -->
                                <div class="card mb-4">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">Sản phẩm sắp hết hàng</h5>
                                        <a href="#products" data-bs-toggle="pill" class="btn btn-sm btn-primary">Quản lý kho</a>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Hình ảnh</th>
                                                        <th>Tên sản phẩm</th>
                                                        <th>Tồn kho</th>
                                                        <th>Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${lowStockProducts}" var="product" end="4">
                                                        <tr>
                                                            <td>${product.productId}</td>
                                                            <td>
                                                                <img src="${pageContext.request.contextPath}/${product.imageUrl}" 
                                                                     alt="${product.name}" class="product-image-preview">
                                                            </td>
                                                            <td>${product.name}</td>
                                                            <td>
                                                                <span class="badge bg-warning">${product.stockQuantity}</span>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-sm btn-primary update-stock-btn" 
                                                                        data-id="${product.productId}" 
                                                                        data-name="${product.name}"
                                                                        data-bs-toggle="modal" 
                                                                        data-bs-target="#updateStockModal">
                                                                    Cập nhật tồn kho
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Products Tab -->
                            <div class="tab-pane fade" id="products">
                                <div class="admin-header d-flex justify-content-between align-items-center">
                                    <h1 class="h2">Quản lý sản phẩm</h1>
                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                                        <i class="bi bi-plus-circle"></i> Thêm sản phẩm mới
                                    </button>
                                </div>

                                <!-- Search and Filter -->
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <form id="productFilterForm" class="row g-3">
                                            <div class="col-md-3">
                                                <label for="categoryFilter" class="form-label">Danh mục</label>
                                                <select class="form-select" id="categoryFilter" name="category">
                                                    <option value="">Tất cả danh mục</option>
                                                    <c:forEach items="${categories}" var="category">
                                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label for="priceMin" class="form-label">Giá từ</label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control" id="priceMin" name="priceMin" min="0">
                                                    <span class="input-group-text">₫</span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <label for="priceMax" class="form-label">Giá đến</label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control" id="priceMax" name="priceMax" min="0">
                                                    <span class="input-group-text">₫</span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <label for="stockFilter" class="form-label">Tồn kho</label>
                                                <select class="form-select" id="stockFilter" name="stock">
                                                    <option value="">Tất cả</option>
                                                    <option value="low">Sắp hết hàng (< 10)</option>
                                                    <option value="out">Hết hàng (0)</option>
                                                    <option value="available">Còn hàng (> 0)</option>
                                                </select>
                                            </div>
                                            <div class="col-12 mt-3">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-search"></i> Lọc
                                                </button>
                                                <button type="reset" class="btn btn-secondary">
                                                    <i class="bi bi-arrow-counterclockwise"></i> Đặt lại
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Products Table -->
                                <div class="card">
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table id="productsTable" class="table table-striped table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Hình ảnh</th>
                                                        <th>Tên sản phẩm</th>
                                                        <th>Danh mục</th>
                                                        <th>Giá</th>
                                                        <th>Tồn kho</th>
                                                        <th>Nổi bật</th>
                                                        <th>Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${products}" var="product">
                                                        <tr>
                                                            <td>${product.productId}</td>
                                                            <td>
                                                                <img src="${pageContext.request.contextPath}/${product.imageUrl}" 
                                                                     alt="${product.name}" class="product-image-preview">
                                                            </td>
                                                            <td>${product.name}</td>
                                                            <td>${product.categoryName}</td>
                                                            <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/></td>
                                                            <td>
                                                                <span class="badge ${product.stockQuantity == 0 ? 'bg-danger' : 
                                                                                     product.stockQuantity < 10 ? 'bg-warning' : 'bg-success'}">
                                                                          ${product.stockQuantity}
                                                                      </span>
                                                                </td>
                                                                <td>
                                                                    <div class="form-check form-switch">
                                                                        <input class="form-check-input toggle-featured" type="checkbox" 
                                                                               data-product-id="${product.productId}" 
                                                                               ${product.isFeatured ? 'checked' : ''}>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <button class="btn btn-sm btn-info view-product-btn" data-id="${product.productId}">
                                                                        <i class="bi bi-eye"></i>
                                                                    </button>
                                                                    <button class="btn btn-sm btn-primary edit-product-btn" data-id="${product.productId}" 
                                                                            data-bs-toggle="modal" data-bs-target="#editProductModal">
                                                                        <i class="bi bi-pencil"></i>
                                                                    </button>
                                                                    <button class="btn btn-sm btn-danger delete-product-btn" data-id="${product.productId}" 
                                                                            data-bs-toggle="modal" data-bs-target="#deleteProductModal">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Orders Tab -->
                                <div class="tab-pane fade" id="orders">
                                    <div class="admin-header d-flex justify-content-between align-items-center">
                                        <h1 class="h2">Quản lý đơn hàng</h1>
                                    </div>

                                    <!-- Search and Filter -->
                                    <div class="card mb-4">
                                        <div class="card-body">
                                            <form id="orderFilterForm" class="row g-3">
                                                <div class="col-md-3">
                                                    <label for="orderStatus" class="form-label">Trạng thái</label>
                                                    <select class="form-select" id="orderStatus" name="status">
                                                        <option value="">Tất cả trạng thái</option>
                                                        <option value="pending">Chờ xử lý</option>
                                                        <option value="processing">Đang xử lý</option>
                                                        <option value="completed">Hoàn thành</option>
                                                        <option value="cancelled">Đã hủy</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-3">
                                                    <label for="orderDateFrom" class="form-label">Từ ngày</label>
                                                    <input type="date" class="form-control" id="orderDateFrom" name="dateFrom">
                                                </div>
                                                <div class="col-md-3">
                                                    <label for="orderDateTo" class="form-label">Đến ngày</label>
                                                    <input type="date" class="form-control" id="orderDateTo" name="dateTo">
                                                </div>
                                                <div class="col-md-3">
                                                    <label for="orderSearch" class="form-label">Tìm kiếm</label>
                                                    <input type="text" class="form-control" id="orderSearch" name="search" 
                                                           placeholder="ID, tên khách hàng...">
                                                </div>
                                                <div class="col-12 mt-3">
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="bi bi-search"></i> Lọc
                                                    </button>
                                                    <button type="reset" class="btn btn-secondary">
                                                        <i class="bi bi-arrow-counterclockwise"></i> Đặt lại
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Orders Table -->
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table id="ordersTable" class="table table-striped table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Khách hàng</th>
                                                            <th>Ngày đặt</th>
                                                            <th>Tổng tiền</th>
                                                            <th>Trạng thái</th>
                                                            <th>Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${orders}" var="order">
                                                            <tr>
                                                                <td>${order.orderId}</td>
                                                                <td>${order.customerName}</td>
                                                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                                                <td>
                                                                    <span class="badge ${order.status eq 'Chờ xử lý' ? 'bg-warning' : 
                                                                                         order.status eq 'Đang xử lý' ? 'bg-info' : 
                                                                                         order.status eq 'Hoàn thành' ? 'bg-success' : 'bg-danger'}">
                                                                              ${order.status}
                                                                          </span>
                                                                    </td>
                                                                    <td>
                                                                        <button class="btn btn-sm btn-info view-order-btn" data-id="${order.orderId}" 
                                                                                data-bs-toggle="modal" data-bs-target="#viewOrderModal">
                                                                            <i class="bi bi-eye"></i>
                                                                        </button>
                                                                        <button class="btn btn-sm btn-primary update-status-btn" data-id="${order.orderId}" 
                                                                                data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                                                                            <i class="bi bi-pencil"></i> Cập nhật
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Users Tab -->
                                    <div class="tab-pane fade" id="users">
                                        <div class="admin-header d-flex justify-content-between align-items-center">
                                            <h1 class="h2">Quản lý người dùng</h1>
                                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                                <i class="bi bi-plus-circle"></i> Thêm người dùng mới
                                            </button>
                                        </div>

                                        <!-- Search and Filter -->
                                        <div class="card mb-4">
                                            <div class="card-body">
                                                <form id="userFilterForm" class="row g-3">
                                                    <div class="col-md-4">
                                                        <label for="userRole" class="form-label">Vai trò</label>
                                                        <select class="form-select" id="userRole" name="role">
                                                            <option value="">Tất cả vai trò</option>
                                                            <option value="admin">Admin</option>
                                                            <option value="customer">Khách hàng</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label for="userStatus" class="form-label">Trạng thái</label>
                                                        <select class="form-select" id="userStatus" name="status">
                                                            <option value="">Tất cả trạng thái</option>
                                                            <option value="active">Đang hoạt động</option>
                                                            <option value="inactive">Đã vô hiệu hóa</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label for="userSearch" class="form-label">Tìm kiếm</label>
                                                        <input type="text" class="form-control" id="userSearch" name="search" 
                                                               placeholder="Tên, email, số điện thoại...">
                                                    </div>
                                                    <div class="col-12 mt-3">
                                                        <button type="submit" class="btn btn-primary">
                                                            <i class="bi bi-search"></i> Lọc
                                                        </button>
                                                        <button type="reset" class="btn btn-secondary">
                                                            <i class="bi bi-arrow-counterclockwise"></i> Đặt lại
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>

                                        <!-- Users Table -->
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="table-responsive">
                                                    <table id="usersTable" class="table table-striped table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Họ tên</th>
                                                                <th>Email</th>
                                                                <th>Số điện thoại</th>
                                                                <th>Vai trò</th>
                                                                <th>Trạng thái</th>
                                                                <th>Ngày tạo</th>
                                                                <th>Thao tác</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${users}" var="user">
                                                                <tr>
                                                                    <td>${user.userId}</td>
                                                                    <td>${user.fullName}</td>
                                                                    <td>${user.email}</td>
                                                                    <td>${user.phone}</td>
                                                                    <td>
                                                                        <span class="badge ${user.role eq 'admin' ? 'bg-danger' : 'bg-info'}">
                                                                            ${user.role eq 'admin' ? 'Admin' : 'Khách hàng'}
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <span class="badge ${user.status eq 'active' ? 'bg-success' : 'bg-secondary'}">
                                                                            ${user.status eq 'active' ? 'Đang hoạt động' : 'Vô hiệu hóa'}
                                                                        </span>
                                                                    </td>
                                                                    <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></td>
                                                                    <td>
                                                                        <button class="btn btn-sm btn-info view-user-btn" data-id="${user.userId}" 
                                                                                data-bs-toggle="modal" data-bs-target="#viewUserModal">
                                                                            <i class="bi bi-eye"></i>
                                                                        </button>
                                                                        <button class="btn btn-sm btn-primary edit-user-btn" data-id="${user.userId}" 
                                                                                data-bs-toggle="modal" data-bs-target="#editUserModal">
                                                                            <i class="bi bi-pencil"></i>
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Categories Tab -->
                                    <div class="tab-pane fade" id="categories">
                                        <div class="admin-header d-flex justify-content-between align-items-center">
                                            <h1 class="h2">Quản lý danh mục</h1>
                                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                                                <i class="bi bi-plus-circle"></i> Thêm danh mục mới
                                            </button>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-8">
                                                <div class="card">
                                                    <div class="card-body">
                                                        <div class="table-responsive">
                                                            <table id="categoriesTable" class="table table-striped table-hover">
                                                                <thead>
                                                                    <tr>
                                                                        <th>ID</th>
                                                                        <th>Tên danh mục</th>
                                                                        <th>Số sản phẩm</th>
                                                                        <th>Thao tác</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach items="${categories}" var="category">
                                                                        <tr>
                                                                            <td>${category.categoryId}</td>
                                                                            <td>${category.categoryName}</td>
                                                                            <td>${category.productCount}</td>
                                                                            <td>
                                                                                <button class="btn btn-sm btn-primary edit-category-btn" 
                                                                                        data-id="${category.categoryId}" 
                                                                                        data-name="${category.categoryName}"
                                                                                        data-bs-toggle="modal" 
                                                                                        data-bs-target="#editCategoryModal">
                                                                                    <i class="bi bi-pencil"></i>
                                                                                </button>
                                                                                <button class="btn btn-sm btn-danger delete-category-btn" 
                                                                                        data-id="${category.categoryId}" 
                                                                                        data-name="${category.categoryName}"
                                                                                        data-count="${category.productCount}"
                                                                                        data-bs-toggle="modal" 
                                                                                        data-bs-target="#deleteCategoryModal">
                                                                                    <i class="bi bi-trash"></i>
                                                                                </button>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </main>
                        </div>
                    </div>

                    <!-- MODALS -->

                    <!-- Add Product Modal -->
                    <div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Thêm sản phẩm mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="addProductForm" action="${pageContext.request.contextPath}/admin/add-product" method="post" enctype="multipart/form-data">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="productName" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="productName" name="productName" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="productCategory" class="form-label">Danh mục <span class="text-danger">*</span></label>
                                                <select class="form-select" id="productCategory" name="categoryId" required>
                                                    <option value="">Chọn danh mục</option>
                                                    <c:forEach items="${categories}" var="category">
                                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="productPrice" class="form-label">Giá <span class="text-danger">*</span></label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control" id="productPrice" name="price" min="0" required>
                                                    <span class="input-group-text">₫</span>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="productStock" class="form-label">Số lượng tồn kho <span class="text-danger">*</span></label>
                                                <input type="number" class="form-control" id="productStock" name="stockQuantity" min="0" required>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="productDescription" class="form-label">Mô tả sản phẩm</label>
                                            <textarea class="form-control" id="productDescription" name="description" rows="4"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="productImage" class="form-label">Hình ảnh sản phẩm</label>
                                            <input type="file" class="form-control" id="productImage" name="imageFile" accept="image/*">
                                            <div id="imagePreview" class="mt-2"></div>
                                        </div>
                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="checkbox" id="productFeatured" name="featured">
                                            <label class="form-check-label" for="productFeatured">
                                                Sản phẩm nổi bật
                                            </label>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Product Modal -->
                    <div class="modal fade" id="editProductModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Chỉnh sửa sản phẩm</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="editProductForm" action="${pageContext.request.contextPath}/admin/update-product" method="post" enctype="multipart/form-data">
                                        <input type="hidden" id="editProductId" name="productId">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="editProductName" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="editProductName" name="productName" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="editProductCategory" class="form-label">Danh mục <span class="text-danger">*</span></label>
                                                <select class="form-select" id="editProductCategory" name="categoryId" required>
                                                    <option value="">Chọn danh mục</option>
                                                    <c:forEach items="${categories}" var="category">
                                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="editProductPrice" class="form-label">Giá <span class="text-danger">*</span></label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control" id="editProductPrice" name="price" min="0" required>
                                                    <span class="input-group-text">₫</span>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="editProductStock" class="form-label">Số lượng tồn kho <span class="text-danger">*</span></label>
                                                <input type="number" class="form-control" id="editProductStock" name="stockQuantity" min="0" required>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="editProductDescription" class="form-label">Mô tả sản phẩm</label>
                                            <textarea class="form-control" id="editProductDescription" name="description" rows="4"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="editProductImage" class="form-label">Hình ảnh sản phẩm</label>
                                            <input type="file" class="form-control" id="editProductImage" name="imageFile" accept="image/*">
                                            <div id="editImagePreview" class="mt-2"></div>
                                            <input type="hidden" id="currentImageUrl" name="currentImageUrl">
                                        </div>
                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="checkbox" id="editProductFeatured" name="featured">
                                            <label class="form-check-label" for="editProductFeatured">
                                                Sản phẩm nổi bật
                                            </label>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Delete Product Modal -->
                    <div class="modal fade" id="deleteProductModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Xác nhận xóa</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Bạn có chắc chắn muốn xóa sản phẩm này không?</p>
                                    <p class="text-danger">Hành động này không thể hoàn tác.</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <form id="deleteProductForm" action="${pageContext.request.contextPath}/admin/delete-product" method="post">
                                        <input type="hidden" id="deleteProductId" name="productId">
                                        <button type="submit" class="btn btn-danger">Xóa</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- View Order Modal -->
                    <div class="modal fade" id="viewOrderModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Chi tiết đơn hàng</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <h6>Thông tin đơn hàng</h6>
                                            <p><strong>Mã đơn hàng:</strong> <span id="orderIdDetail"></span></p>
                                            <p><strong>Ngày đặt:</strong> <span id="orderDateDetail"></span></p>
                                            <p><strong>Trạng thái:</strong> <span id="orderStatusDetail"></span></p>
                                            <p><strong>Phương thức thanh toán:</strong> <span id="paymentMethodDetail"></span></p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6>Thông tin khách hàng</h6>
                                            <p><strong>Họ tên:</strong> <span id="customerNameDetail"></span></p>
                                            <p><strong>Email:</strong> <span id="customerEmailDetail"></span></p>
                                            <p><strong>Số điện thoại:</strong> <span id="customerPhoneDetail"></span></p>
                                            <p><strong>Địa chỉ:</strong> <span id="customerAddressDetail"></span></p>
                                        </div>
                                    </div>
                                    <h6>Sản phẩm</h6>
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>Đơn giá</th>
                                                    <th>Số lượng</th>
                                                    <th>Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody id="orderItemsDetail">
                                                <!-- Order items will be inserted here -->
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="3" class="text-end"><strong>Tổng cộng:</strong></td>
                                                    <td id="orderTotalDetail"></td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                    <div class="mb-3">
                                        <h6>Ghi chú</h6>
                                        <p id="orderNoteDetail" class="fst-italic"></p>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    <button type="button" class="btn btn-primary" id="printOrderBtn">
                                        <i class="bi bi-printer"></i> In đơn hàng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Update Order Status Modal -->
                    <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Cập nhật trạng thái đơn hàng</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="updateOrderStatusForm" action="${pageContext.request.contextPath}/admin/update-order-status" method="post">
                                        <input type="hidden" id="updateOrderId" name="orderId">
                                        <div class="mb-3">
                                            <label for="orderStatusUpdate" class="form-label">Trạng thái mới</label>
                                            <select class="form-select" id="orderStatusUpdate" name="status" required>
                                                <option value="pending">Chờ xử lý</option>
                                                <option value="processing">Đang xử lý</option>
                                                <option value="shipping">Đang giao hàng</option>
                                                <option value="completed">Hoàn thành</option>
                                                <option value="cancelled">Đã hủy</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="statusNote" class="form-label">Ghi chú (tùy chọn)</label>
                                            <textarea class="form-control" id="statusNote" name="note" rows="3"></textarea>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add User Modal -->
                    <div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Thêm người dùng mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="addUserForm" action="${pageContext.request.contextPath}/admin/add-user" method="post">
                                        <div class="mb-3">
                                            <label for="userName" class="form-label">Họ tên <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="userName" name="fullName" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="userEmail" class="form-label">Email <span class="text-danger">*</span></label>
                                            <input type="email" class="form-control" id="userEmail" name="email" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="userPhone" class="form-label">Số điện thoại</label>
                                            <input type="tel" class="form-control" id="userPhone" name="phone">
                                        </div>
                                        <div class="mb-3">
                                            <label for="userPassword" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                            <input type="password" class="form-control" id="userPassword" name="password" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="userRole" class="form-label">Vai trò <span class="text-danger">*</span></label>
                                            <select class="form-select" id="userRole" name="role" required>
                                                <option value="customer">Khách hàng</option>
                                                <option value="admin">Admin</option>
                                            </select>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Thêm người dùng</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit User Modal -->
                    <div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Chỉnh sửa người dùng</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="editUserForm" action="${pageContext.request.contextPath}/admin/update-user" method="post">
                                        <input type="hidden" id="editUserId" name="userId">
                                        <div class="mb-3">
                                            <label for="editUserName" class="form-label">Họ tên <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="editUserName" name="fullName" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="editUserEmail" class="form-label">Email <span class="text-danger">*</span></label>
                                            <input type="email" class="form-control" id="editUserEmail" name="email" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="editUserPhone" class="form-label">Số điện thoại</label>
                                            <input type="tel" class="form-control" id="editUserPhone" name="phone">
                                        </div>
                                        <div class="mb-3">
                                            <label for="editUserPassword" class="form-label">Mật khẩu mới (để trống nếu không thay đổi)</label>
                                            <input type="password" class="form-control" id="editUserPassword" name="password">
                                        </div>
                                        <div class="mb-3">
                                            <label for="editUserRole" class="form-label">Vai trò <span class="text-danger">*</span></label>
                                            <select class="form-select" id="editUserRole" name="role" required>
                                                <option value="customer">Khách hàng</option>
                                                <option value="admin">Admin</option>
                                            </select>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add Category Modal -->
                    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Thêm danh mục mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="addCategoryForm" action="${pageContext.request.contextPath}/admin/add-category" method="post">
                                        <div class="mb-3">
                                            <label for="categoryName" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Thêm danh mục</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Category Modal -->
                    <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Chỉnh sửa danh mục</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="editCategoryForm" action="${pageContext.request.contextPath}/admin/update-category" method="post">
                                        <input type="hidden" id="editCategoryId" name="categoryId">
                                        <div class="mb-3">
                                            <label for="editCategoryName" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="editCategoryName" name="categoryName" required>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Delete Category Modal -->
                    <div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Xác nhận xóa</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Bạn có chắc chắn muốn xóa danh mục "<span id="deleteCategoryName"></span>"?</p>
                                    <div id="categoryWarning" class="alert alert-warning d-none">
                                        <i class="bi bi-exclamation-triangle-fill"></i> Danh mục này đang chứa <span id="productCount"></span> sản phẩm. 
                                        Nếu xóa, các sản phẩm này sẽ không có danh mục.
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <form id="deleteCategoryForm" action="${pageContext.request.contextPath}/admin/delete-category" method="post">
                                        <input type="hidden" id="deleteCategoryId" name="categoryId">
                                        <button type="submit" class="btn btn-danger">Xóa</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Update Stock Modal -->
                    <div class="modal fade" id="updateStockModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Cập nhật tồn kho</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Cập nhật tồn kho cho sản phẩm: <strong id="updateStockProductName"></strong></p>
                                    <form id="updateStockForm" action="${pageContext.request.contextPath}/admin/update-stock" method="post">
                                        <input type="hidden" id="updateStockProductId" name="productId">
                                        <div class="mb-3">
                                            <label for="newStockQuantity" class="form-label">Số lượng tồn kho mới</label>
                                            <input type="number" class="form-control" id="newStockQuantity" name="stockQuantity" min="0" required>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- View User Modal -->
                    <div class="modal fade" id="viewUserModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Thông tin người dùng</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Thông tin cá nhân</h6>
                                            <p><strong>Họ tên:</strong> <span id="viewUserName"></span></p>
                                            <p><strong>Email:</strong> <span id="viewUserEmail"></span></p>
                                            <p><strong>Số điện thoại:</strong> <span id="viewUserPhone"></span></p>
                                            <p><strong>Vai trò:</strong> <span id="viewUserRole"></span></p>
                                            <p><strong>Trạng thái:</strong> <span id="viewUserStatus"></span></p>
                                            <p><strong>Ngày tạo:</strong> <span id="viewUserCreatedAt"></span></p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6>Địa chỉ</h6>
                                            <p><span id="viewUserAddress"></span></p>
                                        </div>
                                    </div>
                                    <hr>
                                    <h6>Lịch sử đơn hàng</h6>
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Mã đơn hàng</th>
                                                    <th>Ngày đặt</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody id="userOrderHistory">
                                                <!-- User order history will be inserted here -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>



                    <!-- Thêm các thư viện JavaScript cần thiết -->

                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
                    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>

                    <!-- JavaScript cho trang admin -->
                    <script>
                        var contextPath = '/PROJECT';

                        $(document).ready(function () {
                            // Khởi tạo DataTables
                            $('#productsTable').DataTable({
                                "language": {
                                    "url": "//cdn.datatables.net/plug-ins/1.11.5/i18n/vi.json"
                                }
                            });

                            $('#ordersTable').DataTable({
                                "language": {
                                    "url": "//cdn.datatables.net/plug-ins/1.11.5/i18n/vi.json"
                                }
                            });

                            $('#usersTable').DataTable({
                                "language": {
                                    "url": "//cdn.datatables.net/plug-ins/1.11.5/i18n/vi.json"
                                }
                            });

                            // Xử lý chuyển tab dựa trên hash URL
                            function activateTabFromHash() {
                                var hash = window.location.hash;
                                if (hash) {
                                    $('.tab-pane').removeClass('active show');
                                    $(hash).addClass('active show');
                                    $('.nav-link').removeClass('active');
                                    $('.nav-link[href="' + hash + '"]').addClass('active');
                                }
                            }

                            activateTabFromHash();
                            $(window).on('hashchange', activateTabFromHash);

                            // Xử lý nút xem chi tiết sản phẩm
                            $('.view-product-btn').click(function () {
                                var productId = $(this).data('id');
                                // Gọi AJAX để lấy thông tin sản phẩm
                                $.ajax({
                                    url: contextPath + '/admin/get-product',
                                    type: 'GET',
                                    data: {productId: productId},
                                    success: function (product) {
                                        // Hiển thị thông tin sản phẩm trong modal
                                        alert("Xem sản phẩm ID: " + productId);
                                    },
                                    error: function (xhr, status, error) {
                                        alert('Lỗi khi lấy thông tin sản phẩm: ' + error);
                                    }
                                });
                            });

                            // Xử lý nút sửa sản phẩm
                            $('.edit-product-btn').click(function () {
                                var productId = $(this).data('id');
                                // Gọi AJAX để lấy thông tin sản phẩm
                                $.ajax({
                                    url: contextPath + '/admin/get-product',
                                    type: 'GET',
                                    data: {productId: productId},
                                    success: function (product) {
                                        // Điền thông tin sản phẩm vào form sửa
                                        $('#editProductId').val(product.productId);
                                        $('#editProductName').val(product.name);
                                        $('#editProductCategory').val(product.categoryId);
                                        $('#editProductPrice').val(product.price);
                                        $('#editProductStock').val(product.stockQuantity);
                                        $('#editProductDescription').val(product.description);
                                        $('#editImagePreview').attr('src', product.imageUrl);
                                        $('#currentImageUrl').val(product.imageUrl);
                                        $('#editProductFeatured').prop('checked', product.isFeatured);
                                    },
                                    error: function (xhr, status, error) {
                                        alert('Lỗi khi lấy thông tin sản phẩm: ' + error);
                                    }
                                });
                            });

                            // Xử lý nút xóa sản phẩm
                            $('.delete-product-btn').click(function () {
                                var productId = $(this).data('id');
                                $('#deleteProductId').val(productId);
                            });

                            // Xử lý toggle featured
                            $('.toggle-featured').change(function () {
                                var productId = $(this).data('product-id');
                                var featured = $(this).prop('checked');

                                $.ajax({
                                    url: contextPath + '/admin/toggle-featured',
                                    type: 'POST',
                                    data: {
                                        productId: productId,
                                        featured: featured
                                    },
                                    success: function (response) {
                                        // Thông báo thành công
                                    },
                                    error: function (xhr, status, error) {
                                        alert('Lỗi khi cập nhật trạng thái nổi bật: ' + error);
                                        // Hoàn tác trạng thái switch
                                        $(this).prop('checked', !featured);
                                    }
                                });
                            });

                            // Xử lý nút cập nhật tồn kho
                            $('.update-stock-btn').click(function () {
                                var productId = $(this).data('id');
                                var productName = $(this).data('name');

                                $('#updateStockProductId').val(productId);
                                $('#updateStockProductName').text(productName);

                                // Lấy số lượng tồn kho hiện tại
                                $.ajax({
                                    url: contextPath + '/admin/get-product-stock',
                                    type: 'GET',
                                    data: {productId: productId},
                                    success: function (stockQuantity) {
                                        $('#newStockQuantity').val(stockQuantity);
                                    },
                                    error: function (xhr, status, error) {
                                        alert('Lỗi khi lấy thông tin tồn kho: ' + error);
                                    }
                                });
                            });
                        });


                        // Xử lý chuyển tab dựa trên hash URL
                        function activateTabFromHash() {
                            var hash = window.location.hash;
                            if (hash) {
                                $('.tab-pane').removeClass('active show');
                                $(hash).addClass('active show');
                                $('.nav-link').removeClass('active');
                                $('.nav-link[href="' + hash + '"]').addClass('active');
                            } else {
                                $('#dashboard').addClass('active show');
                                $('.nav-link[href="#dashboard"]').addClass('active');
                            }
                        }

                        activateTabFromHash();
                        $(window).on('hashchange', activateTabFromHash);

                        // Xử lý nút xem chi tiết sản phẩm
                        $('.view-product-btn').click(function () {
                            var productId = $(this).data('id');
                            // Gọi AJAX để lấy thông tin sản phẩm
                            $.ajax({
                                url: contextPath + '/admin/get-product',
                                type: 'GET',
                                data: {productId: productId},
                                success: function (product) {
                                    // Hiển thị thông tin sản phẩm trong modal
                                    alert("Xem sản phẩm ID: " + productId);
                                },
                                error: function (xhr, status, error) {
                                    alert('Lỗi khi lấy thông tin sản phẩm: ' + error);
                                }
                            });
                        });

                        // Xử lý nút sửa sản phẩm
                        $('.edit-product-btn').click(function () {
                            var productId = $(this).data('id');
                            // Gọi AJAX để lấy thông tin sản phẩm
                            $.ajax({
                                url: contextPath + '/admin/get-product',
                                type: 'GET',
                                data: {productId: productId},
                                success: function (product) {
                                    // Điền thông tin sản phẩm vào form sửa
                                    $('#editProductId').val(product.productId);
                                    $('#editProductName').val(product.name);
                                    $('#editCategoryId').val(product.categoryId);
                                    $('#editPrice').val(product.price);
                                    $('#editStockQuantity').val(product.stockQuantity);
                                    $('#editDescription').val(product.description);
                                    $('#currentImagePreview').attr('src', product.imageUrl);
                                    $('#currentImageUrl').val(product.imageUrl);
                                    $('#editFeatured').prop('checked', product.featured);
                                },
                                error: function (xhr, status, error) {
                                    alert('Lỗi khi lấy thông tin sản phẩm: ' + error);
                                }
                            });
                        });

                        // Xử lý nút xóa sản phẩm
                        $('.delete-product-btn').click(function () {
                            var productId = $(this).data('id');
                            $('#deleteProductId').val(productId);
                        });

                        // Xử lý toggle featured
                        $('.toggle-featured').change(function () {
                            var productId = $(this).data('product-id');
                            var featured = $(this).prop('checked');

                            $.ajax({
                                url: contextPath + '/admin/toggle-featured',
                                type: 'POST',
                                data: {
                                    productId: productId,
                                    featured: featured
                                },
                                success: function (response) {
                                    // Thông báo thành công
                                },
                                error: function (xhr, status, error) {
                                    alert('Lỗi khi cập nhật trạng thái nổi bật: ' + error);
                                    // Hoàn tác trạng thái switch
                                    $(this).prop('checked', !featured);
                                }
                            });
                        });

                        // Xử lý nút cập nhật tồn kho
                        $('.update-stock-btn').click(function () {
                            var productId = $(this).data('id');
                            var productName = $(this).data('name');

                            $('#stockProductId').val(productId);
                            $('#stockProductName').text(productName);

                            // Lấy số lượng tồn kho hiện tại
                            $.ajax({
                                url: contextPath + '/admin/get-product-stock',
                                type: 'GET',
                                data: {productId: productId},
                                success: function (stockQuantity) {
                                    $('#newStockQuantity').val(stockQuantity);
                                },
                                error: function (xhr, status, error) {
                                    alert('Lỗi khi lấy thông tin tồn kho: ' + error);
                                }
                            });
                        });

                        // Xử lý nút xem chi tiết đơn hàng
                        $('.view-order-btn').click(function () {
                            var orderId = $(this).data('id');

                            $.ajax({
                                url: contextPath + '/admin/get-order',
                                type: 'GET',
                                data: {orderId: orderId},
                                success: function (order) {
                                    // Điền thông tin đơn hàng vào modal
                                    $('#orderDetailId').text(order.orderId);
                                    $('#orderDetailDate').text(new Date(order.orderDate).toLocaleString('vi-VN'));
                                    $('#orderDetailCustomer').text(order.customerName || 'Khách vãng lai');
                                    $('#orderDetailEmail').text(order.customerEmail || 'N/A');
                                    $('#orderDetailPhone').text(order.customerPhone || 'N/A');
                                    $('#orderDetailAddress').text(order.shippingAddress || 'N/A');
                                    $('#orderDetailTotal').text(new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(order.totalAmount));

                                    // Hiển thị trạng thái đơn hàng
                                    var statusClass = '';
                                    switch (order.status) {
                                        case 'Chờ xử lý':
                                            statusClass = 'text-warning';
                                            break;
                                        case 'Đang xử lý':
                                            statusClass = 'text-primary';
                                            break;
                                        case 'Đang giao hàng':
                                            statusClass = 'text-info';
                                            break;
                                        case 'Hoàn thành':
                                            statusClass = 'text-success';
                                            break;
                                        case 'Đã hủy':
                                            statusClass = 'text-danger';
                                            break;
                                    }
                                    $('#orderDetailStatus').text(order.status).removeClass().addClass(statusClass);

                                    // Hiển thị chi tiết sản phẩm trong đơn hàng
                                    var itemsHtml = '';
                                    order.items.forEach(function (item) {
                                        itemsHtml +=
                                                '<tr>' +
                                                '<td>' + item.productName + '</td>' +
                                                '<td>' + item.quantity + '</td>' +
                                                '<td>' + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(item.price) + '</td>' +
                                                '<td>' + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(item.price * item.quantity) + '</td>' +
                                                '</tr>';

                                    });
                                    $('#orderItemsDetail').html(itemsHtml);

                                    // Hiển thị modal
                                    $('#viewOrderModal').modal('show');
                                },
                                error: function (xhr, status, error) {
                                    alert('Lỗi khi lấy thông tin đơn hàng: ' + error);
                                }
                            });
                        });

                        // Xử lý nút cập nhật trạng thái đơn hàng
                        $('.update-order-status-btn').click(function () {
                            var orderId = $(this).data('id');

                            $.ajax({
                                url: contextPath + '/admin/get-order-status',
                                type: 'GET',
                                data: {orderId: orderId},
                                success: function (status) {
                                    $('#orderIdUpdate').val(orderId);
                                    $('#orderStatusUpdate').val(status);
                                    $('#updateOrderStatusModal').modal('show');
                                },
                                error: function (xhr, status, error) {
                                    alert('Lỗi khi lấy trạng thái đơn hàng: ' + error);
                                }
                            });
                        });

                        // Xử lý nút xem chi tiết người dùng
                        $('.view-user-btn').click(function () {
                            var userId = $(this).data('id');

                            $.ajax({
                                url: contextPath + '/admin/get-user',
                                type: 'GET',
                                data: {userId: userId},
                                success: function (user) {
                                    // Điền thông tin người dùng vào modal
                                    $('#userDetailId').text(user.userId);
                                    $('#userDetailName').text(user.fullName);
                                    $('#userDetailEmail').text(user.email);
                                    $('#userDetailPhone').text(user.phone || 'Chưa cập nhật');
                                    $('#userDetailRole').text(user.role === 'admin' ? 'Quản trị viên' : 'Khách hàng');
                                    $('#userDetailCreatedAt').text(new Date(user.createdAt).toLocaleDateString('vi-VN'));
                                    $('#userDetailAddress').text(user.address || 'Chưa cập nhật');

                                    // Hiển thị lịch sử đơn hàng
                                    var ordersHtml = '';
                                    if (user.orders && user.orders.length > 0) {
                                        user.orders.forEach(function (order) {
                                            var statusClass = '';
                                            switch (order.status) {
                                                case 'Chờ xử lý':
                                                    statusClass = 'text-warning';
                                                    break;
                                                case 'Đang xử lý':
                                                    statusClass = 'text-primary';
                                                    break;
                                                case 'Đang giao hàng':
                                                    statusClass = 'text-info';
                                                    break;
                                                case 'Hoàn thành':
                                                    statusClass = 'text-success';
                                                    break;
                                                case 'Đã hủy':
                                                    statusClass = 'text-danger';
                                                    break;
                                            }

                                            ordersHtml +=
                                                    '<tr>' +
                                                    '<td>' + order.orderId + '</td>' +
                                                    '<td>' + new Date(order.createdAt).toLocaleDateString('vi-VN') + '</td>' +
                                                    '<td>' + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(order.totalPrice) + '</td>' +
                                                    '<td><span class="' + statusClass + '">' + order.status + '</span></td>' +
                                                    '</tr>';

                                        });
                                    } else {
                                        ordersHtml = '<tr><td colspan="4" class="text-center">Không có đơn hàng nào</td></tr>';
                                    }
                                    $('#userOrderHistory').html(ordersHtml);

                                    // Hiển thị modal
                                    $('#viewUserModal').modal('show');
                                },
                                error: function (xhr, status, error) {
                                    alert('Lỗi khi lấy thông tin người dùng: ' + error);
                                }
                            });
                        });

                        // Xử lý nút sửa người dùng
                        $('.edit-user-btn').click(function () {
                            var userId = $(this).data('id');

                            $.ajax({
                                url: contextPath + '/admin/get-user',
                                type: 'GET',
                                data: {userId: userId},
                                success: function (user) {
                                    $('#editUserId').val(user.userId);
                                    $('#editUserFullName').val(user.fullName);
                                    $('#editUserEmail').val(user.email);
                                    $('#editUserPhone').val(user.phone);
                                    $('#editUserRole').val(user.role);
                                    $('#editUserAddress').val(user.address);

                                    // Hiển thị modal
                                    $('#editUserModal').modal('show');
                                },
                                error: function (xhr, status, error) {
                                    alert('Lỗi khi lấy thông tin người dùng: ' + error);
                                }
                            });
                        });

                        // Xử lý preview ảnh khi chọn file
                        $('#productImage, #editProductImage').change(function () {
                            var file = this.files[0];
                            var reader = new FileReader();
                            var previewId = $(this).attr('id') === 'productImage' ? '#imagePreview' : '#editImagePreview';
                            reader.onload = function (e) {
                                $(previewId).attr('src', e.target.result).show();
                            };
                            if (file) {
                                reader.readAsDataURL(file);
                            }
                        });
                    </script>
                </body>
            </html>


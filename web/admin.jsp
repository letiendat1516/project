<%-- 
    Document   : admin
    Created on : Feb 23, 2025, 9:16:26 PM
    Author     : IUHADU
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        <title>Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            .sidebar {
                min-height: 100vh;
            }
            .stat-card {
                transition: transform 0.3s;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav class="col-md-2 d-none d-md-block bg-dark sidebar">
                    <div class="position-sticky pt-3">
                        <div class="text-center mb-4">
                            <h6 class="text-white">Admin Panel</h6>
                        </div>
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link active text-white" href="dashboard">
                                    <i class="bi bi-house-door me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-white" href="products">
                                    <i class="bi bi-box me-2"></i>Quản lý sản phẩm
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-white" href="categories">
                                    <i class="bi bi-tags me-2"></i>Danh mục
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-white" href="orders">
                                    <i class="bi bi-cart me-2"></i>Đơn hàng
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-white" href="users">
                                    <i class="bi bi-people me-2"></i>Người dùng
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-white" href="discounts">
                                    <i class="bi bi-ticket-perforated me-2"></i>Mã giảm giá
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-white" href="reviews">
                                    <i class="bi bi-star me-2"></i>Đánh giá
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>

                <!-- Main content -->
                <main class="col-md-10 ms-sm-auto px-md-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1>Dashboard</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-download"></i> Export
                                </button>
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle">
                                <i class="bi bi-calendar"></i> This week
                            </button>
                        </div>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card bg-primary text-white stat-card">
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
                        <div class="col-md-3">
                            <div class="card bg-success text-white stat-card">
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
                        <div class="col-md-3">
                            <div class="card bg-warning text-white stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Sản phẩm</h6>
                                            <h3 class="card-text">${totalProducts}</h3>
                                        </div>
                                        <i class="bi bi-box-seam fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card bg-info text-white stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Khách hàng</h6>
                                            <h3 class="card-text">${totalCustomers}</h3>
                                        </div>
                                        <i class="bi bi-people fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Orders & Low Stock Products -->
                    <div class="row">
                        <!-- Recent Orders -->
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Đơn hàng gần đây</h5>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Mã đơn</th>
                                                    <th>Khách hàng</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày đặt</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${recentOrders}" var="order">
                                                    <tr>
                                                        <td>#${order.orderId}</td>
                                                        <td>${order.userName}</td>
                                                        <td>
                                                            <fmt:formatNumber value="${order.totalPrice}" type="currency"/>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-${order.status == 'Pending' ? 'warning' : 
                                                                                    order.status == 'Completed' ? 'success' : 
                                                                                    order.status == 'Cancelled' ? 'danger' : 'primary'}">
                                                                      ${order.status}
                                                                  </span>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Low Stock Products -->
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Sản phẩm sắp hết hàng</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table">
                                                <thead>
                                                    <tr>
                                                        <th>Sản phẩm</th>
                                                        <th>Tồn kho</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${lowStockProducts}" var="product">
                                                        <tr>
                                                            <td>${product.name}</td>
                                                            <td>
                                                                <span class="badge bg-danger">${product.stockQuantity}</span>
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

                        <!-- Sales Chart -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Thống kê doanh thu</h5>
                                    </div>
                                    <div class="card-body">
                                        <canvas id="salesChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                // Sales Chart
                const ctx = document.getElementById('salesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ${chartLabels},
                        datasets: [{
                                label: 'Doanh thu',
                                data: ${chartData},
                                borderColor: 'rgb(75, 192, 192)',
                                tension: 0.1
                            }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            </script>
        </body>
    </html>

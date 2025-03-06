<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp" />
<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<!-- Main content -->
<main class="col-md-10 ms-sm-auto px-md-4 py-4">
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
            <a href="${pageContext.request.contextPath}/admin?page=orders" class="btn btn-sm btn-primary">Xem tất cả</a>
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
                <a href="${pageContext.request.contextPath}/admin?page=products" class="btn btn-sm btn-primary">Quản lý kho</a>
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
    </main>

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
                    <form id="updateStockForm" action="${pageContext.request.contextPath}/admin" method="post">
                        <input type="hidden" name="action" value="updateStock">
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

<jsp:include page="includes/footer.jsp" />

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar -->
<nav class="col-md-2 d-none d-md-block sidebar">
    <div class="logo-container">
        <img src="${pageContext.request.contextPath}/resources/logo.png" alt="Kingdoms Toys" class="img-fluid">
        <h5 class="admin-title mt-3">Admin Panel</h5>
    </div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?page=dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?page=products">
                <i class="bi bi-box-seam"></i> Quản lý sản phẩm
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?page=orders">
                <i class="bi bi-cart3"></i> Quản lý đơn hàng
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?page=users">
                <i class="bi bi-people"></i> Quản lý người dùng
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?page=categories">
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

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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp" />
<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="orders" />
</jsp:include>

<!-- Main content -->
<main class="col-md-10 ms-sm-auto px-md-4 py-4">
    <div class="admin-header d-flex justify-content-between align-items-center">
        <h1 class="h2">Quản lý đơn hàng</h1>
        <div>
            <button class="btn btn-outline-secondary me-2" id="exportOrdersBtn">
                <i class="bi bi-download"></i> Xuất Excel
            </button>
            <button class="btn btn-outline-secondary" id="printOrdersBtn">
                <i class="bi bi-printer"></i> In danh sách
            </button>
        </div>
    </div>

    <!-- Filter Orders -->
    <div class="card mb-4">
        <div class="card-body">
            <form id="orderFilterForm" class="row g-3">
                <div class="col-md-3">
                    <label for="orderDateFrom" class="form-label">Từ ngày</label>
                    <input type="date" class="form-control" id="orderDateFrom" name="dateFrom">
                </div>
                <div class="col-md-3">
                    <label for="orderDateTo" class="form-label">Đến ngày</label>
                    <input type="date" class="form-control" id="orderDateTo" name="dateTo">
                </div>
                <div class="col-md-3">
                    <label for="orderStatus" class="form-label">Trạng thái</label>
                    <select class="form-select" id="orderStatus" name="status">
                        <option value="">Tất cả</option>
                        <option value="Chờ xử lý">Chờ xử lý</option>
                        <option value="Đang xử lý">Đang xử lý</option>
                        <option value="Đang giao hàng">Đang giao hàng</option>
                        <option value="Hoàn thành">Hoàn thành</option>
                        <option value="Đã hủy">Đã hủy</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="orderSearch" class="form-label">Tìm kiếm</label>
                    <input type="text" class="form-control" id="orderSearch" name="search" placeholder="ID hoặc tên khách hàng">
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
                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                <td>
                                    <span class="badge ${order.status eq 'Chờ xử lý' ? 'bg-secondary' : 
                                                         order.status eq 'Đang xử lý' ? 'bg-primary' : 
                                                         order.status eq 'Đang giao hàng' ? 'bg-info' : 
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
</main>

<!-- View Order Modal -->
<div class="modal fade" id="viewOrderModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chi tiết đơn hàng #<span id="orderIdDetail"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h6>Thông tin khách hàng</h6>
                        <p><strong>Tên:</strong> <span id="customerName"></span></p>
                        <p><strong>Email:</strong> <span id="customerEmail"></span></p>
                        <p><strong>Số điện thoại:</strong> <span id="customerPhone"></span></p>
                        <p><strong>Địa chỉ giao hàng:</strong> <span id="shippingAddress"></span></p>
                    </div>
                    <div class="col-md-6">
                        <h6>Thông tin đơn hàng</h6>
                        <p><strong>Ngày đặt:</strong> <span id="orderDate"></span></p>
                        <p><strong>Trạng thái:</strong> <span id="orderStatus"></span></p>
                        <p><strong>Tổng tiền:</strong> <span id="orderTotal"></span></p>
                    </div>
                </div>
                <h6>Chi tiết sản phẩm</h6>
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
                        <tbody id="orderItems">
                            <!-- Sẽ được điền bởi JavaScript -->
                        </tbody>
                    </table>
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

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập nhật trạng thái đơn hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="updateStatusForm" action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="updateOrderStatus">
                    <input type="hidden" id="updateOrderId" name="orderId">
                    <div class="mb-3">
                        <label for="newStatus" class="form-label">Trạng thái mới</label>
                        <select class="form-select" id="newStatus" name="status" required>
                            <option value="Chờ xử lý">Chờ xử lý</option>
                            <option value="Đang xử lý">Đang xử lý</option>
                            <option value="Đang giao hàng">Đang giao hàng</option>
                            <option value="Hoàn thành">Hoàn thành</option>
                            <option value="Đã hủy">Đã hủy</option>
                        </select>
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

<script>
    $(document).ready(function() {
        // Xử lý nút xem chi tiết đơn hàng
        $('.view-order-btn').click(function() {
            var orderId = $(this).data('id');
            
            // Lấy thông tin đơn hàng từ server
            $.ajax({
                url: '${pageContext.request.contextPath}/admin',
                type: 'GET',
                data: {
                    action: 'getOrder',
                    orderId: orderId
                },
                success: function(order) {
                    // Điền thông tin đơn hàng vào modal
                    $('#orderIdDetail').text(order.orderId);
                    $('#customerName').text(order.customerName || 'Khách vãng lai');
                    $('#customerEmail').text(order.customerEmail || 'N/A');
                    $('#customerPhone').text(order.customerPhone || 'N/A');
                    $('#shippingAddress').text(order.shippingAddress || 'N/A');
                    
                    // Format date
                    var orderDate = new Date(order.orderDate);
                    $('#orderDate').text(orderDate.toLocaleString('vi-VN'));
                    
                    // Format status with badge
                    var statusClass = '';
                    switch(order.status) {
                        case 'Chờ xử lý': statusClass = 'bg-secondary'; break;
                        case 'Đang xử lý': statusClass = 'bg-primary'; break;
                        case 'Đang giao hàng': statusClass = 'bg-info'; break;
                        case 'Hoàn thành': statusClass = 'bg-success'; break;
                        case 'Đã hủy': statusClass = 'bg-danger'; break;
                    }
                    $('#orderStatus').html('<span class="badge ' + statusClass + '">' + order.status + '</span>');
                    
                    // Format total
                    $('#orderTotal').text(new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(order.totalAmount));
                    
                    // Populate order items
                    var itemsHtml = '';
                    order.items.forEach(function(item) {
                        itemsHtml += '<tr>' +
                            '<td>' + item.productName + '</td>' +
                            '<td>' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(item.price) + '</td>' +
                            '<td>' + item.quantity + '</td>' +
                            '<td>' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(item.price * item.quantity) + '</td>' +
                            '</tr>';
                    });
                    $('#orderItems').html(itemsHtml);
                },
                error: function(xhr, status, error) {
                    alert('Lỗi khi lấy thông tin đơn hàng: ' + error);
                }
            });
        });
        
        // Xử lý nút cập nhật trạng thái
        $('.update-status-btn').click(function() {
            var orderId = $(this).data('id');
            $('#updateOrderId').val(orderId);
            
            // Lấy trạng thái hiện tại
            $.ajax({
                url: '${pageContext.request.contextPath}/admin',
                type: 'GET',
                data: {
                    action: 'getOrderStatus',
                    orderId: orderId
                },
                success: function(status) {
                    $('#newStatus').val(status);
                },
                error: function(xhr, status, error) {
                    alert('Lỗi khi lấy trạng thái đơn hàng: ' + error);
                }
            });
        });
        
        // Xử lý nút in đơn hàng
        $('#printOrderBtn').click(function() {
            // Tạo cửa sổ in mới
            var printWindow = window.open('', '_blank');
            
            // Nội dung HTML cho trang in
            var printContent = '<html><head>' +
                '<title>Đơn hàng #' + $('#orderIdDetail').text() + '</title>' +
                '<style>' +
                'body { font-family: Arial, sans-serif; }' +
                '.header { text-align: center; margin-bottom: 20px; }' +
                '.info-section { margin-bottom: 20px; }' +
                'table { width: 100%; border-collapse: collapse; }' +
                'th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }' +
                'th { background-color: #f2f2f2; }' +
                '.total { text-align: right; margin-top: 20px; font-weight: bold; }' +
                '</style>' +
                '</head><body>' +
                '<div class="header">' +
                '<h2>KINGDOMS TOYS</h2>' +
                '<h3>ĐƠN HÀNG #' + $('#orderIdDetail').text() + '</h3>' +
                '</div>' +
                '<div class="info-section">' +
                '<h4>Thông tin khách hàng</h4>' +
                '<p><strong>Tên:</strong> ' + $('#customerName').text() + '</p>' +
                '<p><strong>Email:</strong> ' + $('#customerEmail').text() + '</p>' +
                '<p><strong>Số điện thoại:</strong> ' + $('#customerPhone').text() + '</p>' +
                '<p><strong>Địa chỉ giao hàng:</strong> ' + $('#shippingAddress').text() + '</p>' +
                '</div>' +
                '<div class="info-section">' +
                '<h4>Thông tin đơn hàng</h4>' +
                '<p><strong>Ngày đặt:</strong> ' + $('#orderDate').text() + '</p>' +
                '<p><strong>Trạng thái:</strong> ' + $('#orderStatus').text() + '</p>' +
                '</div>' +
                '<h4>Chi tiết sản phẩm</h4>' +
                '<table>' +
                '<thead><tr><th>Sản phẩm</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr></thead>' +
                '<tbody>' + $('#orderItems').html() + '</tbody>' +
                '</table>' +
                '<div class="total">Tổng tiền: ' + $('#orderTotal').text() + '</div>' +
                '</body></html>';
            
            // Ghi nội dung vào cửa sổ in và in
            printWindow.document.write(printContent);
            printWindow.document.close();
            printWindow.focus();
            setTimeout(function() {
                printWindow.print();
                printWindow.close();
            }, 500);
        });
    });
</script>

<jsp:include page="includes/footer.jsp" />

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp" />
<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="users" />
</jsp:include>

<!-- Main content -->
<main class="col-md-10 ms-sm-auto px-md-4 py-4">
    <div class="admin-header d-flex justify-content-between align-items-center">
        <h1 class="h2">Quản lý người dùng</h1>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
            <i class="bi bi-person-plus"></i> Thêm người dùng mới
        </button>
    </div>

    <!-- Filter Users -->
    <div class="card mb-4">
        <div class="card-body">
            <form id="userFilterForm" class="row g-3">
                <div class="col-md-4">
                    <label for="userSearch" class="form-label">Tìm kiếm</label>
                    <input type="text" class="form-control" id="userSearch" name="search" placeholder="Tên, email hoặc số điện thoại">
                </div>
                <div class="col-md-4">
                    <label for="userRole" class="form-label">Vai trò</label>
                    <select class="form-select" id="userRole" name="role">
                        <option value="">Tất cả</option>
                        <option value="admin">Admin</option>
                        <option value="customer">Khách hàng</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="userStatus" class="form-label">Trạng thái</label>
                    <select class="form-select" id="userStatus" name="status">
                        <option value="">Tất cả</option>
                        <option value="active">Đang hoạt động</option>
                        <option value="inactive">Không hoạt động</option>
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
                            <th>Ngày đăng ký</th>
                            <th>Trạng thái</th>
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
                                    <span class="badge ${user.roleId == 1 ? 'bg-danger' : 'bg-info'}">
                                        ${user.roleId == 1 ? 'Admin' : 'Khách hàng'}
                                    </span>
                                </td>
                                <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <span class="badge ${user.isActive ? 'bg-success' : 'bg-secondary'}">
                                        ${user.isActive ? 'Đang hoạt động' : 'Không hoạt động'}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-info view-user-btn" data-id="${user.userId}" 
                                            data-bs-toggle="modal" data-bs-target="#viewUserModal">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-primary edit-user-btn" data-id="${user.userId}" 
                                            data-bs-toggle="modal" data-bs-target="#editUserModal">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <c:if test="${!user.isAdmin}">
                                        <button class="btn btn-sm btn-danger delete-user-btn" data-id="${user.userId}" 
                                                data-bs-toggle="modal" data-bs-target="#deleteUserModal">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm người dùng mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addUserForm" action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="addUser">
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Họ tên <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="fullName" name="fullName" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" id="phone" name="phone">
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Địa chỉ</label>
                        <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="isAdmin" name="isAdmin">
                        <label class="form-check-label" for="isAdmin">Quyền Admin</label>
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
                <form id="editUserForm" action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="updateUser">
                    <input type="hidden" id="editUserId" name="userId">
                    <div class="mb-3">
                        <label for="editFullName" class="form-label">Họ tên <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="editFullName" name="fullName" required>
                    </div>
                    <div class="mb-3">
                        <label for="editEmail" class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="editEmail" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="editPhone" class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" id="editPhone" name="phone">
                    </div>
                    <div class="mb-3">
                        <label for="editPassword" class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" id="editPassword" name="password" 
                               placeholder="Để trống nếu không thay đổi">
                    </div>
                    <div class="mb-3">
                        <label for="editAddress" class="form-label">Địa chỉ</label>
                        <textarea class="form-control" id="editAddress" name="address" rows="2"></textarea>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="editIsAdmin" name="isAdmin">
                        <label class="form-check-label" for="editIsAdmin">Quyền Admin</label>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="editIsActive" name="isActive">
                        <label class="form-check-label" for="editIsActive">Đang hoạt động</label>
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

<!-- View User Modal -->
<div class="modal fade" id="viewUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thông tin người dùng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label fw-bold">ID:</label>
                    <p id="viewUserId"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Họ tên:</label>
                    <p id="viewFullName"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Email:</label>
                    <p id="viewEmail"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Số điện thoại:</label>
                    <p id="viewPhone"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Địa chỉ:</label>
                    <p id="viewAddress"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Vai trò:</label>
                    <p id="viewRole"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Ngày đăng ký:</label>
                    <p id="viewRegistrationDate"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Trạng thái:</label>
                    <p id="viewStatus"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Đơn hàng đã đặt:</label>
                    <p id="viewOrderCount"></p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" id="viewUserOrders">Xem đơn hàng</button>
            </div>
        </div>
    </div>
</div>

<!-- Delete User Modal -->
<div class="modal fade" id="deleteUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa người dùng này không? Hành động này không thể hoàn tác.</p>
            </div>
            <div class="modal-footer">
                <form id="deleteUserForm" action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="deleteUser">
                    <input type="hidden" id="deleteUserId" name="userId">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger">Xóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Xử lý nút xem thông tin người dùng
        $('.view-user-btn').click(function () {
            var userId = $(this).data('id');

            // Lấy thông tin người dùng từ server
            $.ajax({
                url: '${pageContext.request.contextPath}/admin',
                type: 'GET',
                data: {
                    action: 'getUser',
                    userId: userId
                },
                success: function (user) {
                    // Điền thông tin người dùng vào modal
                    $('#viewUserId').text(user.userId);
                    $('#viewFullName').text(user.fullName);
                    $('#viewEmail').text(user.email);
                    $('#viewPhone').text(user.phone || 'Chưa cập nhật');
                    $('#viewAddress').text(user.address || 'Chưa cập nhật');

                    // Hiển thị vai trò với badge
                    var roleHtml = user.isAdmin ?
                            '<span class="badge bg-danger">Admin</span>' :
                            '<span class="badge bg-info">Khách hàng</span>';
                    $('#viewRole').html(roleHtml);

                    // Format ngày đăng ký
                    var registrationDate = new Date(user.registrationDate);
                    $('#viewRegistrationDate').text(registrationDate.toLocaleDateString('vi-VN'));

                    // Hiển thị trạng thái với badge
                    var statusHtml = user.isActive ?
                            '<span class="badge bg-success">Đang hoạt động</span>' :
                            '<span class="badge bg-secondary">Không hoạt động</span>';
                    $('#viewStatus').html(statusHtml);

                    // Hiển thị số đơn hàng
                    $('#viewOrderCount').text(user.orderCount || 0);

                    // Lưu userId cho nút xem đơn hàng
                    $('#viewUserOrders').data('id', user.userId);
                },
                error: function (xhr, status, error) {
                    alert('Lỗi khi lấy thông tin người dùng: ' + error);
                }
            });
        });

        // Xử lý nút sửa thông tin người dùng
        $('.edit-user-btn').click(function () {
            var userId = $(this).data('id');

            // Lấy thông tin người dùng từ server
            $.ajax({
                url: '${pageContext.request.contextPath}/admin',
                type: 'GET',
                data: {
                    action: 'getUser',
                    userId: userId
                },
                success: function (user) {
                    // Điền thông tin người dùng vào form
                    $('#editUserId').val(user.userId);
                    $('#editFullName').val(user.fullName);
                    $('#editEmail').val(user.email);
                    $('#editPhone').val(user.phone);
                    $('#editAddress').val(user.address);
                    $('#editIsAdmin').prop('checked', user.isAdmin);
                    $('#editIsActive').prop('checked', user.isActive);
                },
                error: function (xhr, status, error) {
                    alert('Lỗi khi lấy thông tin người dùng: ' + error);
                }
            });
        });

        // Xử lý nút xóa người dùng
        $('.delete-user-btn').click(function () {
            var userId = $(this).data('id');
            $('#deleteUserId').val(userId);
        });

        // Xử lý nút xem đơn hàng của người dùng
        $('#viewUserOrders').click(function () {
            var userId = $(this).data('id');
            window.location.href = '${pageContext.request.contextPath}/admin?page=orders&userId=' + userId;
        });
    });
</script>

<jsp:include page="includes/footer.jsp" />


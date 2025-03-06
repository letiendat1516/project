<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp" />
<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="categories" />
</jsp:include>

<!-- Main content -->
<main class="col-md-10 ms-sm-auto px-md-4 py-4">
    <div class="admin-header d-flex justify-content-between align-items-center">
        <h1 class="h2">Quản lý danh mục</h1>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
            <i class="bi bi-plus-circle"></i> Thêm danh mục mới
        </button>
    </div>

    <!-- Categories Table -->
    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên danh mục</th>
                            <th>Mô tả</th>
                            <th>Số sản phẩm</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${categories}" var="category">
                            <tr>
                                <td>${category.categoryId}</td>
                                <td>${category.categoryName}</td>
                                <td>${category.description}</td>
                                <td>
                                    <span class="badge bg-info">${category.productCount}</span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary edit-category-btn" data-id="${category.categoryId}" 
                                            data-name="${category.categoryName}" data-description="${category.description}"
                                            data-bs-toggle="modal" data-bs-target="#editCategoryModal">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger delete-category-btn" data-id="${category.categoryId}" 
                                            data-name="${category.categoryName}" data-count="${category.productCount}"
                                            data-bs-toggle="modal" data-bs-target="#deleteCategoryModal">
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
</main>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm danh mục mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addCategoryForm" action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="addCategory">
                    <div class="mb-3">
                        <label for="categoryName" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                    </div>
                    <div class="mb-3">
                        <label for="categoryDescription" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="categoryDescription" name="description" rows="3"></textarea>
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
                <form id="editCategoryForm" action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="updateCategory">
                    <input type="hidden" id="editCategoryId" name="categoryId">
                    <div class="mb-3">
                        <label for="editCategoryName" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="editCategoryName" name="categoryName" required>
                    </div>
                    <div class="mb-3">
                        <label for="editCategoryDescription" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="editCategoryDescription" name="description" rows="3"></textarea>
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
                <p>Bạn có chắc chắn muốn xóa danh mục "<span id="deleteCategoryName"></span>" không?</p>
                <div id="categoryHasProducts" class="alert alert-warning" style="display: none;">
                    <i class="bi bi-exclamation-triangle"></i> Danh mục này đang có <strong id="productCount"></strong> sản phẩm. 
                    Nếu xóa, tất cả sản phẩm trong danh mục sẽ bị xóa hoặc chuyển sang danh mục khác.
                </div>
                <div class="mb-3" id="replaceCategoryDiv" style="display: none;">
                    <label for="replaceCategory" class="form-label">Chuyển sản phẩm sang danh mục:</label>
                    <select class="form-select" id="replaceCategory" name="replaceCategoryId">
                        <option value="">-- Xóa tất cả sản phẩm --</option>
                        <c:forEach items="${categories}" var="category">
                            <option value="${category.categoryId}">${category.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <form id="deleteCategoryForm" action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="deleteCategory">
                    <input type="hidden" id="deleteCategoryId" name="categoryId">
                    <input type="hidden" id="replaceCategoryId" name="replaceCategoryId">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger">Xóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // Xử lý nút chỉnh sửa danh mục
        $('.edit-category-btn').click(function() {
            var categoryId = $(this).data('id');
            var categoryName = $(this).data('name');
            var description = $(this).data('description');
            
            $('#editCategoryId').val(categoryId);
            $('#editCategoryName').val(categoryName);
            $('#editCategoryDescription').val(description);
        });
        
        // Xử lý nút xóa danh mục
        $('.delete-category-btn').click(function() {
            var categoryId = $(this).data('id');
            var categoryName = $(this).data('name');
            var productCount = $(this).data('count');
            
            $('#deleteCategoryId').val(categoryId);
            $('#deleteCategoryName').text(categoryName);
            
            // Loại bỏ danh mục hiện tại khỏi danh sách danh mục thay thế
            $('#replaceCategory option[value="' + categoryId + '"]').remove();
            
            // Hiển thị cảnh báo và lựa chọn thay thế nếu có sản phẩm trong danh mục
            if (productCount > 0) {
                $('#categoryHasProducts').show();
                $('#productCount').text(productCount);
                $('#replaceCategoryDiv').show();
            } else {
                $('#categoryHasProducts').hide();
                $('#replaceCategoryDiv').hide();
            }
        });
        
        // Cập nhật giá trị replaceCategoryId khi chọn danh mục thay thế
        $('#replaceCategory').change(function() {
            $('#replaceCategoryId').val($(this).val());
        });
    });
</script>

<jsp:include page="includes/footer.jsp" />

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp" />
<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="products" />
</jsp:include>

<!-- Main content -->
<main class="col-md-10 ms-sm-auto px-md-4 py-4">
    <div class="admin-header d-flex justify-content-between align-items-center">
        <h1 class="h2">Quản lý sản phẩm</h1>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
            <i class="bi bi-plus-circle"></i> Thêm sản phẩm mới
        </button>
    </div>

    <!-- Hiển thị thông báo thành công hoặc lỗi -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

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
</main>

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
                        <textarea class="form-control" id="productDescription" name="description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="productImage" class="form-label">Hình ảnh sản phẩm</label>
                        <input type="file" class="form-control" id="productImage" name="imageFile" accept="image/*">
                        <div id="imagePreview" class="mt-2"></div>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="productFeatured" name="featured">
                        <label class="form-check-label" for="productFeatured">Sản phẩm nổi bật</label>
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
                    <input type="hidden" id="currentImageUrl" name="currentImageUrl">
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
                        <textarea class="form-control" id="editProductDescription" name="description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="editProductImage" class="form-label">Hình ảnh sản phẩm</label>
                        <input type="file" class="form-control" id="editProductImage" name="imageFile" accept="image/*">
                        <small class="text-muted">Để trống nếu không muốn thay đổi hình ảnh</small>
                        <div id="editImagePreview" class="mt-2"></div>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="editProductFeatured" name="featured">
                        <label class="form-check-label" for="editProductFeatured">Sản phẩm nổi bật</label>
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
                <p>Bạn có chắc chắn muốn xóa sản phẩm này không? Hành động này không thể hoàn tác.</p>
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

<script>
    $(document).ready(function () {
        // Xử lý nút sửa sản phẩm
        $('.edit-product-btn').click(function () {
            var productId = $(this).data('id');

            // Lấy thông tin sản phẩm từ server
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/get-product',
                type: 'GET',
                data: {
                    productId: productId
                },
                success: function (product) {
                    // Điền thông tin sản phẩm vào form
                    $('#editProductId').val(product.productId);
                    $('#editProductName').val(product.name);
                    $('#editProductCategory').val(product.categoryId);
                    $('#editProductPrice').val(product.price);
                    $('#editProductStock').val(product.stockQuantity);
                    $('#editProductDescription').val(product.description);
                    $('#currentImageUrl').val(product.imageUrl);
                    $('#editProductFeatured').prop('checked', product.featured);

                    // Hiển thị ảnh hiện tại
                    if (product.imageUrl) {
                        $('#editImagePreview').html('<img src="${pageContext.request.contextPath}/' + product.imageUrl + '" class="image-preview" />');
                    }
                },
                error: function (xhr, status, error) {
                    alert('Lỗi khi lấy thông tin sản phẩm: ' + error);
                }
            });
        });

        // Xử lý nút xóa sản phẩm
        $('.delete-product-btn').click(function () {
            var productId = $(this).data('id');
            console.log("Setting product ID for deletion: " + productId);
            $('#deleteProductId').val(productId);
        });

        // Thêm kiểm tra trước khi submit form xóa
        $('#deleteProductForm').submit(function (e) {
            var productId = $('#deleteProductId').val();
            console.log("Submitting delete form with product ID: " + productId);

            if (!productId) {
                e.preventDefault();
                alert('Lỗi: Không tìm thấy ID sản phẩm!');
                return false;
            }
        });

        // Xử lý toggle featured
        $('.toggle-featured').change(function () {
            var productId = $(this).data('product-id');
            var featured = $(this).prop('checked');

            $.ajax({
                url: '${pageContext.request.contextPath}/admin/toggle-featured',
                type: 'POST',
                data: {
                    productId: productId,
                    featured: featured
                },
                error: function (xhr, status, error) {
                    alert('Lỗi khi cập nhật trạng thái nổi bật: ' + error);
                    // Khôi phục trạng thái checkbox
                    $(this).prop('checked', !featured);
                }
            });
        });

        // Xử lý xem trước ảnh khi thêm sản phẩm
        $('#productImage').change(function () {
            previewImage(this, '#imagePreview');
        });

        // Xử lý xem trước ảnh khi sửa sản phẩm
        $('#editProductImage').change(function () {
            previewImage(this, '#editImagePreview');
        });

        // Hàm xem trước ảnh
        function previewImage(input, previewElement) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $(previewElement).html('<img src="' + e.target.result + '" class="image-preview" />');
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    });
</script>

<jsp:include page="includes/footer.jsp" />

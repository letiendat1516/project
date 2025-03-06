<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            </div>
        </div>

        <!-- Thêm các thư viện JavaScript cần thiết -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>

        <!-- JavaScript cho trang admin -->
        <script>
            var contextPath = '${pageContext.request.contextPath}';

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

                // Xử lý preview ảnh khi chọn file
                $('#productImage, #editProductImage').change(function () {
                    var file = this.files[0];
                    var reader = new FileReader();
                    var previewId = $(this).attr('id') === 'productImage' ? '#imagePreview' : '#editImagePreview';
                    reader.onload = function (e) {
                        $(previewId).html('<img src="' + e.target.result + '" class="image-preview" />');
                    };
                    if (file) {
                        reader.readAsDataURL(file);
                    }
                });
            });
        </script>
    </body>
</html>

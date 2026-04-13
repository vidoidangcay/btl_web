<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản trị Admin</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: #f7f7f9; color: #333; }
        header { background: #0d4b87; color: white; padding: 18px 0; box-shadow: 0 2px 8px rgba(0,0,0,.08); }
        .container { max-width: 1300px; margin: 0 auto; padding: 20px; }
        .admin-top { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
        .logo { font-size: 24px; font-weight: bold; letter-spacing: 1px; }
        .btn-home { color: #0d4b87; background: white; padding: 10px 18px; border-radius: 8px; text-decoration: none; font-weight: bold; }
        .grid { display: grid; gap: 20px; }
        .cards { grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); }
        .card { background: white; border-radius: 14px; padding: 18px; box-shadow: 0 8px 20px rgba(0,0,0,.05); }
        .card h3 { margin: 0 0 12px; font-size: 16px; color: #0d4b87; }
        .card strong { display: block; font-size: 32px; color: #1a1a1a; }
        .section { margin-top: 24px; }
        .product-filter { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 18px; }
        .filter-pill { display: inline-flex; align-items: center; padding: 10px 14px; border-radius: 999px; background: #eef4ff; color: #0d4b87; text-decoration: none; font-size: 14px; border: 1px solid transparent; transition: all .2s ease; }
        .filter-pill.active, .filter-pill:hover { background: #0d4b87; color: white; border-color: #0d4b87; }
        .pagination { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 16px; justify-content: flex-end; }
        .pagination a { display: inline-flex; align-items: center; justify-content: center; min-width: 36px; padding: 8px 12px; border-radius: 8px; border: 1px solid #d9d9d9; color: #0d4b87; text-decoration: none; transition: background .2s ease; }
        .pagination a.active, .pagination a:hover { background: #0d4b87; color: white; border-color: #0d4b87; }
        .pagination span { display: inline-flex; align-items: center; justify-content: center; min-width: 36px; padding: 8px 12px; border-radius: 8px; background: #f3f5f8; color: #666; }
        .section h2 { margin-bottom: 14px; font-size: 20px; border-left: 5px solid #0d4b87; padding-left: 12px; }
        table { width: 100%; border-collapse: collapse; background: white; }
        th, td { padding: 12px 10px; border-bottom: 1px solid #ececec; text-align: left; font-size: 14px; }
        th { background: #f0f7ff; color: #0d4b87; }
        tr:hover { background: #fbfbfb; }
        .small-btn { padding: 8px 12px; border-radius: 8px; border: none; cursor: pointer; font-size: 13px; }
        .btn-delete { background: #f64e4e; color: white; }
        .btn-update { background: #0d4b87; color: white; }
        .form-grid { display: grid; gap: 14px; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); }
        .field { display: flex; flex-direction: column; }
        .field label { font-weight: 600; margin-bottom: 6px; font-size: 14px; }
        .field input, .field textarea, .field select { padding: 10px 12px; border: 1px solid #d9d9d9; border-radius: 8px; font-size: 14px; }
        .field textarea { resize: vertical; min-height: 90px; }
        .form-card { padding: 20px; background: white; border-radius: 14px; box-shadow: 0 8px 20px rgba(0,0,0,.04); }
        .btn-save { background: #0d4b87; color: white; border: none; padding: 12px 18px; border-radius: 10px; cursor: pointer; font-size: 14px; }
        .status-pill { display: inline-flex; align-items: center; padding: 6px 10px; border-radius: 999px; font-size: 12px; font-weight: bold; }
        .status-0 { background: #fff2cc; color: #a56f00; }
        .status-1 { background: #d9f7e4; color: #137333; }
        .status-2 { background: #deebff; color: #0d4b87; }
        .status-3 { background: #ffe3e3; color: #a80000; }
        .admin-nav {
            margin-top: 16px;
            background: white;
            border-radius: 14px;
            box-shadow: 0 6px 18px rgba(0,0,0,.06);
            padding: 12px 20px;
        }
        .admin-nav ul {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }
        .admin-nav a {
            display: inline-block;
            padding: 10px 16px;
            border-radius: 999px;
            text-decoration: none;
            color: #0d4b87;
            background: #eef4ff;
            font-weight: 600;
            transition: background .3s, transform .2s;
        }
        .admin-nav a:hover,
        .admin-nav a.active {
            background: #0d4b87;
            color: white;
            transform: translateY(-1px);
        }
    </style>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<c:if test="${sessionScope.accounts == null || sessionScope.accounts.role != 1}">
    <c:redirect url="index1.jsp" />
</c:if>
<header>
    <div class="container admin-top">
        <div class="logo">Admin Dashboard</div>
        <div>
            <a href="home" class="btn-home">Trở về cửa hàng</a>
        </div>
    </div>
</header>
<div class="container">
    <nav class="admin-nav">
        <ul>
            <li><a href="admin?view=dashboard" class="${view == 'dashboard' ? 'active' : ''}">Tổng quan</a></li>
            <li><a href="admin?view=products" class="${view == 'products' ? 'active' : ''}">Sản phẩm</a></li>
            <li><a href="admin?view=categories" class="${view == 'categories' ? 'active' : ''}">Danh mục</a></li>
            <li><a href="admin?view=suppliers" class="${view == 'suppliers' ? 'active' : ''}">Nhà cung cấp</a></li>
            <li><a href="admin?view=vouchers" class="${view == 'vouchers' ? 'active' : ''}">Voucher</a></li>
            <li><a href="admin?view=orders" class="${view == 'orders' ? 'active' : ''}">Đơn hàng <c:if test="${pendingOrderCount > 0}">(${pendingOrderCount})</c:if></a></li>
            <li><a href="admin?view=stockins" class="${view == 'stockins' ? 'active' : ''}">Nhập kho</a></li>
        </ul>
    </nav>
    <c:if test="${view == 'dashboard'}">
        <div class="grid cards" id="dashboard">
            <div class="card">
                <h3>Tổng sản phẩm</h3>
                <strong>${totalProductCount}</strong>
            </div>
            <div class="card">
                <h3>Danh mục</h3>
                <strong>${categories.size()}</strong>
            </div>
            <div class="card">
                <h3>Voucher</h3>
                <strong>${vouchers.size()}</strong>
            </div>
            <div class="card">
                <h3>Đơn mới</h3>
                <strong>${pendingOrderCount}</strong>
            </div>
            <div class="card">
                <h3>Đơn hàng</h3>
                <strong>${orders.size()}</strong>
            </div>
        </div>
    </c:if>

    <c:if test="${view == 'products'}">
        <div class="section" id="products">
        <h2>Quản lý sản phẩm</h2>
        <div class="product-filter">
            <a href="admin?view=products" class="filter-pill ${empty productCategoryFilter && view == 'products' ? 'active' : ''}">Tất cả</a>
            <c:forEach items="${categories}" var="c">
                <a href="admin?view=products&productCategory=${c.id}" class="filter-pill ${productCategoryFilter == c.id ? 'active' : ''}">${c.name}</a>
            </c:forEach>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Mã</th>
                    <th>Tên</th>
                    <th>Danh mục</th>
                    <th>Số lượng</th>
                    <th>Giá</th>
                    <th>Ngày ra mắt</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${products}" var="p">
                    <tr>
                        <td>${p.id}</td>
                        <td>${p.name}</td>
                        <td>${categoryMap[p.cid]}</td>
                        <td>${p.quantity}</td>
                        <td><fmt:formatNumber value="${p.price}" type="number" /> đ</td>
                        <td><fmt:formatDate value="${p.releaseDate}" pattern="yyyy-MM-dd"/></td>
                        <td>
                            <form action="admin" method="post" style="display:inline-block; margin-right:6px;">
                                <input type="hidden" name="view" value="${view}" />
                                <input type="hidden" name="productCategory" value="${productCategoryFilter}" />
                                <input type="hidden" name="page" value="${currentProductPage}" />
                                <input type="hidden" name="action" value="deleteProduct" />
                                <input type="hidden" name="productId" value="${p.id}" />
                                <button class="small-btn btn-delete" type="submit">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <div class="pagination">
            <c:if test="${currentProductPage > 1}">
                <a href="admin?view=products&productCategory=${productCategoryFilter}&page=${currentProductPage - 1}">&laquo;</a>
            </c:if>
            <c:forEach var="p" begin="1" end="${totalProductPages}">
                <a href="admin?view=products&productCategory=${productCategoryFilter}&page=${p}" class="${p == currentProductPage ? 'active' : ''}">${p}</a>
            </c:forEach>
            <c:if test="${currentProductPage < totalProductPages}">
                <a href="admin?view=products&productCategory=${productCategoryFilter}&page=${currentProductPage + 1}">&raquo;</a>
            </c:if>
        </div>
    </div>

    <div class="section" id="add-product">
        <h2>Thêm sản phẩm mới</h2>
        <div class="form-card">
            <form action="admin" method="post">
                <input type="hidden" name="view" value="${view}" />
                <input type="hidden" name="productCategory" value="${productCategoryFilter}" />
                <input type="hidden" name="page" value="${currentProductPage}" />
                <input type="hidden" name="action" value="addProduct" />
                <div class="form-grid">
                    <div class="field"><label>Mã sản phẩm</label><input name="productId" required /></div>
                    <div class="field"><label>Tên sản phẩm</label><input name="productName" required /></div>
                    <div class="field"><label>Số lượng</label><input type="number" min="0" name="productQuantity" required /></div>
                    <div class="field"><label>Giá</label><input type="number" step="0.01" min="0" name="productPrice" required /></div>
                    <div class="field"><label>Ngày ra mắt</label><input type="date" name="productRelease" required /></div>
                    <div class="field"><label>Danh mục</label>
                        <select name="productCategoryId" required>
                            <c:forEach items="${categories}" var="c">
                                <option value="${c.id}">${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="field"><label>Ảnh (URL)</label><input name="productImage" required /></div>
                    <div class="field" style="grid-column: span 2;"><label>Mô tả</label><textarea name="productDescription"></textarea></div>
                </div>
                <button class="btn-save" type="submit">Lưu sản phẩm</button>
            </form>
        </div>
    </div>
    </c:if>

    <c:if test="${view == 'categories'}">
        <div class="section" id="categories">
                <h2>Danh mục</h2>
                <table>
                    <thead>
                        <tr><th>ID</th><th>Tên</th><th>Mô tả</th><th>Hành động</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${categories}" var="c">
                            <tr>
                                <td>${c.id}</td>
                                <td>${c.name}</td>
                                <td>${c.describe}</td>
                                <td>
                                    <form action="admin" method="post" style="display:inline-block;">
                                        <input type="hidden" name="view" value="${view}" />
                                        <input type="hidden" name="action" value="deleteCategory" />
                                        <input type="hidden" name="categoryId" value="${c.id}" />
                                        <button class="small-btn btn-delete" type="submit">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="section" id="add-category">
                <h2>Thêm danh mục</h2>
                <div class="form-card">
                    <form action="admin" method="post">
                        <input type="hidden" name="view" value="${view}" />
                        <input type="hidden" name="action" value="addCategory" />
                        <div class="form-grid">
                            <div class="field"><label>Tên danh mục</label><input name="categoryName" required /></div>
                            <div class="field"><label>Mô tả</label><input name="categoryDescription" /></div>
                        </div>
                        <button class="btn-save" type="submit">Lưu danh mục</button>
                    </form>
                </div>
            </div>
        </div>
        </c:if>

    <c:if test="${view == 'suppliers'}">
        <div class="section" id="suppliers">
                <h2>Nhà cung cấp</h2>
                <table>
                    <thead>
                        <tr><th>ID</th><th>Tên</th><th>Điện thoại</th><th>Địa chỉ</th><th>Hành động</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${suppliers}" var="s">
                            <tr>
                                <td>${s.id}</td>
                                <td>${s.name}</td>
                                <td>${s.phone}</td>
                                <td>${s.address}</td>
                                <td>
                                    <form action="admin" method="post" style="display:inline-block;">
                                        <input type="hidden" name="view" value="${view}" />
                                        <input type="hidden" name="action" value="deleteSupplier" />
                                        <input type="hidden" name="supplierId" value="${s.id}" />
                                        <button class="small-btn btn-delete" type="submit">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="section" id="add-supplier">
                <h2>Thêm nhà cung cấp</h2>
                <div class="form-card">
                    <form action="admin" method="post">
                        <input type="hidden" name="view" value="${view}" />
                        <input type="hidden" name="action" value="addSupplier" />
                        <div class="form-grid">
                            <div class="field"><label>Tên</label><input name="supplierName" required /></div>
                            <div class="field"><label>Điện thoại</label><input name="supplierPhone" required /></div>
                            <div class="field" style="grid-column: span 2;"><label>Địa chỉ</label><input name="supplierAddress" required /></div>
                        </div>
                        <button class="btn-save" type="submit">Lưu nhà cung cấp</button>
                    </form>
                </div>
            </div>
        </div>
        </c:if>

    <c:if test="${view == 'vouchers'}">
    <div class="section" id="vouchers">
        <h2>Voucher</h2>
        <table>
            <thead>
                <tr><th>Mã</th><th>Giảm giá</th><th>Hết hạn</th><th>Giá tối thiểu</th><th>Số lượng</th><th>Hành động</th></tr>
            </thead>
            <tbody>
                <c:forEach items="${vouchers}" var="v">
                    <tr>
                        <td>${v.code}</td>
                        <td><fmt:formatNumber value="${v.discountValue}" type="number" /> đ</td>
                        <td><fmt:formatDate value="${v.expirationDate}" pattern="yyyy-MM-dd"/></td>
                        <td><fmt:formatNumber value="${v.minOrderValue}" type="number" /> đ</td>
                        <td>${v.quantity}</td>
                        <td>
                            <form action="admin" method="post" style="display:inline-block;">
                                <input type="hidden" name="view" value="${view}" />
                                <input type="hidden" name="action" value="deleteVoucher" />
                                <input type="hidden" name="voucherCode" value="${v.code}" />
                                <button class="small-btn btn-delete" type="submit">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="section" id="add-voucher">
        <h2>Thêm voucher</h2>
        <div class="form-card">
            <form action="admin" method="post">
                <input type="hidden" name="view" value="${view}" />
                <input type="hidden" name="action" value="addVoucher" />
                <div class="form-grid">
                    <div class="field"><label>Mã voucher</label><input name="voucherCode" required /></div>
                    <div class="field"><label>Giảm giá</label><input type="number" step="0.01" min="0" name="voucherDiscount" required /></div>
                    <div class="field"><label>Ngày hết hạn</label><input type="date" name="voucherExpiration" required /></div>
                    <div class="field"><label>Giá tối thiểu</label><input type="number" step="0.01" min="0" name="voucherMinValue" required /></div>
                    <div class="field"><label>Số lượng</label><input type="number" min="0" name="voucherQuantity" required /></div>
                </div>
                <button class="btn-save" type="submit">Lưu voucher</button>
            </form>
        </div>
    </div>
    </c:if>

    <c:if test="${view == 'orders'}">
    <div class="section" id="orders">
        <h2>Đơn hàng</h2>
        <table>
            <thead>
                <tr><th>ID</th><th>Khách</th><th>Tổng tiền</th><th>Trạng thái</th><th>Địa chỉ</th><th>Voucher</th><th>Chi tiết</th><th>Hành động</th></tr>
            </thead>
            <tbody>
                <c:forEach items="${orders}" var="o">
                    <tr>
                        <td>${o.id}</td>
                        <td>${o.username}</td>
                        <td><fmt:formatNumber value="${o.totalmoney}" type="number" /> đ</td>
                        <td>
                            <c:choose>
                                <c:when test="${o.status == 0}"><span class="status-pill status-0">Chờ duyệt</span></c:when>
                                <c:when test="${o.status == 1}"><span class="status-pill status-1">Đã xác nhận</span></c:when>
                                <c:when test="${o.status == 2}"><span class="status-pill status-2">Đã giao</span></c:when>
                                <c:otherwise><span class="status-pill status-3">Đã hủy</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${o.shipping_address}</td>
                        <td>${o.voucher_code}</td>
                        <td>
                            <a href="order?orderId=${o.id}" class="small-btn btn-update" style="margin-right:6px;">Chi tiết</a>
                        </td>
                        <td>
                            <form action="admin" method="post" style="display:inline-block; margin-right:6px;">
                                <input type="hidden" name="view" value="${view}" />
                                <input type="hidden" name="action" value="updateOrderStatus" />
                                <input type="hidden" name="orderId" value="${o.id}" />
                                <select name="statusValue" style="border-radius:8px; padding:6px; border:1px solid #ccc;">
                                    <option value="0" ${o.status == 0 ? 'selected' : ''}>Chờ duyệt</option>
                                    <option value="1" ${o.status == 1 ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="2" ${o.status == 2 ? 'selected' : ''}>Đã giao</option>
                                    <option value="3" ${o.status == 3 ? 'selected' : ''}>Đã hủy</option>
                                </select>
                                <button class="small-btn btn-update" type="submit">Cập nhật</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    </c:if>

    <c:if test="${view == 'stockins'}">
    <div class="section" id="stockins">
        <h2>Nhập kho (Stock-In)</h2>
        <div class="form-card" style="margin-bottom:20px;">
            <h3>Thêm nhập kho mới</h3>
            <form action="admin" method="post">
                <input type="hidden" name="view" value="stockins" />
                <input type="hidden" name="action" value="addStockIn" />
                <div class="form-grid">
                    <div class="field">
                        <label>Nhà cung cấp</label>
                        <select name="supplierId" required>
                            <option value="">Chọn nhà cung cấp</option>
                            <c:forEach items="${suppliers}" var="s">
                                <option value="${s.id}">${s.name} - ${s.phone}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label>Sản phẩm</label>
                        <select name="stockProductId" required>
                            <option value="">Chọn sản phẩm</option>
                            <c:forEach items="${allProducts}" var="p">
                                <option value="${p.id}">${p.id} - ${p.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label>Số lượng</label>
                        <input type="number" name="stockQuantity" min="1" step="1" value="1" required />
                    </div>
                    <div class="field">
                        <label>Giá nhập (VNĐ)</label>
                        <input type="number" name="purchasePrice" min="0" step="0.01" value="0" required />
                    </div>
                </div>
                <div style="margin-top: 14px; text-align: right;">
                    <button class="btn-save" type="submit">Lưu nhập kho</button>
                </div>
            </form>
        </div>
        <table>
            <thead>
                <tr><th>ID</th><th>Ngày</th><th>Nhà cung cấp</th><th>Admin</th><th>Sản phẩm</th><th>Số lượng</th><th>Tổng chi phí</th></tr>
            </thead>
            <tbody>
                <c:forEach items="${stockIns}" var="st">
                    <tr>
                        <td>${st.id}</td>
                        <td><fmt:formatDate value="${st.date}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td><c:out value="${supplierMap[st.sid]}" default="${st.sid}"/></td>
                        <td>${st.admin_user}</td>
                        <td><c:choose>
                            <c:when test="${stockInDetailMap[st.id] != null}">
                                <c:out value="${productMap[stockInDetailMap[st.id].pid]}" default="${stockInDetailMap[st.id].pid}"/>
                            </c:when>
                            <c:otherwise>---</c:otherwise>
                        </c:choose></td>
                        <td><c:choose>
                            <c:when test="${stockInDetailMap[st.id] != null}">
                                ${stockInDetailMap[st.id].quantity}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose></td>
                        <td><fmt:formatNumber value="${st.total_cost}" type="number" /> đ</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    </c:if>
</div>
</div>
<c:if test="${view == 'orders'}">
<script>
    // Tự động refresh trang Orders để admin thấy đơn hàng mới khi có khách vừa mua.
    setInterval(function() {
        window.location.reload();
    }, 10000); // reload mỗi 10s
</script>
</c:if>
<script>
    document.querySelectorAll('.admin-nav a').forEach(link => {
        link.addEventListener('click', function () {
            document.querySelectorAll('.admin-nav a').forEach(item => item.classList.remove('active'));
            this.classList.add('active');
        });
    });
</script>
</html>

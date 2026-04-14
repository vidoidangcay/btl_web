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
        .form-grid { display: grid; gap: 18px; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); align-items: start; }
        .edit-account-top { display: grid; gap: 18px; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); align-items: start; margin-bottom: 22px; }
        .details-panel { display: grid; gap: 18px; grid-template-columns: repeat(2, minmax(240px, 1fr)); padding: 22px; background: #f8fbff; border: 1px solid #dbeafe; border-radius: 20px; }
        .field { display: flex; flex-direction: column; }
        .field label { font-weight: 700; margin-bottom: 8px; font-size: 14px; color: #334155; }
        .field input, .field textarea, .field select { padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 12px; font-size: 14px; background: #ffffff; transition: border-color .2s ease, box-shadow .2s ease; }
        .field input:focus, .field textarea:focus, .field select:focus { outline: none; border-color: #0d4b87; box-shadow: 0 0 0 4px rgba(13,75,135,0.08); }
        .field textarea { resize: vertical; min-height: 100px; }
        .form-card { padding: 26px; background: #ffffff; border-radius: 20px; box-shadow: 0 14px 32px rgba(15, 23, 42, 0.08); }
        .btn-save { background: #0d4b87; color: white; border: none; padding: 13px 22px; border-radius: 12px; cursor: pointer; font-size: 15px; font-weight: 700; }
        .btn-save:hover { background: #0b3b6d; }
        .form-actions { margin-top: 24px; display: flex; justify-content: flex-end; gap: 12px; flex-wrap: wrap; }
        .details-panel .field input, .details-panel .field textarea, .details-panel .field select { background: #ffffff; }
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

        .admin-subnav {
            display: flex;
            flex-wrap: wrap;
            gap: 18px;
            padding: 18px 20px;
            margin-bottom: 24px;
            border-radius: 24px;
            background: #ffffff;
            border: 1px solid rgba(13, 75, 135, 0.15);
            box-shadow: 0 18px 40px rgba(13, 75, 135, 0.08);
        }

        .admin-subnav a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-width: 220px;
            padding: 16px 24px;
            border-radius: 18px;
            background: #eef4ff;
            color: #0d4b87;
            font-size: 1.05rem;
            font-weight: 700;
            line-height: 1.4;
            text-decoration: none;
            transition: all 0.25s ease;
        }

        .admin-subnav a:hover {
            transform: translateY(-1px);
            background: #dde8ff;
        }

        .admin-subnav a.active {
            background: #0d4b87;
            color: white;
            box-shadow: 0 18px 30px rgba(13, 75, 135, 0.18);
        }

        .alert-banner {
            margin: 24px 0;
            padding: 16px 20px;
            border-radius: 16px;
            background: #fff4e6;
            color: #9a5008;
            border: 1px solid #f5d5b4;
            font-weight: 700;
            box-shadow: 0 8px 24px rgba(255, 188, 123, 0.12);
        }

        .section h2 {
            margin-bottom: 18px;
            font-size: 1.9rem;
            border-left: 6px solid #0d4b87;
            padding-left: 14px;
            letter-spacing: -0.02em;
        }

        .section {
            margin-top: 32px;
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
            <li><a href="admin?view=accounts" class="${view == 'accounts' || view == 'addAccount' ? 'active' : ''}">Tài khoản</a></li>
            <li><a href="admin?view=suppliers" class="${view == 'suppliers' ? 'active' : ''}">Nhà cung cấp</a></li>
            <li><a href="admin?view=vouchers" class="${view == 'vouchers' ? 'active' : ''}">Voucher</a></li>
            <li><a href="admin?view=orders" class="${view == 'orders' ? 'active' : ''}">Đơn hàng <c:if test="${pendingOrderCount > 0}">(${pendingOrderCount})</c:if></a></li>
            <li><a href="admin?view=stockins" class="${view == 'stockins' ? 'active' : ''}">Nhập kho</a></li>
        </ul>
    </nav>
    <c:if test="${not empty param.alert}">
        <div class="alert-banner">${param.alert}</div>
    </c:if>
    <c:if test="${not empty requestScope.alert}">
        <div class="alert-banner">${requestScope.alert}</div>
    </c:if>
    <c:if test="${view == 'dashboard'}">
        <div class="grid cards" id="dashboard">
            <div class="card">
                <h3>Tổng sản phẩm</h3>
                <strong>${totalProductCount}</strong>
            </div>
            <div class="card">
                <h3>Voucher</h3>
                <strong>${vouchers.size()}</strong>
            </div>
            <div class="card">
                <h3>Tài khoản</h3>
                <strong>${accounts.size()}</strong>
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
                            <a href="admin?view=products&productCategory=${productCategoryFilter}&page=${currentProductPage}&editProductId=${p.id}" class="small-btn btn-update" style="margin-right:6px;">Sửa</a>
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
        <c:choose>
            <c:when test="${editProduct != null}">
                <h2>Chỉnh sửa sản phẩm</h2>
            </c:when>
            <c:otherwise>
                <h2>Thêm sản phẩm mới</h2>
            </c:otherwise>
        </c:choose>
        <div class="form-card">
            <form action="admin" method="post">
                <input type="hidden" name="view" value="${view}" />
                <input type="hidden" name="productCategory" value="${productCategoryFilter}" />
                <input type="hidden" name="page" value="${currentProductPage}" />
                <input type="hidden" name="action" value="${editProduct != null ? 'editProduct' : 'addProduct'}" />
                <div class="form-grid">
                    <div class="field"><label>Mã sản phẩm</label><input name="productId" required value="${editProduct.id}" <c:if test="${editProduct != null}">readonly</c:if> /></div>
                    <div class="field"><label>Tên sản phẩm</label><input name="productName" required value="${editProduct.name}" /></div>
                    <div class="field"><label>Số lượng</label><input type="number" min="0" name="productQuantity" required value="${editProduct.quantity}" /></div>
                    <div class="field"><label>Giá</label><input type="number" step="0.01" min="0" name="productPrice" required value="${editProduct.price}" /></div>
                    <div class="field"><label>Ngày ra mắt</label><input type="date" name="productRelease" required value="${editProduct.releaseDate}" /></div>
                    <div class="field"><label>Danh mục</label>
                        <select name="productCategoryId" required>
                            <c:forEach items="${categories}" var="c">
                                <option value="${c.id}" <c:if test="${editProduct != null && editProduct.cid == c.id}">selected</c:if>>${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="field"><label>Ảnh (URL)</label><input name="productImage" required value="${editProduct.image}" /></div>
                    <div class="field" style="grid-column: span 2;"><label>Mô tả</label><textarea name="productDescription">${editProduct.describe}</textarea></div>
                </div>
                <button class="btn-save" type="submit"><c:choose><c:when test="${editProduct != null}">Cập nhật sản phẩm</c:when><c:otherwise>Thêm sản phẩm</c:otherwise></c:choose></button>
                <c:if test="${editProduct != null}">
                    <a href="admin?view=products&productCategory=${productCategoryFilter}&page=${currentProductPage}" class="small-btn btn-delete" style="margin-left:12px;">Hủy</a>
                </c:if>
            </form>
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

    <c:if test="${view == 'accounts'}">
    <div class="section" id="accounts">
        <div class="admin-subnav">
            <a href="admin?view=accounts" class="${view == 'accounts' ? 'active' : ''}"><span>📋</span>Danh sách tài khoản</a>
            <a href="admin?view=addAccount" class="${view == 'addAccount' ? 'active' : ''}"><span>➕</span>Thêm tài khoản</a>
        </div>
        <h2>Danh sách tài khoản</h2>
        <table>
            <thead>
                <tr><th>Username</th><th>Vai trò</th><th>Hành động</th></tr>
            </thead>
            <tbody>
                <c:forEach items="${accounts}" var="a">
                    <tr>
                        <td>${a.username}</td>
                        <td><c:choose><c:when test="${a.role == 1}">Admin</c:when><c:otherwise>Khách hàng</c:otherwise></c:choose></td>
                        <td>
                            <a href="admin?view=accounts&detailUsername=${a.username}" class="small-btn btn-update" style="margin-right:6px;">Chi tiết</a>
                        <a href="admin?view=accounts&editUsername=${a.username}" class="small-btn btn-save" style="margin-right:6px;">Sửa</a>
                        <c:if test="${sessionScope.accounts.username != a.username}">
                            <c:choose>
                                <c:when test="${a.role == 1 && pendingDeleteMap[a.username]}">
                                    <span class="status-pill status-0">Đợi phản hồi</span>
                                </c:when>
                                <c:otherwise>
                                    <form action="admin" method="post" style="display:inline-block; margin-right:6px;">
                                        <input type="hidden" name="view" value="${view}" />
                                        <input type="hidden" name="action" value="deleteAccount" />
                                        <input type="hidden" name="username" value="${a.username}" />
                                        <button class="small-btn btn-delete" type="submit">Xóa</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                            <c:if test="${sessionScope.accounts.username == a.username}">
                                <span class="status-pill status-2">Đang đăng nhập</span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${not empty detailAccount}">
        <div class="section" id="account-detail">
            <h2>Chi tiết tài khoản: ${detailAccount.username}</h2>
            <div style="margin-bottom: 16px;">
                <a href="admin?view=accounts&editUsername=${detailAccount.username}" class="small-btn btn-save">Sửa tài khoản</a>
            </div>
            <c:if test="${not empty deleteRequestRequester}">
                <div class="alert-banner">
                    <strong>Yêu cầu xóa tài khoản</strong><br />
                    Admin <strong>${deleteRequestRequester}</strong> đã gửi yêu cầu xóa tài khoản này.
                    <c:if test="${detailAccount.username == sessionScope.accounts.username}">
                        <div style="margin-top:12px;">
                            <form action="admin" method="post" style="display:inline-block; margin-right:10px;">
                                <input type="hidden" name="view" value="accounts" />
                                <input type="hidden" name="action" value="respondDeleteAdmin" />
                                <input type="hidden" name="targetUsername" value="${detailAccount.username}" />
                                <input type="hidden" name="response" value="accept" />
                                <button class="small-btn btn-update" type="submit">Chấp nhận</button>
                            </form>
                            <form action="admin" method="post" style="display:inline-block;">
                                <input type="hidden" name="view" value="accounts" />
                                <input type="hidden" name="action" value="respondDeleteAdmin" />
                                <input type="hidden" name="targetUsername" value="${detailAccount.username}" />
                                <input type="hidden" name="response" value="reject" />
                                <button class="small-btn btn-delete" type="submit">Từ chối</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </c:if>
            <div class="form-card" style="margin-top: 20px;">
                <div class="form-grid">
                    <div class="field"><label>Username</label><div>${detailAccount.username}</div></div>
                    <div class="field"><label>Vai trò</label><div><c:choose><c:when test="${detailAccount.role == 1}">Admin</c:when><c:otherwise>Khách hàng</c:otherwise></c:choose></div></div>
                    <div class="field"><label>Họ tên</label><div>${detailCustomer != null ? detailCustomer.fullname : '—'}</div></div>
                    <div class="field"><label>Email</label><div>${detailCustomer != null ? detailCustomer.email : '—'}</div></div>
                    <div class="field"><label>Điện thoại</label><div>${detailCustomer != null ? detailCustomer.phone : '—'}</div></div>
                    <div class="field" style="grid-column: span 2;"><label>Địa chỉ</label><div>${detailCustomer != null ? detailCustomer.address : '—'}</div></div>
                    <div class="field"><label>Điểm</label><div>${detailCustomer != null ? detailCustomer.points : '0'}</div></div>
                    <div class="field"><label>Số đơn</label><div>${detailOrders != null ? detailOrders.size() : 0}</div></div>
                    <div class="field"><label>Sản phẩm trong giỏ</label><div>${detailCart != null ? detailCart.size() : 0}</div></div>
                    <div class="field"><label>Yêu thích</label><div>${detailWishlist != null ? detailWishlist.size() : 0}</div></div>
                </div>
            </div>
            <c:if test="${detailAccount.role == 0 && not empty detailOrders}">
                <div class="section" style="margin-top: 18px;">
                    <h3>Đơn hàng gần đây</h3>
                    <table>
                        <thead>
                            <tr><th>ID</th><th>Tổng tiền</th><th>Trạng thái</th><th>Voucher</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${detailOrders}" var="o">
                                <tr>
                                    <td>${o.id}</td>
                                    <td><fmt:formatNumber value="${o.totalmoney}" type="number" /> đ</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status == 0}">Chờ duyệt</c:when>
                                            <c:when test="${o.status == 1}">Đã xác nhận</c:when>
                                            <c:when test="${o.status == 2}">Đang giao</c:when>
                                            <c:otherwise>Hoàn thành</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${o.voucher_code != null ? o.voucher_code : '—'}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </c:if>

    <c:if test="${not empty editAccount}">
        <div class="section" id="account-edit">
            <h2>Chỉnh sửa tài khoản: ${editAccount.username}</h2>
            <div class="form-card">
                <form action="admin" method="post">
                    <input type="hidden" name="view" value="${view}" />
                    <input type="hidden" name="action" value="editAccount" />
                    <input type="hidden" name="username" value="${editAccount.username}" />
                    <div class="edit-account-top">
                        <div class="field"><label>Username</label><input value="${editAccount.username}" readonly /></div>
                        <div class="field"><label>Mật khẩu mới</label><input type="password" name="accountPassword" placeholder="Để trống nếu không đổi" /></div>
                        <div class="field"><label>Vai trò</label>
                            <select id="editAccountRole" name="accountRole">
                                <option value="0" <c:if test="${editAccount.role == 0}">selected</c:if>>Khách hàng</option>
                                <option value="1" <c:if test="${editAccount.role == 1}">selected</c:if>>Admin</option>
                            </select>
                        </div>
                    </div>
                    <div id="editAccountDetailsFields" class="details-panel">
                        <div class="field"><label>Họ tên</label><input name="accountFullname" value="${editCustomer != null ? editCustomer.fullname : ''}" /></div>
                        <div class="field"><label>Email</label><input type="email" name="accountEmail" value="${editCustomer != null ? editCustomer.email : ''}" /></div>
                        <div class="field"><label>Điện thoại</label><input name="accountPhone" value="${editCustomer != null ? editCustomer.phone : ''}" /></div>
                        <div class="field"><label>Địa chỉ</label><input name="accountAddress" value="${editCustomer != null ? editCustomer.address : ''}" /></div>
                    </div>
                    <div class="form-actions">
                        <a href="admin?view=accounts" class="small-btn btn-delete">Hủy</a>
                        <button class="btn-save" type="submit">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>
</c:if>

    <c:if test="${view == 'addAccount'}">
        <div class="section" id="add-account">
            <div class="admin-subnav">
                <a href="admin?view=accounts" class="${view == 'accounts' ? 'active' : ''}">Danh sách tài khoản</a>
                <a href="admin?view=addAccount" class="${view == 'addAccount' ? 'active' : ''}">Thêm tài khoản</a>
            </div>
            <h2>Thêm tài khoản mới</h2>
            <div class="form-card">
                <form action="admin" method="post">
                    <input type="hidden" name="view" value="accounts" />
                    <input type="hidden" name="action" value="addAccount" />
                    <div class="form-grid">
                        <div class="field"><label>Username</label><input name="accountUsername" required /></div>
                        <div class="field"><label>Mật khẩu</label><input type="password" name="accountPassword" required /></div>
                        <div class="field"><label>Vai trò</label>
                            <select name="accountRole" id="accountRole">
                                <option value="0">Khách hàng</option>
                                <option value="1">Admin</option>
                            </select>
                        </div>
                    </div>
                    <div id="accountDetailsFields" class="form-grid" style="margin-top: 18px;">
                        <div class="field"><label>Họ tên</label><input name="accountFullname" required /></div>
                        <div class="field"><label>Email</label><input type="email" name="accountEmail" required /></div>
                        <div class="field"><label>Điện thoại</label><input name="accountPhone" required /></div>
                        <div class="field" style="grid-column: span 2;"><label>Địa chỉ</label><input name="accountAddress" required /></div>
                    </div>
                    <button class="btn-save" type="submit">Thêm tài khoản</button>
                </form>
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
        <c:choose>
            <c:when test="${empty orders}">
                <div class="section-card" style="padding: 24px; text-align: center; border: 1px solid rgba(215, 0, 24, 0.15); background: #fff6f6; color: #7a1c1c;">
                    <h3>Chưa có đơn hàng nào</h3>
                    <p>Hiện tại chưa có đơn hàng mới. Khi có khách đặt hàng, danh sách sẽ xuất hiện tại đây.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr><th>ID</th><th>Khách</th><th>Tổng tiền</th><th>Phương thức</th><th>Trạng thái</th><th>Địa chỉ</th><th>Voucher</th><th>Chi tiết</th><th>Hành động</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${orders}" var="o">
                            <tr>
                        <td>${o.id}</td>
                        <td>${o.username}</td>
                        <td><fmt:formatNumber value="${o.totalmoney}" type="number" /> đ</td>
                        <td><c:choose>
                            <c:when test="${o.paymentMethod == 'cod'}">COD</c:when>
                            <c:otherwise>QR/Ngân hàng</c:otherwise>
                        </c:choose></td>
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
                                    <option value="0" <c:if test="${o.status == 0}">selected</c:if>>Chờ duyệt</option>
                                    <option value="1" <c:if test="${o.status == 1}">selected</c:if>>Đã xác nhận</option>
                                    <option value="2" <c:if test="${o.status == 2}">selected</c:if>>Đã giao</option>
                                </select>
                                <button class="small-btn btn-update" type="submit">Cập nhật</button>
                            </form>
                            <form action="admin" method="post" style="display:inline-block;">
                                <input type="hidden" name="view" value="${view}" />
                                <input type="hidden" name="action" value="deleteOrder" />
                                <input type="hidden" name="orderId" value="${o.id}" />
                                <button class="small-btn btn-delete" type="submit">Xóa đơn hàng</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
            </c:otherwise>
        </c:choose>
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

    const accountRoleSelects = Array.from(document.querySelectorAll('#accountRole, #editAccountRole'));
    const accountDetailsFieldsGroups = Array.from(document.querySelectorAll('#accountDetailsFields, #editAccountDetailsFields'));

    function toggleAccountDetailsFields(select) {
        if (!select) return;
        const isAdminRole = select.value === '1';
        const groupId = select.id === 'editAccountRole' ? 'editAccountDetailsFields' : 'accountDetailsFields';
        const fieldsGroup = document.getElementById(groupId);
        if (!fieldsGroup) return;
        fieldsGroup.style.display = isAdminRole ? 'none' : 'grid';
        fieldsGroup.querySelectorAll('input').forEach(input => {
            if (isAdminRole) {
                input.removeAttribute('required');
            } else {
                input.setAttribute('required', 'required');
            }
        });
    }

    accountRoleSelects.forEach(select => {
        select.addEventListener('change', () => toggleAccountDetailsFields(select));
        toggleAccountDetailsFields(select);
    });
</script>
</html>

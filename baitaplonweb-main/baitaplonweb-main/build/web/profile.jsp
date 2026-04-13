<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thông tin cá nhân</title>

<style>
body {
    margin: 0;
    font-family: Arial;
    background: #f5f5f5;
}

/* HEADER */
.header {
    background: #d70018;
    color: white;
    padding: 15px 30px;
    font-size: 20px;
    font-weight: bold;
}

/* LAYOUT */
.container {
    max-width: 1100px;
    margin: 30px auto;
    display: flex;
    gap: 20px;
}

/* SIDEBAR */
.sidebar {
    width: 250px;
    background: white;
    border-radius: 10px;
    padding: 20px;
    text-align: center;
}

.avatar {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: #ddd;
    margin: 0 auto 10px;
}

.username {
    font-weight: bold;
    margin-bottom: 15px;
}

.menu a {
    display: block;
    padding: 10px;
    text-decoration: none;
    color: #333;
    border-radius: 6px;
    margin-bottom: 5px;
}

.menu a:hover {
    background: #fff1f2;
    color: #d70018;
}

/* CONTENT */
.content {
    flex: 1;
    background: white;
    border-radius: 10px;
    padding: 25px;
}

.title {
    font-size: 20px;
    margin-bottom: 20px;
    font-weight: bold;
}

/* FORM */
.form-group {
    margin-bottom: 15px;
}

label {
    display: block;
    margin-bottom: 5px;
    font-size: 14px;
}

input {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 6px;
}

.row {
    display: flex;
    gap: 15px;
}

.row .form-group {
    flex: 1;
}

button {
    background: #d70018;
    color: white;
    border: none;
    padding: 12px;
    width: 200px;
    border-radius: 6px;
    cursor: pointer;
}

button:hover {
    background: #a50012;
}

/* BOX PASSWORD */
.password-box {
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid #eee;
}

.tab-panel {
    display: none;
}

.tab-panel.active {
    display: block;
}

.tab-nav {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 20px;
}

.tab-nav button {
    width: 100%;
    border: none;
    background: #f7f7f7;
    color: #333;
    padding: 12px 16px;
    border-radius: 10px;
    font-size: 14px;
    text-align: left;
    cursor: pointer;
    transition: background 0.2s ease, color 0.2s ease;
}

.tab-nav button.active,
.tab-nav button:hover {
    background: #d70018;
    color: white;
}

    .menu-link {
        display: block;
        padding: 12px 16px;
        border-radius: 10px;
        background: #f7f7f7;
        color: #333;
        text-decoration: none;
        font-weight: 600;
        transition: background 0.2s ease, color 0.2s ease;
    }

    .menu-link:hover {
        background: #fff1f2;
        color: #d70018;
    }

</style>
<link rel="stylesheet" href="css/style.css">

</head>

<body>

<div class="header">
    <a href="home" style="color: white; text-decoration: none;">
        MY CELL PHONE
    </a>
</div>

<div class="container">

    <!-- SIDEBAR -->
    <div class="sidebar">
            <div class="avatar"></div>
            <div class="username">${customer.username}</div>

            <div class="tab-nav">
                <button type="button" class="${empty activeTab || activeTab == 'tab-info' ? 'active' : ''}" data-target="tab-info">👤 Thông tin cá nhân</button>
                <button type="button" class="${activeTab == 'tab-edit' ? 'active' : ''}" data-target="tab-edit">✏️ Chỉnh sửa thông tin cá nhân</button>
                <button type="button" class="${activeTab == 'tab-password' ? 'active' : ''}" data-target="tab-password">🔒 Thay đổi mật khẩu</button>
                <a href="home" class="menu-link">🏠 Trang chủ</a>
            </div>
        </div>
    <!-- CONTENT -->
    <div class="content">

            <div class="title">Hồ sơ của tôi</div>

        <c:if test="${not empty message}">
            <div style="margin-bottom:20px; padding:12px 16px; border-radius:8px; background:#eaf7ea; color:#175a21;">
                ${message}
            </div>
        </c:if>

        <div style="display:flex; gap:16px; flex-wrap:wrap; margin-bottom:24px;">
            <div style="flex:1; min-width:180px; padding:16px; background:#f7f7f7; border-radius:10px;">
                <div style="font-size:14px; color:#555; margin-bottom:8px;">Giỏ hàng</div>
                <div style="font-size:28px; font-weight:bold; color:#d70018;">${cartCount}</div>
            </div>
            <div style="flex:1; min-width:180px; padding:16px; background:#f7f7f7; border-radius:10px;">
                <div style="font-size:14px; color:#555; margin-bottom:8px;">Wishlist</div>
                <div style="font-size:28px; font-weight:bold; color:#0d4b87;">${wishlistCount}</div>
            </div>
            <div style="flex:1; min-width:180px; padding:16px; background:#f7f7f7; border-radius:10px;">
                <div style="font-size:14px; color:#555; margin-bottom:8px;">Đơn hàng</div>
                <div style="font-size:28px; font-weight:bold; color:#137333;">${orders.size()}</div>
            </div>
        </div>

        <div id="tab-info" class="tab-panel ${empty activeTab || activeTab == 'tab-info' ? 'active' : ''}">
            <div class="title">Thông tin cá nhân</div>
            <div style="display:flex; gap:16px; flex-wrap:wrap; margin-bottom:24px;">
                <div style="flex:1; min-width:240px; padding:16px; background:#f7f7f7; border-radius:10px;">
                    <div style="font-size:14px; color:#555; margin-bottom:8px;">Họ tên</div>
                    <div style="font-size:16px; font-weight:600;">${customer.fullname}</div>
                </div>
                <div style="flex:1; min-width:240px; padding:16px; background:#f7f7f7; border-radius:10px;">
                    <div style="font-size:14px; color:#555; margin-bottom:8px;">Email</div>
                    <div style="font-size:16px; font-weight:600;">${customer.email}</div>
                </div>
                <div style="flex:1; min-width:240px; padding:16px; background:#f7f7f7; border-radius:10px;">
                    <div style="font-size:14px; color:#555; margin-bottom:8px;">Số điện thoại</div>
                    <div style="font-size:16px; font-weight:600;">${customer.phone}</div>
                </div>
                <div style="flex:1; min-width:240px; padding:16px; background:#f7f7f7; border-radius:10px;">
                    <div style="font-size:14px; color:#555; margin-bottom:8px;">Điểm tích lũy</div>
                    <div style="font-size:16px; font-weight:600;">${customer.points}</div>
                </div>
            </div>
            <div style="padding:16px; background:#f7f7f7; border-radius:10px;">
                <div style="font-size:14px; color:#555; margin-bottom:8px;">Địa chỉ</div>
                <div style="font-size:16px; font-weight:600;">${customer.address}</div>
            </div>
        </div>

        <div id="tab-edit" class="tab-panel ${activeTab == 'tab-edit' ? 'active' : ''}">
            <div class="title">Chỉnh sửa thông tin cá nhân</div>
            <form action="profile" method="post">
                <input type="hidden" name="action" value="updateInfo"/>

                <div class="row">
                    <div class="form-group">
                        <label>Họ tên</label>
                        <input type="text" name="fullname" value="${customer.fullname}">
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="text" name="email" value="${customer.email}">
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" value="${customer.phone}">
                    </div>

                    <div class="form-group">
                        <label>Điểm tích lũy</label>
                        <input type="text" value="${customer.points}" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label>Địa chỉ</label>
                    <input type="text" name="address" value="${customer.address}">
                </div>

                <button type="submit">Lưu thay đổi</button>
            </form>
        </div>

        <div id="tab-password" class="tab-panel ${activeTab == 'tab-password' ? 'active' : ''}">
            <div class="title">Thay đổi mật khẩu</div>
            <form action="profile" method="post">
                <input type="hidden" name="action" value="changePassword"/>

                <div class="form-group">
                    <label>Mật khẩu cũ</label>
                    <input type="password" name="oldPass">
                </div>

                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <input type="password" name="newPass">
                </div>

                <div class="form-group">
                    <label>Nhập lại mật khẩu</label>
                    <input type="password" name="rePass">
                </div>

                <button type="submit">Đổi mật khẩu</button>
            </form>
        </div>
            <div class="title">Lịch sử đơn hàng</div>
            <div style="overflow-x:auto; background:white; border-radius:10px; padding:16px; box-shadow:0 6px 18px rgba(0,0,0,0.06);">
            <table style="width:100%; border-collapse:collapse;">
                <thead>
                    <tr style="background:#f0f7ff; color:#0d4b87; text-align:left;">
                        <th style="padding:12px 8px;">Mã đơn</th>
                        <th style="padding:12px 8px;">Ngày</th>
                        <th style="padding:12px 8px;">Tổng tiền</th>
                        <th style="padding:12px 8px;">Trạng thái</th>
                        <th style="padding:12px 8px;">Voucher</th>
                        <th style="padding:12px 8px;">Theo dõi</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orders}" var="order">
                        <tr style="border-bottom:1px solid #eee;">
                            <td style="padding:12px 8px;">${order.id}</td>
                            <td style="padding:12px 8px;"><fmt:formatDate value="${order.date}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td style="padding:12px 8px; color:#d70018; font-weight:bold;"><fmt:formatNumber value="${order.totalmoney}" type="number" /> đ</td>
                            <td style="padding:12px 8px;">
                                <c:choose>
                                    <c:when test="${order.status == 0}">Chờ duyệt</c:when>
                                    <c:when test="${order.status == 1}">Đã xác nhận</c:when>
                                    <c:when test="${order.status == 2}">Đã giao</c:when>
                                    <c:otherwise>Đã hủy</c:otherwise>
                                </c:choose>
                            </td>
                            <td style="padding:12px 8px;">${order.voucher_code}</td>
                            <td style="padding:12px 8px;">
                                <a href="order?orderId=${order.id}" style="color:#0d4b87; text-decoration:none; font-weight:bold;">Xem</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="5" style="padding:16px 8px; text-align:center; color:#666;">Bạn chưa có đơn hàng nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </div>

</div>

<script>
    const tabButtons = document.querySelectorAll('.tab-nav button');
    const panels = document.querySelectorAll('.tab-panel');

    tabButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            tabButtons.forEach(b => b.classList.remove('active'));
            panels.forEach(panel => panel.classList.remove('active'));
            btn.classList.add('active');
            const target = document.getElementById(btn.dataset.target);
            if (target) {
                target.classList.add('active');
            }
        });
    });
</script>

</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết đơn hàng</title>
<style>
body { margin: 0; font-family: Arial, sans-serif; background: #f4f5f8; color: #333; }
.header { background: #d70018; color: white; padding: 18px 30px; display: flex; justify-content: space-between; align-items: center; }
.header a { color: white; text-decoration: none; font-weight: bold; }
.container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
.card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); margin-bottom: 24px; }
.card h2 { margin-top: 0; }
.table { width: 100%; border-collapse: collapse; }
.table th, .table td { padding: 12px 10px; border-bottom: 1px solid #ececec; text-align: left; }
.table th { background: #f0f7ff; color: #0d4b87; }
.status-pill { display: inline-flex; align-items: center; padding: 6px 10px; border-radius: 999px; font-size: 13px; font-weight: bold; }
.status-0 { background: #fff2cc; color: #a56f00; }
.status-1 { background: #d9f7e4; color: #137333; }
.status-2 { background: #deebff; color: #0d4b87; }
.status-3 { background: #ffe3e3; color: #a80000; }
.button { display: inline-block; margin-top: 14px; padding: 12px 20px; border-radius: 8px; background: #d70018; color: white; text-decoration: none; }
</style>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="header">
    <div>MY CELLPHONE S</div>
    <div><a href="${isAdminView ? 'admin' : 'profile'}">← Quay lại</a></div>
</div>
<div class="container">
    <div class="card">
        <h2>Chi tiết đơn hàng #${order.id}</h2>
        <p><strong>Khách hàng:</strong> ${order.username}</p>
        <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.date}" pattern="yyyy-MM-dd HH:mm"/></p>
        <p><strong>Địa chỉ nhận hàng:</strong> ${order.shipping_address}</p>
        <p><strong>Người nhận:</strong> ${order.receiver_name} - ${order.receiver_phone}</p>
        <p><strong>Voucher:</strong> ${order.voucher_code != null && order.voucher_code != '' ? order.voucher_code : 'Không có'}</p>
        <p><strong>Trạng thái:</strong>
            <c:choose>
                <c:when test="${order.status == 0}"><span class="status-pill status-0">Chờ duyệt</span></c:when>
                <c:when test="${order.status == 1}"><span class="status-pill status-1">Đã xác nhận</span></c:when>
                <c:when test="${order.status == 2}"><span class="status-pill status-2">Đã giao</span></c:when>
                <c:otherwise><span class="status-pill status-3">Đã hủy</span></c:otherwise>
            </c:choose>
        </p>
    </div>

    <div class="card">
        <h2>Sản phẩm trong đơn</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Giá gốc</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${details}" var="detail">
                    <tr>
                        <td>${productMap[detail.pid].name}</td>
                        <td><fmt:formatNumber value="${detail.price}" type="number" /> đ</td>
                        <td>${detail.quantity}</td>
                        <td><fmt:formatNumber value="${detail.price * detail.quantity}" type="number" /> đ</td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="3" style="text-align:right; font-weight:bold; padding:12px 10px;">Tổng đơn hàng</td>
                    <td style="font-weight:bold; padding:12px 10px;"><fmt:formatNumber value="${order.totalmoney}" type="number" /> đ</td>
                </tr>
            </tfoot>
        </table>
    </div>

    <a href="${isAdminView ? 'admin' : 'profile'}" class="button">Quay về ${isAdminView ? 'Admin' : 'Hồ sơ'}</a>
</div>
</body>
</html>

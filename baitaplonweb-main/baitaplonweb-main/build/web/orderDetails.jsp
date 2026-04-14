<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết đơn hàng</title>
<style>
body { margin: 0; font-family: 'Inter', Arial, sans-serif; background: #eef2f7; color: #1f2937; }
.container { max-width: 1080px; margin: 36px auto; padding: 0 20px; }
.card { background: #ffffff; border-radius: 24px; padding: 28px; box-shadow: 0 16px 40px rgba(15, 23, 42, 0.08); margin-bottom: 24px; }
.card h2 { margin-top: 0; margin-bottom: 18px; font-size: 1.65rem; color: #111827; }
.order-meta-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; margin-bottom: 22px; }
.order-meta-item { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 18px; padding: 20px; }
.order-meta-item strong { display: block; font-size: 0.95rem; color: #475569; margin-bottom: 10px; }
.order-meta-item span { display: block; font-size: 0.98rem; color: #0f172a; line-height: 1.7; }
.order-tag { display: inline-flex; align-items: center; padding: 8px 14px; border-radius: 999px; font-size: 0.95rem; font-weight: 700; letter-spacing: 0.01em; }
.order-tag.gray { background: #e2e8f0; color: #334155; }
.order-tag.green { background: #dcfce7; color: #166534; }
.order-tag.yellow { background: #fef3c7; color: #92400e; }
.order-tag.red { background: #fee2e2; color: #991b1b; }
.table { width: 100%; border-collapse: collapse; margin-top: 10px; }
.table th, .table td { padding: 14px 14px; border-bottom: 1px solid #e2e8f0; text-align: left; }
.table th { background: #f8fafc; color: #0f172a; font-weight: 700; }
.table tbody tr:hover { background: #f8fafc; }
.table tfoot td { border-top: 2px solid #cbd5e1; font-weight: 700; }
.status-pill { display: inline-flex; align-items: center; padding: 8px 12px; border-radius: 999px; font-size: 0.9rem; font-weight: 700; }
.status-0 { background: #fef3c7; color: #92400e; }
.status-1 { background: #dcfce7; color: #166534; }
.status-2 { background: #dbeafe; color: #1d4ed8; }
.status-3 { background: #fee2e2; color: #991b1b; }
.button { display: inline-flex; align-items: center; justify-content: center; margin-top: 14px; padding: 13px 22px; border-radius: 14px; background: #1d4ed8; color: white; text-decoration: none; font-weight: 600; border: none; cursor: pointer; }
.button:hover { background: #1e40af; }
.review-box { white-space: pre-wrap; padding: 18px; border-radius: 18px; background: #f8fafc; border: 1px solid #cbd5e1; color: #0f172a; line-height: 1.75; }
.review-textarea { width: 100%; border: 1px solid #cbd5e1; border-radius: 14px; padding: 16px; font-size: 0.95rem; resize: vertical; margin-top: 8px; min-height: 140px; background: #f8fafc; }
.error-message { color: #b91c1c; font-weight: 600; margin-bottom: 14px; }
.success-message { color: #166534; font-weight: 600; margin-bottom: 14px; }
.label-block { display: block; margin-bottom: 8px; font-size: 0.95rem; color: #475569; }
</style>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<jsp:include page="header.jsp" />
<div class="container">
    <div style="margin: 18px 0;">
        <a href="${isAdminView ? 'admin' : 'profile'}" class="btn btn-secondary">← Quay lại</a>
    </div>
    <div class="card">
        <h2>Chi tiết đơn hàng #${order.id}</h2>
        <div class="order-meta-grid">
            <div class="order-meta-item">
                <strong>Thông tin đơn hàng</strong>
                <span>Người đặt: <c:out value="${customer != null && customer.fullname != null && customer.fullname != '' ? customer.fullname : order.username}"/></span>
                <span>Username: ${order.username}</span>
                <span>Phương thức: <c:choose><c:when test="${order.paymentMethod == 'cod'}">COD - Thu tiền khi nhận</c:when><c:otherwise>Chuyển khoản</c:otherwise></c:choose></span>
                <span>Voucher: ${order.voucher_code != null && order.voucher_code != '' ? order.voucher_code : 'Không có'}</span>
            </div>
            <div class="order-meta-item">
                <strong>Thông tin giao hàng</strong>
                <span>Người nhận: ${order.receiver_name}</span>
                <span>SĐT: ${order.receiver_phone}</span>
                <span>Địa chỉ: ${order.shipping_address}</span>
                <span class="label-block">Thanh toán: <span class="order-tag ${order.paid ? 'green' : 'yellow'}">${order.paidStatus}</span></span>
                <span class="label-block">Trạng thái: 
                    <c:choose>
                        <c:when test="${order.status == 0}"><span class="order-tag yellow">Chờ duyệt</span></c:when>
                        <c:when test="${order.status == 1}"><span class="order-tag green">Đã xác nhận</span></c:when>
                        <c:when test="${order.status == 2}"><span class="order-tag gray">Đã giao</span></c:when>
                        <c:otherwise><span class="order-tag red">Đã hủy</span></c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
        <div class="order-meta-grid">
            <div class="order-meta-item">
                <strong>Giá sau voucher</strong>
                <span><fmt:formatNumber value="${order.totalmoney}" type="number" /> đ</span>
            </div>
            <div class="order-meta-item">
                <strong>Bản tóm tắt giá</strong>
                <span>Tổng trước voucher: <fmt:formatNumber value="${originalTotal}" type="number" /> đ</span>
                <c:if test="${voucherDiscount > 0}">
                    <span>Giảm voucher: <fmt:formatNumber value="${voucherDiscount}" type="number" /> đ</span>
                </c:if>
            </div>
        </div>
    </div>

    <c:if test="${feedback != null}">
        <div class="card">
            <h2>Nhận xét đã gửi</h2>
            <p><strong>Nhận xét:</strong></p>
            <div class="review-box">${feedback.comment}</div>
            <p style="margin-top:10px; color:#555; font-size:0.95rem;">Gửi lúc: <fmt:formatDate value="${feedback.createdDate}" pattern="dd/MM/yyyy HH:mm"/></p>
        </div>
    </c:if>

    <c:if test="${showReviewForm}">
        <div class="card">
            <h2>Đánh giá đơn hàng</h2>
            <c:if test="${not empty reviewError}">
                <p class="error-message">${reviewError}</p>
            </c:if>
            <c:if test="${not empty reviewSuccess}">
                <p class="success-message">${reviewSuccess}</p>
            </c:if>
            <form action="order" method="post">
                <input type="hidden" name="orderId" value="${order.id}" />
                <label for="comment">Nhận xét của bạn</label>
                <textarea id="comment" name="comment" rows="5" class="review-textarea"></textarea>
                <button type="submit" class="button">Gửi nhận xét</button>
            </form>
        </div>
    </c:if>

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

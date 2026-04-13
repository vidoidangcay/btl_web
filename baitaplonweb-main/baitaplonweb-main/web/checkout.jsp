<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thanh toán</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f6f6f6;
}

/* HEADER */
.header {
    background: #d70018;
    color: white;
    padding: 15px 30px;
    font-weight: bold;
    display: flex;
    justify-content: space-between;
}

.header a {
    color: white;
    text-decoration: none;
}

/* BOX */
.box {
    background: white;
    width: 420px;
    margin: 50px auto;
    padding: 30px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 5px 20px rgba(0,0,0,0.1);
}

/* TITLE */
h2 {
    margin-bottom: 10px;
}

/* PRICE */
.price {
    color: #d70018;
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 15px;
}

/* QR */
.qr-box img {
    width: 260px;
    border-radius: 10px;
    border: 1px solid #eee;
    padding: 10px;
    background: #fafafa;
}

/* NOTE */
.note {
    margin-top: 15px;
    font-size: 14px;
    color: #555;
}

/* BUTTONS */
.btn {
    display: block;
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
    border: none;
    cursor: pointer;
}

/* SUCCESS BUTTON */
.btn-success {
    background: #28a745;
    color: white;
}

.btn-success:hover {
    background: #1e7e34;
}

/* BACK BUTTON */
.btn-back {
    background: white;
    border: 1px solid #d70018;
    color: #d70018;
}

.btn-back:hover {
    background: #fff1f2;
}
</style>
<link rel="stylesheet" href="css/style.css">

</head>

<body>

<div class="header">
    <a href="home">MY CELLPHONE S</a>
    <div>Thanh toán</div>
</div>

<div class="box">

    <h2>Thanh toán đơn hàng</h2>

    <div class="price">${totalMoney} đ</div>

    <c:if test="${not empty error}">
        <div class="alert">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${showQR == true}">
            <div class="qr-box">
                <img 
                src="https://img.vietqr.io/image/BIDV-8820036081-compact2.png?amount=${totalMoney}&addInfo=ThanhToan_${sessionScope.accounts.username}"
                />
            </div>
            <div class="note">
                Quét mã QR bằng app ngân hàng để thanh toán<br>
                Nội dung chuyển khoản đã được tự động điền
            </div>

            <form action="payment" method="post">
                <input type="hidden" name="action" value="done"/>
                <input type="hidden" name="name" value="${paymentName}"/>
                <input type="hidden" name="phone" value="${paymentPhone}"/>
                <input type="hidden" name="address" value="${paymentAddress}"/>
                <button type="submit" class="btn btn-success">
                    ✔ Tôi đã thanh toán
                </button>
            </form>
        </c:when>
        <c:otherwise>
            <form action="checkout" method="post">
                <div class="form-group">
                    <label class="form-label" for="name">Tên người nhận</label>
                    <input id="name" type="text" name="name" value="${paymentName != null ? paymentName : customer.fullname}" placeholder="Nguyễn Văn A" />
                </div>
                <div class="form-group">
                    <label class="form-label" for="phone">Số điện thoại</label>
                    <input id="phone" type="tel" name="phone" value="${paymentPhone != null ? paymentPhone : customer.phone}" placeholder="0912345678" />
                </div>
                <div class="form-group">
                    <label class="form-label" for="address">Địa chỉ nhận hàng</label>
                    <textarea id="address" name="address" rows="3" placeholder="Số nhà, đường, quận, thành phố">${paymentAddress != null ? paymentAddress : customer.address}</textarea>
                </div>

                <button type="submit" class="btn btn-success">
                    📩 Tiếp tục đến QR
                </button>
            </form>
        </c:otherwise>
    </c:choose>

    <a href="cart" class="btn btn-back">
        ← Quay lại giỏ hàng
    </a>

</div>

</body>
</html>
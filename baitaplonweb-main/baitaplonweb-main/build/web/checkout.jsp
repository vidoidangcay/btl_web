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
    background: linear-gradient(180deg, #ffffff 0%, #fff8f8 100%);
    width: min(540px, calc(100% - 40px));
    margin: 40px auto;
    padding: 36px;
    border-radius: 24px;
    text-align: left;
    box-shadow: 0 25px 60px rgba(0,0,0,0.12);
    border: 1px solid rgba(215, 0, 24, 0.12);
}

/* TITLE */
h2 {
    margin-bottom: 16px;
    font-size: 28px;
    letter-spacing: -0.03em;
    color: #1f1f1f;
}

/* PRICE */
.price {
    color: #d70018;
    font-size: 28px;
    font-weight: 800;
    margin-bottom: 20px;
}

.form-row {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 18px;
}

.form-group {
    display: flex;
    flex-direction: column;
    text-align: left;
    margin-bottom: 16px;
}

.form-label {
    margin-bottom: 8px;
    font-weight: 700;
    color: #333;
    font-size: 14px;
}

input[type="text"], input[type="tel"], textarea {
    width: 100%;
    padding: 14px 16px;
    border: 1px solid #e4e4e6;
    border-radius: 14px;
    font-size: 15px;
    color: #2a2a2a;
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
    background: #fff;
}

input[type="text"]:focus,
input[type="tel"]:focus,
textarea:focus {
    outline: none;
    border-color: #d70018;
    box-shadow: 0 0 0 4px rgba(215, 0, 24, 0.12);
}

textarea {
    min-height: 120px;
    resize: vertical;
}

.alert {
    margin: 18px 0;
    padding: 14px 16px;
    border-radius: 14px;
    background: #fff3f3;
    color: #8a1f1f;
    border: 1px solid #f5c2c2;
}

.qr-box {
    margin: 0 auto;
    max-width: 420px;
    border-radius: 24px;
    padding: 20px;
    background: #fff;
    border: 1px solid #f0e8e8;
    box-shadow: 0 20px 45px rgba(0,0,0,0.08);
    text-align: center;
}

.qr-box img {
    width: 100%;
    max-width: 360px;
    border-radius: 22px;
    border: 1px solid #f0e8e8;
    padding: 16px;
    background: #faf8f8;
}

.qr-box p {
    margin: 0;
    font-size: 15px;
    color: #4a4a4a;
    line-height: 1.7;
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
    <a href="home">MY CELL PHONE</a>
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
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="name">Tên người nhận</label>
                        <input id="name" type="text" name="name" value="${paymentName != null ? paymentName : customer.fullname}" placeholder="Nguyễn Văn A" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="phone">Số điện thoại</label>
                        <input id="phone" type="tel" name="phone" value="${paymentPhone != null ? paymentPhone : customer.phone}" placeholder="0912345678" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="address">Địa chỉ nhận hàng</label>
                    <textarea id="address" name="address" rows="4" placeholder="Số nhà, đường, quận, thành phố">${paymentAddress != null ? paymentAddress : customer.address}</textarea>
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
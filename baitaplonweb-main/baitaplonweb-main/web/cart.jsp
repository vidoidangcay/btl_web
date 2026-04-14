<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Giỏ hàng - Baophone</title>

<style>
body { background: #f6f6f6; margin: 0; font-family: Arial, sans-serif; }
.container { max-width: 1200px; margin: 30px auto; }
.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
.card { background: white; border-radius: 14px; overflow: hidden; transition: 0.3s; border: 1px solid #eee; position: relative; }
.card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
.card img { width: 100%; height: 200px; object-fit: contain; background: #fafafa; }
.card-body { padding: 15px; }
.card h4 { font-size: 15px; height: 40px; overflow: hidden; margin: 10px 0; }
.price { color: #d70018; font-weight: bold; font-size: 16px; }
.old-price { text-decoration: line-through; color: #999; font-size: 13px; font-weight: normal; }
.qty-box { display: flex; align-items: center; margin: 10px 0; }
.qty-box a { width: 30px; height: 30px; display: flex; align-items: center; justify-content: center; background: #eee; text-decoration: none; font-weight: bold; border-radius: 5px; color: black; }
.qty-box span { margin: 0 10px; font-weight: bold; }
.btn-remove { display: block; text-align: center; margin-top: 10px; padding: 8px; background: #eee; color: #666; border-radius: 6px; text-decoration: none; font-size: 13px; }
.btn-remove:hover { background: #d70018; color: white; }
.total { margin-top: 25px; background: white; padding: 20px; border-radius: 10px; text-align: right; font-size: 20px; font-weight: bold; border: 1px solid #eee; }
.empty-box { background: white; padding: 40px; text-align: center; border-radius: 10px; }
.overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.popup { background: white; width: 400px; border-radius: 10px; padding: 20px; }
.voucher { border: 1px solid #ddd; padding: 10px; border-radius: 6px; margin-bottom: 10px; cursor: pointer; }
.voucher:hover { border-color: #d70018; }
</style>
<link rel="stylesheet" href="css/style.css">
</head>

<body>

<c:if test="${sessionScope.accounts == null}">
    <c:redirect url="login.jsp"/>
</c:if>

<jsp:include page="header.jsp" />

<div class="container">
    <h2>🛒 Giỏ hàng của bạn</h2>

    <c:if test="${isSuccess != null && isSuccess == false}">
        <div style="background:#fff3cd; padding:15px; border-radius:8px; margin-bottom:20px;">⚠️ Hết hàng!</div>
    </c:if>

    <c:choose>
        <c:when test="${empty cartList}">
            <div class="empty-box">
                <h3>🛒 Giỏ hàng trống</h3>
                <p>Bạn chưa có sản phẩm nào.</p>
                <a href="home" style="color:#d70018; font-weight:bold;">← Mua sắm ngay</a>
            </div>
        </c:when>

        <c:otherwise>
            <c:set var="finalTotalMoney" value="0"/>

            <div class="grid">
                <c:forEach items="${cartList}" var="c">
                    <c:set var="p" value="${productMap[c.pid]}" />
                    <c:set var="v" value="${voucherDetailMap[c.pid]}" />

                    <c:if test="${p != null}">
                        <div class="card">
                            <img src="${p.image}">
                            <div class="card-body">
                                <h4>${p.name}</h4>

                                <c:choose>
                                    <c:when test="${v != null}">
                                        <c:set var="lineTotal" value="${p.price * c.quantity}"/>
                                        <c:set var="discountedTotal" value="${lineTotal - v.discountValue}"/>
                                        <p class="price">
                                            <span class="old-price">${lineTotal} đ</span> <br/>
                                            ${discountedTotal} đ 
                                            <span style="color: #28a745; font-size: 11px;">(-${v.discountValue}đ)</span>
                                        </p>
                                        <c:set var="currentLineTotal" value="${discountedTotal}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="currentLineTotal" value="${p.price * c.quantity}"/>
                                        <p class="price">${p.price} đ</p>
                                    </c:otherwise>
                                </c:choose>

                                <div class="qty-box">
                                    <a href="cart?action=sub&id=${c.pid}">-</a>
                                    <span>${c.quantity}</span>
                                    <a href="cart?action=add&id=${c.pid}">+</a>
                                </div>

                                <p style="color:#555; font-size: 14px;">
                                    <c:choose>
                                        <c:when test="${v != null}">
                                            Thành tiền sau voucher: <b style="color:#d70018;">${currentLineTotal} đ</b>
                                        </c:when>
                                        <c:otherwise>
                                            Thành tiền: <b style="color:#d70018;">${currentLineTotal} đ</b>
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <a href="checkout?pid=${c.pid}&quantity=${c.quantity}" 
                                   style="display:block; margin-top:10px; padding:10px; background:#28a745; color:white; text-align:center; border-radius:6px; text-decoration:none; font-size: 14px;">
                                   Thanh toán sản phẩm này
                                </a>

                                <a href="cart?showVoucher=${c.pid}" 
                                   style="display:block; margin-top:8px; padding:8px; background:#007bff; color:white; text-align:center; border-radius:6px; text-decoration:none; font-size: 14px;">
                                   🎁 ${v != null ? 'Đổi Voucher' : 'Chọn Voucher'}
                                </a>

                                <a href="cart?action=remove&id=${c.pid}" class="btn-remove">Xóa khỏi giỏ</a>
                            </div>
                        </div>
                        
                        <c:set var="finalTotalMoney" value="${finalTotalMoney + currentLineTotal}"/>
                    </c:if>
                </c:forEach>
            </div>

            <div class="total">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        Tổng thanh toán: <span style="color:#d70018;">${finalTotalMoney} đ</span>
                    </div>
                    <a href="checkout" style="background:#d70018; color:white; padding:12px 25px; border-radius:8px; text-decoration:none; font-size:18px;">
                        Đặt hàng ngay
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<c:if test="${param.showVoucher != null}">
    <div class="overlay">
        <div class="popup">
            <h3 style="margin-top:0;">🎁 Chọn Voucher</h3>
            <p style="font-size: 13px; color: #666;">Áp dụng cho: <b>${productMap[param.showVoucher].name}</b></p>
            
            <form action="applyVoucher" method="post">
                <input type="hidden" name="pid" value="${param.showVoucher}"/>
                
                <div style="max-height: 300px; overflow-y: auto; margin-bottom: 15px;">
                    <c:forEach items="${voucherList}" var="v">
                        <label class="voucher" style="display: block;">
                            <input type="radio" name="voucherId" value="${v.code}" required/>
                            <b style="margin-left: 5px;">${v.code}</b> <br/>
                            <span style="margin-left: 22px; font-size: 13px; color: #d70018;">Giảm: ${v.discountValue} đ</span> <br/>
                            <span style="margin-left: 22px; font-size: 12px; color: #888;">Đơn tối thiểu: ${v.minOrderValue} đ</span>
                        </label>
                    </c:forEach>
                    
                    <c:if test="${empty voucherList}">
                        <p style="text-align: center; color: #999;">Không có voucher khả dụng.</p>
                    </c:if>
                </div>

                <button type="submit" style="background:#28a745; color:white; padding:12px; width:100%; border:none; border-radius:6px; cursor:pointer; font-weight:bold;">
                    Áp dụng Voucher
                </button>
            </form>

            <a href="cart" style="display:block; text-align:center; margin-top:15px; color: #666; text-decoration: none; font-size: 14px;">
                ← Quay lại giỏ hàng
            </a>
        </div>
    </div>
</c:if>

</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết sản phẩm</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

    <div class="section-card" style="width:800px; margin:50px auto; background:white; padding:20px; border-radius:10px;">

        <h2>${detail.name}</h2>

        <img src="${detail.image}" style="width:300px;">

        <p style="color:red; font-size:20px;">
            <fmt:formatNumber value="${detail.price}" /> đ
        </p>

        <p>${detail.describe}</p>

        <c:if test="${sessionScope.accounts == null || sessionScope.accounts.role != 1}">
            <!-- Nút thêm vào giỏ -->
            <a href="cart?id=${detail.id}" 
               style="display:inline-block; padding:10px 20px; background:#d70018; color:white; text-decoration:none; border-radius:5px;">
                🛒 Thêm vào giỏ
            </a>
        </c:if>

    </div>

</body>
</html>
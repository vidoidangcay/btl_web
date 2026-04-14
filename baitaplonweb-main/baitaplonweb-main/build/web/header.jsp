<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="site-header">
    <div class="container" style="display:flex; justify-content:space-between; align-items:center; gap:10px;">
        <div class="logo"><a href="home">MY CELL PHONE</a></div>
        <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap; justify-content:flex-end;">
            <c:choose>
                <c:when test="${sessionScope.accounts != null}">
                    <c:if test="${sessionScope.accounts.role != 1}">
                        <a href="cart" class="header-action" style="margin-right:8px;">🛒 Giỏ hàng</a>
                    </c:if>
                    <c:if test="${sessionScope.accounts.role == 1}">
                        <a href="admin" class="header-action" style="margin-right:8px;">⚙️ Admin</a>
                    </c:if>
                    <a href="profile" class="header-action">👤 Hồ sơ</a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp" class="header-action">Đăng nhập / Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

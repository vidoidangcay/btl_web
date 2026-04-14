<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Baophone - Chuyên Smartphone</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(180deg, #fcfcfc 0%, #f3f3f8 100%);
            color: #333;
        }

        .container {
            max-width: 1320px;
            margin: 0 auto;
            padding: 0 20px 40px;
        }


        .logo {
            font-weight: 900;
            font-size: 28px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .main-layout {
            display: grid;
            grid-template-columns: 320px 1.1fr 300px;
            gap: 24px;
            margin-top: 25px;
            align-items: start;
        }

        .sidebar-left,
        .main-banner,
        .sidebar-right {
            background: white;
            border-radius: 22px;
            box-shadow: 0 14px 35px rgba(50, 50, 93, 0.08);
        }

        .sidebar-left {
            overflow: hidden;
        }

        .main-banner {
            min-height: 380px;
        }

        .sidebar-right {
            padding: 24px;
            display: grid;
            gap: 18px;
        }

        .menu-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .menu-list li a {
            display: block;
            padding: 22px 30px;
            text-decoration: none;
            color: #333;
            border-bottom: 1px solid #f2f2f5;
            font-size: 18px;
            font-weight: 800;
            line-height: 1.6;
            letter-spacing: 0.02em;
            transition: all 0.25s ease;
        }

        .menu-list li a:hover,
        .menu-list li a.active {
            background: #fff1f2;
            color: #d70018;
            transform: translateX(3px);
            border-left: 4px solid #d70018;
            padding-left: 26px;
        }

        .header-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 14px 22px;
            background: white;
            color: #d70018;
            border-radius: 14px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 800;
            box-shadow: 0 10px 20px rgba(0,0,0,0.10);
            transition: transform 0.25s ease, box-shadow 0.25s ease, background 0.25s ease;
        }

        .header-action:hover {
            transform: translateY(-1px);
            background: #fff7f7;
            box-shadow: 0 12px 24px rgba(0,0,0,0.12);
        }

        .banner-box {
            padding: 30px;
            text-align: center;
            color: #222;
            display: grid;
            gap: 18px;
            align-items: center;
            justify-items: center;
        }

        .banner-box h2 {
            margin: 0;
            font-size: 32px;
            line-height: 1.05;
            letter-spacing: -0.03em;
            max-width: 560px;
        }

        .banner-box .banner-subtitle {
            color: #6b6b6b;
            margin: 0;
            max-width: 520px;
            line-height: 1.75;
            font-size: 15px;
        }

        .banner-box .banner-product {
            font-size: 16px;
            font-weight: 700;
            color: #d70018;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .banner-box img {
            width: 100%;
            max-width: 520px;
            height: 320px;
            border-radius: 24px;
            margin-top: 0;
            object-fit: cover;
            box-shadow: 0 18px 38px rgba(0,0,0,0.12);
        }

        .banner-box .btn-banner {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 14px 24px;
            background: linear-gradient(135deg, #d70018 0%, #f25a62 100%);
            color: white;
            border-radius: 16px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 700;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .banner-box .btn-banner:hover {
            transform: translateY(-1px);
            box-shadow: 0 12px 30px rgba(215,0,24,0.24);
        }

        .info-card {
            padding: 24px;
            border-radius: 22px;
            box-shadow: inset 0 0 0 1px rgba(215, 0, 24, 0.08);
        }

        .info-card p {
            margin: 0;
            line-height: 1.7;
            color: #575757;
        }

        .info-card strong {
            color: #d70018;
        }

        .btn-login-trigger {
            display: block;
            width: 100%;
            max-width: 220px;
            margin: 0 auto;
            background: linear-gradient(135deg, #d70018 0%, #f25a62 100%);
            color: white;
            text-align: center;
            padding: 14px 18px;
            text-decoration: none;
            border-radius: 14px;
            font-weight: 700;
            letter-spacing: 0.02em;
            box-shadow: 0 10px 22px rgba(215, 0, 24, 0.18);
            transition: transform 0.25s ease, box-shadow 0.25s ease, background 0.25s ease;
        }

        .btn-login-trigger:hover {
            background: linear-gradient(135deg, #b1000f 0%, #d13e44 100%);
            transform: translateY(-1px);
            box-shadow: 0 14px 26px rgba(215, 0, 24, 0.22);
        }

        .product-section {
            margin-top: 34px;
            margin-bottom: 60px;
        }

        .section-title {
            background: linear-gradient(90deg, rgba(255,255,255,0.98), rgba(255,255,255,0.9));
            padding: 18px 24px;
            border-radius: 20px;
            margin-bottom: 22px;
            border-left: 8px solid #d70018;
            font-weight: 800;
            letter-spacing: 0.02em;
            box-shadow: 0 10px 25px rgba(0,0,0,0.04);
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 24px;
        }

        .product-item {
            background: #ffffff;
            border-radius: 24px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(216, 216, 216, 0.8);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .product-item:hover {
            transform: translateY(-6px);
            box-shadow: 0 22px 45px rgba(93, 55, 145, 0.08);
            border-color: rgba(215, 0, 24, 0.25);
        }

        .product-item img {
            width: 100%;
            height: 200px;
            object-fit: contain;
            margin-bottom: 18px;
        }

        .product-item h3 {
            font-size: 16px;
            color: #1d1d1d;
            margin: 0 0 10px;
            min-height: 46px;
            line-height: 1.35;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-align: left;
        }

        .product-item .price {
            color: #d70018;
            font-weight: 800;
            font-size: 18px;
            margin-bottom: 14px;
            text-align: left;
        }

        .product-item .price small {
            color: #777;
            font-weight: 400;
            display: block;
            margin-top: 4px;
            font-size: 13px;
        }

        .btn-buy {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            padding: 12px 16px;
            background: linear-gradient(135deg, #d70018 0%, #f25a62 100%);
            color: white;
            border: none;
            border-radius: 14px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            transition: all 0.25s ease;
        }

        .btn-buy:hover {
            background: linear-gradient(135deg, #af0015 0%, #dc3b44 100%);
            transform: translateY(-1px);
        }

        .sort-toolbar {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 14px;
            margin-bottom: 18px;
        }

        .sort-toolbar label {
            color: #5e5e5e;
            font-weight: 700;
            font-size: 14px;
        }

        .sort-toolbar select {
            min-width: 200px;
            padding: 12px 14px;
            border: 1px solid #dcdce2;
            border-radius: 14px;
            background: white;
            color: #333;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .sort-toolbar select:focus {
            border-color: #d70018;
            box-shadow: 0 0 0 5px rgba(215, 0, 24, 0.1);
        }

        .pagination {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
            margin-top: 28px;
        }

        .page-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 46px;
            padding: 10px 14px;
            border-radius: 12px;
            border: 1px solid #e2e2e8;
            background: white;
            color: #444;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.25s ease;
        }

        .page-link:hover {
            background: #fce8e9;
            border-color: #f6c7c9;
            color: #d70018;
        }

        .page-link.active {
            background: #d70018;
            color: white;
            border-color: #d70018;
        }

        @media screen and (max-width: 1100px) {
            .main-layout {
                grid-template-columns: 1fr;
            }

            .sidebar-right,
            .sidebar-left,
            .main-banner {
                width: 100%;
            }
        }

        @media screen and (max-width: 720px) {
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            }

            .product-item img {
                height: 160px;
            }
        }
    </style>
            <link rel="stylesheet" href="css/style.css">
<body>

    <jsp:include page="header.jsp" />

    <div class="container">
        <div class="main-layout">
            <aside class="sidebar-left">
            <ul class="menu-list">
                <li><a href="home?cid=0">🏠 Tất cả sản phẩm</a></li>
                <c:forEach items="${categoryList}" var="c">
                    <li><a href="home?cid=${c.id}">• ${c.name}</a></li>
                </c:forEach>
            </ul>
            </aside>

            <section class="main-banner">
                <div class="banner-box">
                    <c:choose>
                        <c:when test="${highlightProduct != null}">
                            <div class="banner-product">Sản phẩm bán chạy nhất</div>
                            <h2>${highlightProduct.name}</h2>
                            <img src="${highlightProduct.image != null && !highlightProduct.image.isEmpty() ? highlightProduct.image : 'https://via.placeholder.com/800x400'}" alt="${highlightProduct.name}" />
                            <c:choose>
                                <c:when test="${sessionScope.accounts != null}">
                                    <a href="detail?pid=${highlightProduct.id}" class="btn-banner">Mua ngay</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="login.jsp" class="btn-banner">Mua ngay</a>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <div class="banner-product">Sản phẩm nổi bật</div>
                            <h2>GALAXY S24 ULTRA</h2>
                            <img src="https://via.placeholder.com/800x400" alt="Banner S24" />
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <aside class="sidebar-right">
                <div class="info-card">
                    <p style="margin-top: 0; font-size: 15px;">Chào mừng bạn đến với <strong>S-Member</strong></p>
                    <c:choose>
                        <c:when test="${sessionScope.accounts == null}">
                            <p style="margin: 18px 0 0; font-size: 15px; color: #555;">Đăng nhập để mua hàng và xem ưu đãi.</p>
                        </c:when>
                        <c:otherwise>
                            <p style="margin: 15px 0;">Xin chào, <strong style="color:#d70018;">${sessionScope.accounts.username}</strong></p>
                            <p style="margin: 10px 0;">
                                <a href="profile" class="btn-login-trigger" style="background: white; color: #d70018;">Hồ sơ</a>
                            </p>
                            <a href="logout" class="btn-login-trigger" style="background: #333;">Đăng xuất</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </aside>
        </div>

        <section class="product-section">
            <div class="section-title">DANH SÁCH SMARTPHONE</div>
            <div class="sort-toolbar">
                <form method="get" action="home" style="display:flex; align-items:center; gap:12px; margin:0;">
                    <input type="hidden" name="cid" value="${currentCid}" />
                    <label for="optionSelect">Option:</label>
                    <select id="optionSelect" name="option" onchange="this.form.submit()">
                        <option value="" <c:if test="${empty sortOption}">selected</c:if>>Mặc định</option>
                        <option value="priceAsc" <c:if test="${sortOption == 'priceAsc'}">selected</c:if>>Giá từ thấp đến cao</option>
                        <option value="priceDesc" <c:if test="${sortOption == 'priceDesc'}">selected</c:if>>Giá từ cao đến thấp</option>
                    </select>
                </form>
            </div>
            <div class="product-grid">
                <c:forEach items="${productList}" var="p">

    <div class="product-item" style="position:relative;">

        <!-- ⭐ WISHLIST STAR -->
        <c:if test="${sessionScope.accounts != null}">

            <c:choose>

                <c:when test="${not empty wishMap[p.id]}">
                    <a href="wishlist?action=remove&id=${p.id}"
                       style="position:absolute; top:8px; right:10px; color:gold; font-size:18px; text-decoration:none;">
                        *
                    </a>
                </c:when>

                <c:otherwise>
                    <a href="wishlist?action=add&id=${p.id}"
                       style="position:absolute; top:8px; right:10px; color:#bbb; font-size:18px; text-decoration:none;">
                        *
                    </a>
                </c:otherwise>

                    </c:choose>

             </c:if>
            
                    <a href="detail?id=${p.id}" style="text-decoration:none;">
                        <img src="${p.image}" alt="${p.name}">
                        <h3>${p.name}</h3>
                        <p class="price"><fmt:formatNumber value="${p.price}" type="number" /> đ</p>
                    </a>

                    <a href="detail?id=${p.id}" class="btn-buy">Mua ngay</a>

                </div>

            </c:forEach>
            </div>
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <c:url var="prevUrl" value="home">
                            <c:param name="page" value="${currentPage - 1}" />
                            <c:if test="${currentCid != 0}">
                                <c:param name="cid" value="${currentCid}" />
                            </c:if>
                        </c:url>
                        <a href="${prevUrl}" class="page-link">&laquo; Trước</a>
                    </c:if>

                    <c:forEach var="pageNum" begin="1" end="${totalPages}">
                        <c:url var="pageUrl" value="home">
                            <c:param name="page" value="${pageNum}" />
                            <c:if test="${currentCid != 0}">
                                <c:param name="cid" value="${currentCid}" />
                            </c:if>
                        </c:url>
                        <a href="${pageUrl}" class="page-link ${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <c:url var="nextUrl" value="home">
                            <c:param name="page" value="${currentPage + 1}" />
                            <c:if test="${currentCid != 0}">
                                <c:param name="cid" value="${currentCid}" />
                            </c:if>
                        </c:url>
                        <a href="${nextUrl}" class="page-link">Tiếp &raquo;</a>
                    </c:if>
                </div>
            </c:if>
        </section>
    </div>

</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Baophone</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { margin: 0; background: #f5f7fb; font-family: Arial, sans-serif; }
        .login-page { max-width: 420px; margin: 60px auto; padding: 30px; background: white; border-radius: 16px; box-shadow: 0 18px 45px rgba(0,0,0,.08); }
        .login-page h2 { margin: 0 0 20px; color: #0d4b87; }
        .login-page p { color: #555; margin-bottom: 25px; }
        .login-page input { width: 100%; padding: 14px 16px; margin-bottom: 14px; border: 1px solid #dde2ea; border-radius: 10px; font-size: 15px; }
        .login-page button { width: 100%; padding: 14px 16px; border: none; border-radius: 10px; background: #d70018; color: white; font-size: 15px; cursor: pointer; transition: .2s; }
        .login-page button:hover { background: #a50012; }
        .info { color: #4a4a4a; margin-top: 18px; font-size: 14px; line-height: 1.6; }
        .link-row { display: flex; justify-content: space-between; gap: 10px; margin-top: 10px; }
        .link-row a { text-decoration: none; color: #d70018; font-weight: bold; }
        .error-box { background: #fce2e2; color: #a81a1a; padding: 12px 16px; border-radius: 10px; margin-bottom: 16px; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="login-page">
        <h2>Đăng nhập tài khoản</h2>

        <% String registered = request.getParameter("registered");
           String error = (String) request.getAttribute("error");
           if (registered != null) { %>
            <div class="error-box" style="background:#e8f7eb; color:#136034;">
                Đăng ký thành công. Vui lòng đăng nhập.
            </div>
        <% } else if (error != null) { %>
            <div class="error-box"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <input type="text" name="user" placeholder="Tên tài khoản" required>
            <input type="password" name="pass" placeholder="Mật khẩu" required>
            <button type="submit">Đăng nhập</button>
        </form>

        <div class="link-row">
            <a href="signup.jsp">Đăng ký mới</a>
            <a href="home">Về trang chủ</a>
        </div>
    </div>
</body>
</html>

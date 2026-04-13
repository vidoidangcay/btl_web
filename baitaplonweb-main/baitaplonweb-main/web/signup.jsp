<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký thành viên - Baophone</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .signup-box {
                max-width: 450px;
                margin: 50px auto;
                padding: 30px;
                border: 1px solid #ddd;
                border-radius: 10px;
                text-align: center;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                font-family: Arial, sans-serif;
            }
            .signup-box input {
                width: 100%;
                padding: 12px;
                margin: 8px 0;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }
            .btn-signup {
                width: 100%;
                padding: 12px;
                background-color: #d70018;
                color: white;
                border: none;
                border-radius: 5px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 15px;
                transition: 0.3s;
            }
            .btn-signup:hover { background-color: #a50012; }
            .error { 
                color: white; 
                background-color: #d70018; 
                padding: 10px; 
                border-radius: 5px; 
                margin-bottom: 15px; 
                font-size: 14px; 
            }
            .section-title {
                text-align: left;
                font-size: 14px;
                font-weight: bold;
                color: #555;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <div class="signup-box">
            <h2 style="color: #d70018; margin-bottom: 5px;">ĐĂNG KÝ SMEMBER</h2>
            <p style="font-size: 13px; color: #666; margin-bottom: 20px;">Tham gia hệ thống bán lẻ điện thoại Baophone</p>
            
            <%-- Hiển thị thông báo lỗi --%>
            <% 
                String error = (String) request.getAttribute("error");
                if(error != null) { 
            %>
                <div class="error"><%= error %></div>
            <% } %>

            <form action="AddAccountServlet" method="post">
                <div class="section-title">Thông tin đăng nhập</div>
                <input type="text" name="user" placeholder="Tên đăng nhập (Username)" required>
                <input type="password" name="pass" placeholder="Mật khẩu" required>
                <input type="password" name="repass" placeholder="Xác nhận mật khẩu" required>
                
                <div class="section-title">Thông tin cá nhân</div>
                <input type="text" name="fullname" placeholder="Họ và tên" required>
                <input type="email" name="email" placeholder="Email (ví dụ: abc@gmail.com)" required>
                <input type="tel" name="phone" placeholder="Số điện thoại" required>
                <input type="text" name="address" placeholder="Địa chỉ giao hàng mặc định" required>
                
                <button type="submit" class="btn-signup">Đăng ký ngay</button>
            </form>
            
            <p style="margin-top: 20px; font-size: 14px;">
                Đã có tài khoản? <a href="login.jsp" style="color: #d70018; font-weight: bold; text-decoration: none;">Đăng nhập tại đây</a>
            </p>
        </div>
    </body>
</html>
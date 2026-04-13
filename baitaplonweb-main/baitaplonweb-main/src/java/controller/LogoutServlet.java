package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Bổ sung urlPatterns để khớp với href="logout" ở JSP
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy session hiện tại nếu nó tồn tại (không tạo mới nếu chưa có)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Xóa sổ toàn bộ dữ liệu trong session (bao gồm account, cart,...)
            session.invalidate(); 
        }
        
        // 3. Chuyển về servlet home để tải dữ liệu sản phẩm lại đúng cách
        response.sendRedirect("home");
    }
}
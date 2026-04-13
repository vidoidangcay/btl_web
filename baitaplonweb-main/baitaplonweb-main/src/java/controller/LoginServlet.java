package controller;

import dal.DAO;
import model.Accounts;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String u = request.getParameter("user");
        String p = request.getParameter("pass");

        DAO dao = new DAO();
        Accounts a = dao.login(u, p); 

        if (a == null) {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // --- ĐĂNG NHẬP THÀNH CÔNG ---
            HttpSession session = request.getSession();
            session.setAttribute("accounts", a);
            
            // 🔥 BƯỚC QUAN TRỌNG: Tái tạo voucherMap từ Database
            // Quét bảng UserVoucher để lấy lại danh sách PID -> VoucherCode đã chọn trước đó
            Map<String, String> savedVouchers = dao.getSavedVouchersByUsername(a.getUsername());
            session.setAttribute("voucherMap", savedVouchers);
            
            if(a.getRole() == 1) {
                response.sendRedirect("admin");
            } else {
                response.sendRedirect("home");
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
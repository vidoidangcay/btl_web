package controller;

import dal.DAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AddAccountServlet", urlPatterns = {"/AddAccountServlet"})
public class AddAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String repass = request.getParameter("repass");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        DAO dao = new DAO();
        
        // 2. Validation
        if (!pass.equals(repass)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        if (dao.checkAccountExist(user) != null) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }
        
        // 3. Gọi DAO thực hiện Transaction
        try {
            dao.register(user, pass, fullname, email, phone, address);
            response.sendRedirect("login.jsp?registered=true");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: Email hoặc SĐT đã được sử dụng!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    }
}
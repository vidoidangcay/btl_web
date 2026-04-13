package controller;

import dal.DAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import model.Accounts;

@WebServlet("/applyVoucher")
public class ApplyVoucherServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        // 1. Kiểm tra đăng nhập
        Accounts acc = (Accounts) session.getAttribute("accounts");
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Lấy dữ liệu từ request
        String username = acc.getUsername();
        String pid = request.getParameter("pid");
        String voucherId = request.getParameter("voucherId");

        // 3. Xử lý logic tại Database (Xóa cũ, hoàn số lượng, trừ số lượng mới, lưu hạn dùng)
        DAO dao = new DAO();
        dao.applyVoucher(username, pid, voucherId);

        // 4. Đồng bộ hóa với Session (Để hiển thị giao diện nhanh)
        Map<String, String> voucherMap = (Map<String, String>) session.getAttribute("voucherMap");
        if (voucherMap == null) {
            voucherMap = new HashMap<>();
        }
        
        if (voucherId == null || voucherId.trim().isEmpty() || voucherId.equals("null")) {
            voucherMap.remove(pid);
        } else {
            voucherMap.put(pid, voucherId);
        }
        
        session.setAttribute("voucherMap", voucherMap);

        // 5. Điều hướng về trang giỏ hàng
        response.sendRedirect("cart");
    }
}
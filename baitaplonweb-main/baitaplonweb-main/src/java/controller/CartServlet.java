package controller;

import dal.DAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;
import model.*;
import java.util.*;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    DAO dao = new DAO();
    
    Accounts acc = (Accounts) session.getAttribute("accounts");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (acc.getRole() == 1) {
        response.sendRedirect("home");
        return;
    }

    String username = acc.getUsername();
    String action = request.getParameter("action");
    String id = request.getParameter("id");
    Map<String, String> voucherMap = (Map<String, String>) session.getAttribute("voucherMap");

    // Xử lý các thao tác giỏ hàng
    if (id != null) {
    if (action == null) {
        // TRƯỜNG HỢP 1: Nhấn từ trang Chi tiết sản phẩm (chỉ có id, không có action)
        dao.addToCart(username, id);
    } else {
        // TRƯỜNG HỢP 2: Nhấn các nút + , - , Xóa trong trang giỏ hàng (có cả id và action)
        switch (action) {
            case "add":
                dao.addToCart(username, id);
                break;
            case "sub":
                dao.subFromCart(username, id);
                break;
            case "remove":
                dao.removeFromCart(username, id);
                // Xóa luôn voucher trong session nếu có
                if (voucherMap != null) {
                    voucherMap.remove(id);
                    session.setAttribute("voucherMap", voucherMap);
                }
                break;
        }
    }
}

    // --- LOGIC ĐỒNG BỘ VOUCHER ---
    Map<String, Vouchers> voucherDetailMap = new HashMap<>();
    if (voucherMap != null) {
        for (String pidKey : voucherMap.keySet()) {
            Vouchers v = dao.getVoucherByCode(voucherMap.get(pidKey));
            if (v != null) voucherDetailMap.put(pidKey, v);
        }
    }

    // Lấy dữ liệu hiển thị
    List<Cart> list = dao.getCartByUser(username);
    Map<String, Products> productMap = new HashMap<>();
    for (Cart c : list) {
        Products p = dao.getProductById(c.getPid());
        if (p != null) productMap.put(c.getPid(), p);
    }

    // Gửi dữ liệu sang JSP
    request.setAttribute("cartList", list);
    request.setAttribute("productMap", productMap);
    request.setAttribute("voucherDetailMap", voucherDetailMap); // Map chứa chi tiết số tiền giảm
    
    // Xử lý hiển thị popup voucher nếu có yêu cầu
    String showVoucher = request.getParameter("showVoucher");
    if (showVoucher != null) {
        request.setAttribute("voucherList", dao.getValidVoucherByPid(showVoucher));
    }

    request.getRequestDispatcher("cart.jsp").forward(request, response);
}
}
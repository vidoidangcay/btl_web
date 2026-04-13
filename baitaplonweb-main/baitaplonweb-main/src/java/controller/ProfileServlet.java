package controller;

import dal.DAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.Accounts;
import model.Customers;
import model.Orders;

import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private void prepareProfilePage(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Accounts acc = (Accounts) session.getAttribute("accounts");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        DAO dao = new DAO();
        Customers customer = dao.getCustomerByUsername(acc.getUsername());
        List<Orders> orders = dao.getOrdersByUsername(acc.getUsername());

        request.setAttribute("customer", customer);
        request.setAttribute("orders", orders);
        request.setAttribute("wishlistCount", dao.getWishlist(acc.getUsername()).size());
        request.setAttribute("cartCount", dao.getCartByUser(acc.getUsername()).size());
        if (message != null) {
            request.setAttribute("message", message);
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareProfilePage(request, response, null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Accounts acc = (Accounts) session.getAttribute("accounts");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        DAO dao = new DAO();

        if ("updateInfo".equals(action)) {
            Customers c = new Customers();
            c.setUsername(acc.getUsername());
            c.setFullname(request.getParameter("fullname"));
            c.setEmail(request.getParameter("email"));
            c.setPhone(request.getParameter("phone"));
            c.setAddress(request.getParameter("address"));
            dao.updateCustomer(c);
            prepareProfilePage(request, response, "Cập nhật thông tin thành công.");
            return;
        }

        if ("changePassword".equals(action)) {
            String oldPass = request.getParameter("oldPass");
            String newPass = request.getParameter("newPass");
            String rePass = request.getParameter("rePass");

            if (oldPass == null || newPass == null || rePass == null || oldPass.isEmpty() || newPass.isEmpty() || rePass.isEmpty()) {
                prepareProfilePage(request, response, "Vui lòng nhập đầy đủ thông tin đổi mật khẩu.");
                return;
            }

            if (!newPass.equals(rePass)) {
                prepareProfilePage(request, response, "Mật khẩu mới không khớp.");
                return;
            }

            if (dao.login(acc.getUsername(), oldPass) == null) {
                prepareProfilePage(request, response, "Mật khẩu cũ không chính xác.");
                return;
            }

            dao.updateAccount(acc.getUsername(), newPass);
            prepareProfilePage(request, response, "Đổi mật khẩu thành công.");
            return;
        }

        response.sendRedirect("profile");
    }
}

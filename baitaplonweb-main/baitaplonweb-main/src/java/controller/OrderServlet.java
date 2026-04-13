package controller;

import dal.DAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Accounts;
import model.OrderDetails;
import model.Orders;
import model.Products;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Accounts acc = (Accounts) session.getAttribute("accounts");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect("profile");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("profile");
            return;
        }

        DAO dao = new DAO();
        Orders order = dao.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("profile");
            return;
        }

        boolean isAdmin = acc.getRole() == 1;
        if (!isAdmin && !acc.getUsername().equals(order.getUsername())) {
            response.sendRedirect("profile");
            return;
        }

        List<OrderDetails> details = dao.getOrderDetailsByOrderId(orderId);
        Map<String, Products> productMap = new HashMap<>();
        for (OrderDetails detail : details) {
            Products p = dao.getProductById(detail.getPid());
            if (p != null) {
                productMap.put(detail.getPid(), p);
            }
        }

        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.setAttribute("productMap", productMap);
        request.setAttribute("isAdminView", isAdmin);
        request.getRequestDispatcher("orderDetails.jsp").forward(request, response);
    }
}

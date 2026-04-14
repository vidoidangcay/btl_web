package controller;

import dal.DAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Accounts;
import model.Customers;
import model.Feedback;
import model.OrderDetails;
import model.Orders;
import model.Products;

import java.io.IOException;
import java.sql.Timestamp;
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
        double originalTotal = 0;
        for (OrderDetails detail : details) {
            Products p = dao.getProductById(detail.getPid());
            if (p != null) {
                productMap.put(detail.getPid(), p);
            }
            originalTotal += detail.getPrice() * detail.getQuantity();
        }

        Customers customer = dao.getCustomerByUsername(order.getUsername());
        double voucherDiscount = originalTotal - order.getTotalmoney();
        if (voucherDiscount < 0) {
            voucherDiscount = 0;
        }

        Feedback feedback = dao.getFeedbackByOrderId(orderId);
        boolean showReviewForm = order.getStatus() == 2 && feedback == null && !isAdmin;

        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.setAttribute("productMap", productMap);
        request.setAttribute("customer", customer);
        request.setAttribute("originalTotal", originalTotal);
        request.setAttribute("voucherDiscount", voucherDiscount);
        request.setAttribute("isAdminView", isAdmin);
        request.setAttribute("feedback", feedback);
        request.setAttribute("showReviewForm", showReviewForm);
        request.getRequestDispatcher("orderDetails.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Accounts acc = (Accounts) session.getAttribute("accounts");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        String comment = request.getParameter("comment");
        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("profile");
            return;
        }

        DAO dao = new DAO();
        Orders order = dao.getOrderById(orderId);
        if (order == null || acc.getRole() == 1 || !acc.getUsername().equals(order.getUsername())) {
            response.sendRedirect("profile");
            return;
        }

        if (order.getStatus() != 2) {
            request.setAttribute("reviewError", "Chỉ có thể nhận xét đơn hàng sau khi đã giao.");
            doGet(request, response);
            return;
        }

        Feedback existingFeedback = dao.getFeedbackByOrderId(orderId);
        if (existingFeedback != null) {
            request.setAttribute("reviewError", "Bạn đã gửi nhận xét cho đơn hàng này.");
            doGet(request, response);
            return;
        }

        if (comment == null || comment.trim().isEmpty()) {
            request.setAttribute("reviewError", "Vui lòng nhập nhận xét.");
            doGet(request, response);
            return;
        }

        Feedback feedback = new Feedback(0, orderId, acc.getUsername(), comment.trim(), new Timestamp(System.currentTimeMillis()));
        dao.addFeedback(feedback);
        request.setAttribute("reviewSuccess", "Cảm ơn bạn đã nhận xét đơn hàng.");
        doGet(request, response);
    }
}

package controller;

import dal.DAO;
import model.*;
import model.OrderShipment;

import java.io.IOException;
import java.util.List;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!"done".equals(request.getParameter("action"))) {
            response.sendRedirect("home");
            return;
        }

        HttpSession session = request.getSession();
        DAO dao = new DAO();

        Accounts acc = (Accounts) session.getAttribute("accounts");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = acc.getUsername();

        List<Cart> checkoutList = (List<Cart>) session.getAttribute("checkoutList");
        Map<String, String> voucherMap = (Map<String, String>) session.getAttribute("voucherMap");

        if (checkoutList == null || checkoutList.isEmpty()) {
            checkoutList = dao.getCartByUser(username);
        }

        if (checkoutList == null || checkoutList.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        double totalMoney = 0;
        List<Cart> selectedItems = new ArrayList<>();

        // =========================
        // 🔥 LẤY DATA + TÍNH TIỀN (1 lần)
        // =========================
        for (Cart c : checkoutList) {
            Products p = dao.getProductById(c.getPid());
            if (p == null) continue;

            double lineTotal = p.getPrice() * c.getQuantity();
            if (voucherMap != null && voucherMap.containsKey(c.getPid())) {
                Vouchers v = dao.getVoucherByCode(voucherMap.get(c.getPid()));
                if (v != null) {
                    lineTotal -= v.getDiscountValue();
                }
            }

            totalMoney += Math.max(0, lineTotal);
            selectedItems.add(c); // lưu lại để dùng tiếp
        }

        if (selectedItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        // =========================
        // 🔥 TẠO ORDER
        // =========================
        Orders order = new Orders();
        order.setUsername(username);
        order.setTotalmoney(totalMoney);
        order.setStatus(0);

        order.setReceiver_name(request.getParameter("name"));
        order.setReceiver_phone(request.getParameter("phone"));
        order.setShipping_address(request.getParameter("address"));

        String orderVoucher = null;
        if (voucherMap != null && !voucherMap.isEmpty()) {
            orderVoucher = voucherMap.values().iterator().next();
        }
        order.setVoucher_code(orderVoucher);

        List<OrderDetails> orderDetails = new ArrayList<>();
        for (Cart c : selectedItems) {
            Products p = dao.getProductById(c.getPid());
            if (p == null) continue;

            OrderDetails od = new OrderDetails();
            od.setPid(c.getPid());
            od.setQuantity(c.getQuantity());
            od.setPrice(p.getPrice());
            orderDetails.add(od);
        }

        OrderShipment shipment = new OrderShipment();
        shipment.setUsername(username);
        shipment.setReceiver_name(request.getParameter("name"));
        shipment.setReceiver_phone(request.getParameter("phone"));
        shipment.setShipping_address(request.getParameter("address"));
        shipment.setStatus(0);
        shipment.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis()));

        int orderId = dao.insertOrderWithDetails(order, orderDetails, shipment);
        if (orderId <= 0) {
            response.sendRedirect("cart");
            return;
        }

        List<String> purchasedPids = new ArrayList<>();
        for (Cart c : selectedItems) {
            dao.removeCartItem(username, c.getPid());
            purchasedPids.add(c.getPid());
        }

        // =========================
        // 🔥 XÓA USER VOUCHER ĐÃ DÙNG
        // =========================
        if (purchasedPids.size() > 0) {
            for (String pid : purchasedPids) {
                dao.deleteUserVoucher(username, pid);
                if (voucherMap != null) {
                    voucherMap.remove(pid);
                }
            }
            session.setAttribute("voucherMap", voucherMap);
        }
        session.removeAttribute("checkoutList");

        // =========================
        // 🔥 DONE
        // =========================
        response.sendRedirect("home");
    }
}
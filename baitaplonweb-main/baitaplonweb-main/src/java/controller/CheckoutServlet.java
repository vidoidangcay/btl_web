package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import dal.DAO;
import java.util.List;
import model.*;
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    DAO dao = new DAO();

    Accounts acc = (Accounts) session.getAttribute("accounts");

    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = acc.getUsername();

    String pid = request.getParameter("pid");

    double totalMoney = 0;

    // 👉 LIST dùng cho payment
    List<Cart> checkoutList = new ArrayList<>();

    Map<String, String> voucherMap = (Map<String, String>) session.getAttribute("voucherMap");
    Map<String, Vouchers> voucherDetailMap = new HashMap<>();
    if (voucherMap != null) {
        for (Map.Entry<String, String> entry : voucherMap.entrySet()) {
            Vouchers v = dao.getVoucherByCode(entry.getValue());
            if (v != null) {
                voucherDetailMap.put(entry.getKey(), v);
            }
        }
    }

    // =========================
    // CASE 1: 1 sản phẩm
    // =========================
    if (pid != null) {

        int quantity = 1;
        try {
            quantity = Integer.parseInt(request.getParameter("quantity"));
        } catch (Exception e) {}

        Products p = dao.getProductById(pid);

        if (p != null) {
            double lineTotal = p.getPrice() * quantity;
            if (voucherDetailMap.containsKey(pid)) {
                lineTotal -= voucherDetailMap.get(pid).getDiscountValue();
            }
            totalMoney = Math.max(0, lineTotal);

            // 👉 tạo Cart giả để đưa vào list
            Cart c = new Cart();
            c.setUsername(username);
            c.setPid(pid);
            c.setQuantity(quantity);

            checkoutList.add(c);

            request.setAttribute("product", p);
            request.setAttribute("quantity", quantity);
        }

    } 
    // =========================
    // CASE 2: toàn bộ giỏ hàng
    // =========================
    else {

        List<Cart> cartList = dao.getCartByUser(username);

        if (cartList != null) {
            for (Cart c : cartList) {
                Products p = dao.getProductById(c.getPid());
                if (p != null) {
                    double lineTotal = p.getPrice() * c.getQuantity();
                    if (voucherDetailMap.containsKey(c.getPid())) {
                        lineTotal -= voucherDetailMap.get(c.getPid()).getDiscountValue();
                    }
                    totalMoney += Math.max(0, lineTotal);
                    checkoutList.add(c);
                }
            }
        }

        request.setAttribute("cartList", cartList);
    }

    Customers customer = dao.getCustomerByUsername(username);
    session.setAttribute("checkoutList", checkoutList);

    request.setAttribute("voucherDetailMap", voucherDetailMap);
    request.setAttribute("totalMoney", totalMoney);
    request.setAttribute("customer", customer);
    request.setAttribute("showQR", false);

    request.getRequestDispatcher("checkout.jsp").forward(request, response);
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

        if (!loadCheckoutData(request, response)) {
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "qr";
        }

        request.setAttribute("paymentName", name);
        request.setAttribute("paymentPhone", phone);
        request.setAttribute("paymentAddress", address);
        request.setAttribute("paymentMethod", paymentMethod);

        if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin nhận hàng trước khi tiếp tục.");
            request.setAttribute("showQR", false);
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        request.setAttribute("showQR", true);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    private boolean loadCheckoutData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DAO dao = new DAO();

        Accounts acc = (Accounts) session.getAttribute("accounts");
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return false;
        }

        String username = acc.getUsername();
        String pid = request.getParameter("pid");

        double totalMoney = 0;
        List<Cart> checkoutList = new ArrayList<>();

        Map<String, String> voucherMap = (Map<String, String>) session.getAttribute("voucherMap");
        Map<String, Vouchers> voucherDetailMap = new HashMap<>();
        if (voucherMap != null) {
            for (Map.Entry<String, String> entry : voucherMap.entrySet()) {
                Vouchers v = dao.getVoucherByCode(entry.getValue());
                if (v != null) {
                    voucherDetailMap.put(entry.getKey(), v);
                }
            }
        }

        if (pid != null) {
            int quantity = 1;
            try {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            } catch (Exception e) {
            }

            Products p = dao.getProductById(pid);
            if (p != null) {
                double lineTotal = p.getPrice() * quantity;
                if (voucherDetailMap.containsKey(pid)) {
                    lineTotal -= voucherDetailMap.get(pid).getDiscountValue();
                }
                totalMoney = Math.max(0, lineTotal);

                Cart c = new Cart();
                c.setUsername(username);
                c.setPid(pid);
                c.setQuantity(quantity);
                checkoutList.add(c);

                request.setAttribute("product", p);
                request.setAttribute("quantity", quantity);
            }
        } else {
            List<Cart> cartList = (List<Cart>) session.getAttribute("checkoutList");
            if (cartList == null || cartList.isEmpty()) {
                cartList = dao.getCartByUser(username);
            }
            if (cartList != null) {
                for (Cart c : cartList) {
                    Products p = dao.getProductById(c.getPid());
                    if (p != null) {
                        double lineTotal = p.getPrice() * c.getQuantity();
                        if (voucherDetailMap.containsKey(c.getPid())) {
                            lineTotal -= voucherDetailMap.get(c.getPid()).getDiscountValue();
                        }
                        totalMoney += Math.max(0, lineTotal);
                        checkoutList.add(c);
                    }
                }
            }
            request.setAttribute("cartList", cartList);
        }

        Customers customer = dao.getCustomerByUsername(username);
        session.setAttribute("checkoutList", checkoutList);

        request.setAttribute("voucherDetailMap", voucherDetailMap);
        request.setAttribute("totalMoney", totalMoney);
        request.setAttribute("customer", customer);
        return true;
    }
}

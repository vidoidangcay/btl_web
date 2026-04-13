package controller;

import dal.DAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/wishlist"})
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        DAO dao = new DAO();

        // check login
        Object accObj = session.getAttribute("accounts");
        if (accObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = ((model.Accounts) accObj).getUsername();

        String action = request.getParameter("action");
        String productId = request.getParameter("id");

        if (action != null && productId != null) {

            switch (action) {

                case "add":
                    dao.addWishlist(username, productId);
                    break;

                case "remove":
                    dao.removeWishlist(username, productId);
                    break;
            }
        }

        // load wishlist -> set
        List<String> list = dao.getWishlist(username);

        Set<String> wishSet = new HashSet<>(list);

        request.setAttribute("wishSet", wishSet);

        // quay về home
        response.sendRedirect("home");
    }
}
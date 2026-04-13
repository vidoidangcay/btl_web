package controller;

import dal.DAO;
import java.io.IOException;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Products;
import model.Accounts;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DAO dao = new DAO();
        HttpSession session = request.getSession();

        // =========================
        // 1. LẤY CID TỪ REQUEST
        // =========================
        String cid_raw = request.getParameter("cid");

        Integer cidSession = (Integer) session.getAttribute("cid");

        int cid;

        if (cid_raw != null && !cid_raw.isEmpty()) {
            try {
                cid = Integer.parseInt(cid_raw);
                session.setAttribute("cid", cid); // update session
            } catch (NumberFormatException e) {
                cid = (cidSession != null) ? cidSession : 0;
            }
        } else {
            cid = (cidSession != null) ? cidSession : 0;
        }

        // =========================
        // 2. GET PRODUCT LIST
        // =========================
        List<Products> list;

        if (cid == 0) {
            list = dao.getAllProducts();
        } else {
            list = dao.getProductsByCid(cid);
        }

        // =========================
        // 3. WISHLIST
        // =========================
        Accounts acc = (Accounts) session.getAttribute("accounts");

        Set<String> wishSet = new HashSet<>();

        if (acc != null) {
            List<String> wishList = dao.getWishlist(acc.getUsername());
            if (wishList != null) {
                wishSet = new HashSet<>(wishList);
            }
        }

        // =========================
        // 4. SORT OPTION
        // =========================
        String sortOption = request.getParameter("option");
        if (sortOption == null) {
            sortOption = "";
        }

        final Set<String> finalWishSet = wishSet;
        final boolean priceDesc = "priceDesc".equals(sortOption);
        final boolean priceAsc = "priceAsc".equals(sortOption);

        list.sort((a, b) -> {
            boolean wa = finalWishSet.contains(a.getId());
            boolean wb = finalWishSet.contains(b.getId());

            if (wa && !wb) return -1;
            if (!wa && wb) return 1;

            if (priceDesc) {
                return Double.compare(b.getPrice(), a.getPrice());
            }
            if (priceAsc) {
                return Double.compare(a.getPrice(), b.getPrice());
            }

            if (a.getPrice() > b.getPrice())
                return -1;
            else if (a.getPrice() < b.getPrice())
                return 1;
            return 0;
        });

        // =========================
        // 5. PAGINATION 10 ITEMS / PAGE
        // =========================
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {
            }
        }

        int pageSize = 10;
        int totalProducts = list.size();
        int totalPages = totalProducts == 0 ? 1 : (int) Math.ceil((double) totalProducts / pageSize);
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalProducts);
        List<Products> pageProducts = list.subList(startIndex, endIndex);

        // =========================
        // 6. SET ATTRIBUTE
        // =========================
        request.setAttribute("productList", pageProducts);
        request.setAttribute("wishSet", wishSet);
        request.setAttribute("categoryList", dao.getAllCategories());
        request.setAttribute("currentCid", cid);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("sortOption", sortOption);

        request.getRequestDispatcher("index1.jsp").forward(request, response);
    }
}
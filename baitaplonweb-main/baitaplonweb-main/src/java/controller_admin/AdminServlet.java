package controller_admin;

import dal.DAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Accounts;
import model.Categories;
import model.Orders;
import model.Products;
import model.StockIn;
import model.Suppliers;
import model.Vouchers;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean isAdmin(HttpSession session) {
        if (session == null) {
            return false;
        }
        Accounts account = (Accounts) session.getAttribute("accounts");
        return account != null && account.getRole() == 1;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect("index1.jsp");
            return;
        }

        DAO dao = new DAO();
        List<Categories> categories = dao.getAllCategories();
        List<Products> products = dao.getAllProducts();
        List<Suppliers> suppliers = dao.getAllSuppliers();
        List<Vouchers> vouchers = dao.getAllVouchers();
        List<Orders> orders = dao.getAllOrders();
        List<StockIn> stockIns = dao.getAllStockIns();

        int pendingOrderCount = 0;
        for (Orders o : orders) {
            if (o.getStatus() == 0) {
                pendingOrderCount++;
            }
        }

        String view = request.getParameter("view");
        if (view == null || view.trim().isEmpty()) {
            if (pendingOrderCount > 0) {
                view = "orders";
            } else {
                view = "dashboard";
            }
        }

        String productCategoryFilter = request.getParameter("productCategory");
        String pageParam = request.getParameter("page");
        int currentProductPage = 1;
        if (pageParam != null) {
            try {
                currentProductPage = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {
            }
        }

        List<Products> filteredProducts = new ArrayList<>();
        if (productCategoryFilter != null && !productCategoryFilter.trim().isEmpty()) {
            try {
                int categoryId = Integer.parseInt(productCategoryFilter);
                for (Products p : products) {
                    if (p.getCid() == categoryId) {
                        filteredProducts.add(p);
                    }
                }
            } catch (NumberFormatException ignored) {
                filteredProducts.addAll(products);
            }
        } else {
            filteredProducts.addAll(products);
        }

        int pageSize = 10;
        int totalProducts = filteredProducts.size();
        int totalProductPages = totalProducts == 0 ? 1 : (int) Math.ceil((double) totalProducts / pageSize);
        if (currentProductPage > totalProductPages) {
            currentProductPage = totalProductPages;
        }
        int startIndex = (currentProductPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalProducts);
        List<Products> pageProducts = filteredProducts.subList(startIndex, endIndex);

        Map<Integer, String> categoryMap = new HashMap<>();
        for (Categories c : categories) {
            categoryMap.put(c.getId(), c.getName());
        }

        request.setAttribute("categories", categories);
        request.setAttribute("products", pageProducts);
        request.setAttribute("totalProductCount", products.size());
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("orders", orders);
        request.setAttribute("pendingOrderCount", pendingOrderCount);
        request.setAttribute("stockIns", stockIns);
        request.setAttribute("categoryMap", categoryMap);
        request.setAttribute("productCategoryFilter", productCategoryFilter);
        request.setAttribute("currentProductPage", currentProductPage);
        request.setAttribute("totalProductPages", totalProductPages);
        request.setAttribute("view", view);

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect("index1.jsp");
            return;
        }

        String action = request.getParameter("action");
        DAO dao = new DAO();

        if (action != null) {
            switch (action) {
                case "addCategory":
                    String categoryName = request.getParameter("categoryName");
                    String categoryDescription = request.getParameter("categoryDescription");
                    if (categoryName != null && !categoryName.isEmpty()) {
                        dao.insertCategory(categoryName.trim(), categoryDescription);
                    }
                    break;
                case "deleteCategory":
                    String categoryId = request.getParameter("categoryId");
                    if (categoryId != null) {
                        dao.deleteCategory(Integer.parseInt(categoryId));
                    }
                    break;
                case "addSupplier":
                    String supplierName = request.getParameter("supplierName");
                    String supplierPhone = request.getParameter("supplierPhone");
                    String supplierAddress = request.getParameter("supplierAddress");
                    if (supplierName != null && !supplierName.isEmpty()) {
                        dao.insertSupplier(new Suppliers(0, supplierName.trim(), supplierPhone, supplierAddress));
                    }
                    break;
                case "deleteSupplier":
                    String supplierId = request.getParameter("supplierId");
                    if (supplierId != null) {
                        dao.deleteSupplier(Integer.parseInt(supplierId));
                    }
                    break;
                case "addVoucher":
                    String code = request.getParameter("voucherCode");
                    String discountValue = request.getParameter("voucherDiscount");
                    String expirationDate = request.getParameter("voucherExpiration");
                    String minValue = request.getParameter("voucherMinValue");
                    String quantity = request.getParameter("voucherQuantity");

                    if (code != null && !code.isEmpty()) {
                        Vouchers voucher = new Vouchers();
                        voucher.setCode(code.trim());
                        voucher.setDiscountValue(Double.parseDouble(discountValue));
                        voucher.setExpirationDate(Date.valueOf(expirationDate));
                        voucher.setMinOrderValue(Double.parseDouble(minValue));
                        voucher.setQuantity(Integer.parseInt(quantity));
                        dao.insertVoucher(voucher);
                    }
                    break;
                case "deleteVoucher":
                    String voucherCode = request.getParameter("voucherCode");
                    if (voucherCode != null) {
                        dao.deleteVoucher(voucherCode);
                    }
                    break;
                case "addProduct":
                    String productId = request.getParameter("productId");
                    String productName = request.getParameter("productName");
                    String productQty = request.getParameter("productQuantity");
                    String productPrice = request.getParameter("productPrice");
                    String productRelease = request.getParameter("productRelease");
                    String productDesc = request.getParameter("productDescription");
                    String productImage = request.getParameter("productImage");
                    String productCid = request.getParameter("productCategoryId");
                    if (productId != null && !productId.isEmpty()) {
                        Products product = new Products();
                        product.setId(productId.trim());
                        product.setName(productName);
                        product.setQuantity(Integer.parseInt(productQty));
                        product.setPrice(Double.parseDouble(productPrice));
                        product.setReleaseDate(Date.valueOf(productRelease));
                        product.setDescribe(productDesc);
                        product.setImage(productImage);
                        product.setCid(Integer.parseInt(productCid));
                        dao.insertProduct(product);
                    }
                    break;
                case "deleteProduct":
                    String deleteProductId = request.getParameter("productId");
                    if (deleteProductId != null) {
                        dao.deleteProduct(deleteProductId);
                    }
                    break;
                case "updateOrderStatus":
                    String orderId = request.getParameter("orderId");
                    String statusValue = request.getParameter("statusValue");
                    if (orderId != null && statusValue != null) {
                        dao.updateOrderStatus(Integer.parseInt(orderId), Integer.parseInt(statusValue));
                    }
                    break;
                default:
                    break;
            }
        }

        String view = request.getParameter("view");
        String productCategoryFilter = request.getParameter("productCategory");
        String page = request.getParameter("page");

        String redirectUrl = "admin";
        if (view != null && !view.trim().isEmpty()) {
            redirectUrl += "?view=" + URLEncoder.encode(view, StandardCharsets.UTF_8);
            if ("products".equals(view)) {
                if (productCategoryFilter != null && !productCategoryFilter.trim().isEmpty()) {
                    redirectUrl += "&productCategory=" + URLEncoder.encode(productCategoryFilter, StandardCharsets.UTF_8);
                }
                if (page != null && !page.trim().isEmpty()) {
                    redirectUrl += "&page=" + URLEncoder.encode(page, StandardCharsets.UTF_8);
                }
            }
        }

        response.sendRedirect(redirectUrl);
    }
}

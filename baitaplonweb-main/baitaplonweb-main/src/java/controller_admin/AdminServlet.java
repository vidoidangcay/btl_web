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
import model.Cart;
import model.Categories;
import model.Customers;
import model.Orders;
import model.Products;
import model.StockIn;
import model.StockInDetails;
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
            response.sendRedirect(request.getContextPath() + "/index1.jsp");
            return;
        }

        DAO dao = new DAO();
        List<Categories> categories = dao.getAllCategories();
        List<Products> products = dao.getAllProducts();
        List<Suppliers> suppliers = dao.getAllSuppliers();
        List<Vouchers> vouchers = dao.getAllVouchers();
        List<Orders> orders = dao.getAllOrders();
        List<StockIn> stockIns = dao.getAllStockIns();
        List<Accounts> accounts = dao.getAllAccounts();

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

        Map<Integer, String> supplierMap = new HashMap<>();
        for (Suppliers s : suppliers) {
            supplierMap.put(s.getId(), s.getName());
        }

        Map<String, String> productMap = new HashMap<>();
        for (Products p : products) {
            productMap.put(p.getId(), p.getName());
        }
        for (Products p : filteredProducts) {
            productMap.put(p.getId(), p.getName());
        }

        String editProductId = request.getParameter("editProductId");
        Products editProduct = null;
        if (editProductId != null && !editProductId.trim().isEmpty()) {
            editProduct = dao.getProductById(editProductId.trim());
        }

        String detailUsername = request.getParameter("detailUsername");
        Accounts detailAccount = null;
        Customers detailCustomer = null;
        List<Orders> detailOrders = null;
        List<Cart> detailCart = null;
        List<String> detailWishlist = null;
        String deleteRequestRequester = null;
        Accounts currentAccount = (Accounts) session.getAttribute("accounts");
        boolean forceRespondDelete = false;
        if (currentAccount != null && currentAccount.getRole() == 1 && dao.hasPendingAdminDeleteRequest(currentAccount.getUsername())) {
            forceRespondDelete = true;
            if (detailUsername == null || detailUsername.trim().isEmpty()) {
                detailUsername = currentAccount.getUsername();
            }
            view = "accounts";
            request.setAttribute("alert", "Bạn đang có yêu cầu xóa tài khoản cần phản hồi ngay.");
        }
        if (detailUsername != null && !detailUsername.trim().isEmpty()) {
            detailAccount = dao.checkAccountExist(detailUsername.trim());
            detailCustomer = dao.getCustomerByUsername(detailUsername.trim());
            if (detailAccount != null && detailAccount.getRole() == 0) {
                detailOrders = dao.getOrdersByUsername(detailUsername.trim());
                detailCart = dao.getCartByUser(detailUsername.trim());
                detailWishlist = dao.getWishlist(detailUsername.trim());
            }
            deleteRequestRequester = dao.getAdminDeleteRequester(detailUsername.trim());
        }

        String editUsername = request.getParameter("editUsername");
        Accounts editAccount = null;
        Customers editCustomer = null;
        if (editUsername != null && !editUsername.trim().isEmpty()) {
            editAccount = dao.checkAccountExist(editUsername.trim());
            editCustomer = dao.getCustomerByUsername(editUsername.trim());
        }

        List<String> pendingDeleteTargets = dao.getPendingAdminDeleteTargets();
        Map<String, Boolean> pendingDeleteMap = new HashMap<>();
        for (String username : pendingDeleteTargets) {
            pendingDeleteMap.put(username, true);
        }

        Map<Integer, StockInDetails> stockInDetailMap = new HashMap<>();
        for (StockIn si : stockIns) {
            StockInDetails detail = dao.getStockInDetailByStockId(si.getId());
            if (detail != null) {
                stockInDetailMap.put(si.getId(), detail);
            }
        }

        request.setAttribute("categories", categories);
        request.setAttribute("supplierMap", supplierMap);
        request.setAttribute("productMap", productMap);
        request.setAttribute("editProduct", editProduct);
        request.setAttribute("detailAccount", detailAccount);
        request.setAttribute("detailCustomer", detailCustomer);
        request.setAttribute("detailOrders", detailOrders);
        request.setAttribute("detailCart", detailCart);
        request.setAttribute("detailWishlist", detailWishlist);
        request.setAttribute("deleteRequestRequester", deleteRequestRequester);
        request.setAttribute("editAccount", editAccount);
        request.setAttribute("editCustomer", editCustomer);
        request.setAttribute("pendingDeleteMap", pendingDeleteMap);
        request.setAttribute("stockInDetailMap", stockInDetailMap);
        request.setAttribute("products", pageProducts);
        request.setAttribute("allProducts", products);
        request.setAttribute("accounts", accounts);
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

        request.getRequestDispatcher("/admin.jsp").forward(request, response);
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
        String redirectDetailUsername = null;
        String redirectEditUsername = null;
        String redirectAlert = null;

        if (action != null) {
            switch (action) {
                case "addCategory": {
                    String categoryName = request.getParameter("categoryName");
                    String categoryDescription = request.getParameter("categoryDescription");
                    if (categoryName != null && !categoryName.isEmpty()) {
                        dao.insertCategory(categoryName.trim(), categoryDescription);
                    }
                    break;
                }
                case "deleteCategory": {
                    String categoryId = request.getParameter("categoryId");
                    if (categoryId != null) {
                        dao.deleteCategory(Integer.parseInt(categoryId));
                    }
                    break;
                }
                case "addSupplier": {
                    String supplierName = request.getParameter("supplierName");
                    String supplierPhone = request.getParameter("supplierPhone");
                    String supplierAddress = request.getParameter("supplierAddress");
                    if (supplierName != null && !supplierName.isEmpty()) {
                        dao.insertSupplier(new Suppliers(0, supplierName.trim(), supplierPhone, supplierAddress));
                    }
                    break;
                }
                case "deleteSupplier": {
                    String supplierId = request.getParameter("supplierId");
                    if (supplierId != null) {
                        dao.deleteSupplier(Integer.parseInt(supplierId));
                    }
                    break;
                }
                case "addVoucher": {
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
                }
                case "deleteVoucher": {
                    String voucherCode = request.getParameter("voucherCode");
                    if (voucherCode != null) {
                        dao.deleteVoucher(voucherCode);
                    }
                    break;
                }
                case "addProduct": {
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
                }
                case "editProduct": {
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
                        dao.updateProduct(product);
                    }
                    break;
                }
                case "addStockIn": {
                    String supplierId = request.getParameter("supplierId");
                    String stockProductId = request.getParameter("stockProductId");
                    String stockQuantity = request.getParameter("stockQuantity");
                    String purchasePrice = request.getParameter("purchasePrice");
                    if (supplierId != null && stockProductId != null && stockQuantity != null && purchasePrice != null
                            && !supplierId.isEmpty() && !stockProductId.isEmpty()) {
                        try {
                            int sid = Integer.parseInt(supplierId);
                            int quantity = Integer.parseInt(stockQuantity);
                            double unitPrice = Double.parseDouble(purchasePrice);
                            if (quantity > 0 && unitPrice >= 0) {
                                double totalCost = quantity * unitPrice;
                                Accounts adminAccount = (Accounts) session.getAttribute("accounts");
                                StockIn stockIn = new StockIn(0, null, sid, adminAccount.getUsername(), totalCost);
                                StockInDetails detail = new StockInDetails(0, stockProductId, quantity, unitPrice);
                                dao.insertStockInWithDetail(stockIn, detail);
                            }
                        } catch (NumberFormatException ignored) {
                            // Bỏ qua nếu dữ liệu không hợp lệ
                        }
                    }
                    break;
                }
                case "deleteProduct": {
                    String deleteProductId = request.getParameter("productId");
                    if (deleteProductId != null) {
                        dao.deleteProduct(deleteProductId);
                    }
                    break;
                }
                case "deleteAccount": {
                    String username = request.getParameter("username");
                    if (username != null && !username.trim().isEmpty()) {
                        String trimmedUsername = username.trim();
                        Accounts targetAccount = dao.checkAccountExist(trimmedUsername);
                        Accounts currentAccount = (Accounts) session.getAttribute("accounts");
                        if (targetAccount != null && targetAccount.getRole() == 1) {
                            if (trimmedUsername.equals(currentAccount.getUsername())) {
                                redirectAlert = "Bạn không thể xóa chính mình.";
                            } else if (dao.hasPendingAdminDeleteRequest(trimmedUsername)) {
                                redirectAlert = "Đã có yêu cầu xóa đang chờ phản hồi.";
                            } else if (dao.hasOrdersInStatus(trimmedUsername, 2)) {
                                redirectAlert = "Tài khoản đang có đơn hàng đang giao, không thể xóa.";
                            } else {
                                dao.createAdminDeleteRequest(trimmedUsername, currentAccount.getUsername());
                                redirectAlert = "Đã gửi yêu cầu xóa. Đợi phản hồi từ admin đó.";
                            }
                        } else {
                            boolean hasConfirmedOrders = dao.hasOrdersInStatus(trimmedUsername, 1);
                            boolean hasDeliveringOrders = dao.hasOrdersInStatus(trimmedUsername, 2);
                            if (hasDeliveringOrders) {
                                redirectAlert = "Tài khoản đang có đơn hàng đang giao, không thể xóa.";
                            } else {
                                // Nếu tài khoản có đơn đã xác nhận, vẫn xóa bình thường.
                                // Nếu tài khoản không có đơn đã xác nhận, vẫn xóa tất cả dữ liệu liên quan.
                                dao.deleteAccount(trimmedUsername);
                                redirectAlert = "Tài khoản đã được xóa.";
                            }
                        }
                    }
                    break;
                }
                case "respondDeleteAdmin": {
                    String targetUsername = request.getParameter("targetUsername");
                    String responseValue = request.getParameter("response");
                    if (targetUsername != null && !targetUsername.trim().isEmpty() && responseValue != null) {
                        String trimmedTarget = targetUsername.trim();
                        Accounts currentAccount = (Accounts) session.getAttribute("accounts");
                        if (trimmedTarget.equals(currentAccount.getUsername()) && dao.hasPendingAdminDeleteRequest(trimmedTarget)) {
                            if ("accept".equals(responseValue)) {
                                dao.deleteAccount(trimmedTarget);
                                dao.removeAdminDeleteRequest(trimmedTarget);
                                session.invalidate();
                                response.sendRedirect(request.getContextPath() + "/login.jsp");
                                return;
                            } else {
                                dao.removeAdminDeleteRequest(trimmedTarget);
                                redirectAlert = "Yêu cầu xóa đã bị từ chối.";
                            }
                        }
                    }
                    break;
                }
                case "addAccount": {
                    String username = request.getParameter("accountUsername");
                    String password = request.getParameter("accountPassword");
                    String roleValue = request.getParameter("accountRole");
                    String fullname = request.getParameter("accountFullname");
                    String email = request.getParameter("accountEmail");
                    String phone = request.getParameter("accountPhone");
                    String address = request.getParameter("accountAddress");
                    if (username != null && !username.trim().isEmpty() && password != null && !password.trim().isEmpty()) {
                        int role = "1".equals(roleValue) ? 1 : 0;
                        if (dao.checkAccountExist(username.trim()) == null) {
                            dao.insertAccount(username.trim(), password.trim(), role, fullname, email, phone, address);
                            redirectDetailUsername = username.trim();
                        }
                    }
                    break;
                }
                case "editAccount": {
                    String username = request.getParameter("username");
                    String password = request.getParameter("accountPassword");
                    String roleValue = request.getParameter("accountRole");
                    String fullname = request.getParameter("accountFullname");
                    String email = request.getParameter("accountEmail");
                    String phone = request.getParameter("accountPhone");
                    String address = request.getParameter("accountAddress");
                    if (username != null && !username.trim().isEmpty()) {
                        int role = "1".equals(roleValue) ? 1 : 0;
                        Accounts currentAccount = (Accounts) session.getAttribute("accounts");
                        boolean selfEdit = currentAccount != null && currentAccount.getUsername().equals(username.trim());
                        int oldRole = selfEdit ? currentAccount.getRole() : -1;

                        dao.updateAccount(username.trim(), password, role);
                        Customers existingCustomer = dao.getCustomerByUsername(username.trim());
                        Customers customer = new Customers(username.trim(), fullname, email, phone, address, existingCustomer != null ? existingCustomer.getPoints() : 0);
                        if (existingCustomer != null) {
                            dao.updateCustomer(customer);
                        } else if (role == 0) {
                            dao.insertCustomer(customer);
                        }

                        if (selfEdit) {
                            if (password != null && !password.trim().isEmpty()) {
                                currentAccount.setPassword(password);
                            }
                            currentAccount.setRole(role);
                            session.setAttribute("accounts", currentAccount);
                            if (oldRole == 1 && role == 0) {
                                response.sendRedirect(request.getContextPath() + "/home");
                                return;
                            }
                        }

                        redirectEditUsername = username.trim();
                    }
                    break;
                }
                case "updateOrderStatus": {
                    String orderId = request.getParameter("orderId");
                    String statusValue = request.getParameter("statusValue");
                    if (orderId != null && statusValue != null) {
                        dao.updateOrderStatus(Integer.parseInt(orderId), Integer.parseInt(statusValue));
                    }
                    break;
                }
                case "deleteOrder": {
                    String orderId = request.getParameter("orderId");
                    if (orderId != null) {
                        dao.deleteOrderById(Integer.parseInt(orderId));
                        redirectAlert = "Đã xóa đơn hàng và hoàn lại sản phẩm liên quan.";
                    }
                    break;
                }
                default: {
                    break;
                }
            }
        }

        String view = request.getParameter("view");
        String productCategoryFilter = request.getParameter("productCategory");
        String page = request.getParameter("page");

        String redirectUrl = request.getContextPath() + "/admin";
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
            if (redirectEditUsername != null) {
                redirectUrl += "&editUsername=" + URLEncoder.encode(redirectEditUsername, StandardCharsets.UTF_8);
            } else if (redirectDetailUsername != null) {
                redirectUrl += "&detailUsername=" + URLEncoder.encode(redirectDetailUsername, StandardCharsets.UTF_8);
            }
            if (redirectAlert != null) {
                redirectUrl += "&alert=" + URLEncoder.encode(redirectAlert, StandardCharsets.UTF_8);
            }
        } else if (redirectEditUsername != null) {
            redirectUrl += "?editUsername=" + URLEncoder.encode(redirectEditUsername, StandardCharsets.UTF_8);
            if (redirectAlert != null) {
                redirectUrl += "&alert=" + URLEncoder.encode(redirectAlert, StandardCharsets.UTF_8);
            }
        } else if (redirectDetailUsername != null) {
            redirectUrl += "?detailUsername=" + URLEncoder.encode(redirectDetailUsername, StandardCharsets.UTF_8);
            if (redirectAlert != null) {
                redirectUrl += "&alert=" + URLEncoder.encode(redirectAlert, StandardCharsets.UTF_8);
            }
        } else if (redirectAlert != null) {
            redirectUrl += "?alert=" + URLEncoder.encode(redirectAlert, StandardCharsets.UTF_8);
        }

        response.sendRedirect(redirectUrl);
    }
}

package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;
import model.*;
public class DAO extends DBContext {
    public Accounts checkAccountExist(String user) {
    String sql = "SELECT * FROM Accounts WHERE username = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, user);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new Accounts(rs.getString("username"), rs.getString("password"), rs.getInt("role"));
        }
    } catch (SQLException e) {
        System.out.println(e);
    }
    return null;
}

// Đăng ký: Insert vào Accounts (role=0) và Customers (points=0)
public void register(String user, String pass, String fullname, String email, String phone, String address) {
    String sqlAcc = "INSERT INTO Accounts (username, password, role) VALUES (?, ?, 0)";
    String sqlCust = "INSERT INTO Customers (username, fullname, email, phone, address, points) VALUES (?, ?, ?, ?, ?, 0)";
    
    try {
        connection.setAutoCommit(false); // Bắt đầu Giao dịch

        // Insert vào Accounts
        PreparedStatement ps1 = connection.prepareStatement(sqlAcc);
        ps1.setString(1, user);
        ps1.setString(2, pass);
        ps1.executeUpdate();

        // Insert vào Customers
        PreparedStatement ps2 = connection.prepareStatement(sqlCust);
        ps2.setString(1, user);
        ps2.setString(2, fullname);
        ps2.setString(3, email);
        ps2.setString(4, phone);
        ps2.setString(5, address);
        ps2.executeUpdate();

        connection.commit(); // Lưu vĩnh viễn
    } catch (SQLException e) {
        try { connection.rollback(); } catch (SQLException ex) {} // Lỗi là hủy hết
        throw new RuntimeException(e); // Đẩy lỗi ra cho Servlet bắt
    } finally {
        try { connection.setAutoCommit(true); } catch (SQLException e) {}
    }
}
public Products getProducts(String id) {
    // Thêm điều kiện quantity > 0 để lọc sản phẩm hết hàng
    String sql = "SELECT * FROM Products WHERE id = ? AND quantity > 0";

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Products p = new Products();

            p.setId(rs.getString("id"));
            p.setName(rs.getString("name"));
            // Lưu ý: SQL là DECIMAL(10,2) nên dùng getDouble hoặc getBigDecimal
            p.setPrice(rs.getDouble("price")); 
            p.setImage(rs.getString("image"));
            // Bạn có thể set thêm quantity nếu class Products có thuộc tính này
            // p.setQuantity(rs.getInt("quantity"));

            return p;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    // Nếu sản phẩm có id đó nhưng quantity = 0, hàm sẽ trả về null
    return null;
}
public int insertOrder(Orders o) {
    String sql = "INSERT INTO Orders (date, totalmoney, status, username, receiver_name, receiver_phone, shipping_address, voucher_code) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    try {
        Timestamp orderDate = Timestamp.valueOf(LocalDateTime.now());

        PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        st.setTimestamp(1, orderDate);         // date
        st.setDouble(2, o.getTotalmoney());
        st.setInt(3, o.getStatus());
        st.setString(4, o.getUsername());
        st.setString(5, o.getReceiver_name());
        st.setString(6, o.getReceiver_phone());
        st.setString(7, o.getShipping_address());
        st.setString(8, o.getVoucher_code());

        st.executeUpdate();

        ResultSet rs = st.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1); // orderId
        }

    } catch (Exception e) {
        System.out.println("insertOrder error: " + e);
    }

    return -1;
}
public void applyVoucher(String username, String pid, String newVoucherCode) {
    // 1. Lấy voucher_code cũ để hoàn lại số lượng
    String sqlGetOld = "SELECT voucher_code FROM UserVoucher WHERE username = ? AND pid = ?";
    
    // 2. Xóa bản ghi cũ
    String sqlDelete = "DELETE FROM UserVoucher WHERE username = ? AND pid = ?";
    
    // 3. Hoàn lại số lượng (+1) cho voucher cũ
    String sqlRefund = "UPDATE Vouchers SET quantity = quantity + 1 WHERE code = ?";
    
    // 4. Trừ số lượng (-1) cho voucher mới
    String sqlUpdateNew = "UPDATE Vouchers SET quantity = quantity - 1 WHERE code = ? AND quantity > 0";
    
    // 5. Chèn mới: Lấy expirationDate từ bảng Vouchers để làm selectedDate
    String sqlInsert = "INSERT INTO UserVoucher (username, pid, voucher_code, selectedDate) " +
                       "SELECT ?, ?, code, expirationDate FROM Vouchers WHERE code = ?";

    try {
        // --- XỬ LÝ HOÀN VOUCHER CŨ ---
        PreparedStatement psGetOld = connection.prepareStatement(sqlGetOld);
        psGetOld.setString(1, username);
        psGetOld.setString(2, pid);
        ResultSet rs = psGetOld.executeQuery();
        
        if (rs.next()) {
            String oldVoucherCode = rs.getString("voucher_code");
            PreparedStatement psRefund = connection.prepareStatement(sqlRefund);
            psRefund.setString(1, oldVoucherCode);
            psRefund.executeUpdate();
        }

        // --- XÓA BẢN GHI CŨ TRONG USERVOUCHER ---
        PreparedStatement psDel = connection.prepareStatement(sqlDelete);
        psDel.setString(1, username);
        psDel.setString(2, pid);
        psDel.executeUpdate();

        // --- ÁP DỤNG VOUCHER MỚI ---
        if (newVoucherCode != null && !newVoucherCode.isEmpty()) {
            // Bước A: Trừ số lượng trong kho Vouchers
            PreparedStatement psUpdateNew = connection.prepareStatement(sqlUpdateNew);
            psUpdateNew.setString(1, newVoucherCode);
            int rowsAffected = psUpdateNew.executeUpdate();

            // Bước B: Nếu trừ thành công (còn voucher), tiến hành copy sang UserVoucher
            if (rowsAffected > 0) {
                PreparedStatement psIns = connection.prepareStatement(sqlInsert);
                psIns.setString(1, username);
                psIns.setString(2, pid);
                psIns.setString(3, newVoucherCode);
                psIns.executeUpdate();
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
public List<Vouchers> getValidVoucherByPid(String pid) {

    List<Vouchers> list = new ArrayList<>();

    String sql =
        "SELECT v.* FROM Vouchers v, Products p " +
        "WHERE p.id = ? " +
        "AND v.quantity > 0 " +
        "AND v.expirationDate >= GETDATE() " +
        "AND p.price >= v.minOrderValue";

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, pid);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            Vouchers v = new Vouchers();

            v.setCode(rs.getString("code"));
            v.setDiscountValue(rs.getDouble("discountValue"));
            v.setExpirationDate(rs.getDate("expirationDate"));
            v.setMinOrderValue(rs.getDouble("minOrderValue"));
            v.setQuantity(rs.getInt("quantity"));

            list.add(v);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
public void insertOrderDetail(OrderDetails od) {
    String sql = "INSERT INTO OrderDetails (oid, pid, quantity, price) VALUES (?, ?, ?, ?)";

    try {
        PreparedStatement st = connection.prepareStatement(sql);

        st.setInt(1, od.getOid());
        st.setString(2, od.getPid());
        st.setInt(3, od.getQuantity());
        st.setDouble(4, od.getPrice());

        st.executeUpdate();

    } catch (Exception e) {
        System.out.println("insertOrderDetail: " + e);
    }
}

public int insertOrderWithDetails(Orders o, List<OrderDetails> details, OrderShipment shipment) {
    int orderId = -1;
    boolean originalAutoCommit = true;
    try {
        originalAutoCommit = connection.getAutoCommit();
        connection.setAutoCommit(false);

        orderId = insertOrder(o);
        if (orderId <= 0) {
            connection.rollback();
            return -1;
        }

        for (OrderDetails od : details) {
            od.setOid(orderId);
            insertOrderDetail(od);
        }

        if (shipment != null) {
            shipment.setOrderId(orderId);
            try {
                insertOrderShipment(shipment);
            } catch (Exception e) {
                // Ignore shipment insertion failures so the order still persists.
                System.out.println("Warning: OrderShipment insert failed, order saved without shipment: " + e);
            }
        }

        connection.commit();
        return orderId;
    } catch (Exception e) {
        try {
            connection.rollback();
        } catch (Exception rollbackEx) {
            rollbackEx.printStackTrace();
        }
        System.out.println("insertOrderWithDetails error: " + e);
        return -1;
    } finally {
        try {
            connection.setAutoCommit(originalAutoCommit);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

public void insertOrderShipment(OrderShipment shipment) {
    String sql = "INSERT INTO OrderShipment (order_id, username, receiver_name, receiver_phone, shipping_address, status, createdDate) VALUES (?, ?, ?, ?, ?, ?, ?)";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, shipment.getOrderId());
        st.setString(2, shipment.getUsername());
        st.setString(3, shipment.getReceiver_name());
        st.setString(4, shipment.getReceiver_phone());
        st.setString(5, shipment.getShipping_address());
        st.setInt(6, shipment.getStatus());
        st.setTimestamp(7, shipment.getCreatedDate());
        st.executeUpdate();
    } catch (Exception e) {
        System.out.println("insertOrderShipment: " + e);
    }
}

public boolean addToCart(String username, String pid) {
    // SQL kiểm tra tồn kho
    String sqlCheckStock = "SELECT quantity FROM Products WHERE id = ?";
    // SQL trừ số lượng sản phẩm
    String sqlUpdateProduct = "UPDATE Products SET quantity = quantity - 1 WHERE id = ? AND quantity > 0";
    // SQL kiểm tra giỏ hàng
    String sqlCheckCart = "SELECT quantity FROM Cart WHERE username = ? AND pid = ?";
    String sqlInsertCart = "INSERT INTO Cart (username, pid, quantity, addedDate) VALUES (?, ?, 1, GETDATE())";
    String sqlUpdateCart = "UPDATE Cart SET quantity = quantity + 1 WHERE username = ? AND pid = ?";

    boolean result = false; // Mặc định là thất bại

    try {
        connection.setAutoCommit(false);

        // Bước 1: Kiểm tra số lượng trong kho
        PreparedStatement psStock = connection.prepareStatement(sqlCheckStock);
        psStock.setString(1, pid);
        ResultSet rsStock = psStock.executeQuery();

        if (rsStock.next()) {
            int currentStock = rsStock.getInt("quantity");

            if (currentStock > 0) {
                // Bước 2: Trừ 1 sản phẩm trong bảng Products
                PreparedStatement psUpdateProd = connection.prepareStatement(sqlUpdateProduct);
                psUpdateProd.setString(1, pid);
                int rowsAffected = psUpdateProd.executeUpdate();

                if (rowsAffected > 0) {
                    // Bước 3: Kiểm tra giỏ hàng của user
                    PreparedStatement psCheckCart = connection.prepareStatement(sqlCheckCart);
                    psCheckCart.setString(1, username);
                    psCheckCart.setString(2, pid);
                    ResultSet rsCart = psCheckCart.executeQuery();

                    if (rsCart.next()) {
                        PreparedStatement psUpCart = connection.prepareStatement(sqlUpdateCart);
                        psUpCart.setString(1, username);
                        psUpCart.setString(2, pid);
                        psUpCart.executeUpdate();
                    } else {
                        PreparedStatement psInsCart = connection.prepareStatement(sqlInsertCart);
                        psInsCart.setString(1, username);
                        psInsCart.setString(2, pid);
                        psInsCart.executeUpdate();
                    }

                    connection.commit();
                    result = true; // Giao dịch hoàn tất thành công
                }
            }
        }
    } catch (Exception e) {
        try {
            if (connection != null) connection.rollback();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        e.printStackTrace();
        result = false;
    } finally {
        try {
            if (connection != null) connection.setAutoCommit(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    return result; // Trả về true nếu thành công, false nếu hết hàng hoặc lỗi
}
public Accounts login(String user, String pass) {
    String sql = "SELECT * FROM Accounts WHERE username = ? AND password = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, user);
        st.setString(2, pass);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new Accounts(rs.getString("username"), rs.getString("password"), rs.getInt("role"));
        }
    } catch (SQLException e) {
        System.out.println(e);
    }
    return null;
}

    // ==========================================
    // 1. XỬ LÝ CATEGORY (DANH MỤC)
    // ==========================================
    public List<Categories> getAllCategories() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT id, name, describe FROM Categories";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Categories(
                    rs.getInt("id"), 
                    rs.getString("name"), 
                    rs.getString("describe")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error getAllCategories: " + e);
        }
        return list;
    }

    // ==========================================
    // 2. XỬ LÝ PRODUCT (SẢN PHẨM)
    // ==========================================
    
    // Hàm bổ trợ để map dữ liệu từ ResultSet vào Object Products
    private Products mapProduct(ResultSet rs) throws SQLException {
        return new Products(
            rs.getString("id"),
            rs.getString("name"),
            rs.getInt("quantity"),
            rs.getDouble("price"),
            rs.getDate("releaseDate"),
            rs.getString("describe"),
            rs.getString("image"),
            rs.getInt("cid") // Lấy mã danh mục
        );
    }

   public List<Products> getAllProducts() {
    List<Products> list = new ArrayList<>();
    // Hiển thị tất cả sản phẩm để admin có thể quản lý đầy đủ
    String sql = "SELECT * FROM Products";
    
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            list.add(mapProduct(rs));
        }
    } catch (SQLException e) {
        System.out.println("Error getAllProducts: " + e);
    }
    return list;
}

    public List<Suppliers> getAllSuppliers() {
        List<Suppliers> list = new ArrayList<>();
        String sql = "SELECT id, name, phone, address FROM Suppliers";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Suppliers(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("phone"),
                    rs.getString("address")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error getAllSuppliers: " + e);
        }
        return list;
    }

    public List<Vouchers> getAllVouchers() {
        List<Vouchers> list = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Vouchers(
                    rs.getString("code"),
                    rs.getDouble("discountValue"),
                    rs.getDate("expirationDate"),
                    rs.getDouble("minOrderValue"),
                    rs.getInt("quantity")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error getAllVouchers: " + e);
        }
        return list;
    }

    public List<Orders> getAllOrders() {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY date DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Orders(
                    rs.getInt("id"),
                    rs.getTimestamp("date"),
                    rs.getDouble("totalmoney"),
                    rs.getInt("status"),
                    rs.getString("username"),
                    rs.getString("receiver_name"),
                    rs.getString("receiver_phone"),
                    rs.getString("shipping_address"),
                    rs.getString("voucher_code")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error getAllOrders: " + e);
        }
        return list;
    }

    public List<StockIn> getAllStockIns() {
        List<StockIn> list = new ArrayList<>();
        String sql = "SELECT * FROM StockIn ORDER BY date DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new StockIn(
                    rs.getInt("id"),
                    rs.getTimestamp("date"),
                    rs.getInt("sid"),
                    rs.getString("admin_user"),
                    rs.getDouble("total_cost")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error getAllStockIns: " + e);
        }
        return list;
    }

    public StockInDetails getStockInDetailByStockId(int stockId) {
        String sql = "SELECT * FROM StockInDetails WHERE stock_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, stockId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new StockInDetails(
                    rs.getInt("stock_id"),
                    rs.getString("pid"),
                    rs.getInt("quantity"),
                    rs.getDouble("purchase_price")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getStockInDetailByStockId: " + e);
        }
        return null;
    }

    public Products getTopSellingProduct() {
        String sql = "SELECT p.id, p.name, p.quantity, p.price, p.releaseDate, p.describe, p.image, p.cid "
                   + "FROM Products p "
                   + "JOIN OrderDetails od ON p.id = od.pid "
                   + "GROUP BY p.id, p.name, p.quantity, p.price, p.releaseDate, p.describe, p.image, p.cid "
                   + "ORDER BY SUM(od.quantity) DESC "
                   + "OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Products(
                    rs.getString("id"),
                    rs.getString("name"),
                    rs.getInt("quantity"),
                    rs.getDouble("price"),
                    rs.getDate("releaseDate"),
                    rs.getString("describe"),
                    rs.getString("image"),
                    rs.getInt("cid")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getTopSellingProduct: " + e);
        }
        return null;
    }

    public int insertStockInWithDetail(StockIn stockIn, StockInDetails detail) {
        String sqlStock = "INSERT INTO StockIn (sid, admin_user, total_cost) VALUES (?, ?, ?)";
        String sqlDetail = "INSERT INTO StockInDetails (stock_id, pid, quantity, purchase_price) VALUES (?, ?, ?, ?)";
        String sqlUpdateProduct = "UPDATE Products SET quantity = quantity + ? WHERE id = ?";

        try {
            connection.setAutoCommit(false);

            PreparedStatement psStock = connection.prepareStatement(sqlStock, Statement.RETURN_GENERATED_KEYS);
            psStock.setInt(1, stockIn.getSid());
            psStock.setString(2, stockIn.getAdmin_user());
            psStock.setDouble(3, stockIn.getTotal_cost());
            psStock.executeUpdate();

            ResultSet rsStock = psStock.getGeneratedKeys();
            if (!rsStock.next()) {
                connection.rollback();
                return -1;
            }

            int stockId = rsStock.getInt(1);
            PreparedStatement psDetail = connection.prepareStatement(sqlDetail);
            psDetail.setInt(1, stockId);
            psDetail.setString(2, detail.getPid());
            psDetail.setInt(3, detail.getQuantity());
            psDetail.setDouble(4, detail.getPurchase_price());
            psDetail.executeUpdate();

            PreparedStatement psUpdateProduct = connection.prepareStatement(sqlUpdateProduct);
            psUpdateProduct.setInt(1, detail.getQuantity());
            psUpdateProduct.setString(2, detail.getPid());
            int updated = psUpdateProduct.executeUpdate();
            if (updated == 0) {
                connection.rollback();
                return -1;
            }

            connection.commit();
            return stockId;
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) {}
            System.out.println("Error insertStockInWithDetail: " + e);
            return -1;
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) {}
        }
    }

    public void insertCategory(String name, String describe) {
        String sql = "INSERT INTO Categories (name, describe) VALUES (?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, name);
            st.setString(2, describe);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error insertCategory: " + e);
        }
    }

    public void deleteCategory(int id) {
        String sql = "DELETE FROM Categories WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleteCategory: " + e);
        }
    }

    public void insertSupplier(Suppliers supplier) {
        String sql = "INSERT INTO Suppliers (name, phone, address) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, supplier.getName());
            st.setString(2, supplier.getPhone());
            st.setString(3, supplier.getAddress());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error insertSupplier: " + e);
        }
    }

    public void deleteSupplier(int id) {
        String sql = "DELETE FROM Suppliers WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleteSupplier: " + e);
        }
    }

    public void insertVoucher(Vouchers v) {
        String sql = "INSERT INTO Vouchers (code, discountValue, expirationDate, minOrderValue, quantity) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, v.getCode());
            st.setDouble(2, v.getDiscountValue());
            st.setDate(3, v.getExpirationDate());
            st.setDouble(4, v.getMinOrderValue());
            st.setInt(5, v.getQuantity());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error insertVoucher: " + e);
        }
    }

    public void deleteVoucher(String code) {
        String sql = "DELETE FROM Vouchers WHERE code = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, code);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleteVoucher: " + e);
        }
    }

    public void deleteProduct(String id) {
        String sql = "DELETE FROM Products WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleteProduct: " + e);
        }
    }

    public void updateOrderStatus(int orderId, int status) {
        String sql = "UPDATE Orders SET status = ? WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, orderId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updateOrderStatus: " + e);
        }
    }

    public Products getProductById(String id) {
        String sql = "SELECT * FROM Products WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapProduct(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getProductById: " + e);
        }
        return null;
    }

    public List<Products> getProductsByCid(int cid) {
        List<Products> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE cid = ?"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, cid);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs)); 
            }
        } catch (SQLException e) {
            System.out.println("Error getProductsByCid: " + e);
        }
        return list;
    }

    public void insertProduct(Products p) {
        String sql = "INSERT INTO Products (id, name, quantity, price, releaseDate, describe, image, cid) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, p.getId());
            st.setString(2, p.getName());
            st.setInt(3, p.getQuantity());
            st.setDouble(4, p.getPrice());
            st.setDate(5, p.getReleaseDate());
            st.setString(6, p.getDescribe());
            st.setString(7, p.getImage());
            st.setInt(8, p.getCid());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error insertProduct: " + e);
        }
    }

    // ==========================================
    // 3. XỬ LÝ ACCOUNT (TÀI KHOẢN)
    // ==========================================
    
   public void subFromCart(String username, String pid) {
    // SQL kiểm tra giỏ hàng
    String checkCartSql = "SELECT quantity FROM Cart WHERE username = ? AND pid = ?";
    // SQL giảm số lượng trong giỏ
    String updateCartSql = "UPDATE Cart SET quantity = quantity - 1 WHERE username = ? AND pid = ?";
    // SQL cộng trả lại hàng vào kho
    String updateStockSql = "UPDATE Products SET quantity = quantity + 1 WHERE id = ?";

    try {
        // Bắt đầu giao dịch
        connection.setAutoCommit(false);

        PreparedStatement ps = connection.prepareStatement(checkCartSql);
        ps.setString(1, username);
        ps.setString(2, pid);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            int currentQtyInCart = rs.getInt("quantity");

            if (currentQtyInCart > 1) {
                // 1. Giảm 1 trong giỏ hàng
                PreparedStatement psUpdateCart = connection.prepareStatement(updateCartSql);
                psUpdateCart.setString(1, username);
                psUpdateCart.setString(2, pid);
                psUpdateCart.executeUpdate();

                // 2. Cộng trả 1 vào kho Products
                PreparedStatement psUpdateStock = connection.prepareStatement(updateStockSql);
                psUpdateStock.setString(1, pid);
                psUpdateStock.executeUpdate();

                connection.commit();
            } else {
                // Nếu số lượng = 1, gọi hàm xóa hẳn dòng đó
                // Lưu ý: Hàm removeFromCart của bạn cũng PHẢI có logic cộng trả kho
                removeFromCart(username, pid);
                
                // Vì removeFromCart thường đã có commit riêng, 
                // nên ở đây ta chỉ cần đảm bảo hàm đó xử lý đúng.
            }
        }
    } catch (Exception e) {
        try {
            if (connection != null) connection.rollback();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        e.printStackTrace();
    } finally {
        try {
            if (connection != null) connection.setAutoCommit(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
   public Vouchers getVoucherByCode(String code) {
    String sql = "SELECT * FROM Vouchers WHERE code = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, code);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new Vouchers(
                rs.getString("code"),
                rs.getDouble("discountValue"),
                rs.getDate("expirationDate"),
                rs.getDouble("minOrderValue"),
                rs.getInt("quantity")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
  public Map<String, String> getSavedVouchersByUsername(String username) {
    Map<String, String> map = new HashMap<>();
    // Câu lệnh SQL lấy cặp Sản phẩm - Voucher mà User đã lưu trong DB
    String sql = "SELECT pid, voucher_code FROM UserVoucher WHERE username = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            // Đẩy vào Map để Session sử dụng
            map.put(rs.getString("pid"), rs.getString("voucher_code"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return map;
}
   public void removeFromCart(String username, String pid) {
    // 1. SQL cho Cart và Products
    String sqlGetQty = "SELECT quantity FROM Cart WHERE username = ? AND pid = ?";
    String sqlDeleteCart = "DELETE FROM Cart WHERE username = ? AND pid = ?";
    String sqlUpdateStock = "UPDATE Products SET quantity = quantity + ? WHERE id = ?";

    // 2. SQL cho Voucher
    String sqlCheckVoucher = "SELECT voucher_code FROM UserVoucher WHERE username = ? AND pid = ?";
    String sqlDeleteUserVoucher = "DELETE FROM UserVoucher WHERE username = ? AND pid = ?";
    String sqlRefundVoucher = "UPDATE Vouchers SET quantity = quantity + 1 WHERE code = ?";

    try {
        // Bắt đầu giao dịch (Transaction)
        connection.setAutoCommit(false);

        // --- BƯỚC 1: XỬ LÝ SẢN PHẨM TRONG GIỎ ---
        PreparedStatement psGet = connection.prepareStatement(sqlGetQty);
        psGet.setString(1, username);
        psGet.setString(2, pid);
        ResultSet rs = psGet.executeQuery();

        if (rs.next()) {
            int qtyInCart = rs.getInt("quantity");

            // Cộng trả số lượng sản phẩm vào kho
            PreparedStatement psStock = connection.prepareStatement(sqlUpdateStock);
            psStock.setInt(1, qtyInCart);
            psStock.setString(2, pid);
            psStock.executeUpdate();

            // Xóa sản phẩm khỏi giỏ hàng
            PreparedStatement psDelCart = connection.prepareStatement(sqlDeleteCart);
            psDelCart.setString(1, username);
            psDelCart.setString(2, pid);
            psDelCart.executeUpdate();

            // --- BƯỚC 2: XỬ LÝ VOUCHER (NẾU CÓ) ---
            PreparedStatement psCheckV = connection.prepareStatement(sqlCheckVoucher);
            psCheckV.setString(1, username);
            psCheckV.setString(2, pid);
            ResultSet rsV = psCheckV.executeQuery();

            if (rsV.next()) {
                String voucherCode = rsV.getString("voucher_code");

                // Hoàn trả số lượng voucher (+1)
                PreparedStatement psRefundV = connection.prepareStatement(sqlRefundVoucher);
                psRefundV.setString(1, voucherCode);
                psRefundV.executeUpdate();

                // Xóa bản ghi áp dụng voucher
                PreparedStatement psDelUV = connection.prepareStatement(sqlDeleteUserVoucher);
                psDelUV.setString(1, username);
                psDelUV.setString(2, pid);
                psDelUV.executeUpdate();
            }

            // Nếu mọi thứ ok, xác nhận thay đổi xuống DB
            connection.commit();
            System.out.println("Xóa sản phẩm và hoàn voucher thành công!");
        }
    } catch (SQLException e) {
        try {
            if (connection != null) {
                connection.rollback(); // Có lỗi thì hủy bỏ toàn bộ các bước trên
                System.out.println("Đã xảy ra lỗi, rollback dữ liệu!");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        e.printStackTrace();
    } finally {
        try {
            if (connection != null) {
                connection.setAutoCommit(true); // Trả lại trạng thái mặc định
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
    // Kiểm tra tài khoản tồn tại
public void addWishlist(String username, String pid) {
    String sql = "INSERT INTO Wishlist (username, pid, addedDate) VALUES (?, ?, GETDATE())";

    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        st.setString(2, pid);

        st.executeUpdate();

    } catch (SQLException e) {
        System.out.println("Error addWishlist: " + e);
    }
}
public void removeWishlist(String username, String pid) {
    String sql = "DELETE FROM Wishlist WHERE username = ? AND pid = ?";

    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        st.setString(2, pid);

        st.executeUpdate();

    } catch (SQLException e) {
        System.out.println("Error removeWishlist: " + e);
    }
}
public List<String> getWishlist(String username) {
    List<String> list = new ArrayList<>();

    String sql = "SELECT pid FROM Wishlist WHERE username = ?";

    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);

        ResultSet rs = st.executeQuery();

        while (rs.next()) {
            list.add(rs.getString("pid"));
        }

    } catch (SQLException e) {
        System.out.println("Error getWishlist: " + e);
    }

    return list;
}
// Đăng ký mới: Chèn vào cả 2 bảng Accounts và Customers
public void register(String user, String pass, String phone, String address) {
    String sqlAcc = "INSERT INTO Accounts (username, password, role) VALUES (?, ?, 0)";
    String sqlCust = "INSERT INTO Customers (username, phone, address) VALUES (?, ?, ?)";
    try {
        // Tắt auto commit để thực hiện giao dịch (transaction) - Đảm bảo cả 2 bảng cùng được lưu
        connection.setAutoCommit(false);

        // 1. Chèn vào Accounts
        PreparedStatement st1 = connection.prepareStatement(sqlAcc);
        st1.setString(1, user);
        st1.setString(2, pass);
        st1.executeUpdate();

        // 2. Chèn vào Customers
        PreparedStatement st2 = connection.prepareStatement(sqlCust);
        st2.setString(1, user);
        st2.setString(2, phone);
        st2.setString(3, address);
        st2.executeUpdate();

        connection.commit();
        connection.setAutoCommit(true);
    } catch (SQLException e) {
        try { connection.rollback(); } catch (SQLException ex) {}
        System.out.println("Error Register: " + e);
    }
}
public void useVoucher(String code) {
    String sql = "UPDATE Vouchers SET quantity = quantity - 1 WHERE code = ? AND quantity > 0";

    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, code);
        st.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
public void removeSelectedCart(String username, List<String> listPid) {

    String sql = "DELETE FROM Cart WHERE username = ? AND pid = ?";

    try {
        PreparedStatement st = connection.prepareStatement(sql);

        for (String pid : listPid) {
            st.setString(1, username);
            st.setString(2, pid);
            st.addBatch();
        }

        st.executeBatch();

    } catch (Exception e) {
        e.printStackTrace();
    }
}
public void removeCartItem(String username, String pid) {
    String sql = "DELETE FROM Cart WHERE username = ? AND pid = ?";

    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        st.setString(2, pid);
        st.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public void deleteUserVoucher(String username, String pid) {
    String sql = "DELETE FROM UserVoucher WHERE username = ? AND pid = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        st.setString(2, pid);
        st.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public Cart getCartItem(String username, String pid) {
    String sql = "SELECT * FROM Cart WHERE username = ? AND pid = ?";

    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        st.setString(2, pid);

        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            Cart c = new Cart();
            c.setUsername(rs.getString("username"));
            c.setPid(rs.getString("pid"));
            c.setQuantity(rs.getInt("quantity"));
            return c;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null; // không có
}
public void updateAccount(String username, String password) {
    String sql = "UPDATE Accounts SET password = ? WHERE username = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, password);
        st.setString(2, username);
        st.executeUpdate();
    } catch (Exception e) {
        System.out.println(e);
    }
}
public Customers getCustomerByUsername(String username) {
    String sql = "SELECT * FROM Customers WHERE username = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            return new Customers(
                rs.getString("username"),
                rs.getString("fullname"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getString("address"),
                rs.getInt("points")
            );
        }
    } catch (Exception e) {
        System.out.println(e);
    }
    return null;
}

    public List<Orders> getOrdersByUsername(String username) {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE username = ? ORDER BY date DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Orders(
                    rs.getInt("id"),
                    rs.getTimestamp("date"),
                    rs.getDouble("totalmoney"),
                    rs.getInt("status"),
                    rs.getString("username"),
                    rs.getString("receiver_name"),
                    rs.getString("receiver_phone"),
                    rs.getString("shipping_address"),
                    rs.getString("voucher_code")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error getOrdersByUsername: " + e);
        }
        return list;
    }

    public Orders getOrderById(int orderId) {
        String sql = "SELECT * FROM Orders WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Orders(
                    rs.getInt("id"),
                    rs.getTimestamp("date"),
                    rs.getDouble("totalmoney"),
                    rs.getInt("status"),
                    rs.getString("username"),
                    rs.getString("receiver_name"),
                    rs.getString("receiver_phone"),
                    rs.getString("shipping_address"),
                    rs.getString("voucher_code")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getOrderById: " + e);
        }
        return null;
    }

    public List<OrderDetails> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetails> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetails WHERE oid = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new OrderDetails(
                    rs.getInt("oid"),
                    rs.getString("pid"),
                    rs.getInt("quantity"),
                    rs.getDouble("price")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error getOrderDetailsByOrderId: " + e);
        }
        return list;
    }

public void updateCustomer(Customers c) {
    String sql = "UPDATE Customers SET fullname=?, email=?, phone=?, address=? WHERE username=?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, c.getFullname());
        st.setString(2, c.getEmail());
        st.setString(3, c.getPhone());
        st.setString(4, c.getAddress());
        st.setString(5, c.getUsername());
        st.executeUpdate();
    } catch (Exception e) {
        System.out.println(e);
    }
}
public void clearCart(String username) {
    String sql = "DELETE FROM Cart WHERE username = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        st.executeUpdate();
    } catch (Exception e) {
        System.out.println(e);
    }
}
    public List<Cart> getCartByUser(String username) {
    List<Cart> list = new ArrayList<>();
    String sql = "SELECT * FROM Cart WHERE username=?";

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            list.add(new Cart(
                rs.getInt("id"),
                rs.getString("username"),
                rs.getString("pid"),
                rs.getInt("quantity"),
                rs.getTimestamp("addedDate")
            ));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}   
}
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Product;

public class DAO extends DBContext {

    // 1. Lấy tất cả danh mục (Hiển thị trên Menu/Sidebar)
    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT cid, name, describe FROM Categories";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("cid"),
                        rs.getString("name"),
                        rs.getString("describe")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Error getAll: " + e);
        }
        return list;
    }

    // 2. Tìm danh mục theo ID
    public Category getCategoryById(int cid) {
        String sql = "SELECT * FROM Categories WHERE cid = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, cid);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Category(
                        rs.getInt("cid"),
                        rs.getString("name"),
                        rs.getString("describe")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getCategoryById: " + e);
        }
        return null;
    }

    // 3. Lấy 3 sản phẩm mới nhất (Dựa trên ngày phát hành)
    public List<Product> getNewProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 3 p.*, c.name AS cname, c.describe AS cdesc "
                   + "FROM Products p INNER JOIN Categories c ON p.cid = c.cid "
                   + "ORDER BY p.releaseDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getNewProducts: " + e);
        }
        return list;
    }

    // 4. Lấy 3 sản phẩm cũ nhất
    public List<Product> getOldProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 3 p.*, c.name AS cname, c.describe AS cdesc "
                   + "FROM Products p INNER JOIN Categories c ON p.cid = c.cid "
                   + "ORDER BY p.releaseDate ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getOldProducts: " + e);
        }
        return list;
    }

    // 5. Tìm kiếm sản phẩm theo từ khóa (Tên hoặc mô tả)
    public List<Product> searchByKey(String key) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS cname, c.describe AS cdesc "
                   + "FROM Products p INNER JOIN Categories c ON p.cid = c.cid "
                   + "WHERE p.name LIKE ? OR p.describe LIKE ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + key + "%");
            st.setString(2, "%" + key + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error searchByKey: " + e);
        }
        return list;
    }

    // 6. Lọc sản phẩm theo Category ID (Sửa lại để an toàn và linh hoạt)
    public List<Product> getProductsByCid(int cid) {
        List<Product> list = new ArrayList<>();
        // Nếu cid = 0 thì lấy tất cả, ngược lại lọc theo cid
        String sql = "SELECT p.*, c.name AS cname, c.describe AS cdesc "
                   + "FROM Products p INNER JOIN Categories c ON p.cid = c.cid "
                   + "WHERE (? = 0 OR p.cid = ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, cid);
            st.setInt(2, cid);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getProductsByCid: " + e);
        }
        return list;
    }

    // 7. Lọc sản phẩm theo nhiều Category (Dùng cho Checkbox)
    public List<Product> searchByCheck(int[] cid) {
        List<Product> list = new ArrayList<>();
        if (cid == null || cid.length == 0 || (cid.length == 1 && cid[0] == 0)) {
            return getProductsByCid(0); // Trả về tất cả nếu không chọn
        }

        StringBuilder sql = new StringBuilder("SELECT p.*, c.name AS cname, c.describe AS cdesc "
                   + "FROM Products p INNER JOIN Categories c ON p.cid = c.cid "
                   + "WHERE p.cid IN (");
        
        for (int i = 0; i < cid.length; i++) {
            sql.append("?").append(i == cid.length - 1 ? "" : ",");
        }
        sql.append(")");

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < cid.length; i++) {
                st.setInt(i + 1, cid[i]);
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error searchByCheck: " + e);
        }
        return list;
    }

    // 8. Lọc sản phẩm theo khoảng giá
    public List<Product> getProductsByPrice(double from, double to) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS cname, c.describe AS cdesc "
                   + "FROM Products p INNER JOIN Categories c ON p.cid = c.cid "
                   + "WHERE p.price BETWEEN ? AND ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDouble(1, from);
            st.setDouble(2, to);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getProductsByPrice: " + e);
        }
        return list;
    }

    // --- HÀM PHỤ TRỢ (HELPER) ---
    // Giúp chuyển đổi dữ liệu từ Database sang Object Product một cách thống nhất
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getString("id"));
        p.setName(rs.getString("name"));
        p.setQuantity(rs.getInt("quantity"));
        p.setPrice(rs.getDouble("price"));
        p.setReleaseDate(rs.getString("releaseDate"));
        p.setDescribe(rs.getString("describe"));
        p.setImage(rs.getString("image"));
        
        // Gán thông tin Category cho Product
        Category c = new Category(
                rs.getInt("cid"),
                rs.getString("cname"),
                rs.getString("cdesc")
        );
        p.setCategory(c);
        return p;
    }

    // --- KIỂM TRA NHANH (Main Test) ---
    public static void main(String[] args) {
        DAO d = new DAO();
        List<Product> list = d.getNewProducts();
        for (Product p : list) {
            System.out.println(p.getId() + " - " + p.getName() + " - " + p.getCategory().getName());
        }
    }
}
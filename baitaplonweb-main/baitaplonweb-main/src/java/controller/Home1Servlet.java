package controller;

import dal.DAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Product;

@WebServlet(name = "Home1Servlet", urlPatterns = {"/home1"})
public class Home1Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Khởi tạo các mảng dữ liệu cho giao diện
        String[] pp = {"Tất cả mức giá", "Dưới 1 triệu", "Từ 1-3 triệu", "Từ 3-5 triệu", "Từ 5-10 triệu", "Trên 10 triệu"};
        DAO d = new DAO();
        List<Category> categories = d.getAll();
        
        // Mảng boolean để giữ trạng thái "checked" cho checkbox trên JSP
        boolean[] pb = new boolean[pp.length]; 
        boolean[] chid = new boolean[categories.size() + 1];
        
        // 2. Nhận tham số từ Request
        String key = request.getParameter("key");      // Từ khóa tìm kiếm
        String cid_raw = request.getParameter("cid");  // Lọc 1 danh mục (từ menu)
        String[] cidd_raw = request.getParameterValues("cidd"); // Lọc nhiều danh mục (checkbox)
        String[] price_raw = request.getParameterValues("price"); // Lọc khoảng giá (checkbox)
        
        List<Product> products = new ArrayList<>();

        try {
            // --- BƯỚC A: LỌC THEO DANH MỤC HOẶC TÌM KIẾM ---
            if (key != null && !key.trim().isEmpty()) {
                // Nếu có từ khóa tìm kiếm
                products = d.searchByKey(key);
            } 
            else if (cidd_raw != null) {
                // Nếu lọc bằng nhiều Checkbox Danh mục
                int[] cidd = new int[cidd_raw.length];
                for (int i = 0; i < cidd.length; i++) {
                    cidd[i] = Integer.parseInt(cidd_raw[i]);
                }
                products = d.searchByCheck(cidd);
                
                // Đánh dấu checked cho các checkbox tương ứng
                if (cidd[0] == 0) {
                    chid[0] = true;
                } else {
                    for (int i = 1; i < chid.length; i++) {
                        chid[i] = ischeck(categories.get(i - 1).getCid(), cidd);
                    }
                }
            } 
            else if (cid_raw != null) {
                // Nếu lọc bằng 1 Danh mục (thường từ Menu Sidebar)
                int cid = Integer.parseInt(cid_raw);
                products = d.getProductsByCid(cid);
                if (cid == 0) chid[0] = true;
                else {
                    for (int i = 0; i < categories.size(); i++) {
                        if (categories.get(i).getCid() == cid) chid[i+1] = true;
                    }
                }
            } 
            else {
                // Mặc định: Hiển thị tất cả sản phẩm
                products = d.getProductsByCid(0);
                chid[0] = true;
            }

            // --- BƯỚC B: LỌC TIẾP THEO GIÁ (Lọc trên tập kết quả của Bước A) ---
            if (price_raw != null) {
                List<Product> tempResult = new ArrayList<>();
                for (String pStr : price_raw) {
                    int pIdx = Integer.parseInt(pStr);
                    pb[pIdx] = true; // Đánh dấu checked cho checkbox giá
                    
                    if (pIdx == 0) {
                        tempResult = products; // Chọn "Tất cả mức giá"
                        break;
                    }

                    double from = 0, to = 0;
                    switch (pIdx) {
                        case 1: from = 0; to = 1000; break;
                        case 2: from = 1000; to = 3000; break;
                        case 3: from = 3000; to = 5000; break;
                        case 4: from = 5000; to = 10000; break;
                        case 5: from = 10000; to = 100000; break; // Giả định trần là 100k
                    }

                    for (Product prod : products) {
                        if (prod.getPrice() >= from && prod.getPrice() <= to) {
                            if (!tempResult.contains(prod)) tempResult.add(prod);
                        }
                    }
                }
                products = tempResult;
            } else {
                pb[0] = true; // Mặc định tick "Tất cả mức giá"
            }

        } catch (NumberFormatException e) {
            System.out.println("Lỗi tham số: " + e);
        }

        // 3. Đẩy dữ liệu sang trang list.jsp
        request.setAttribute("data", categories);
        request.setAttribute("products", products);
        request.setAttribute("pp", pp);
        request.setAttribute("key", key);
        request.setAttribute("pb", pb);
        request.setAttribute("chid", chid);
        
        request.getRequestDispatcher("list.jsp").forward(request, response);
    }

    /**
     * Hàm kiểm tra một ID có nằm trong mảng ID được chọn hay không
     */
    private boolean ischeck(int d, int[] id) {
        if (id == null) return false;
        for (int i : id) {
            if (i == d) return true;
        }
        return false;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển mọi yêu cầu POST sang GET để xử lý chung một logic lọc
        doGet(request, response);
    }
}
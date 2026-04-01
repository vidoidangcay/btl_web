package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // 1. Cấu hình URL (Sử dụng 127.0.0.1 thay cho localhost để ổn định hơn)
            String url = "jdbc:sqlserver://127.0.0.1:1433;databaseName=Trading2022;encrypt=true;trustServerCertificate=true;";
            String username = "sa";
            String password = "123456"; // Đảm bảo pass này đúng với máy của bạn

            // 2. Nạp Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // 3. Mở kết nối
            connection = DriverManager.getConnection(url, username, password);
            
        } catch (ClassNotFoundException | SQLException ex) {
            // In lỗi ra Console để "bắt bệnh" nếu connection bị null
            System.out.println("LỖI KẾT NỐI DBContext: " + ex.getMessage());
        }
    }
}
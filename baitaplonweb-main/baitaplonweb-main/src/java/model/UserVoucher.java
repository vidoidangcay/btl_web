import java.util.Date;

public class UserVoucher {
    private String username;
    private String pid;
    private String voucherCode;
    private Date selectedDate;

    // Constructor mặc định
    public UserVoucher() {
    }

    // Constructor đầy đủ tham số
    public UserVoucher(String username, String pid, String voucherCode, Date selectedDate) {
        this.username = username;
        this.pid = pid;
        this.voucherCode = voucherCode;
        this.selectedDate = selectedDate;
    }

    // Getter và Setter
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public Date getSelectedDate() {
        return selectedDate;
    }

    public void setSelectedDate(Date selectedDate) {
        this.selectedDate = selectedDate;
    }

    // Phương thức hỗ trợ in dữ liệu (tùy chọn)
    @Override
    public String toString() {
        return "UserVoucher{" +
                "username='" + username + '\'' +
                ", pid='" + pid + '\'' +
                ", voucherCode='" + voucherCode + '\'' +
                ", selectedDate=" + selectedDate +
                '}';
    }
}
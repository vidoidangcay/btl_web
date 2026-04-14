package model;

import java.sql.Timestamp;

public class Orders {
    private int id;
    private Timestamp date;
    private double totalmoney;
    private int status;
    private String username;
    private String receiver_name;
    private String receiver_phone;
    private String shipping_address;
    private String voucher_code;
    private String paymentMethod;

    public Orders() {
    }

    public Orders(int id, Timestamp date, double totalmoney, int status, String username, 
                  String receiver_name, String receiver_phone, String shipping_address, String voucher_code, String paymentMethod) {
        this.id = id;
        this.date = date;
        this.totalmoney = totalmoney;
        this.status = status;
        this.username = username;
        this.receiver_name = receiver_name;
        this.receiver_phone = receiver_phone;
        this.shipping_address = shipping_address;
        this.voucher_code = voucher_code;
        this.paymentMethod = paymentMethod;
    }

    // --- NHÓM GETTER ---
    public int getId() { return id; }
    public Timestamp getDate() { return date; }
    public double getTotalmoney() { return totalmoney; }
    public int getStatus() { return status; }
    public String getUsername() { return username; }
    public String getReceiver_name() { return receiver_name; }
    public String getReceiver_phone() { return receiver_phone; }
    public String getShipping_address() { return shipping_address; }
    public String getVoucher_code() { return voucher_code; }

    // --- NHÓM SETTER ---
    public void setId(int id) { this.id = id; }
    public void setDate(Timestamp date) { this.date = date; }
    public void setTotalmoney(double totalmoney) { this.totalmoney = totalmoney; }
    public void setStatus(int status) { this.status = status; }
    public void setUsername(String username) { this.username = username; }
    public void setReceiver_name(String receiver_name) { this.receiver_name = receiver_name; }
    public void setReceiver_phone(String receiver_phone) { this.receiver_phone = receiver_phone; }
    public void setShipping_address(String shipping_address) { this.shipping_address = shipping_address; }
    public void setVoucher_code(String voucher_code) { this.voucher_code = voucher_code; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public boolean isPaid() {
        return paymentMethod != null && !paymentMethod.equalsIgnoreCase("cod");
    }

    public String getPaidStatus() {
        if (paymentMethod == null) {
            return "Chưa xác định";
        }
        return paymentMethod.equalsIgnoreCase("cod") ? "Chưa thanh toán" : "Đã thanh toán";
    }

    // Gợi ý thêm hàm toString để Admin dễ debug (kiểm tra dữ liệu)
    @Override
    public String toString() {
        return "Orders{" + "id=" + id + ", totalmoney=" + totalmoney + ", status=" + status + 
               ", username=" + username + ", receiver=" + receiver_name + ", paymentMethod=" + paymentMethod + "}";
    }
}
package model;

import java.sql.Date;

public class Vouchers {
    private String code;
    private double discountValue;
    private Date expirationDate;
    private double minOrderValue;
    private int quantity;

    public Vouchers() {
    }

    public Vouchers(String code, double discountValue, Date expirationDate, double minOrderValue, int quantity) {
        this.code = code;
        this.discountValue = discountValue;
        this.expirationDate = expirationDate;
        this.minOrderValue = minOrderValue;
        this.quantity = quantity;
    }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public Date getExpirationDate() { return expirationDate; }
    public void setExpirationDate(Date expirationDate) { this.expirationDate = expirationDate; }

    public double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(double minOrderValue) { this.minOrderValue = minOrderValue; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
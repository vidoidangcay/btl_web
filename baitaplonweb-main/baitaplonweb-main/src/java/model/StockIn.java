package model;

import java.sql.Timestamp;

public class StockIn {
    private int id;
    private Timestamp date;
    private int sid; // ID nhà cung cấp
    private String admin_user;
    private double total_cost;

    public StockIn() {
    }

    public StockIn(int id, Timestamp date, int sid, String admin_user, double total_cost) {
        this.id = id;
        this.date = date;
        this.sid = sid;
        this.admin_user = admin_user;
        this.total_cost = total_cost;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }

    public int getSid() { return sid; }
    public void setSid(int sid) { this.sid = sid; }

    public String getAdmin_user() { return admin_user; }
    public void setAdmin_user(String admin_user) { this.admin_user = admin_user; }

    public double getTotal_cost() { return total_cost; }
    public void setTotal_cost(double total_cost) { this.total_cost = total_cost; }
}   
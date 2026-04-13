package model;

public class StockInDetails {
    private int stock_id;
    private String pid;
    private int quantity;
    private double purchase_price;

    public StockInDetails() {
    }

    public StockInDetails(int stock_id, String pid, int quantity, double purchase_price) {
        this.stock_id = stock_id;
        this.pid = pid;
        this.quantity = quantity;
        this.purchase_price = purchase_price;
    }

    public int getStock_id() { return stock_id; }
    public void setStock_id(int stock_id) { this.stock_id = stock_id; }

    public String getPid() { return pid; }
    public void setPid(String pid) { this.pid = pid; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPurchase_price() { return purchase_price; }
    public void setPurchase_price(double purchase_price) { this.purchase_price = purchase_price; }
}
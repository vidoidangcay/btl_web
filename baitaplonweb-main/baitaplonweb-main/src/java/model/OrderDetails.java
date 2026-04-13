package model;

public class OrderDetails {
    private int oid;
    private String pid;
    private int quantity;
    private double price;

    public OrderDetails() {
    }

    public OrderDetails(int oid, String pid, int quantity, double price) {
        this.oid = oid;
        this.pid = pid;
        this.quantity = quantity;
        this.price = price;
    }

    public int getOid() { return oid; }
    public void setOid(int oid) { this.oid = oid; }

    public String getPid() { return pid; }
    public void setPid(String pid) { this.pid = pid; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
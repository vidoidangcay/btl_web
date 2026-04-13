package model;

import java.sql.Timestamp;

public class Cart {
    private int id;
    private String username;
    private String pid;
    private int quantity;
    private Timestamp addedDate;

    public Cart() {
    }

    public Cart(int id, String username, String pid, int quantity, Timestamp addedDate) {
        this.id = id;
        this.username = username;
        this.pid = pid;
        this.quantity = quantity;
        this.addedDate = addedDate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPid() { return pid; }
    public void setPid(String pid) { this.pid = pid; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public Timestamp getAddedDate() { return addedDate; }
    public void setAddedDate(Timestamp addedDate) { this.addedDate = addedDate; }
}
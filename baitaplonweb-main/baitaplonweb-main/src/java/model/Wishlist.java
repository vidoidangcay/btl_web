package model;

import java.sql.Date;

public class Wishlist {
    private String username;
    private String pid;
    private Date addedDate;

    public Wishlist() {
    }

    public Wishlist(String username, String pid, Date addedDate) {
        this.username = username;
        this.pid = pid;
        this.addedDate = addedDate;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPid() { return pid; }
    public void setPid(String pid) { this.pid = pid; }

    public Date getAddedDate() { return addedDate; }
    public void setAddedDate(Date addedDate) { this.addedDate = addedDate; }
}
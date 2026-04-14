package model;

import java.sql.Timestamp;

public class Feedback {
    private int id;
    private int orderId;
    private String username;
    private String comment;
    private Timestamp createdDate;

    public Feedback() {
    }

    public Feedback(int id, int orderId, String username, String comment, Timestamp createdDate) {
        this.id = id;
        this.orderId = orderId;
        this.username = username;
        this.comment = comment;
        this.createdDate = createdDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
}

package model;

import java.sql.Timestamp;

public class OrderShipment {
    private int orderId;
    private String username;
    private String receiver_name;
    private String receiver_phone;
    private String shipping_address;
    private int status;
    private Timestamp createdDate;

    public OrderShipment() {
    }

    public OrderShipment(int orderId, String username, String receiver_name, String receiver_phone, String shipping_address, int status, Timestamp createdDate) {
        this.orderId = orderId;
        this.username = username;
        this.receiver_name = receiver_name;
        this.receiver_phone = receiver_phone;
        this.shipping_address = shipping_address;
        this.status = status;
        this.createdDate = createdDate;
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

    public String getReceiver_name() {
        return receiver_name;
    }

    public void setReceiver_name(String receiver_name) {
        this.receiver_name = receiver_name;
    }

    public String getReceiver_phone() {
        return receiver_phone;
    }

    public void setReceiver_phone(String receiver_phone) {
        this.receiver_phone = receiver_phone;
    }

    public String getShipping_address() {
        return shipping_address;
    }

    public void setShipping_address(String shipping_address) {
        this.shipping_address = shipping_address;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
}
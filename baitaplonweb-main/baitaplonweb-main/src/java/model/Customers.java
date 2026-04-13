package model;

public class Customers {
    private String username;
    private String fullname;
    private String email;
    private String phone;
    private String address;
    private int points;

    public Customers() {
    }

    public Customers(String username, String fullname, String email, String phone, String address, int points) {
        this.username = username;
        this.fullname = fullname;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.points = points;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }
}
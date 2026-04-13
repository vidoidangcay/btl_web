package model;

import java.sql.Date;

public class Products {
    private String id;
    private String name;
    private int quantity;
    private double price;
    private Date releaseDate;
    private String describe;
    private String image;
    private int cid; // Khóa ngoại từ Categories

    public Products() {
        
    }

    public Products(String id, String name, int quantity, double price, Date releaseDate, String describe, String image, int cid) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
        this.releaseDate = releaseDate;
        this.describe = describe;
        this.image = image;
        this.cid = cid;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public Date getReleaseDate() { return releaseDate; }
    public void setReleaseDate(Date releaseDate) { this.releaseDate = releaseDate; }

    public String getDescribe() { return describe; }
    public void setDescribe(String describe) { this.describe = describe; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getCid() { return cid; }
    public void setCid(int cid) { this.cid = cid; }
}
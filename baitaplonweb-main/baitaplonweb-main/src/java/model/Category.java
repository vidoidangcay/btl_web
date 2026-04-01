package model;

public class Category {
    private int cid; // Đổi từ id thành cid
    private String name, describe;

    public Category() {
    }

    public Category(int cid, String name, String describe) {
        this.cid = cid;
        this.name = name;
        this.describe = describe;
    }

    // Đổi tên hàm thành getCid
    public int getCid() {
        return cid;
    }

    public void setCid(int cid) {
        this.cid = cid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescribe() {
        return describe;
    }

    public void setDescribe(String describe) {
        this.describe = describe;
    }
}
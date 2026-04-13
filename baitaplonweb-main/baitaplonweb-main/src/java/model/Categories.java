package model;

/**
 * Model class cho bảng Categories
 */
public class Categories {
    private int id;
    private String name;
    private String describe;

    // Constructor không tham số
    public Categories() {
    }

    // Constructor có tham số (Dùng trong DAO khi lấy dữ liệu từ ResultSet)
    public Categories(int id, String name, String describe) {
        this.id = id;
        this.name = name;
        this.describe = describe;
    }

    // Getter và Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    // Ghi đè phương thức toString để hỗ trợ việc debug/kiểm tra dữ liệu
    @Override
    public String toString() {
        return "Categories{" + "id=" + id + ", name=" + name + ", describe=" + describe + '}';
    }
}
package model;

public class ProductGallery {
    private int id;
    private String pid;
    private String imageUrl;

    public ProductGallery() {
    }

    public ProductGallery(int id, String pid, String imageUrl) {
        this.id = id;
        this.pid = pid;
        this.imageUrl = imageUrl;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPid() { return pid; }
    public void setPid(String pid) { this.pid = pid; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
package model;

import java.sql.Date;

public class Feedback {
    private int id;
    private String username;
    private String pid;
    private int rating;
    private String comment;
    private Date date;

    public Feedback() {
    }

    public Feedback(int id, String username, String pid, int rating, String comment, Date date) {
        this.id = id;
        this.username = username;
        this.pid = pid;
        this.rating = rating;
        this.comment = comment;
        this.date = date;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPid() { return pid; }
    public void setPid(String pid) { this.pid = pid; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}
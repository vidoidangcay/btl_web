package model;

import java.io.Serializable;

/**
 * Khớp với bảng Accounts trong SQL: username, password, role
 */
public class Accounts implements Serializable {

    private String username; // Khóa chính là String
    private String password;
    private int role;        // 1 cho admin, 0 cho user

    public Accounts() {
    }

    public Accounts(String username, String password, int role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }

    // Getter và Setter
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "Accounts{" + "username=" + username + ", role=" + role + '}';
    }
}
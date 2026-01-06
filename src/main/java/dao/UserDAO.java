package dao;

import model.User;
import util.KoneksiDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User register(String email, String password, String name, String phone, String address) {
        Connection c = null;
        try {
            c = KoneksiDB.getConnection();
            if (c == null) return null;

            // Check if email exists
            String checkSql = "SELECT id FROM users WHERE email = ?";
            try (PreparedStatement ps = c.prepareStatement(checkSql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return null; // Email already exists
                    }
                }
            }

            // Insert new user
            String insertSql = "INSERT INTO users(email, password, name, phone, address, role) VALUES (?,?,?,?,?,?) RETURNING id, created_at";
            try (PreparedStatement ps = c.prepareStatement(insertSql)) {
                ps.setString(1, email);
                ps.setString(2, password); // In production, use hashing (BCrypt, etc)
                ps.setString(3, name);
                ps.setString(4, phone);
                ps.setString(5, address);
                ps.setString(6, "user"); // Default role
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User u = new User();
                        u.setId(rs.getInt("id"));
                        u.setEmail(email);
                        u.setPassword(password);
                        u.setName(name);
                        u.setPhone(phone);
                        u.setAddress(address);
                        u.setRole("user");
                        Timestamp ts = rs.getTimestamp("created_at");
                        u.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
                        return u;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public User login(String email, String password) {
        String sql = "SELECT id, email, password, name, phone, address, role, created_at, updated_at FROM users WHERE email = ? AND password = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, email);
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User u = new User();
                        u.setId(rs.getInt("id"));
                        u.setEmail(rs.getString("email"));
                        u.setPassword(rs.getString("password"));
                        u.setName(rs.getString("name"));
                        u.setPhone(rs.getString("phone"));
                        u.setAddress(rs.getString("address"));
                        u.setRole(rs.getString("role"));
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        Timestamp updatedAt = rs.getTimestamp("updated_at");
                        u.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
                        u.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);
                        return u;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getById(int id) {
        String sql = "SELECT id, email, password, name, phone, address, role, created_at, updated_at FROM users WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User u = new User();
                        u.setId(rs.getInt("id"));
                        u.setEmail(rs.getString("email"));
                        u.setPassword(rs.getString("password"));
                        u.setName(rs.getString("name"));
                        u.setPhone(rs.getString("phone"));
                        u.setAddress(rs.getString("address"));
                        u.setRole(rs.getString("role"));
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        Timestamp updatedAt = rs.getTimestamp("updated_at");
                        u.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
                        u.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);
                        return u;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, email, password, name, phone, address, role, created_at, updated_at FROM users ORDER BY created_at DESC";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setName(rs.getString("name"));
                    u.setPhone(rs.getString("phone"));
                    u.setAddress(rs.getString("address"));
                    u.setRole(rs.getString("role"));
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    u.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
                    u.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

package dao;

import model.Contact;
import util.KoneksiDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {
    private Connection conn;

    public ContactDAO() {
        this.conn = KoneksiDB.getConnection();
    }

    public boolean insert(Contact contact) {
        String sql = "INSERT INTO contacts (name, email, phone, message, created_at) VALUES (?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contact.getName());
            ps.setString(2, contact.getEmail());
            ps.setString(3, contact.getPhone());
            ps.setString(4, contact.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Contact> getAll() {
        List<Contact> list = new ArrayList<>();
        String sql = "SELECT id, name, email, phone, message, created_at FROM contacts ORDER BY created_at DESC";
        try (Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Contact c = new Contact();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setMessage(rs.getString("message"));
                c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Contact getById(int id) {
        String sql = "SELECT id, name, email, phone, message, created_at FROM contacts WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Contact c = new Contact();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setMessage(rs.getString("message"));
                c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

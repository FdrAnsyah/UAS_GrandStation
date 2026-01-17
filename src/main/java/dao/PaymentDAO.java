package dao;

import model.Payment;
import util.KoneksiDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class PaymentDAO {

    private static String genPaymentCode() {
        return "PAY-" + UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
    }

    public Payment createPayment(int bookingId, double amount, String method) {
        Connection c = null;
        try {
            c = KoneksiDB.getConnection();
            if (c == null) return null;

            String code = genPaymentCode();
            String sql = "INSERT INTO payments(booking_id, payment_code, amount, status, method) VALUES (?,?,?,?,?) RETURNING id, created_at";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                ps.setString(2, code);
                ps.setDouble(3, amount);
                ps.setString(4, "PENDING");
                ps.setString(5, method);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Payment p = new Payment();
                        p.setId(rs.getInt("id"));
                        p.setBookingId(bookingId);
                        p.setPaymentCode(code);
                        p.setAmount(amount);
                        p.setStatus("PENDING");
                        p.setMethod(method);
                        Timestamp ts = rs.getTimestamp("created_at");
                        p.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
                        return p;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Payment getByPaymentCode(String paymentCode) {
        String sql = "SELECT id, booking_id, payment_code, amount, status, method, created_at, updated_at FROM payments WHERE payment_code = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, paymentCode);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Payment p = new Payment();
                        p.setId(rs.getInt("id"));
                        p.setBookingId(rs.getInt("booking_id"));
                        p.setPaymentCode(rs.getString("payment_code"));
                        p.setAmount(rs.getDouble("amount"));
                        p.setStatus(rs.getString("status"));
                        p.setMethod(rs.getString("method"));
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        Timestamp updatedAt = rs.getTimestamp("updated_at");
                        p.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
                        p.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);
                        return p;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE payments SET status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setInt(2, paymentId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Payment> getAll() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT id, booking_id, payment_code, amount, status, method, created_at, updated_at FROM payments ORDER BY created_at DESC";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setId(rs.getInt("id"));
                    p.setBookingId(rs.getInt("booking_id"));
                    p.setPaymentCode(rs.getString("payment_code"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setStatus(rs.getString("status"));
                    p.setMethod(rs.getString("method"));
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    p.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
                    p.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Payment getByBookingId(int bookingId) {
        String sql = "SELECT id, booking_id, payment_code, amount, status, method, created_at, updated_at FROM payments WHERE booking_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Payment p = new Payment();
                        p.setId(rs.getInt("id"));
                        p.setBookingId(rs.getInt("booking_id"));
                        p.setPaymentCode(rs.getString("payment_code"));
                        p.setAmount(rs.getDouble("amount"));
                        p.setStatus(rs.getString("status"));
                        p.setMethod(rs.getString("method"));
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        Timestamp updatedAt = rs.getTimestamp("updated_at");
                        p.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
                        p.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);
                        return p;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

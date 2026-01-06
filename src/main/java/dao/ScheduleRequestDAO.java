package dao;

import model.User;
import util.KoneksiDB;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ScheduleRequestDAO {

    // Save or update schedule request from user
    public void saveRequest(int userId, int originId, int destinationId, LocalDate requestedDate) {
        String checkSql = "SELECT id, request_count FROM schedule_requests WHERE user_id = ? AND origin_station_id = ? AND destination_station_id = ? AND requested_date = ? AND status = 'pending'";
        String updateSql = "UPDATE schedule_requests SET request_count = request_count + 1, last_requested_at = NOW() WHERE id = ?";
        String insertSql = "INSERT INTO schedule_requests (user_id, origin_station_id, destination_station_id, requested_date) VALUES (?, ?, ?, ?)";

        try (Connection conn = KoneksiDB.getConnection()) {
            // Check if request already exists
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                checkStmt.setInt(2, originId);
                checkStmt.setInt(3, destinationId);
                checkStmt.setDate(4, Date.valueOf(requestedDate));

                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    // Update existing request count
                    int requestId = rs.getInt("id");
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, requestId);
                        updateStmt.executeUpdate();
                    }
                } else {
                    // Insert new request
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setInt(1, userId);
                        insertStmt.setInt(2, originId);
                        insertStmt.setInt(3, destinationId);
                        insertStmt.setDate(4, Date.valueOf(requestedDate));
                        insertStmt.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all pending schedule requests for admin
    public List<Map<String, Object>> getPendingRequests() {
        List<Map<String, Object>> requests = new ArrayList<>();
        String sql = "SELECT * FROM admin_schedule_requests WHERE status = 'pending' ORDER BY request_count DESC, last_requested_at DESC";

        try (Connection conn = KoneksiDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> request = new HashMap<>();
                request.put("id", rs.getInt("id"));
                request.put("request_count", rs.getInt("request_count"));
                request.put("requested_date", rs.getDate("requested_date").toLocalDate());
                request.put("origin_name", rs.getString("origin_name"));
                request.put("origin_code", rs.getString("origin_code"));
                request.put("destination_name", rs.getString("destination_name"));
                request.put("destination_code", rs.getString("destination_code"));
                request.put("user_name", rs.getString("user_name"));
                request.put("user_email", rs.getString("user_email"));
                request.put("created_at", rs.getTimestamp("created_at"));
                request.put("last_requested_at", rs.getTimestamp("last_requested_at"));
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    // Mark request as reviewed or created
    public void updateStatus(int requestId, String status, String notes) {
        String sql = "UPDATE schedule_requests SET status = ?, notes = ? WHERE id = ?";
        try (Connection conn = KoneksiDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, notes);
            stmt.setInt(3, requestId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get request count by route
    public int getRequestCountByRoute(int originId, int destinationId) {
        String sql = "SELECT COALESCE(SUM(request_count), 0) as total FROM schedule_requests WHERE origin_station_id = ? AND destination_station_id = ? AND status = 'pending'";
        try (Connection conn = KoneksiDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, originId);
            stmt.setInt(2, destinationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

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

    // Save or update schedule request (supports logged-in user or anonymous)
    public void saveRequest(Integer userId, int originId, int destinationId, LocalDate requestedDate) {
        String checkSqlWithUser = "SELECT id FROM schedule_requests WHERE user_id = ? AND origin_station_id = ? AND destination_station_id = ? AND requested_date = ? AND status = 'pending'";
        String checkSqlAnon = "SELECT id FROM schedule_requests WHERE user_id IS NULL AND origin_station_id = ? AND destination_station_id = ? AND requested_date = ? AND status = 'pending'";
        String updateSql = "UPDATE schedule_requests SET request_count = request_count + 1, last_requested_at = NOW() WHERE id = ?";
        String insertSql = "INSERT INTO schedule_requests (user_id, origin_station_id, destination_station_id, requested_date) VALUES (?, ?, ?, ?)";

        try (Connection conn = KoneksiDB.getConnection()) {
            if (conn == null) return;

            boolean isAnonymous = userId == null;
            String checkSql = isAnonymous ? checkSqlAnon : checkSqlWithUser;

            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                int paramIndex = 1;
                if (!isAnonymous) {
                    checkStmt.setInt(paramIndex++, userId);
                }
                checkStmt.setInt(paramIndex++, originId);
                checkStmt.setInt(paramIndex++, destinationId);
                checkStmt.setDate(paramIndex, Date.valueOf(requestedDate));

                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    int requestId = rs.getInt("id");
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, requestId);
                        updateStmt.executeUpdate();
                    }
                } else {
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        if (isAnonymous) {
                            insertStmt.setNull(1, Types.INTEGER);
                        } else {
                            insertStmt.setInt(1, userId);
                        }
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

    // Get a single schedule request by id
    public Map<String, Object> getById(int id) {
        String sql = "SELECT sr.id, sr.request_count, sr.requested_date, sr.status, sr.last_requested_at, " +
                     "sr.origin_station_id, sr.destination_station_id, " +
                     "s1.name AS origin_name, s1.code AS origin_code, s2.name AS destination_name, s2.code AS destination_code, " +
                     "u.name AS user_name, u.email AS user_email, sr.created_at " +
                     "FROM schedule_requests sr " +
                     "JOIN stations s1 ON sr.origin_station_id = s1.id " +
                     "JOIN stations s2 ON sr.destination_station_id = s2.id " +
                     "LEFT JOIN users u ON sr.user_id = u.id " +
                     "WHERE sr.id = ?";

        try (Connection conn = KoneksiDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> request = new HashMap<>();
                    request.put("id", rs.getInt("id"));
                    request.put("request_count", rs.getInt("request_count"));
                    Date reqDate = rs.getDate("requested_date");
                    request.put("requested_date", reqDate != null ? reqDate.toLocalDate() : null);
                    request.put("status", rs.getString("status"));
                    request.put("last_requested_at", rs.getTimestamp("last_requested_at"));
                    request.put("origin_station_id", rs.getInt("origin_station_id"));
                    request.put("destination_station_id", rs.getInt("destination_station_id"));
                    request.put("origin_name", rs.getString("origin_name"));
                    request.put("origin_code", rs.getString("origin_code"));
                    request.put("destination_name", rs.getString("destination_name"));
                    request.put("destination_code", rs.getString("destination_code"));
                    request.put("user_name", rs.getString("user_name"));
                    request.put("user_email", rs.getString("user_email"));
                    request.put("created_at", rs.getTimestamp("created_at"));
                    return request;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all pending schedule requests for admin
    public List<Map<String, Object>> getPendingRequests() {
        List<Map<String, Object>> requests = new ArrayList<>();
        String sql = "SELECT sr.id, sr.request_count, sr.requested_date, sr.status, sr.last_requested_at, " +
                     "s1.name AS origin_name, s1.code AS origin_code, s2.name AS destination_name, s2.code AS destination_code, " +
                     "u.name AS user_name, u.email AS user_email, sr.created_at " +
                     "FROM schedule_requests sr " +
                     "JOIN stations s1 ON sr.origin_station_id = s1.id " +
                     "JOIN stations s2 ON sr.destination_station_id = s2.id " +
                     "LEFT JOIN users u ON sr.user_id = u.id " +
                     "WHERE sr.status = 'pending' " +
                     "ORDER BY sr.request_count DESC, sr.last_requested_at DESC";

        try (Connection conn = KoneksiDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> request = new HashMap<>();
                request.put("id", rs.getInt("id"));
                request.put("request_count", rs.getInt("request_count"));
                Date reqDate = rs.getDate("requested_date");
                request.put("requested_date", reqDate != null ? reqDate.toLocalDate() : null);
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

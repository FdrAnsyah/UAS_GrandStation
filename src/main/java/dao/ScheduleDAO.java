package dao;

import model.Schedule;
import model.Station;
import model.Train;
import util.KoneksiDB;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    private static Schedule mapRow(ResultSet r) throws SQLException {
        Schedule s = new Schedule();
        s.setId(r.getInt("id"));
        Timestamp depart = r.getTimestamp("depart_time");
        Timestamp arrive = r.getTimestamp("arrive_time");
        s.setDepartTime(depart != null ? depart.toLocalDateTime() : null);
        s.setArriveTime(arrive != null ? arrive.toLocalDateTime() : null);
        s.setPrice(r.getDouble("price"));
        s.setSeatsAvailable(r.getInt("seats_available"));

        Train t = new Train();
        t.setId(r.getInt("train_id"));
        t.setCode(r.getString("train_code"));
        t.setName(r.getString("train_name"));
        t.setTrainClass(r.getString("train_class"));
        t.setSeatsTotal(r.getInt("seats_total"));
        s.setTrain(t);

        Station o = new Station();
        o.setId(r.getInt("origin_id"));
        o.setCode(r.getString("origin_code"));
        o.setName(r.getString("origin_name"));
        o.setCity(r.getString("origin_city"));
        s.setOrigin(o);

        Station d = new Station();
        d.setId(r.getInt("dest_id"));
        d.setCode(r.getString("dest_code"));
        d.setName(r.getString("dest_name"));
        d.setCity(r.getString("dest_city"));
        s.setDestination(d);

        return s;
    }

    public List<Schedule> search(int originId, int destinationId, LocalDate travelDate) {
        List<Schedule> list = new ArrayList<>();

        String sql = "SELECT "
                + "s.id, s.depart_time, s.arrive_time, s.price, s.seats_available, "
                + "t.id AS train_id, t.code AS train_code, t.name AS train_name, t.train_class, t.seats_total, "
                + "o.id AS origin_id, o.code AS origin_code, o.name AS origin_name, o.city AS origin_city, "
                + "d.id AS dest_id, d.code AS dest_code, d.name AS dest_name, d.city AS dest_city "
                + "FROM schedules s "
                + "JOIN trains t ON s.train_id = t.id "
                + "JOIN stations o ON s.origin_id = o.id "
                + "JOIN stations d ON s.destination_id = d.id "
                + "WHERE s.origin_id = ? AND s.destination_id = ? AND DATE(s.depart_time) = ? "
                + "ORDER BY s.depart_time ASC";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, originId);
                ps.setInt(2, destinationId);
                ps.setDate(3, Date.valueOf(travelDate));
                try (ResultSet r = ps.executeQuery()) {
                    while (r.next()) {
                        list.add(mapRow(r));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Schedule getById(int scheduleId) {
        String sql = "SELECT "
                + "s.id, s.depart_time, s.arrive_time, s.price, s.seats_available, "
                + "t.id AS train_id, t.code AS train_code, t.name AS train_name, t.train_class, t.seats_total, "
                + "o.id AS origin_id, o.code AS origin_code, o.name AS origin_name, o.city AS origin_city, "
                + "d.id AS dest_id, d.code AS dest_code, d.name AS dest_name, d.city AS dest_city "
                + "FROM schedules s "
                + "JOIN trains t ON s.train_id = t.id "
                + "JOIN stations o ON s.origin_id = o.id "
                + "JOIN stations d ON s.destination_id = d.id "
                + "WHERE s.id = ?";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, scheduleId);
                try (ResultSet r = ps.executeQuery()) {
                    if (r.next()) {
                        return mapRow(r);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Schedule> getAll() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT "
                + "s.id, s.depart_time, s.arrive_time, s.price, s.seats_available, "
                + "t.id AS train_id, t.code AS train_code, t.name AS train_name, t.train_class, t.seats_total, "
                + "o.id AS origin_id, o.code AS origin_code, o.name AS origin_name, o.city AS origin_city, "
                + "d.id AS dest_id, d.code AS dest_code, d.name AS dest_name, d.city AS dest_city "
                + "FROM schedules s "
                + "JOIN trains t ON s.train_id = t.id "
                + "JOIN stations o ON s.origin_id = o.id "
                + "JOIN stations d ON s.destination_id = d.id "
                + "ORDER BY s.depart_time DESC";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet r = ps.executeQuery()) {
                while (r.next()) {
                    list.add(mapRow(r));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean add(Schedule schedule) {
        String sql = "INSERT INTO schedules (train_id, origin_id, destination_id, depart_time, arrive_time, price, seats_available) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, schedule.getTrain().getId());
                ps.setInt(2, schedule.getOrigin().getId());
                ps.setInt(3, schedule.getDestination().getId());
                ps.setTimestamp(4, Timestamp.valueOf(schedule.getDepartTime()));
                ps.setTimestamp(5, Timestamp.valueOf(schedule.getArriveTime()));
                ps.setDouble(6, schedule.getPrice());
                ps.setInt(7, schedule.getSeatsAvailable());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Schedule schedule) {
        String sql = "UPDATE schedules SET train_id = ?, origin_id = ?, destination_id = ?, "
                + "depart_time = ?, arrive_time = ?, price = ?, seats_available = ? WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, schedule.getTrain().getId());
                ps.setInt(2, schedule.getOrigin().getId());
                ps.setInt(3, schedule.getDestination().getId());
                ps.setTimestamp(4, Timestamp.valueOf(schedule.getDepartTime()));
                ps.setTimestamp(5, Timestamp.valueOf(schedule.getArriveTime()));
                ps.setDouble(6, schedule.getPrice());
                ps.setInt(7, schedule.getSeatsAvailable());
                ps.setInt(8, schedule.getId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM schedules WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

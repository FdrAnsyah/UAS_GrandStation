package dao;

import model.Booking;
import model.Schedule;
import model.Station;
import model.Train;
import util.KoneksiDB;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BookingDAO {

    private static String genCode() {
        // contoh: BK-7F3A1C2D
        return "BK-" + UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
    }

    // Helper method to map ResultSet to Booking object
    private Booking mapRow(ResultSet r) throws SQLException {
        Booking b = new Booking();
        b.setId(r.getInt("booking_id"));
        b.setBookingCode(r.getString("booking_code"));
        b.setPassengerName(r.getString("passenger_name"));
        b.setPassengerPhone(r.getString("passenger_phone"));
        b.setSeats(r.getInt("seats"));
        b.setTotalPrice(r.getDouble("total_price"));

        Timestamp ts = r.getTimestamp("created_at");
        b.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);

        // Get status if available
        try {
            String status = r.getString("status");
            if (status != null) {
                b.setStatus(status);
            }
        } catch (SQLException ignored) {
            // Column might not exist in some queries
        }

        Schedule s = new Schedule();
        s.setId(r.getInt("schedule_id"));
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
        try {
            t.setSeatsTotal(r.getInt("seats_total"));
        } catch (SQLException ignored) {
            // seats_total might not be in all queries
        }
        s.setTrain(t);

        Station o = new Station();
        o.setId(r.getInt("origin_id"));
        o.setCode(r.getString("origin_code"));
        o.setName(r.getString("origin_name"));
        try {
            o.setCity(r.getString("origin_city"));
        } catch (SQLException ignored) {
            // city might not be in all queries
        }
        s.setOrigin(o);

        Station d = new Station();
        d.setId(r.getInt("dest_id"));
        d.setCode(r.getString("dest_code"));
        d.setName(r.getString("dest_name"));
        try {
            d.setCity(r.getString("dest_city"));
        } catch (SQLException ignored) {
            // city might not be in all queries
        }
        s.setDestination(d);

        b.setSchedule(s);
        return b;
    }

    public Booking createBooking(int scheduleId, int userId, String passengerName, String passengerPhone, int seats) {
        Connection c = null;
        try {
            c = KoneksiDB.getConnection();
            if (c == null) return null;
            c.setAutoCommit(false);

            // Lock schedule row
            String q = "SELECT price, seats_available FROM schedules WHERE id = ? FOR UPDATE";
            double price;
            int available;
            try (PreparedStatement ps = c.prepareStatement(q)) {
                ps.setInt(1, scheduleId);
                try (ResultSet r = ps.executeQuery()) {
                    if (!r.next()) {
                        c.rollback();
                        return null;
                    }
                    price = r.getDouble("price");
                    available = r.getInt("seats_available");
                }
            }

            if (seats <= 0 || seats > available) {
                c.rollback();
                return null;
            }

            String code = genCode();
            double total = price * seats;

            String ins = "INSERT INTO bookings(booking_code, schedule_id, user_id, passenger_name, passenger_phone, seats, total_price, status) "
                    + "VALUES (?,?,?,?,?,?,?,'pending') RETURNING id, created_at";

            int bookingId;
            LocalDateTime createdAt;
            try (PreparedStatement ps = c.prepareStatement(ins)) {
                ps.setString(1, code);
                ps.setInt(2, scheduleId);
                ps.setInt(3, userId);
                ps.setString(4, passengerName);
                ps.setString(5, passengerPhone);
                ps.setInt(6, seats);
                ps.setDouble(7, total);
                try (ResultSet r = ps.executeQuery()) {
                    r.next();
                    bookingId = r.getInt("id");
                    Timestamp ts = r.getTimestamp("created_at");
                    createdAt = (ts != null) ? ts.toLocalDateTime() : null;
                }
            }

            // Don't reduce seats yet - wait for approval
            // String upd = "UPDATE schedules SET seats_available = seats_available - ? WHERE id = ?";

            c.commit();

            Booking b = new Booking();
            b.setId(bookingId);
            b.setBookingCode(code);
            b.setPassengerName(passengerName);
            b.setPassengerPhone(passengerPhone);
            b.setSeats(seats);
            b.setTotalPrice(total);
            b.setCreatedAt(createdAt);
            return b;

        } catch (Exception e) {
            try {
                if (c != null) c.rollback();
            } catch (Exception ignore) {}
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (c != null) {
                    c.setAutoCommit(true);
                    c.close();
                }
            } catch (Exception ignore) {}
        }
    }

    public List<Booking> getAll() {
        List<Booking> list = new ArrayList<>();

        String sql = "SELECT "
                + "b.id AS booking_id, b.booking_code, b.passenger_name, b.passenger_phone, b.seats, b.total_price, b.created_at, b.status, "
                + "s.id AS schedule_id, s.depart_time, s.arrive_time, s.price, s.seats_available, "
                + "t.id AS train_id, t.code AS train_code, t.name AS train_name, t.train_class, t.seats_total, "
                + "o.id AS origin_id, o.code AS origin_code, o.name AS origin_name, o.city AS origin_city, "
                + "d.id AS dest_id, d.code AS dest_code, d.name AS dest_name, d.city AS dest_city "
                + "FROM bookings b "
                + "JOIN schedules s ON b.schedule_id = s.id "
                + "JOIN trains t ON s.train_id = t.id "
                + "JOIN stations o ON s.origin_id = o.id "
                + "JOIN stations d ON s.destination_id = d.id "
                + "ORDER BY b.created_at DESC";

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

    // Get bookings by user ID
    public List<Booking> getByUserId(int userId) {
        List<Booking> list = new ArrayList<>();

        String sql = "SELECT "
                + "b.id AS booking_id, b.booking_code, b.passenger_name, b.passenger_phone, b.seats, b.total_price, b.created_at, b.status, "
                + "s.id AS schedule_id, s.depart_time, s.arrive_time, s.price, s.seats_available, "
                + "t.id AS train_id, t.code AS train_code, t.name AS train_name, t.train_class, t.seats_total, "
                + "o.id AS origin_id, o.code AS origin_code, o.name AS origin_name, o.city AS origin_city, "
                + "d.id AS dest_id, d.code AS dest_code, d.name AS dest_name, d.city AS dest_city "
                + "FROM bookings b "
                + "JOIN schedules s ON b.schedule_id = s.id "
                + "JOIN trains t ON s.train_id = t.id "
                + "JOIN stations o ON s.origin_id = o.id "
                + "JOIN stations d ON s.destination_id = d.id "
                + "WHERE b.user_id = ? "
                + "ORDER BY b.created_at DESC";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet r = ps.executeQuery()) {
                    while (r.next()) {
                        Booking b = new Booking();
                        b.setId(r.getInt("booking_id"));
                        b.setBookingCode(r.getString("booking_code"));
                        b.setPassengerName(r.getString("passenger_name"));
                        b.setPassengerPhone(r.getString("passenger_phone"));
                        b.setSeats(r.getInt("seats"));
                        b.setTotalPrice(r.getDouble("total_price"));
                        b.setStatus(r.getString("status"));

                        Timestamp ts = r.getTimestamp("created_at");
                        b.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);

                        Schedule s = new Schedule();
                        s.setId(r.getInt("schedule_id"));
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

                        b.setSchedule(s);
                        list.add(b);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get pending bookings for admin approval
    public List<Booking> getPendingBookings() {
        List<Booking> list = new ArrayList<>();

        String sql = "SELECT "
                + "b.id AS booking_id, b.booking_code, b.passenger_name, b.passenger_phone, b.seats, b.total_price, b.created_at, b.status, b.user_id, "
                + "u.name AS user_name, u.email AS user_email, "
                + "s.id AS schedule_id, s.depart_time, s.arrive_time, s.price, s.seats_available, "
                + "t.id AS train_id, t.code AS train_code, t.name AS train_name, t.train_class, t.seats_total, "
                + "o.id AS origin_id, o.code AS origin_code, o.name AS origin_name, o.city AS origin_city, "
                + "d.id AS dest_id, d.code AS dest_code, d.name AS dest_name, d.city AS dest_city "
                + "FROM bookings b "
                + "LEFT JOIN users u ON b.user_id = u.id "
                + "JOIN schedules s ON b.schedule_id = s.id "
                + "JOIN trains t ON s.train_id = t.id "
                + "JOIN stations o ON s.origin_id = o.id "
                + "JOIN stations d ON s.destination_id = d.id "
                + "WHERE b.status = 'pending' "
                + "ORDER BY b.created_at DESC";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet r = ps.executeQuery()) {
                while (r.next()) {
                    Booking b = new Booking();
                    b.setId(r.getInt("booking_id"));
                    b.setBookingCode(r.getString("booking_code"));
                    b.setPassengerName(r.getString("passenger_name"));
                    b.setPassengerPhone(r.getString("passenger_phone"));
                    b.setSeats(r.getInt("seats"));
                    b.setTotalPrice(r.getDouble("total_price"));
                    b.setStatus(r.getString("status"));

                    Timestamp ts = r.getTimestamp("created_at");
                    b.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);

                    Schedule s = new Schedule();
                    s.setId(r.getInt("schedule_id"));
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

                    b.setSchedule(s);
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Approve booking - reduce seats and update status
    public boolean approveBooking(int bookingId, int adminId) {
        Connection c = null;
        try {
            c = KoneksiDB.getConnection();
            if (c == null) return false;
            c.setAutoCommit(false);

            // Get booking details
            String getBooking = "SELECT schedule_id, seats, status FROM bookings WHERE id = ? FOR UPDATE";
            int scheduleId;
            int seats;
            String currentStatus;

            try (PreparedStatement ps = c.prepareStatement(getBooking)) {
                ps.setInt(1, bookingId);
                try (ResultSet r = ps.executeQuery()) {
                    if (!r.next()) {
                        c.rollback();
                        return false;
                    }
                    scheduleId = r.getInt("schedule_id");
                    seats = r.getInt("seats");
                    currentStatus = r.getString("status");
                }
            }

            // Check if already approved
            if ("approved".equals(currentStatus)) {
                c.rollback();
                return false;
            }

            // Check seat availability
            String checkSeats = "SELECT seats_available FROM schedules WHERE id = ? FOR UPDATE";
            int available;
            try (PreparedStatement ps = c.prepareStatement(checkSeats)) {
                ps.setInt(1, scheduleId);
                try (ResultSet r = ps.executeQuery()) {
                    if (!r.next()) {
                        c.rollback();
                        return false;
                    }
                    available = r.getInt("seats_available");
                }
            }

            if (seats > available) {
                c.rollback();
                return false; // Not enough seats
            }

            // Update booking status
            String updateBooking = "UPDATE bookings SET status = 'approved', approved_at = NOW(), approved_by = ? WHERE id = ?";
            try (PreparedStatement ps = c.prepareStatement(updateBooking)) {
                ps.setInt(1, adminId);
                ps.setInt(2, bookingId);
                ps.executeUpdate();
            }

            // Reduce available seats
            String updateSeats = "UPDATE schedules SET seats_available = seats_available - ? WHERE id = ?";
            try (PreparedStatement ps = c.prepareStatement(updateSeats)) {
                ps.setInt(1, seats);
                ps.setInt(2, scheduleId);
                ps.executeUpdate();
            }

            c.commit();
            return true;

        } catch (Exception e) {
            try {
                if (c != null) c.rollback();
            } catch (Exception ignore) {}
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (c != null) {
                    c.setAutoCommit(true);
                    c.close();
                }
            } catch (Exception ignore) {}
        }
    }

    // Reject booking
    public boolean rejectBooking(int bookingId, int adminId) {
        String sql = "UPDATE bookings SET status = 'rejected', approved_at = NOW(), approved_by = ? WHERE id = ? AND status = 'pending'";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setInt(2, bookingId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get bookings by status
    public List<Booking> getByStatus(String status) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT "
                + "b.id AS booking_id, b.booking_code, b.passenger_name, b.passenger_phone, b.seats, b.total_price, b.created_at, b.status, "
                + "s.id AS schedule_id, s.depart_time, s.arrive_time, s.price, s.seats_available, "
                + "t.id AS train_id, t.code AS train_code, t.name AS train_name, t.train_class, t.seats_total, "
                + "o.id AS origin_id, o.code AS origin_code, o.name AS origin_name, o.city AS origin_city, "
                + "d.id AS dest_id, d.code AS dest_code, d.name AS dest_name, d.city AS dest_city "
                + "FROM bookings b "
                + "JOIN schedules s ON b.schedule_id = s.id "
                + "JOIN trains t ON s.train_id = t.id "
                + "JOIN stations o ON s.origin_id = o.id "
                + "JOIN stations d ON s.destination_id = d.id "
                + "WHERE b.status = ? "
                + "ORDER BY b.created_at DESC";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, status);
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

    // Get booking by ID
    public Booking getById(int id) {
        String sql = "SELECT "
                + "b.id AS booking_id, b.booking_code, b.passenger_name, b.passenger_phone, b.seats, b.total_price, b.created_at, b.status, "
                + "s.id AS schedule_id, s.depart_time, s.arrive_time, s.price, s.seats_available, "
                + "t.id AS train_id, t.code AS train_code, t.name AS train_name, t.train_class, t.seats_total, "
                + "o.id AS origin_id, o.code AS origin_code, o.name AS origin_name, o.city AS origin_city, "
                + "d.id AS dest_id, d.code AS dest_code, d.name AS dest_name, d.city AS dest_city "
                + "FROM bookings b "
                + "JOIN schedules s ON b.schedule_id = s.id "
                + "JOIN trains t ON s.train_id = t.id "
                + "JOIN stations o ON s.origin_id = o.id "
                + "JOIN stations d ON s.destination_id = d.id "
                + "WHERE b.id = ?";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, id);
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

    // Update booking
    public boolean update(Booking booking) {
        String sql = "UPDATE bookings SET booking_code=?, passenger_name=?, passenger_phone=?, seats=?, total_price=?, status=?, created_at=? WHERE id=?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, booking.getBookingCode());
            ps.setString(2, booking.getPassengerName());
            ps.setString(3, booking.getPassengerPhone());
            ps.setInt(4, booking.getSeats());
            ps.setDouble(5, booking.getTotalPrice());
            ps.setString(6, booking.getStatus());

            Timestamp timestamp = null;
            if (booking.getCreatedAt() != null) {
                timestamp = Timestamp.valueOf(booking.getCreatedAt());
            }
            ps.setTimestamp(7, timestamp);

            ps.setInt(8, booking.getId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

package dao;

import model.Train;
import util.KoneksiDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainDAO {

    public List<Train> getAll() {
        List<Train> list = new ArrayList<>();
        String sql = "SELECT id, code, name, train_class, seats_total FROM trains ORDER BY name";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet r = ps.executeQuery()) {
                while (r.next()) {
                    Train t = new Train();
                    t.setId(r.getInt("id"));
                    t.setCode(r.getString("code"));
                    t.setName(r.getString("name"));
                    t.setTrainClass(r.getString("train_class"));
                    t.setSeatsTotal(r.getInt("seats_total"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Train getById(int id) {
        String sql = "SELECT id, code, name, train_class, seats_total FROM trains WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet r = ps.executeQuery()) {
                    if (r.next()) {
                        Train t = new Train();
                        t.setId(r.getInt("id"));
                        t.setCode(r.getString("code"));
                        t.setName(r.getString("name"));
                        t.setTrainClass(r.getString("train_class"));
                        t.setSeatsTotal(r.getInt("seats_total"));
                        return t;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(Train train) {
        String sql = "INSERT INTO trains (code, name, train_class, seats_total) VALUES (?, ?, ?, ?)";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, train.getCode());
                ps.setString(2, train.getName());
                ps.setString(3, train.getTrainClass());
                ps.setInt(4, train.getSeatsTotal());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Train train) {
        String sql = "UPDATE trains SET code = ?, name = ?, train_class = ?, seats_total = ? WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, train.getCode());
                ps.setString(2, train.getName());
                ps.setString(3, train.getTrainClass());
                ps.setInt(4, train.getSeatsTotal());
                ps.setInt(5, train.getId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM trains WHERE id = ?";
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

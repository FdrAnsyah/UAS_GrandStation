package dao;

import model.Station;
import util.KoneksiDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StationDAO {

    public List<Station> getAll() {
        List<Station> list = new ArrayList<>();
        String sql = "SELECT id, code, name, city FROM stations ORDER BY city, name";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet r = ps.executeQuery()) {
                while (r.next()) {
                    Station s = new Station();
                    s.setId(r.getInt("id"));
                    s.setCode(r.getString("code"));
                    s.setName(r.getString("name"));
                    s.setCity(r.getString("city"));
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Station getById(int id) {
        String sql = "SELECT id, code, name, city FROM stations WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet r = ps.executeQuery()) {
                    if (r.next()) {
                        Station s = new Station();
                        s.setId(r.getInt("id"));
                        s.setCode(r.getString("code"));
                        s.setName(r.getString("name"));
                        s.setCity(r.getString("city"));
                        return s;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(Station station) {
        String sql = "INSERT INTO stations (code, name, city) VALUES (?, ?, ?)";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, station.getCode());
                ps.setString(2, station.getName());
                ps.setString(3, station.getCity());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Station station) {
        String sql = "UPDATE stations SET code = ?, name = ?, city = ? WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, station.getCode());
                ps.setString(2, station.getName());
                ps.setString(3, station.getCity());
                ps.setInt(4, station.getId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM stations WHERE id = ?";
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

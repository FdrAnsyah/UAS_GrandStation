package dao;

import model.Jenis;
import util.KoneksiDB;
import java.sql.*;
import java.util.*;

public class JenisDAO {

    public List<Jenis> getAll() {
        List<Jenis> list = new ArrayList<>();
        String sql = "SELECT * FROM jenis ORDER BY id DESC";

        try (Connection c = KoneksiDB.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {

            while (r.next()) {
                Jenis j = new Jenis();
                j.setId(r.getInt("id"));
                j.setNama(r.getString("nama"));
                list.add(j);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

package dao;

import util.KoneksiDB;
import java.sql.*;
import java.util.*;
import model.Jenis;
import model.Produk;

public class ProdukDAO {

    public List<Produk> getAll() {
        List<Produk> list = new ArrayList<>();
        String sql = "SELECT p.id, p.kode, p.nama, p.harga, p.stok, "
                + "j.id AS idjenis, j.nama AS namajenis "
                + "FROM produk p "
                + "LEFT JOIN jenis j ON p.idjenis = j.id "
                + "ORDER BY p.id DESC";

        try (Connection c = KoneksiDB.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            
            while (r.next()) {
                System.out.println("ROW DITEMUKAN");
                
                Produk p = new Produk();
                p.setId(r.getInt("id"));
                p.setKode(r.getString("kode"));
                p.setNama(r.getString("nama"));
                p.setHarga(r.getDouble("harga"));
                p.setStok(r.getInt("stok"));

                Jenis j = new Jenis();
                if (r.getObject("idjenis") != null) {
                    j.setId(r.getInt("idjenis"));
                    j.setNama(r.getString("namajenis"));
                    p.setJenis(j);
                } else {
                    p.setJenis(null);
                }

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

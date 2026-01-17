package dao;

import model.GalleryItem;
import util.KoneksiDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GalleryDAO {

    public List<GalleryItem> getAll() {
        List<GalleryItem> list = new ArrayList<>();
        String sql = "SELECT id, title, category, image_url, description, featured, created_at FROM gallery_items ORDER BY created_at DESC";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet r = ps.executeQuery()) {
                while (r.next()) {
                    GalleryItem g = new GalleryItem();
                    g.setId(r.getInt("id"));
                    g.setTitle(r.getString("title"));
                    g.setCategory(r.getString("category"));
                    g.setImageUrl(r.getString("image_url"));
                    g.setDescription(r.getString("description"));
                    g.setFeatured(r.getBoolean("featured"));
                    Timestamp ts = r.getTimestamp("created_at");
                    g.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
                    list.add(g);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<GalleryItem> getFeatured(int limit) {
        List<GalleryItem> list = new ArrayList<>();
        String sql = "SELECT id, title, category, image_url, description, featured, created_at FROM gallery_items WHERE featured = true ORDER BY created_at DESC LIMIT ?";

        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return list;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, limit);
                try (ResultSet r = ps.executeQuery()) {
                    while (r.next()) {
                        GalleryItem g = new GalleryItem();
                        g.setId(r.getInt("id"));
                        g.setTitle(r.getString("title"));
                        g.setCategory(r.getString("category"));
                        g.setImageUrl(r.getString("image_url"));
                        g.setDescription(r.getString("description"));
                        g.setFeatured(r.getBoolean("featured"));
                        Timestamp ts = r.getTimestamp("created_at");
                        g.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
                        list.add(g);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public GalleryItem getById(int id) {
        String sql = "SELECT id, title, category, image_url, description, featured, created_at FROM gallery_items WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return null;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet r = ps.executeQuery()) {
                    if (r.next()) {
                        GalleryItem g = new GalleryItem();
                        g.setId(r.getInt("id"));
                        g.setTitle(r.getString("title"));
                        g.setCategory(r.getString("category"));
                        g.setImageUrl(r.getString("image_url"));
                        g.setDescription(r.getString("description"));
                        g.setFeatured(r.getBoolean("featured"));
                        Timestamp ts = r.getTimestamp("created_at");
                        g.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
                        return g;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(GalleryItem item) {
        String sql = "INSERT INTO gallery_items (title, category, image_url, description, featured) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, item.getTitle());
                ps.setString(2, item.getCategory());
                ps.setString(3, item.getImageUrl());
                ps.setString(4, item.getDescription());
                ps.setBoolean(5, item.isFeatured());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(GalleryItem item) {
        String sql = "UPDATE gallery_items SET title = ?, category = ?, image_url = ?, description = ?, featured = ? WHERE id = ?";
        try (Connection c = KoneksiDB.getConnection()) {
            if (c == null) return false;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, item.getTitle());
                ps.setString(2, item.getCategory());
                ps.setString(3, item.getImageUrl());
                ps.setString(4, item.getDescription());
                ps.setBoolean(5, item.isFeatured());
                ps.setInt(6, item.getId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM gallery_items WHERE id = ?";
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
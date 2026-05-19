package com.greenguard.dao;

import com.greenguard.model.Violation;
import com.greenguard.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ViolationDAO {

    /* ---- Create ---- */
    public int create(Violation v) throws SQLException {
        String sql = "INSERT INTO violations (reporter_id, type, title, description, location_name, latitude, longitude, photo_url, severity, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'SUBMITTED')";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, v.getReporterId());
            ps.setString(2, v.getType());
            ps.setString(3, v.getTitle());
            ps.setString(4, v.getDescription());
            ps.setString(5, v.getLocationName());
            ps.setDouble(6, v.getLatitude());
            ps.setDouble(7, v.getLongitude());
            ps.setString(8, v.getPhotoUrl());
            ps.setString(9, v.getSeverity());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    /* ---- Find by ID ---- */
    public Violation findById(int id) throws SQLException {
        String sql = "SELECT v.*, u.full_name AS reporter_name FROM violations v " +
                     "JOIN users u ON u.id = v.reporter_id WHERE v.id = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    /* ---- Find by reporter ---- */
    public List<Violation> findByReporter(int reporterId) throws SQLException {
        List<Violation> list = new ArrayList<>();
        String sql = "SELECT v.*, u.full_name AS reporter_name FROM violations v " +
                     "JOIN users u ON u.id = v.reporter_id WHERE v.reporter_id = ? ORDER BY v.created_at DESC";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, reporterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /* ---- Find all with optional filters ---- */
    public List<Violation> findAll(String type, String status, String severity, int page, int size) throws SQLException {
        List<Violation> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder(
                "SELECT v.*, u.full_name AS reporter_name FROM violations v " +
                "JOIN users u ON u.id = v.reporter_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (type != null && !type.isEmpty()) { sb.append(" AND v.type = ?"); params.add(type); }
        if (status != null && !status.isEmpty()) { sb.append(" AND v.status = ?"); params.add(status); }
        if (severity != null && !severity.isEmpty()) { sb.append(" AND v.severity = ?"); params.add(severity); }
        sb.append(" ORDER BY v.created_at DESC LIMIT ? OFFSET ?");
        params.add(size);
        params.add((page - 1) * size);

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /* ---- Count all ---- */
    public int countAll(String type, String status, String severity) throws SQLException {
        StringBuilder sb = new StringBuilder("SELECT COUNT(*) FROM violations WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (type != null && !type.isEmpty()) { sb.append(" AND type = ?"); params.add(type); }
        if (status != null && !status.isEmpty()) { sb.append(" AND status = ?"); params.add(status); }
        if (severity != null && !severity.isEmpty()) { sb.append(" AND severity = ?"); params.add(severity); }
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /* ---- Update status ---- */
    public boolean updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE violations SET status = ? WHERE id = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    /* ---- Hotspot detection ---- */
    public void flagHotspots(double radiusKm, int threshold) throws SQLException {
        // Flag areas with >= threshold reports within radiusKm as hotspots
        String sql = "UPDATE violations v SET v.is_hotspot = 1 WHERE " +
                     "(SELECT COUNT(*) FROM violations v2 WHERE " +
                     "ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(v2.longitude, v2.latitude)) <= ?) >= ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDouble(1, radiusKm * 1000);
            ps.setInt(2, threshold);
            ps.executeUpdate();
        }
    }

    /* ---- Stats by type ---- */
    public Map<String, Integer> countByType() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT type, COUNT(*) AS cnt FROM violations GROUP BY type";
        try (Connection c = DBUtil.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) stats.put(rs.getString("type"), rs.getInt("cnt"));
        }
        return stats;
    }

    /* ---- Stats by status ---- */
    public Map<String, Integer> countByStatus() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM violations GROUP BY status";
        try (Connection c = DBUtil.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) stats.put(rs.getString("status"), rs.getInt("cnt"));
        }
        return stats;
    }

    /* ---- Hotspots ---- */
    public List<Violation> findHotspots() throws SQLException {
        List<Violation> list = new ArrayList<>();
        String sql = "SELECT v.*, u.full_name AS reporter_name FROM violations v " +
                     "JOIN users u ON u.id = v.reporter_id WHERE v.is_hotspot = 1 ORDER BY v.created_at DESC";
        try (Connection c = DBUtil.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    /* ---- Recent (for dashboard) ---- */
    public List<Violation> findRecent(int limit) throws SQLException {
        List<Violation> list = new ArrayList<>();
        String sql = "SELECT v.*, u.full_name AS reporter_name FROM violations v " +
                     "JOIN users u ON u.id = v.reporter_id ORDER BY v.created_at DESC LIMIT ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /* ---- Mapping ---- */
    private Violation map(ResultSet rs) throws SQLException {
        Violation v = new Violation();
        v.setId(rs.getInt("id"));
        v.setReporterId(rs.getInt("reporter_id"));
        v.setReporterName(rs.getString("reporter_name"));
        v.setType(rs.getString("type"));
        v.setTitle(rs.getString("title"));
        v.setDescription(rs.getString("description"));
        v.setLocationName(rs.getString("location_name"));
        v.setLatitude(rs.getDouble("latitude"));
        v.setLongitude(rs.getDouble("longitude"));
        v.setPhotoUrl(rs.getString("photo_url"));
        v.setSeverity(rs.getString("severity"));
        v.setStatus(rs.getString("status"));
        v.setHotspot(rs.getInt("is_hotspot") == 1);
        v.setCreatedAt(rs.getTimestamp("created_at"));
        v.setUpdatedAt(rs.getTimestamp("updated_at"));
        return v;
    }

    /* ---- Find nearby violations ---- */
    public List<Violation> findNearbyViolations(double latitude,
                                                double longitude,
                                                double radiusKm) throws SQLException {

        List<Violation> list = new ArrayList<>();

        String sql =
                "SELECT v.*, u.full_name AS reporter_name, " +
                        "ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(?, ?)) / 1000 AS distance_km " +
                        "FROM violations v " +
                        "JOIN users u ON u.id = v.reporter_id " +
                        "WHERE ST_Distance_Sphere(POINT(v.longitude, v.latitude), POINT(?, ?)) <= ? " +
                        "ORDER BY distance_km ASC";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            // For SELECT distance calculation
            ps.setDouble(1, longitude);
            ps.setDouble(2, latitude);

            // For WHERE filtering
            ps.setDouble(3, longitude);
            ps.setDouble(4, latitude);

            // Radius in meters
            ps.setDouble(5, radiusKm * 1000);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }

        return list;
    }
}

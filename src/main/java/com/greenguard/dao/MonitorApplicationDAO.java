package com.greenguard.dao;

import com.greenguard.model.MonitorApplication;
import com.greenguard.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MonitorApplicationDAO {

    public boolean apply(MonitorApplication app) throws SQLException {
        String sql = "INSERT INTO monitor_applications (user_id, motivation, experience) VALUES (?, ?, ?)";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, app.getUserId());
            ps.setString(2, app.getMotivation());
            ps.setString(3, app.getExperience());
            return ps.executeUpdate() > 0;
        }
    }

    public MonitorApplication findByUser(int userId) throws SQLException {
        String sql = "SELECT ma.*, u.full_name AS user_name, u.email AS user_email FROM monitor_applications ma " +
                     "JOIN users u ON u.id = ma.user_id WHERE ma.user_id = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<MonitorApplication> findPending() throws SQLException {
        List<MonitorApplication> list = new ArrayList<>();
        String sql = "SELECT ma.*, u.full_name AS user_name, u.email AS user_email FROM monitor_applications ma " +
                     "JOIN users u ON u.id = ma.user_id WHERE ma.status = 'PENDING' ORDER BY ma.applied_at ASC";
        try (Connection c = DBUtil.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public List<MonitorApplication> findAll() throws SQLException {
        List<MonitorApplication> list = new ArrayList<>();
        String sql = "SELECT ma.*, u.full_name AS user_name, u.email AS user_email FROM monitor_applications ma " +
                     "JOIN users u ON u.id = ma.user_id ORDER BY ma.applied_at DESC";
        try (Connection c = DBUtil.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public boolean review(int appId, String status, int reviewedBy, String notes) throws SQLException {
        String sql = "UPDATE monitor_applications SET status = ?, reviewed_by = ?, review_notes = ?, reviewed_at = NOW() WHERE id = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewedBy);
            ps.setString(3, notes);
            ps.setInt(4, appId);
            boolean ok = ps.executeUpdate() > 0;
            // If approved, add to certified_monitors
            if (ok && "APPROVED".equals(status)) {
                MonitorApplication app = findById(appId);
                if (app != null) certify(app.getUserId(), c);
            }
            return ok;
        }
    }

    private void certify(int userId, Connection c) throws SQLException {
        String sql = "INSERT INTO certified_monitors (user_id, tier, report_count) " +
                     "VALUES (?, 'BRONZE', 0) ON DUPLICATE KEY UPDATE tier = tier";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    private MonitorApplication findById(int id) throws SQLException {
        String sql = "SELECT ma.*, u.full_name AS user_name, u.email AS user_email FROM monitor_applications ma " +
                     "JOIN users u ON u.id = ma.user_id WHERE ma.id = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    private MonitorApplication map(ResultSet rs) throws SQLException {
        MonitorApplication a = new MonitorApplication();
        a.setId(rs.getInt("id"));
        a.setUserId(rs.getInt("user_id"));
        a.setUserName(rs.getString("user_name"));
        a.setUserEmail(rs.getString("user_email"));
        a.setMotivation(rs.getString("motivation"));
        a.setExperience(rs.getString("experience"));
        a.setStatus(rs.getString("status"));
        try { a.setReviewedBy(rs.getInt("reviewed_by")); } catch (Exception ignored) {}
        a.setReviewNotes(rs.getString("review_notes"));
        a.setAppliedAt(rs.getTimestamp("applied_at"));
        a.setReviewedAt(rs.getTimestamp("reviewed_at"));
        return a;
    }
}

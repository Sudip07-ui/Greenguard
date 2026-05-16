package com.greenguard.dao;

import com.greenguard.model.User;
import com.greenguard.util.DBUtil;
import com.greenguard.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /* ---- Authentication ---- */
    public User authenticate(String email, String password) throws SQLException {

        String sql = "SELECT u.*, cm.tier FROM users u " +
                "LEFT JOIN certified_monitors cm ON cm.user_id = u.id " +
                "WHERE u.email = ? AND u.status = 'ACTIVE'";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    String hash = rs.getString("password_hash");

                    if (PasswordUtil.verify(password, hash)) {
                        return map(rs);
                    }
                }
            }
        }

        return null;
    }

    /* ---- Register ---- */
    public boolean register(User user) throws SQLException {

        String sql = "INSERT INTO users " +
                "(full_name, email, phone, password_hash, role, status) " +
                "VALUES (?, ?, ?, ?, 'CITIZEN', 'PENDING')";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());

            // plain-text passed via setPasswordHash
            ps.setString(4, PasswordUtil.hash(user.getPasswordHash()));

            return ps.executeUpdate() > 0;
        }
    }

    /* ---- Create User By Admin ---- */
    public boolean createByAdmin(User user) throws SQLException {

        String sql = "INSERT INTO users " +
                "(full_name, email, phone, password_hash, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());

            // plain-text passed via setPasswordHash
            ps.setString(4, PasswordUtil.hash(user.getPasswordHash()));

            ps.setString(5, user.getRole());

            // ACTIVE / SUSPENDED / PENDING
            ps.setString(6, user.getStatus());

            return ps.executeUpdate() > 0;
        }
    }

    /* ---- Find by ID ---- */
    public User findById(int id) throws SQLException {

        String sql = "SELECT u.*, cm.tier FROM users u " +
                "LEFT JOIN certified_monitors cm ON cm.user_id = u.id " +
                "WHERE u.id = ?";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return map(rs);
                }
            }
        }

        return null;
    }

    /* ---- Find by Email ---- */
    public User findByEmail(String email) throws SQLException {

        String sql = "SELECT u.*, cm.tier FROM users u " +
                "LEFT JOIN certified_monitors cm ON cm.user_id = u.id " +
                "WHERE u.email = ?";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return map(rs);
                }
            }
        }

        return null;
    }

    /* ---- All users (admin) ---- */
    public List<User> findAll() throws SQLException {

        List<User> list = new ArrayList<>();

        String sql = "SELECT u.*, cm.tier FROM users u " +
                "LEFT JOIN certified_monitors cm ON cm.user_id = u.id " +
                "ORDER BY u.created_at DESC";

        try (Connection c = DBUtil.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                list.add(map(rs));
            }
        }

        return list;
    }

    /* ---- Pending registrations ---- */
    public List<User> findPending() throws SQLException {

        List<User> list = new ArrayList<>();

        String sql = "SELECT u.*, cm.tier FROM users u " +
                "LEFT JOIN certified_monitors cm ON cm.user_id = u.id " +
                "WHERE u.status = 'PENDING' " +
                "ORDER BY u.created_at ASC";

        try (Connection c = DBUtil.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                list.add(map(rs));
            }
        }

        return list;
    }

    /* ---- Update Status ---- */
    public boolean updateStatus(int userId, String status)
            throws SQLException {

        String sql = "UPDATE users SET status = ? WHERE id = ?";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        }
    }

    /* ---- Update Role ---- */
    public boolean updateRole(int userId, String role)
            throws SQLException {

        String sql = "UPDATE users SET role = ? WHERE id = ?";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, role);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        }
    }

    /* ---- Count By Role ---- */
    public int countByRole(String role) throws SQLException {

        String sql = "SELECT COUNT(*) FROM users " +
                "WHERE role = ? AND status = 'ACTIVE'";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, role);

            try (ResultSet rs = ps.executeQuery()) {

                return rs.next()
                        ? rs.getInt(1)
                        : 0;
            }
        }
    }

    /* ---- Mapping ---- */
    private User map(ResultSet rs) throws SQLException {

        User u = new User();

        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));

        u.setPasswordHash(rs.getString("password_hash"));

        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));

        u.setAvatarUrl(rs.getString("avatar_url"));

        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));

        try {

            String tier = rs.getString("tier");

            u.setCertifiedMonitor(tier != null);
            u.setMonitorTier(tier);

        } catch (SQLException ignored) {
        }

        return u;
        ed;
    }
}
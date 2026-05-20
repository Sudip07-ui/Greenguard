package com.greenguard.dao;

import com.greenguard.model.CaseTimeline;
import com.greenguard.model.EnforcementCase;
import com.greenguard.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnforcementCaseDAO {

    /* ---- Assign case ---- */
    public int assign(int violationId, int authorityId) throws SQLException {
        String sql = "INSERT INTO enforcement_cases (violation_id, authority_id, status) VALUES (?, ?, 'ASSIGNED')";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, violationId);
            ps.setInt(2, authorityId);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    /* ---- Find by authority ---- */
    public List<EnforcementCase> findByAuthority(int authorityId) throws SQLException {
        List<EnforcementCase> list = new ArrayList<>();
        String sql = "SELECT ec.*, u.full_name AS authority_name FROM enforcement_cases ec " +
                     "JOIN users u ON u.id = ec.authority_id WHERE ec.authority_id = ? ORDER BY ec.assigned_at DESC";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, authorityId);
            try (ResultSet rs = ps.executeQuery()) {
                ViolationDAO vDao = new ViolationDAO();
                while (rs.next()) {
                    EnforcementCase ec = map(rs);
                    ec.setViolation(vDao.findById(ec.getViolationId()));
                    list.add(ec);
                }
            }
        }
        return list;
    }

    /* ---- Find by ID with timeline ---- */
    public EnforcementCase findById(int id) throws SQLException {
        String sql = "SELECT ec.*, u.full_name AS authority_name FROM enforcement_cases ec " +
                     "JOIN users u ON u.id = ec.authority_id WHERE ec.id = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    EnforcementCase ec = map(rs);
                    ec.setViolation(new ViolationDAO().findById(ec.getViolationId()));
                    ec.setTimeline(getTimeline(id));
                    return ec;
                }
            }
        }
        return null;
    }

    /* ---- Find by violation ---- */
    public EnforcementCase findByViolation(int violationId) throws SQLException {
        String sql = "SELECT ec.*, u.full_name AS authority_name FROM enforcement_cases ec " +
                     "JOIN users u ON u.id = ec.authority_id WHERE ec.violation_id = ? ORDER BY ec.assigned_at DESC LIMIT 1";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, violationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    EnforcementCase ec = map(rs);
                    ec.setTimeline(getTimeline(ec.getId()));
                    return ec;
                }
            }
        }
        return null;
    }

    /* ---- Update case ---- */
    public boolean update(EnforcementCase ec) throws SQLException {
        String sql = "UPDATE enforcement_cases SET status = ?, notes = ?, action_taken = ?, " +
                     "resolved_at = ? WHERE id = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, ec.getStatus());
            ps.setString(2, ec.getNotes());
            ps.setString(3, ec.getActionTaken());
            ps.setTimestamp(4, "RESOLVED".equals(ec.getStatus()) ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setInt(5, ec.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /* ---- Add timeline entry ---- */
    public void addTimeline(int caseId, int actorId, String action, String details) throws SQLException {
        String sql = "INSERT INTO case_timeline (case_id, actor_id, action, details) VALUES (?, ?, ?, ?)";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, caseId);
            ps.setInt(2, actorId);
            ps.setString(3, action);
            ps.setString(4, details);
            ps.executeUpdate();
        }
    }

    /* ---- Get timeline ---- */
    public List<CaseTimeline> getTimeline(int caseId) throws SQLException {
        List<CaseTimeline> list = new ArrayList<>();
        String sql = "SELECT ct.*, u.full_name AS actor_name FROM case_timeline ct " +
                     "JOIN users u ON u.id = ct.actor_id WHERE ct.case_id = ? ORDER BY ct.created_at ASC";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, caseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CaseTimeline t = new CaseTimeline();
                    t.setId(rs.getInt("id"));
                    t.setCaseId(rs.getInt("case_id"));
                    t.setActorId(rs.getInt("actor_id"));
                    t.setActorName(rs.getString("actor_name"));
                    t.setAction(rs.getString("action"));
                    t.setDetails(rs.getString("details"));
                    t.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(t);
                }
            }
        }
        return list;
    }

    /* ---- Stats for authority ---- */
    public int countByAuthorityAndStatus(int authorityId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM enforcement_cases WHERE authority_id = ? AND status = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, authorityId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /* ---- All cases (admin) ---- */
    public List<EnforcementCase> findAll() throws SQLException {
        List<EnforcementCase> list = new ArrayList<>();
        String sql = "SELECT ec.*, u.full_name AS authority_name FROM enforcement_cases ec " +
                     "JOIN users u ON u.id = ec.authority_id ORDER BY ec.assigned_at DESC";
        try (Connection c = DBUtil.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            ViolationDAO vDao = new ViolationDAO();
            while (rs.next()) {
                EnforcementCase ec = map(rs);
                ec.setViolation(vDao.findById(ec.getViolationId()));
                list.add(ec);
            }
        }
        return list;
    }

    private EnforcementCase map(ResultSet rs) throws SQLException {
        EnforcementCase ec = new EnforcementCase();
        ec.setId(rs.getInt("id"));
        ec.setViolationId(rs.getInt("violation_id"));
        ec.setAuthorityId(rs.getInt("authority_id"));
        ec.setAuthorityName(rs.getString("authority_name"));
        ec.setStatus(rs.getString("status"));
        ec.setNotes(rs.getString("notes"));
        ec.setActionTaken(rs.getString("action_taken"));
        ec.setAssignedAt(rs.getTimestamp("assigned_at"));
        ec.setResolvedAt(rs.getTimestamp("resolved_at"));
        return ec;
    }
}

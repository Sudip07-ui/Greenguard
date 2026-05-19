package com.greenguard.dao;

import com.greenguard.model.WatchlistArea;
import com.greenguard.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WatchlistDAO {

    public boolean add(WatchlistArea area) throws SQLException {

        String sql = "INSERT INTO watchlist_areas " +
                "(user_id, area_name, latitude, longitude, radius_km) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, area.getUserId());
            ps.setString(2, area.getAreaName());
            ps.setDouble(3, area.getLatitude());
            ps.setDouble(4, area.getLongitude());
            ps.setDouble(5, area.getRadiusKm());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean remove(int id, int userId) throws SQLException {

        String sql = "DELETE FROM watchlist_areas " +
                "WHERE id = ? AND user_id = ?";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        }
    }

    public List<WatchlistArea> findByUser(int userId) throws SQLException {

        List<WatchlistArea> list = new ArrayList<>();

        String sql = "SELECT * FROM watchlist_areas " +
                "WHERE user_id = ? " +
                "ORDER BY created_at DESC";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }

        return list;
    }

    public boolean exists(int userId, String areaName)
            throws SQLException {

        String sql = "SELECT 1 FROM watchlist_areas " +
                "WHERE user_id = ? " +
                "AND LOWER(area_name) = LOWER(?) " +
                "LIMIT 1";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, areaName);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<WatchlistArea> findMatchingAreas(
            double lat,
            double lng
    ) throws SQLException {

        List<WatchlistArea> list = new ArrayList<>();

        String sql =
                "SELECT * FROM watchlist_areas " +
                        "WHERE ST_Distance_Sphere(" +
                        "POINT(longitude, latitude), " +
                        "POINT(?, ?)" +
                        ") <= radius_km * 1000";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setDouble(1, lng);
            ps.setDouble(2, lat);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }

        return list;
    }

    private WatchlistArea map(ResultSet rs)
            throws SQLException {

        WatchlistArea w = new WatchlistArea();

        w.setId(rs.getInt("id"));
        w.setUserId(rs.getInt("user_id"));
        w.setAreaName(rs.getString("area_name"));
        w.setLatitude(rs.getDouble("latitude"));
        w.setLongitude(rs.getDouble("longitude"));
        w.setRadiusKm(rs.getDouble("radius_km"));
        w.setCreatedAt(rs.getTimestamp("created_at"));

        return w;
    }
}
package com.greenguard.model;

import java.sql.Timestamp;

public class WatchlistArea {
    private int id;
    private int userId;
    private String areaName;
    private double latitude;
    private double longitude;
    private double radiusKm;
    private Timestamp createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getAreaName() { return areaName; }
    public void setAreaName(String areaName) { this.areaName = areaName; }
    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
    public double getRadiusKm() { return radiusKm; }
    public void setRadiusKm(double radiusKm) { this.radiusKm = radiusKm; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
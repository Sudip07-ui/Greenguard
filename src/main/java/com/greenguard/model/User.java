package com.greenguard.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String fullName;
    private String email;
    private String phone;
    private String passwordHash;
    private String role;        // CITIZEN | AUTHORITY | ADMIN
    private String status;      // PENDING | ACTIVE | SUSPENDED
    private String avatarUrl;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // For display: is this user a certified monitor?
    private boolean certifiedMonitor;
    private String monitorTier;

    public User() {}

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isCertifiedMonitor() { return certifiedMonitor; }
    public void setCertifiedMonitor(boolean certifiedMonitor) { this.certifiedMonitor = certifiedMonitor; }

    public String getMonitorTier() { return monitorTier; }
    public void setMonitorTier(String monitorTier) { this.monitorTier = monitorTier; }
}

package com.greenguard.model;

import java.sql.Timestamp;
import java.util.List;

public class EnforcementCase {
    private int id;
    private int violationId;
    private int authorityId;
    private String authorityName;
    private String status;
    private String notes;
    private String actionTaken;
    private Timestamp assignedAt;
    private Timestamp resolvedAt;
    private Violation violation;
    private List<CaseTimeline> timeline;

    public EnforcementCase() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getViolationId() { return violationId; }
    public void setViolationId(int violationId) { this.violationId = violationId; }

    public int getAuthorityId() { return authorityId; }
    public void setAuthorityId(int authorityId) { this.authorityId = authorityId; }

    public String getAuthorityName() { return authorityName; }
    public void setAuthorityName(String authorityName) { this.authorityName = authorityName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getActionTaken() { return actionTaken; }
    public void setActionTaken(String actionTaken) { this.actionTaken = actionTaken; }

    public Timestamp getAssignedAt() { return assignedAt; }
    public void setAssignedAt(Timestamp assignedAt) { this.assignedAt = assignedAt; }

    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }

    public Violation getViolation() { return violation; }
    public void setViolation(Violation violation) { this.violation = violation; }

    public List<CaseTimeline> getTimeline() { return timeline; }
    public void setTimeline(List<CaseTimeline> timeline) { this.timeline = timeline; }
}

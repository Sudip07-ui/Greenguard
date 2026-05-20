<%@ page contentType="text/html;charset=UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    EnforcementCase ec = (EnforcementCase) request.getAttribute("enforcementCase");
    Violation v = ec != null ? ec.getViolation() : null;
    request.setAttribute("pageTitle", "Case #" + (ec != null ? ec.getId() : ""));
%>
<%@ include file="../common/header.jsp" %>

<% if (ec == null || v == null) { %>
<div class="alert alert-error">Case not found.</div>
<% } else { %>

<div style="display:grid;grid-template-columns:1fr 360px;gap:24px;align-items:start;">

  <!-- Left: Violation Details + Update Form -->
  <div>

    <!-- Violation Info -->
    <div class="card mb-24">
      <div class="card-header">
        <h3><i class="fa-solid fa-file-lines" style="color: rgb(38, 36, 23);"></i> Violation Details</h3>
        <span class="badge badge-<%= v.getStatus().toLowerCase().replace("_","-") %>">
          <%= v.getStatus().replace("_"," ") %>
        </span>
      </div>
      <div class="card-body">
        <h2 style="font-size:1.2rem;margin-bottom:12px;"><%= v.getTitle() %></h2>
        <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:16px;">
          <span class="badge" style="background:#f0faf2;color:var(--green-700);">
            <%= v.getType().replace("_"," ") %>
          </span>
          <span class="badge badge-<%= v.getSeverity().toLowerCase() %>"><%= v.getSeverity() %></span>
          <% if (v.isHotspot()) { %><span class="badge badge-hotspot">🔥 Hotspot</span><% } %>
        </div>
        <p style="font-size:.875rem;color:var(--text-mid);margin-bottom:16px;"><%= v.getDescription() %></p>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;font-size:.82rem;color:var(--text-mute);">
          <div><i class="fa-solid fa-map-pin" style="color: rgb(38, 36, 23);"></i> <strong>Location:</strong> <%= v.getLocationName() %></div>
          <div><i class="fa-solid fa-user" style="color: rgb(38, 36, 23);"></i> <strong>Reporter:</strong> <%= v.getReporterName() %></div>
          <div><i class="fa-solid fa-clock" style="color: rgb(38, 36, 23);"></i> <strong>Reported:</strong> <%= v.getCreatedAt() %></div>
          <div><i class="fa-solid fa-spinner" style="color: rgb(38, 36, 23);"></i> <strong>Updated:</strong> <%= v.getUpdatedAt() %></div>
        </div>
        <% if (v.getPhotoUrl() != null && !v.getPhotoUrl().isBlank()) { %>
        <img src="${pageContext.request.contextPath}<%= v.getPhotoUrl() %>"
             alt="Violation photo"
             style="width:100%;max-height:280px;object-fit:cover;border-radius:var(--radius-md);margin-top:16px;"/>
        <% } %>
      </div>
    </div>

    <!-- Update Form -->
    <div class="card">
      <div class="card-header"><h3><i class="fa-solid fa-pencil" style="color: rgb(38, 36, 23);"></i> Update Case Status</h3></div>
      <div class="card-body">
        <form method="POST" action="${pageContext.request.contextPath}/authority/cases/update">
          <input type="hidden" name="caseId" value="<%= ec.getId() %>"/>

          <div class="form-row">
            <div class="form-group">
              <label class="form-label" for="status">Case Status <span class="required">*</span></label>
              <select id="status" name="status" class="form-control" required>
                <option value="ASSIGNED"     <%= "ASSIGNED".equals(ec.getStatus())     ? "selected" : "" %>><i class="fa-regular fa-pen-to-square" style="color: rgb(38, 36, 23);"></i> Assigned</option>
                <option value="INVESTIGATING"<%= "INVESTIGATING".equals(ec.getStatus()) ? "selected" : "" %>><i class="fa-solid fa-magnifying-glass" style="color: rgb(38, 36, 23);"></i> Investigating</option>
                <option value="ACTION_TAKEN" <%= "ACTION_TAKEN".equals(ec.getStatus())  ? "selected" : "" %>><i class="fa-solid fa-bolt" style="color: rgb(38, 36, 23);"></i> Action Taken</option>
                <option value="RESOLVED"     <%= "RESOLVED".equals(ec.getStatus())     ? "selected" : "" %>><i class="fa-regular fa-circle-check" style="color: rgb(34, 191, 37);"></i> Resolved</option>
                <option value="ESCALATED"    <%= "ESCALATED".equals(ec.getStatus())    ? "selected" : "" %>><i class="fa-solid fa-eject"></i> Escalated</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="actionTaken">Action Taken</label>
            <input type="text" id="actionTaken" name="actionTaken" class="form-control"
                   placeholder="e.g. Issued warning notice to factory owner"
                   value="<%= ec.getActionTaken() != null ? ec.getActionTaken() : "" %>"/>
          </div>

          <div class="form-group">
            <label class="form-label" for="notes">Investigation Notes</label>
            <textarea id="notes" name="notes" class="form-control" rows="4"
                      placeholder="Additional notes about your investigation or findings…"><%= ec.getNotes() != null ? ec.getNotes() : "" %></textarea>
          </div>

          <div style="display:flex;gap:12px;">
            <button type="submit" class="btn btn-primary"><i class="fa-solid fa-arrow-rotate-right"></i> Save Update</button>
            <a href="${pageContext.request.contextPath}/authority/cases" class="btn btn-secondary">← Back to Cases</a>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Right: Timeline -->
  <div class="card" style="position:sticky;top:80px;">
    <div class="card-header"><h3><i class="fa-solid fa-calendar-days"></i> Case Timeline</h3></div>
    <div class="card-body">
      <% List<CaseTimeline> timeline = ec.getTimeline();
         if (timeline == null || timeline.isEmpty()) { %>
      <p class="text-mute text-center" style="font-size:.875rem;padding:20px 0;">
        No timeline entries yet. Update the case to add entries.
      </p>
      <% } else { %>
      <div class="timeline">
        <% for (CaseTimeline t : timeline) { %>
        <div class="timeline-item">
          <div class="timeline-dot"></div>
          <div class="timeline-date"><%= t.getCreatedAt() %></div>
          <div class="timeline-action"><%= t.getAction() %></div>
          <div style="font-size:.75rem;color:var(--text-mute);">by <%= t.getActorName() %></div>
          <% if (t.getDetails() != null && !t.getDetails().isBlank()) { %>
          <div class="timeline-details"><%= t.getDetails() %></div>
          <% } %>
        </div>
        <% } %>
      </div>
      <% } %>
    </div>
  </div>
</div>

<% } %>
<%@ include file="../common/footer.jsp" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("pageTitle", "Admin Dashboard"); %>
<%@ include file="../common/header.jsp" %>

<%
    int totalCitizens    = request.getAttribute("totalCitizens")    != null ? (Integer)request.getAttribute("totalCitizens")    : 0;
    int totalAuthorities = request.getAttribute("totalAuthorities") != null ? (Integer)request.getAttribute("totalAuthorities") : 0;
    List<User>      pendingUsers    = (List<User>)      request.getAttribute("pendingUsers");
    List<Violation> recentViolations= (List<Violation>) request.getAttribute("recentViolations");
    List<Violation> hotspots        = (List<Violation>) request.getAttribute("hotspots");
    List<MonitorApplication> pendingMonitors = (List<MonitorApplication>) request.getAttribute("pendingMonitors");
    Map<String,Integer> byType   = (Map<String,Integer>) request.getAttribute("statsByType");
    Map<String,Integer> byStatus = (Map<String,Integer>) request.getAttribute("statsByStatus");

    int totalViolations = byStatus != null ? byStatus.values().stream().mapToInt(Integer::intValue).sum() : 0;
    int resolved = byStatus != null && byStatus.get("RESOLVED") != null ? byStatus.get("RESOLVED") : 0;
%>

<!-- Stats -->
<div class="stats-grid mb-24">
  <div class="stat-card">
    <div class="stat-icon green"><i class="fa-solid fa-user" style="color: rgb(0, 0, 0);"></i></div>
    <div><div class="stat-value"><%= totalCitizens %></div><div class="stat-label">Active Citizens</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon blue"><i class="fa-solid fa-scale-balanced" style="color: rgb(255, 212, 59);"></i></div>
    <div><div class="stat-value"><%= totalAuthorities %></div><div class="stat-label">Authorities</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon amber"><i class="fa-solid fa-triangle-exclamation" style="color: rgb(222, 208, 17);"></i></div>
    <div><div class="stat-value"><%= totalViolations %></div><div class="stat-label">Total Reports</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon green"><i class="fa-solid fa-hourglass-half" style="color: rgb(35, 31, 21);"></i></div>
    <div><div class="stat-value"><%= resolved %></div><div class="stat-label">Resolved</div></div>
  </div>
</div>

<!-- Quick Action Panels -->
<div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;margin-bottom:24px;">

  <!-- Pending User Approvals -->
  <div class="card">
    <div class="card-header">
      <h3> Pending Approvals</h3>
      <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary btn-sm">All Users</a>
    </div>
    <div class="card-body" style="padding:0;">
      <% if (pendingUsers == null || pendingUsers.isEmpty()) { %>
      <div style="padding:24px;text-align:center;color:var(--text-mute);font-size:.875rem;">
        No pending approvals
      </div>
      <% } else {
         for (User u : pendingUsers) { %>
      <div style="padding:12px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;gap:8px;">
        <div>
          <div style="font-weight:600;font-size:.875rem;"><%= u.getFullName() %></div>
          <div style="font-size:.75rem;color:var(--text-mute);"><%= u.getEmail() %></div>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/admin/users" style="display:flex;gap:6px;">
          <input type="hidden" name="userId" value="<%= u.getId() %>"/>
          <button name="action" value="approve" class="btn btn-primary btn-xs"> Approve</button>
          <button name="action" value="suspend" class="btn btn-danger btn-xs"> Reject</button>
        </form>
      </div>
      <% } } %>
    </div>
  </div>

  <!-- Pending Monitor Applications -->
  <div class="card">
    <div class="card-header">
      <h3> Monitor Applications</h3>
      <a href="${pageContext.request.contextPath}/admin/monitors" class="btn btn-secondary btn-sm">View All</a>
    </div>
    <div class="card-body" style="padding:0;">
      <% if (pendingMonitors == null || pendingMonitors.isEmpty()) { %>
      <div style="padding:24px;text-align:center;color:var(--text-mute);font-size:.875rem;">
         No pending applications
      </div>
      <% } else {
         for (MonitorApplication app : pendingMonitors) { %>
      <div style="padding:12px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;gap:8px;">
        <div>
          <div style="font-weight:600;font-size:.875rem;"><%= app.getUserName() %></div>
          <div style="font-size:.75rem;color:var(--text-mute);">
            <%= app.getMotivation().length() > 60 ? app.getMotivation().substring(0,60) + "…" : app.getMotivation() %>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/monitors" class="btn btn-amber btn-xs">Review</a>
      </div>
      <% } } %>
    </div>
  </div>
</div>

<!-- Violations by Type + Recent Violations -->
<div style="display:grid;grid-template-columns:300px 1fr;gap:24px;margin-bottom:24px;">

  <!-- Stats by Type -->
  <div class="card">
    <div class="card-header"><h3> Reports by Type</h3></div>
    <div class="card-body">
      <% if (byType != null) {
         for (Map.Entry<String,Integer> e : byType.entrySet()) { %>
      <div style="display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid var(--border);font-size:.85rem;">
        <span style="color:var(--text-mid);"><%= e.getKey().replace("_"," ") %></span>
        <span style="font-weight:700;color:var(--green-700);"><%= e.getValue() %></span>
      </div>
      <% } } %>
    </div>
  </div>

  <!-- Recent Violations -->
  <div class="card">
    <div class="card-header">
      <h3> Recent Violations</h3>
      <a href="${pageContext.request.contextPath}/admin/violations" class="btn btn-secondary btn-sm">Manage All</a>
    </div>
    <div class="card-body" style="padding:0;">
      <div class="table-wrapper">
        <table>
          <thead>
            <tr><th>#</th><th>Title</th><th>Type</th><th>Severity</th><th>Status</th><th>Reporter</th><th>Date</th></tr>
          </thead>
          <tbody>
            <% if (recentViolations != null) {
               for (Violation v : recentViolations) { %>
            <tr data-href="${pageContext.request.contextPath}/admin/violations">
              <td>#<%= v.getId() %></td>
              <td style="max-width:180px;" class="truncate"><%= v.getTitle() %></td>
              <td><%= v.getType().replace("_"," ") %></td>
              <td><span class="badge badge-<%= v.getSeverity().toLowerCase() %>"><%= v.getSeverity() %></span></td>
              <td><span class="badge badge-<%= v.getStatus().toLowerCase().replace("_","-") %>"><%= v.getStatus().replace("_"," ") %></span></td>
              <td><%= v.getReporterName() %></td>
              <td style="font-size:.75rem;"><%= v.getCreatedAt() %></td>
            </tr>
            <% } } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</div>

<!-- Hotspots -->
<% if (hotspots != null && !hotspots.isEmpty()) { %>
<div class="card">
  <div class="card-header">
    <h3> Violation Hotspots</h3>
    <span class="badge badge-hotspot"><%= hotspots.size() %> areas</span>
  </div>
  <div class="card-body" style="padding:0;">
    <div style="display:flex;flex-wrap:wrap;gap:12px;padding:16px;">
      <% for (Violation h : hotspots) { %>
      <div style="background:var(--red-light);border:1px solid #fecdd3;border-radius:var(--radius-md);padding:12px 16px;min-width:180px;">
        <div style="font-weight:600;font-size:.875rem;color:#991b1b;margin-bottom:4px;"> <%= h.getLocationName() %></div>
        <div style="font-size:.75rem;color:var(--text-mute);"><%= h.getType().replace("_"," ") %></div>
      </div>
      <% } %>
    </div>
  </div>
</div>
<% } %>

<%@ include file="../common/footer.jsp" %>

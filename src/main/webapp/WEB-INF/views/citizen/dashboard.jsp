<%@ page contentType="text/html;charset=UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<% request.setAttribute("pageTitle", "My Dashboard"); %>
<%@ include file="../common/header.jsp" %>

<%
    List<Violation> myReports = (List<Violation>) request.getAttribute("myReports");
    List<Violation> recentAll = (List<Violation>) request.getAttribute("recentAll");
    Map<String,Integer> byStatus = (Map<String,Integer>) request.getAttribute("statsByStatus");

    int submitted   = byStatus != null && byStatus.get("SUBMITTED")    != null ? byStatus.get("SUBMITTED")    : 0;
    int inProgress  = byStatus != null && byStatus.get("IN_PROGRESS")  != null ? byStatus.get("IN_PROGRESS")  : 0;
    int resolved    = byStatus != null && byStatus.get("RESOLVED")     != null ? byStatus.get("RESOLVED")     : 0;
    int myTotal     = myReports != null ? myReports.size() : 0;
%>

<!-- Stats -->
<div class="stats-grid">
  <div class="stat-card">
    <div class="stat-icon green"><i class="fa-regular fa-file-lines"></i></div>
    <div>
      <div class="stat-value"><%= myTotal %></div>
      <div class="stat-label">My Reports</div>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-icon amber"><i class="fa-solid fa-magnifying-glass"></i></div>
    <div>
      <div class="stat-value"><%= submitted %></div>
      <div class="stat-label">Awaiting Review</div>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-icon blue"><i class="fa-solid fa-bars-progress"></i></div>
    <div>
      <div class="stat-value"><%= inProgress %></div>
      <div class="stat-label">In Progress</div>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-icon green"><i class="fa-solid fa-circle-check"></i></div>
    <div>
      <div class="stat-value"><%= resolved %></div>
      <div class="stat-label">Resolved</div>
    </div>
  </div>
</div>

<!-- Quick Actions -->
<div class="d-flex gap-12 mb-24">
  <a href="${pageContext.request.contextPath}/citizen/report"       class="btn btn-primary"><i class="fa-regular fa-file-lines"></i> Report Violation</a>
  <a href="${pageContext.request.contextPath}/citizen/monitor-apply" class="btn btn-amber"><i class="fa-solid fa-display"></i> Apply: Green Monitor</a>
</div>

<div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">

  <!-- My Recent Reports -->
  <div class="card">
    <div class="card-header">
      <h3> My Recent Reports</h3>
      <a href="${pageContext.request.contextPath}/citizen/my-reports" class="btn btn-secondary btn-sm">View All</a>
    </div>
    <div class="card-body" style="padding:0;">
      <% if (myReports == null || myReports.isEmpty()) { %>
      <div class="empty-state">
        <div class="empty-icon"><i class="fa-regular fa-file-lines"></i></div>
        <h3>No reports yet</h3>
        <p>Start by reporting a violation in your area.</p>
      </div>
      <% } else {
         List<Violation> recent5 = myReports.subList(0, Math.min(5, myReports.size()));
         for (Violation v : recent5) { %>
      <div style="padding:14px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;">
        <div>
          <div style="font-weight:600;font-size:.9rem;"><%= v.getTitle() %></div>
          <div style="font-size:.78rem;color:var(--text-mute);margin-top:2px;"><%= v.getType().replace("_"," ") %> • <%= v.getLocationName() %></div>
        </div>
        <span class="badge badge-<%= v.getStatus().toLowerCase() %>"><%= v.getStatus().replace("_"," ") %></span>
      </div>
      <% } } %>
    </div>
  </div>

  <!-- Recent Community Reports -->
  <div class="card">
    <div class="card-header">
      <h3> Community Reports</h3>
    </div>
    <div class="card-body" style="padding:0;">
      <% if (recentAll == null || recentAll.isEmpty()) { %>
      <div class="empty-state">
        <div class="empty-icon"><i class="fa-solid fa-leaf" style="color: rgb(0, 137, 18);"></i></div>
        <h3>No reports yet</h3>
        <p>Be the first to report a violation.</p>
      </div>
      <% } else {
         for (Violation v : recentAll) { %>
      <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:4px;">
          <div style="font-weight:600;font-size:.9rem;"><%= v.getTitle() %></div>
          <% if (v.isHotspot()) { %><span class="badge badge-hotspot"><i class="fa-solid fa-fire" style="color: rgb(228, 133, 18);"></i> Hotspot</span><% } %>
        </div>
        <div style="font-size:.78rem;color:var(--text-mute);">
          📍 <%= v.getLocationName() %> •
          Reported by <%= v.getReporterName() %>
        </div>
        <div style="margin-top:6px;display:flex;gap:6px;">
          <span class="badge badge-<%= v.getType().toLowerCase() %>" style="background:#f0faf2;color:var(--green-700);">
            <%= v.getType().replace("_"," ") %>
          </span>
          <span class="badge badge-<%= v.getSeverity().toLowerCase() %>"><%= v.getSeverity() %></span>
          <span class="badge badge-<%= v.getStatus().toLowerCase() %>"><%= v.getStatus().replace("_"," ") %></span>
        </div>
      </div>
      <% } } %>
    </div>
  </div>

</div>

<%@ include file="../common/footer.jsp" %>

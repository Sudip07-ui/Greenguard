<%@ page contentType="text/html;charset=UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<% request.setAttribute("pageTitle", "My Reports"); %>
<%@ include file="../common/header.jsp" %>

<div class="d-flex justify-between align-center mb-24">
  <p class="text-mute">Track the status of all your submitted violation reports.</p>
  <a href="${pageContext.request.contextPath}/citizen/report" class="btn btn-primary">+ New Report</a>
</div>

<%
    List<Violation> reports = (List<Violation>) request.getAttribute("reports");
    Map<Integer, EnforcementCase> caseMap = (Map<Integer, EnforcementCase>) request.getAttribute("caseMap");
%>

<% if (reports == null || reports.isEmpty()) { %>
<div class="card">
  <div class="card-body">
    <div class="empty-state">
      <div class="empty-icon"><i class="fa-regular fa-file" style="color: rgb(0, 0, 0);"></i></div>
      <h3>No reports submitted yet</h3>
      <p>When you report a violation, it will appear here with live status updates.</p>
      <a href="${pageContext.request.contextPath}/citizen/report" class="btn btn-primary mt-16">Submit Your First Report</a>
    </div>
  </div>
</div>
<% } else { %>

<div style="display:flex;flex-direction:column;gap:16px;">
<% for (Violation v : reports) {
   EnforcementCase ec = caseMap != null ? caseMap.get(v.getId()) : null;
%>
<div class="card">
  <div class="card-body">
    <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:16px;flex-wrap:wrap;">
      <div style="flex:1;">
        <div style="display:flex;align-items:center;gap:10px;margin-bottom:8px;flex-wrap:wrap;">
          <h3 style="font-size:1rem;"><%= v.getTitle() %></h3>
          <% if (v.isHotspot()) { %><span class="badge badge-hotspot"><i class="fa-solid fa-fire" style="color: rgb(228, 133, 18);"></i> Hotspot</span><% } %>
        </div>
        <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px;">
          <span class="badge" style="background:#f0faf2;color:var(--green-700);">
            <%= v.getType().replace("_"," ") %>
          </span>
          <span class="badge badge-<%= v.getSeverity().toLowerCase() %>">
            <%= v.getSeverity() %>
          </span>
          <span class="badge badge-<%= v.getStatus().toLowerCase().replace("_","-") %>">
            <%= v.getStatus().replace("_"," ") %>
          </span>
        </div>
        <p style="font-size:.875rem;color:var(--text-mid);margin-bottom:10px;">
          <%= v.getDescription().length() > 150 ? v.getDescription().substring(0, 150) + "…" : v.getDescription() %>
        </p>
        <div style="font-size:.78rem;color:var(--text-mute);display:flex;gap:16px;flex-wrap:wrap;">
          <span><i class="fa-solid fa-map-pin" style="color: rgb(179, 19, 19);"></i> <%= v.getLocationName() %></span>
          <span><i class="fa-solid fa-clock" style="color: rgb(35, 1, 1);"></i> <%= v.getCreatedAt() %></span>
          <span>#<%= v.getId() %></span>
        </div>

        <% if (ec != null) { %>
        <div style="margin-top:14px;padding:12px;background:var(--green-50);border-radius:var(--radius-sm);border:1px solid var(--green-200);">
          <div style="font-size:.8rem;font-weight:700;color:var(--green-700);margin-bottom:6px;">
            <i class="fa-solid fa-scale-balanced" style="color: rgb(35, 1, 1);"></i> Enforcement Update
          </div>
          <div style="font-size:.82rem;color:var(--text-mid);">
            Officer: <strong><%= ec.getAuthorityName() %></strong> •
            Status: <span class="badge badge-<%= ec.getStatus().toLowerCase() %>"><%= ec.getStatus().replace("_"," ") %></span>
          </div>
          <% if (ec.getActionTaken() != null && !ec.getActionTaken().isBlank()) { %>
          <div style="font-size:.82rem;margin-top:6px;color:var(--text-mid);">
            Action taken: <%= ec.getActionTaken() %>
          </div>
          <% } %>
          <% if (ec.getTimeline() != null && !ec.getTimeline().isEmpty()) { %>
          <div class="timeline" style="margin-top:12px;">
            <% for (CaseTimeline t : ec.getTimeline()) { %>
            <div class="timeline-item">
              <div class="timeline-dot"></div>
              <div class="timeline-date"><%= t.getCreatedAt() %></div>
              <div class="timeline-action"><%= t.getAction() %></div>
              <% if (t.getDetails() != null && !t.getDetails().isBlank()) { %>
              <div class="timeline-details"><%= t.getDetails() %></div>
              <% } %>
            </div>
            <% } %>
          </div>
          <% } %>
        </div>
        <% } %>
      </div>
      <% if (v.getPhotoUrl() != null && !v.getPhotoUrl().isBlank()) { %>
      <img src="${pageContext.request.contextPath}<%= v.getPhotoUrl() %>"
           alt="Violation photo"
           style="width:140px;height:100px;object-fit:cover;border-radius:var(--radius-md);flex-shrink:0;"/>
      <% } %>
    </div>
  </div>
</div>
<% } %>
</div>
<% } %>

<%@ include file="../common/footer.jsp" %>

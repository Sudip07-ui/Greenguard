<%@ page contentType="text/html;charset=UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("pageTitle", "Green Monitor Applications"); %>
<%@ include file="../common/header.jsp" %>

<%
  List<MonitorApplication> applications = (List<MonitorApplication>) request.getAttribute("applications");
  String ctx2 = request.getContextPath();
%>

<div class="card">
  <div class="card-header">
    <h3><i class="fa-solid fa-display"></i> Monitor Applications (<%= applications != null ? applications.size() : 0 %>)</h3>
  </div>
  <div class="card-body" style="padding:0;">
    <% if (applications == null || applications.isEmpty()) { %>
    <div class="empty-state">
      <div class="empty-icon"><i class="fa-solid fa-circle-exclamation"></i></div>
      <h3>No applications yet</h3>
      <p>Green Monitor applications will appear here for review.</p>
    </div>
    <% } else {
      for (MonitorApplication app : applications) { %>
    <div style="padding:20px;border-bottom:1px solid var(--border);">
      <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:16px;flex-wrap:wrap;">
        <div style="flex:1;">
          <div style="display:flex;align-items:center;gap:10px;margin-bottom:8px;">
            <div style="font-weight:700;font-size:1rem;"><%= app.getUserName() %></div>
            <span class="badge badge-<%= app.getStatus().toLowerCase() %>"><%= app.getStatus() %></span>
          </div>
          <div style="font-size:.8rem;color:var(--text-mute);margin-bottom:12px;">
            <i class="fa-regular fa-envelope" style="color: rgb(255, 212, 59);"></i> <%= app.getUserEmail() %> • Applied: <%= app.getAppliedAt() %>
          </div>
          <div style="background:var(--bg);border-radius:var(--radius-sm);padding:12px;margin-bottom:12px;">
            <div style="font-size:.72rem;font-weight:700;color:var(--text-mute);margin-bottom:6px;letter-spacing:.05em;">MOTIVATION</div>
            <p style="font-size:.875rem;"><%= app.getMotivation() %></p>
          </div>
          <% if (app.getExperience() != null && !app.getExperience().isBlank()) { %>
          <div style="background:var(--bg);border-radius:var(--radius-sm);padding:12px;margin-bottom:12px;">
            <div style="font-size:.72rem;font-weight:700;color:var(--text-mute);margin-bottom:6px;letter-spacing:.05em;">EXPERIENCE</div>
            <p style="font-size:.875rem;"><%= app.getExperience() %></p>
          </div>
          <% } %>
          <% if (app.getReviewNotes() != null && !app.getReviewNotes().isBlank()) { %>
          <div class="alert alert-info" style="font-size:.82rem;">
            <strong>Review Notes:</strong> <%= app.getReviewNotes() %>
          </div>
          <% } %>
        </div>

        <% if ("PENDING".equals(app.getStatus())) { %>
        <div class="card" style="min-width:280px;box-shadow:none;">
          <div class="card-body">
            <form method="POST" action="<%= ctx2 %>/admin/monitors">
              <input type="hidden" name="appId"  value="<%= app.getId() %>"/>
              <input type="hidden" name="userId" value="<%= app.getUserId() %>"/>
              <div class="form-group">
                <label class="form-label" for="reviewNotes-<%= app.getId() %>">Review Notes</label>
                <textarea id="reviewNotes-<%= app.getId() %>" name="reviewNotes"
                          class="form-control" rows="3"
                          placeholder="Optional feedback for the applicant…"></textarea>
              </div>
              <div style="display:flex;gap:8px;">
                <button name="status" value="APPROVED"
                        class="btn btn-primary btn-sm"> Approve</button>
                <button name="status" value="REJECTED"
                        class="btn btn-danger btn-sm"> Reject</button>
              </div>
            </form>
          </div>
        </div>
        <% } %>
      </div>
    </div>
    <% } } %>
  </div>
</div>

<%@ include file="../common/footer.jsp" %>

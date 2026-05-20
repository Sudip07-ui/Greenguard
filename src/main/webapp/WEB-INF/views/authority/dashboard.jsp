<%@ page contentType="text/html;charset=UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("pageTitle", "Authority Dashboard"); %>
<%@ include file="../common/header.jsp" %>

<%
    List<EnforcementCase> cases  = (List<EnforcementCase>) request.getAttribute("cases");
    int totalAssigned = request.getAttribute("totalAssigned") != null ? (Integer)request.getAttribute("totalAssigned") : 0;
    int totalInvestig = request.getAttribute("totalInvestig") != null ? (Integer)request.getAttribute("totalInvestig") : 0;
    int totalResolved = request.getAttribute("totalResolved") != null ? (Integer)request.getAttribute("totalResolved") : 0;
    int totalCases    = cases != null ? cases.size() : 0;
%>

<!-- Stats -->
<div class="stats-grid mb-24">
  <div class="stat-card">
    <div class="stat-icon blue"><i class="fa-solid fa-file"></i></div>
    <div><div class="stat-value"><%= totalCases %></div><div class="stat-label">Total Cases</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon amber"><i class="fa-solid fa-file-circle-question"></i></div>
    <div><div class="stat-value"><%= totalAssigned %></div><div class="stat-label">Awaiting Action</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon blue"><i class="fa-solid fa-magnifying-glass"></i></div>
    <div><div class="stat-value"><%= totalInvestig %></div><div class="stat-label">Investigating</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon green"><i class="fa-solid fa-circle-check"></i></div>
    <div><div class="stat-value"><%= totalResolved %></div><div class="stat-label">Resolved</div></div>
  </div>
</div>

<!-- Cases List -->
<div class="card">
  <div class="card-header">
    <h3>⚖️ Assigned Cases</h3>
    <a href="${pageContext.request.contextPath}/authority/cases" class="btn btn-secondary btn-sm">Full View</a>
  </div>
  <div class="card-body" style="padding:0;">
    <% if (cases == null || cases.isEmpty()) { %>
    <div class="empty-state">
      <div class="empty-icon"><i class="fa-solid fa-file-circle-minus"></i></div>
      <h3>No cases assigned yet</h3>
      <p>Cases assigned by the admin will appear here.</p>
    </div>
    <% } else { %>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Case #</th>
            <th>Violation</th>
            <th>Type</th>
            <th>Severity</th>
            <th>Location</th>
            <th>Status</th>
            <th>Assigned</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <% for (EnforcementCase ec : cases) {
             Violation v = ec.getViolation();
          %>
          <tr>
            <td>#<%= ec.getId() %></td>
            <td>
              <div style="font-weight:600;font-size:.875rem;"><%= v != null ? v.getTitle() : "N/A" %></div>
            </td>
            <td><%= v != null ? v.getType().replace("_"," ") : "" %></td>
            <td>
              <% if (v != null) { %>
              <span class="badge badge-<%= v.getSeverity().toLowerCase() %>"><%= v.getSeverity() %></span>
              <% } %>
            </td>
            <td class="truncate" style="max-width:130px;"><%= v != null ? v.getLocationName() : "" %></td>
            <td>
              <span class="badge badge-<%= ec.getStatus().toLowerCase() %>">
                <%= ec.getStatus().replace("_"," ") %>
              </span>
            </td>
            <td style="font-size:.78rem;"><%= ec.getAssignedAt() %></td>
            <td>
              <a href="${pageContext.request.contextPath}/authority/cases?id=<%= ec.getId() %>"
                 class="btn btn-secondary btn-xs">Update</a>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
    <% } %>
  </div>
</div>

<%@ include file="../common/footer.jsp" %>

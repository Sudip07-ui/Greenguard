<%@ page contentType="text/html;charset=UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("pageTitle", "Case Management"); %>
<%@ include file="../common/header.jsp" %>

<%
    List<EnforcementCase> cases = (List<EnforcementCase>) request.getAttribute("cases");
    String ctx2 = request.getContextPath();
%>

<% if ("updated".equals(request.getParameter("success"))) { %>
<div class="alert alert-success" data-autodismiss><i class="fa-solid fa-circle-check"></i> Case updated successfully.</div>
<% } %>

<div class="card">
  <div class="card-header">
    <h3>⚖️ My Assigned Cases</h3>
    <span class="text-mute" style="font-size:.85rem;"><%= cases != null ? cases.size() : 0 %> total</span>
  </div>
  <div class="card-body" style="padding:0;">
    <% if (cases == null || cases.isEmpty()) { %>
    <div class="empty-state">
      <div class="empty-icon"><i class="fa-solid fa-file-circle-minus"></i></div>
      <h3>No cases assigned</h3>
      <p>The admin will assign violation cases to you.</p>
    </div>
    <% } else { %>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Case #</th><th>Violation Title</th><th>Type</th><th>Severity</th>
            <th>Location</th><th>Case Status</th><th>Assigned</th><th></th>
          </tr>
        </thead>
        <tbody>
          <% for (EnforcementCase ec : cases) {
             Violation v = ec.getViolation();
          %>
          <tr>
            <td>#<%= ec.getId() %></td>
            <td style="max-width:200px;" class="truncate"><%= v != null ? v.getTitle() : "N/A" %></td>
            <td><%= v != null ? v.getType().replace("_"," ") : "" %></td>
            <td>
              <% if (v != null) { %>
              <span class="badge badge-<%= v.getSeverity().toLowerCase() %>"><%= v.getSeverity() %></span>
              <% } %>
            </td>
            <td style="max-width:120px;" class="truncate"><%= v != null ? v.getLocationName() : "" %></td>
            <td>
              <span class="badge badge-<%= ec.getStatus().toLowerCase() %>">
                <%= ec.getStatus().replace("_"," ") %>
              </span>
            </td>
            <td style="font-size:.78rem;"><%= ec.getAssignedAt() %></td>
            <td>
              <a href="<%= ctx2 %>/authority/cases?id=<%= ec.getId() %>"
                 class="btn btn-primary btn-xs">View / Update</a>
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

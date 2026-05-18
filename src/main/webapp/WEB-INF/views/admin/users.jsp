<%@ page contentType="text/html;charset=UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  request.setAttribute("pageTitle", "User Management");

  List<User> users = (List<User>) request.getAttribute("users");

  String ctx2 = request.getContextPath();
%>

<%@ include file="../common/header.jsp" %>

<div class="card">

  <div class="card-header"
       style="display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;">

    <h3>
      All Users
      (<%= users != null ? users.size() : 0 %>)
    </h3>

    <!-- Search -->
    <input type="text"
           id="userSearch"
           placeholder="Search users..."
           class="form-control"
           style="max-width:320px;">
  </div>

  <div class="card-body" style="padding:0;">

    <!-- ========================= -->
    <!-- ADD USER FORM -->
    <!-- ========================= -->

    <div style="padding:20px;border-bottom:1px solid var(--border-color);">

      <h3 style="margin-bottom:16px;">
        Add User
      </h3>

      <form method="POST"
            action="<%= ctx2 %>/admin/users"
            style="display:grid;
                         grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
                         gap:14px;">

        <input type="hidden"
               name="action"
               value="addUser"/>

        <!-- Full Name -->
        <div>
          <label>Full Name</label>

          <input type="text"
                 name="fullName"
                 class="form-control"
                 required>
        </div>

        <!-- Email -->
        <div>
          <label>Email</label>

          <input type="email"
                 name="email"
                 class="form-control"
                 required>
        </div>

        <!-- Phone -->
        <div>
          <label>Phone</label>

          <input type="text"
                 name="phone"
                 class="form-control">
        </div>

        <!-- Password -->
        <div>
          <label>Password</label>

          <input type="password"
                 name="password"
                 class="form-control"
                 required>
        </div>

        <!-- Role -->
        <div>
          <label>Role</label>

          <select name="role"
                  class="form-control"
                  required>

            <option value="CITIZEN">
              Citizen
            </option>

            <option value="AUTHORITY">
              Authority
            </option>

            <option value="ADMIN">
              Admin
            </option>

          </select>
        </div>

        <!-- Submit -->
        <div style="display:flex;align-items:end;">

          <button type="submit"
                  class="btn btn-primary">

            <i class="fa-solid fa-user-plus"
               style="color: rgb(38, 36, 23);"></i>

            Add User
          </button>
        </div>

      </form>
    </div>

    <!-- ========================= -->
    <!-- USERS TABLE -->
    <!-- ========================= -->

    <div class="table-wrapper">

      <table>

        <thead>

        <tr>
          <th>#</th>
          <th>Name</th>
          <th>Email</th>
          <th>Phone</th>
          <th>Role</th>
          <th>Status</th>
          <th>Monitor</th>
          <th>Joined</th>
          <th>Actions</th>
        </tr>

        </thead>

        <tbody id="usersTableBody">

        <% if (users != null) {
          for (User u : users) { %>

        <tr>

          <!-- ID -->
          <td>
            #<%= u.getId() %>
          </td>

          <!-- Name -->
          <td style="font-weight:600;">
            <%= u.getFullName() %>
          </td>

          <!-- Email -->
          <td style="font-size:.82rem;">
            <%= u.getEmail() %>
          </td>

          <!-- Phone -->
          <td style="font-size:.82rem;">

            <%= u.getPhone() != null
                    ? u.getPhone()
                    : "—" %>

          </td>

          <!-- Role -->
          <td>

                        <span class="badge badge-<%= u.getRole().toLowerCase() %>">

                            <%= u.getRole() %>

                        </span>

          </td>

          <!-- Status -->
          <td>

                        <span class="badge badge-<%= u.getStatus().toLowerCase() %>">

                            <%= u.getStatus() %>

                        </span>

          </td>

          <!-- Monitor -->
          <td>

            <% if (u.isCertifiedMonitor()) { %>

            <span class="badge badge-monitor">

                            <i class="fa-solid fa-medal"
                               style="color: rgb(38, 36, 23);"></i>

                            <%= u.getMonitorTier() %>

                        </span>

            <% } else { %>

            <span style="color:var(--text-mute);font-size:.78rem;">
                            —
                        </span>

            <% } %>

          </td>

          <!-- Joined -->
          <td style="font-size:.75rem;">
            <%= u.getCreatedAt() %>
          </td>

          <!-- Actions -->
          <td>

            <form method="POST"
                  action="<%= ctx2 %>/admin/users"
                  style="display:flex;gap:4px;flex-wrap:wrap;">

              <input type="hidden"
                     name="userId"
                     value="<%= u.getId() %>"/>

              <% if ("PENDING".equals(u.getStatus())) { %>

              <!-- Approve -->
              <button name="action"
                      value="approve"
                      class="btn btn-primary btn-xs">

                <i class="fa-solid fa-circle-check"
                   style="color: rgb(38, 36, 23);"></i>

                Approve
              </button>

              <!-- Reject -->
              <button name="action"
                      value="suspend"
                      class="btn btn-danger btn-xs">

                <i class="fa-solid fa-circle-xmark"
                   style="color: rgb(38, 36, 23);"></i>

                Reject
              </button>

              <% } else if ("ACTIVE".equals(u.getStatus())) { %>

              <!-- Suspend -->
              <button name="action"
                      value="suspend"
                      class="btn btn-danger btn-xs">

                ⏸ Suspend
              </button>

              <% } else if ("SUSPENDED".equals(u.getStatus())) { %>

              <!-- Activate -->
              <button name="action"
                      value="activate"
                      class="btn btn-primary btn-xs">

                <i class="fa-solid fa-play"
                   style="color: rgb(38, 36, 23);"></i>

                Activate
              </button>

              <% } %>

            </form>

          </td>

        </tr>

        <% } } %>

        </tbody>

      </table>

    </div>
  </div>
</div>

<!-- ========================= -->
<!-- SEARCH SCRIPT -->
<!-- ========================= -->

<script>

  document.getElementById("userSearch")
          .addEventListener("keyup", function () {

            let value = this.value.toLowerCase();

            let rows = document.querySelectorAll("#usersTableBody tr");

            rows.forEach(function (row) {

              let text = row.innerText.toLowerCase();

              row.style.display = text.includes(value)
                      ? ""
                      : "none";
            });
          });

</script>

<%@ include file="../common/footer.jsp" %>
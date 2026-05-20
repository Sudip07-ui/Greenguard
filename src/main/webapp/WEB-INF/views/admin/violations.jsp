<%@ page contentType="text/html;charset=UTF-8" import="com.greenguard.model.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  request.setAttribute("pageTitle", "Violation Management");

  List<Violation> violations =
          (List<Violation>) request.getAttribute("violations");

  List<User> authorities =
          (List<User>) request.getAttribute("authorities");

  int total = request.getAttribute("total") != null
          ? (Integer) request.getAttribute("total")
          : 0;

  int currentPage = request.getAttribute("page") != null
          ? (Integer) request.getAttribute("page")
          : 1;

  int totalPages = request.getAttribute("totalPages") != null
          ? (Integer) request.getAttribute("totalPages")
          : 1;

  String ctx2 = request.getContextPath();

  String filterType =
          (String) request.getAttribute("filterType");

  String filterStatus =
          (String) request.getAttribute("filterStatus");

  String filterSeverity =
          (String) request.getAttribute("filterSeverity");
%>

<%@ include file="../common/header.jsp" %>

<!-- ================= TOM SELECT ================= -->

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/css/tom-select.css">

<script src="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/js/tom-select.complete.min.js"></script>

<style>

  /* ================= PAGE ================= */

  .table-wrapper table{
    border-collapse:separate;
    border-spacing:0 10px;
  }

  .table-wrapper tbody tr{
    background:#fff;
    transition:.2s ease;
  }

  .table-wrapper tbody tr:hover{
    box-shadow:0 4px 14px rgba(0,0,0,.06);
  }

  .table-wrapper td{
    vertical-align:top;
  }

  .badge{
    padding:6px 10px;
    border-radius:999px;
    font-size:.72rem;
    font-weight:700;
  }

  .view-link{
    color:#0d6efd;
    text-decoration:none;
    cursor:pointer;
    font-weight:700;
  }

  .view-link:hover{
    text-decoration:underline;
  }

  /* ================= ACTION PANEL ================= */

  .action-panel{
    display:flex;
    flex-direction:column;
    gap:10px;
    min-width:260px;
  }

  .action-card{
    background:#f8fafc;
    border:1px solid #e5e7eb;
    border-radius:12px;
    padding:10px;
    transition:.2s ease;
  }

  .action-card:hover{
    border-color:#cbd5e1;
    box-shadow:0 4px 12px rgba(0,0,0,.05);
  }

  .action-buttons{
    display:flex;
    gap:8px;
  }

  .action-buttons form{
    flex:1;
  }

  .action-buttons button{
    width:100%;
  }

  /* ================= BUTTONS ================= */

  .btn-sm{
    padding:8px 12px;
    border-radius:10px;
    font-weight:600;
    transition:.2s ease;
  }

  .btn-sm:hover{
    transform:translateY(-1px);
  }

  /* ================= STATUS BOX ================= */

  .status-box{
    padding:10px;
    border-radius:10px;
    font-size:.78rem;
    font-weight:700;
    text-align:center;
  }

  .status-review{
    background:#fff8e1;
    color:#8a6d3b;
  }

  .status-closed{
    background:#e8f5e9;
    color:#2e7d32;
  }

  .status-rejected{
    background:#ffebee;
    color:#c62828;
  }

  /* ================= SEARCHABLE SELECT ================= */

  .ts-control{
    border-radius:10px !important;
    border:1px solid #d1d5db !important;
    min-height:40px !important;
    padding:6px 10px !important;
    font-size:.82rem !important;
  }

  .ts-dropdown{
    border-radius:10px !important;
    overflow:hidden;
  }

  .ts-dropdown .option{
    padding:10px 12px;
    font-size:.82rem;
  }

  .ts-dropdown .active{
    background:#ecfdf5 !important;
    color:#166534 !important;
  }

  /* ================= MODAL ================= */

  .modal{
    display:none;
    position:fixed;
    z-index:9999;
    left:0;
    top:0;
    width:100%;
    height:100%;
    overflow:auto;
    background:rgba(0,0,0,0.65);
    padding:30px 15px;
  }

  .modal-content{
    background:#fff;
    width:100%;
    max-width:900px;
    margin:auto;
    border-radius:12px;
    overflow:hidden;
    animation:fadeIn .25s ease;
  }

  .modal-header{
    padding:18px 24px;
    border-bottom:1px solid #eee;
    display:flex;
    justify-content:space-between;
    align-items:center;
  }

  .modal-header h2{
    margin:0;
    font-size:1.3rem;
  }

  .close-modal{
    font-size:28px;
    cursor:pointer;
    color:#666;
  }

  .modal-body{
    padding:24px;
  }

  .modal-grid{
    display:grid;
    grid-template-columns:repeat(2,1fr);
    gap:14px;
    margin-bottom:24px;
  }

  .detail-card{
    background:#f8f9fa;
    padding:12px;
    border-radius:8px;
  }

  .detail-label{
    font-size:.75rem;
    color:#666;
    margin-bottom:5px;
  }

  .detail-value{
    font-weight:600;
  }

  .modal-description{
    margin-bottom:25px;
  }

  .modal-description p{
    line-height:1.7;
  }

  .modal-image img{
    width:100%;
    max-height:450px;
    object-fit:cover;
    border-radius:10px;
    border:1px solid #ddd;
  }

  @keyframes fadeIn{
    from{
      opacity:0;
      transform:translateY(-10px);
    }
    to{
      opacity:1;
      transform:translateY(0);
    }
  }

  @media(max-width:768px){

    .modal-grid{
      grid-template-columns:1fr;
    }

    .action-buttons{
      flex-direction:column;
    }
  }

</style>

<!-- ================= FILTER BAR ================= -->

<div class="card mb-24">

  <div class="card-body" style="padding:16px;">

    <form method="GET"
          action="<%= ctx2 %>/admin/violations"
          style="display:flex;gap:12px;flex-wrap:wrap;align-items:flex-end;">

      <div>

        <label class="form-label"
               style="font-size:.75rem;">

          Type

        </label>

        <select name="type"
                class="form-control"
                style="min-width:160px;">

          <option value="">All Types</option>

          <option value="ILLEGAL_DUMPING"
                  <%= "ILLEGAL_DUMPING".equals(filterType)
                          ? "selected" : "" %>>

            Illegal Dumping

          </option>

          <option value="WATER_POLLUTION"
                  <%= "WATER_POLLUTION".equals(filterType)
                          ? "selected" : "" %>>

            Water Pollution

          </option>

          <option value="AIR_POLLUTION"
                  <%= "AIR_POLLUTION".equals(filterType)
                          ? "selected" : "" %>>

            Air Pollution

          </option>

          <option value="DEFORESTATION"
                  <%= "DEFORESTATION".equals(filterType)
                          ? "selected" : "" %>>

            Deforestation

          </option>

          <option value="NOISE_POLLUTION"
                  <%= "NOISE_POLLUTION".equals(filterType)
                          ? "selected" : "" %>>

            Noise Pollution

          </option>

          <option value="SOIL_CONTAMINATION"
                  <%= "SOIL_CONTAMINATION".equals(filterType)
                          ? "selected" : "" %>>

            Soil Contamination

          </option>

          <option value="OTHER"
                  <%= "OTHER".equals(filterType)
                          ? "selected" : "" %>>

            Other

          </option>

        </select>

      </div>

      <div>

        <label class="form-label"
               style="font-size:.75rem;">

          Status

        </label>

        <select name="status"
                class="form-control"
                style="min-width:160px;">

          <option value="">All Statuses</option>

          <option value="SUBMITTED">Submitted</option>
          <option value="UNDER_REVIEW">Under Review</option>
          <option value="IN_PROGRESS">In Progress</option>
          <option value="RESOLVED">Resolved</option>
          <option value="CLOSED">Closed</option>
          <option value="REJECTED">Rejected</option>

        </select>

      </div>

      <div>

        <label class="form-label"
               style="font-size:.75rem;">

          Severity

        </label>

        <select name="severity"
                class="form-control">

          <option value="">All</option>
          <option value="LOW">Low</option>
          <option value="MEDIUM">Medium</option>
          <option value="HIGH">High</option>
          <option value="CRITICAL">Critical</option>

        </select>

      </div>

      <button type="submit"
              class="btn btn-primary btn-sm">

        Filter

      </button>

      <a href="<%= ctx2 %>/admin/violations"
         class="btn btn-secondary btn-sm">

        Reset

      </a>

      <span class="text-mute"
            style="font-size:.82rem;margin-left:auto;">

        <%= total %> results

      </span>

    </form>

  </div>

</div>

<!-- ================= TABLE ================= -->

<div class="card">

  <div class="card-header">

    <h3>⚠️ All Violations</h3>

  </div>

  <div class="card-body" style="padding:0;">

    <% if (violations == null || violations.isEmpty()) { %>

    <div class="empty-state">

      <div class="empty-icon">🌿</div>

      <h3>No violations found</h3>

    </div>

    <% } else { %>

    <div class="table-wrapper">

      <table>

        <thead>

        <tr>

          <th>#</th>
          <th>Title</th>
          <th>Type</th>
          <th>Severity</th>
          <th>Location</th>
          <th>Reporter</th>
          <th>Status</th>
          <th>Date</th>
          <th>Actions</th>

        </tr>

        </thead>

        <tbody>

        <% for (Violation v : violations) { %>

        <tr>

          <td>#<%= v.getId() %></td>

          <td>

            <span class="view-link view-violation"

                  data-id="<%= v.getId() %>"
                  data-title="<%= v.getTitle() %>"
                  data-type="<%= v.getType() %>"
                  data-severity="<%= v.getSeverity() %>"
                  data-location="<%= v.getLocationName() %>"
                  data-reporter="<%= v.getReporterName() %>"
                  data-status="<%= v.getStatus() %>"
                  data-date="<%= v.getCreatedAt() %>"
                  data-description="<%= v.getDescription() %>"
                  data-image="<%= v.getPhotoUrl() %>">

              <%= v.getTitle() %>

            </span>

          </td>

          <td><%= v.getType().replace("_"," ") %></td>

          <td>

            <span class="badge badge-<%= v.getSeverity().toLowerCase() %>">

              <%= v.getSeverity() %>

            </span>

          </td>

          <td><%= v.getLocationName() %></td>

          <td><%= v.getReporterName() %></td>

          <td>

            <span class="badge badge-<%= v.getStatus().toLowerCase().replace("_","-") %>">

              <%= v.getStatus().replace("_"," ") %>

            </span>

          </td>

          <td><%= v.getCreatedAt() %></td>

          <!-- ================= ACTIONS ================= -->

          <td>

            <div class="action-panel">

              <!-- VIEW -->

              <button type="button"
                      class="btn btn-info btn-sm view-violation"

                      data-id="<%= v.getId() %>"
                      data-title="<%= v.getTitle() %>"
                      data-type="<%= v.getType() %>"
                      data-severity="<%= v.getSeverity() %>"
                      data-location="<%= v.getLocationName() %>"
                      data-reporter="<%= v.getReporterName() %>"
                      data-status="<%= v.getStatus() %>"
                      data-date="<%= v.getCreatedAt() %>"
                      data-description="<%= v.getDescription() %>"
                      data-image="<%= v.getPhotoUrl() %>">

                👁 View Details

              </button>

              <!-- ASSIGN -->

              <% if ("SUBMITTED".equals(v.getStatus())) { %>

              <div class="action-card">

                <form method="post"
                      action="<%= ctx2 %>/admin/violations">

                  <input type="hidden"
                         name="action"
                         value="assign">

                  <input type="hidden"
                         name="violationId"
                         value="<%= v.getId() %>">

                  <select name="authorityId"
                          class="authority-select"
                          required>

                    <option value="">
                      Search authority...
                    </option>

                    <% for (User a : authorities) { %>

                    <option value="<%= a.getId() %>">

                      <%= a.getFullName() %>

                    </option>

                    <% } %>

                  </select>

                  <button type="submit"
                          class="btn btn-primary btn-sm"
                          style="margin-top:10px;width:100%;">

                    Assign Authority

                  </button>

                </form>

              </div>

              <% } %>

              <!-- ACTIONS -->

              <% if (!"CLOSED".equals(v.getStatus())
                      && !"REJECTED".equals(v.getStatus())) { %>

              <div class="action-buttons">

                <!-- CLOSE -->

                <form method="post"
                      action="<%= ctx2 %>/admin/violations">

                  <input type="hidden"
                         name="action"
                         value="close">

                  <input type="hidden"
                         name="violationId"
                         value="<%= v.getId() %>">

                  <button type="submit"
                          class="btn btn-success btn-sm"
                          onclick="return confirm('Close this report?')">

                    ✅ Close

                  </button>

                </form>

                <!-- REJECT -->

                <form method="post"
                      action="<%= ctx2 %>/admin/violations">

                  <input type="hidden"
                         name="action"
                         value="reject">

                  <input type="hidden"
                         name="violationId"
                         value="<%= v.getId() %>">

                  <button type="submit"
                          class="btn btn-danger btn-sm"
                          onclick="return confirm('Reject this report?')">

                    ❌ Reject

                  </button>

                </form>

              </div>

              <% } %>

            </div>

          </td>

        </tr>

        <% } %>

        </tbody>

      </table>

    </div>

    <% } %>

  </div>

</div>

<!-- ================= MODAL ================= -->

<div id="violationModal" class="modal">

  <div class="modal-content">

    <div class="modal-header">

      <h2 id="modalTitle"></h2>

      <span class="close-modal">&times;</span>

    </div>

    <div class="modal-body">

      <div class="modal-grid">

        <div class="detail-card">
          <div class="detail-label">Violation ID</div>
          <div class="detail-value" id="modalId"></div>
        </div>

        <div class="detail-card">
          <div class="detail-label">Type</div>
          <div class="detail-value" id="modalType"></div>
        </div>

        <div class="detail-card">
          <div class="detail-label">Severity</div>
          <div class="detail-value" id="modalSeverity"></div>
        </div>

        <div class="detail-card">
          <div class="detail-label">Status</div>
          <div class="detail-value" id="modalStatus"></div>
        </div>

        <div class="detail-card">
          <div class="detail-label">Location</div>
          <div class="detail-value" id="modalLocation"></div>
        </div>

        <div class="detail-card">
          <div class="detail-label">Reporter</div>
          <div class="detail-value" id="modalReporter"></div>
        </div>

      </div>

      <div class="modal-description">

        <h4>Description</h4>

        <p id="modalDescription"></p>

      </div>

      <div class="modal-image">

        <img id="modalImage"
             src=""
             alt="Violation Image">

      </div>

    </div>

  </div>

</div>

<script>

  // ================= SEARCHABLE SELECT =================

  document.querySelectorAll(".authority-select")
          .forEach(select => {

            new TomSelect(select, {

              create:false,

              sortField:{
                field:"text",
                direction:"asc"
              },

              placeholder:"Search authority..."

            });

          });

  // ================= MODAL =================

  const modal =
          document.getElementById("violationModal");

  const closeModalBtn =
          document.querySelector(".close-modal");

  const ctx =
          "<%= request.getContextPath() %>";

  document.querySelectorAll(".view-violation")
          .forEach(button => {

            button.addEventListener("click", function () {

              document.getElementById("modalId").innerText =
                      this.dataset.id;

              document.getElementById("modalTitle").innerText =
                      this.dataset.title;

              document.getElementById("modalType").innerText =
                      this.dataset.type.replaceAll("_"," ");

              document.getElementById("modalSeverity").innerText =
                      this.dataset.severity;

              document.getElementById("modalStatus").innerText =
                      this.dataset.status.replaceAll("_"," ");

              document.getElementById("modalLocation").innerText =
                      this.dataset.location;

              document.getElementById("modalReporter").innerText =
                      this.dataset.reporter;

              document.getElementById("modalDescription").innerText =
                      this.dataset.description;

              const imagePath =
                      this.dataset.image;

              const modalImage =
                      document.getElementById("modalImage");

              if (imagePath && imagePath.trim() !== "") {

                let finalImageUrl = imagePath;

                if (imagePath.startsWith("/")) {
                  finalImageUrl = ctx + imagePath;
                }

                modalImage.src = finalImageUrl;
                modalImage.style.display = "block";

              } else {

                modalImage.style.display = "none";

              }

              modal.style.display = "block";

            });

          });

  closeModalBtn.onclick = function () {

    modal.style.display = "none";

  };

  window.onclick = function(event) {

    if (event.target === modal) {

      modal.style.display = "none";

    }

  };

</script>

<%@ include file="../common/footer.jsp" %>
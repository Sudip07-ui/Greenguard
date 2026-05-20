<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("pageTitle", "Report a Violation"); %>
<%@ include file="../common/header.jsp" %>

<div style="max-width:720px;">
  <p class="text-mute mb-24">
    Fill in the details below to report an environmental violation. Be as specific as possible — it helps authorities act faster.
  </p>

  <div class="card">
    <div class="card-header"><h3><i class="fa-solid fa-file-circle-exclamation" style="color: rgb(35, 1, 1);"></i> Violation Report Form</h3></div>
    <div class="card-body">
      <form method="POST" action="${pageContext.request.contextPath}/citizen/report"
            enctype="multipart/form-data">

        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="type">Violation Type <span class="required">*</span></label>
            <select id="type" name="type" class="form-control" required>
              <option value="">-- Select type --</option>
              <option value="ILLEGAL_DUMPING">♻<i class="fa-solid fa-recycle" style="color: rgb(35, 1, 1);"></i> Illegal Dumping</option>
              <option value="WATER_POLLUTION"><i class="fa-solid fa-droplet" style="color: rgb(35, 1, 1);"></i> Water Pollution</option>
              <option value="AIR_POLLUTION"><i class="fa-solid fa-smog" style="color: rgb(35, 1, 1);"></i> Air Pollution</option>
              <option value="DEFORESTATION"><i class="fa-solid fa-tree" style="color: rgb(10, 182, 25);"></i> Deforestation</option>
              <option value="NOISE_POLLUTION"><i class="fa-solid fa-volume-high" style="color: rgb(1, 10, 35);"></i> Noise Pollution</option>
              <option value="SOIL_CONTAMINATION"><i class="fa-solid fa-mound" style="color: rgb(1, 10, 35);"></i> Soil Contamination</option>
              <option value="OTHER"><i class="fa-regular fa-circle-question" style="color: rgb(1, 10, 35);"></i> Other</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label" for="severity">Severity Level <span class="required">*</span></label>
            <select id="severity" name="severity" class="form-control" required>
              <option value="LOW"><i class="fa-solid fa-circle" style="color: rgb(5, 246, 34);"></i> Low</option>
              <option value="MEDIUM" selected><i class="fa-solid fa-circle" style="color: rgb(255, 212, 59);"></i> Medium</option>
              <option value="HIGH"><i class="fa-solid fa-circle" style="color: rgb(255, 69, 59);"></i> High</option>
              <option value="CRITICAL"><i class="fa-solid fa-circle" style="color: rgb(37, 7, 6);"></i> Critical</option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="title">Report Title <span class="required">*</span></label>
          <input type="text" id="title" name="title" class="form-control"
                 placeholder="e.g. Illegal chemical dumping near Bagmati River" required maxlength="200"/>
        </div>

        <div class="form-group">
          <label class="form-label" for="description">Description <span class="required">*</span></label>
          <textarea id="description" name="description" class="form-control" rows="5"
                    placeholder="Describe what you observed in detail. Include time, frequency, visible impact, etc."
                    required minlength="20"></textarea>
        </div>

        <div class="form-group">
          <label class="form-label" for="locationName">Location Name <span class="required">*</span></label>
          <input type="text" id="locationName" name="locationName" class="form-control"
                 placeholder="e.g. Near Tinkune bridge, Kathmandu" required maxlength="255"/>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="latitude">Latitude</label>
            <input type="number" id="latitude" name="latitude" class="form-control"
                   placeholder="e.g. 27.700769" step="0.000001" min="-90" max="90"/>
          </div>
          <div class="form-group">
            <label class="form-label" for="longitude">Longitude</label>
            <input type="number" id="longitude" name="longitude" class="form-control"
                   placeholder="e.g. 85.318769" step="0.000001" min="-180" max="180"/>
          </div>
        </div>
        <button type="button" id="geoBtn" class="btn btn-secondary btn-sm mb-16">
          <i class="fa-solid fa-location-dot" style="color: rgb(37, 7, 6);"></i> Use My Location
        </button>

        <div class="form-group">
          <label class="form-label" for="photoInput">Upload Photo (optional)</label>
          <input type="file" id="photoInput" name="photo" class="form-control"
                 accept="image/jpeg,image/png,image/gif,image/webp"/>
          <div class="form-hint">Max 5 MB. JPEG, PNG, GIF or WEBP only.</div>
          <img id="photoPreview" class="photo-preview" alt="Photo preview"/>
        </div>

        <div style="display:flex;gap:12px;margin-top:8px;">
          <button type="submit" class="btn btn-primary"><i class="fa-solid fa-file-circle-check" style="color: rgb(7, 1, 1);"></i> Submit Report</button>
          <a href="${pageContext.request.contextPath}/citizen/dashboard" class="btn btn-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="../common/footer.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Green Monitor Application" />
<%@ include file="../common/header.jsp" %>

<!-- Bind request/session attributes -->
<c:set var="existing" value="${requestScope.existingApplication}" />
<c:set var="user" value="${sessionScope.user}" />

<div style="max-width:680px;">

  <!-- Info Banner -->
  <div class="card mb-24" style="border-left:4px solid var(--amber);">
    <div class="card-body">
      <div style="display:flex;gap:16px;align-items:flex-start;">
        <div style="font-size:2.5rem;"><i class="fa-solid fa-medal" style="color: rgb(38, 36, 23);"></i></div>
        <div>
          <h3 style="margin-bottom:8px;">What is a Certified Green Monitor?</h3>
          <p style="font-size:.875rem;">
            Green Monitors are trusted, verified citizens who consistently report environmental violations.
            Once approved, you receive a verified badge on your profile, unlocking priority report visibility
            and community recognition.
          </p>
          <div style="display:flex;gap:10px;margin-top:12px;flex-wrap:wrap;">
            <span class="badge badge-monitor"><i class="fa-solid fa-medal" style="color: rgb(109, 96, 8);"></i> Bronze</span>
            <span class="badge badge-monitor"><i class="fa-solid fa-medal" style="color: rgb(131, 131, 131);"></i> Silver</span>
            <span class="badge badge-monitor"><i class="fa-solid fa-medal" style="color: rgb(255, 212, 59);"></i> Gold</span>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- CASE 1: Already Certified -->
  <c:if test="${user.certifiedMonitor}">

    <div class="card">
      <div class="card-body text-center">
        <div style="font-size:3rem;margin-bottom:16px;"><i class="fa-solid fa-medal" style="color: rgb(38, 36, 23);"></i></div>
        <h2 style="margin-bottom:8px;">You are a Certified Green Monitor!</h2>

        <p>
          Tier:
          <span class="badge badge-monitor">
              ${user.monitorTier}
          </span>
        </p>

        <p class="text-mute mt-8">
          Thank you for your contributions to environmental protection.
        </p>
      </div>
    </div>

  </c:if>

  <!-- CASE 2: Application Exists -->
  <c:if test="${!user.certifiedMonitor and not empty existing}">

    <div class="card">
      <div class="card-header">
        <h3><i class="fa-solid fa-file-circle-exclamation" style="color: rgb(38, 36, 23);"></i> Your Application Status</h3>
      </div>

      <div class="card-body">

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:20px;">

          <div>
            <div class="text-mute" style="font-size:.75rem;margin-bottom:4px;">STATUS</div>

            <span class="badge badge-${fn:toLowerCase(existing.status)}">
                ${existing.status}
            </span>
          </div>

          <div>
            <div class="text-mute" style="font-size:.75rem;margin-bottom:4px;">APPLIED</div>
            <div style="font-size:.875rem;">
                ${existing.appliedAt}
            </div>
          </div>

        </div>

        <c:if test="${existing.status == 'REJECTED' and not empty existing.reviewNotes}">
          <div class="alert alert-error">
            <strong>Review Notes:</strong> ${existing.reviewNotes}
          </div>
        </c:if>

        <c:if test="${existing.status == 'PENDING'}">
          <div class="alert alert-info">
            <i class="fa-solid fa-hourglass-half" style="color: rgb(38, 36, 23);"></i> Your application is under review. The admin will notify you once a decision is made.
          </div>
        </c:if>

        <div style="background:var(--bg);border-radius:var(--radius-sm);padding:16px;margin-top:12px;">
          <div class="text-mute" style="font-size:.75rem;margin-bottom:6px;">YOUR MOTIVATION</div>
          <p style="font-size:.875rem;">
              ${existing.motivation}
          </p>
        </div>

      </div>
    </div>

  </c:if>

  <!-- CASE 3: New Application Form -->
  <c:if test="${!user.certifiedMonitor and empty existing}">

    <div class="card">
      <div class="card-header">
        <h3><i class="fa-solid fa-file-pen" style="color: rgb(38, 36, 23);"></i> Submit Application</h3>
      </div>

      <div class="card-body">

        <form method="POST" action="${pageContext.request.contextPath}/citizen/monitor-apply">

          <div class="form-group">
            <label class="form-label">
              Why do you want to become a Green Monitor?
              <span class="required">*</span>
            </label>

            <textarea name="motivation" class="form-control" rows="5"
                      placeholder="Explain your motivation for joining as a certified Green Monitor. (min 20 characters)"
                      required minlength="20"></textarea>
          </div>

          <div class="form-group">
            <label class="form-label">
              Relevant Experience (Optional)
            </label>

            <textarea name="experience" class="form-control" rows="4"
                      placeholder="Any environmental volunteering, activism, or professional experience you'd like to share…"></textarea>
          </div>

          <div class="alert alert-warning">
            <i class="fa-solid fa-triangle-exclamation" style="color: rgb(38, 36, 23);"></i> Applications are reviewed manually. Ensure your account has submitted at least a few violation reports before applying.
          </div>

          <div style="display:flex;gap:12px;">
            <button type="submit" class="btn btn-amber"><i class="fa-solid fa-file-pen" style="color: rgb(38, 36, 23);"></i> Submit Application</button>
            <a href="${pageContext.request.contextPath}/citizen/dashboard" class="btn btn-secondary">
              Cancel
            </a>
          </div>

        </form>

      </div>
    </div>

  </c:if>

</div>

<%@ include file="../common/footer.jsp" %>
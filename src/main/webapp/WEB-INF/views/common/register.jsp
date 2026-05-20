<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Register – GreenGuard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card" style="max-width:480px;">
    <div class="auth-header">
      <div class="auth-logo"><i class="fa-solid fa-leaf" style="color: rgb(26, 166, 16);"></i> Green<span>Guard</span></div>
      <div class="auth-subtitle">Join the Environmental Monitoring Network</div>
    </div>
    <div class="auth-body">
      <h2 style="margin-bottom:24px;font-size:1.3rem;">Create Account</h2>

      <c:if test="${not empty error}">
        <div class="alert alert-error">⚠️ ${error}</div>
      </c:if>

      <form method="POST" action="${pageContext.request.contextPath}/register">
        <div class="form-group">
          <label class="form-label" for="fullName">Full Name <span class="required">*</span></label>
          <input type="text" id="fullName" name="fullName" class="form-control"
                 placeholder="Jane Doe" required value="${param.fullName}"/>
        </div>
        <div class="form-group">
          <label class="form-label" for="email">Email Address <span class="required">*</span></label>
          <input type="email" id="email" name="email" class="form-control"
                 placeholder="you@example.com" required value="${param.email}"/>
        </div>
        <div class="form-group">
          <label class="form-label" for="phone">Phone Number</label>
          <input type="tel" id="phone" name="phone" class="form-control"
                 placeholder="+977 98XXXXXXXX" value="${param.phone}"/>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="password">Password <span class="required">*</span></label>
            <input type="password" id="password" name="password" class="form-control"
                   placeholder="Min 8 characters" required minlength="8"/>
          </div>
          <div class="form-group">
            <label class="form-label" for="confirmPassword">Confirm Password <span class="required">*</span></label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                   placeholder="Repeat password" required minlength="8"/>
          </div>
        </div>
        <div class="alert alert-info" style="font-size:.82rem;margin-bottom:20px;">
           Your account will be reviewed by an admin before you can log in.
        </div>
        <button type="submit" class="btn btn-primary w-100" style="justify-content:center;padding:12px;">
          Create Account
        </button>
      </form>
    </div>
    <div class="auth-footer">
      Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

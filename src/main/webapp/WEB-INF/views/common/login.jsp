<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login – GreenGuard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head> <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<body>
<div class="auth-wrapper">
  <div class="auth-card">
    <div class="auth-header">
      <div class="auth-logo"><i class="fa-solid fa-leaf" style="color: rgb(31, 144, 9);"></i> Green<span>Guard</span></div>
      <div class="auth-subtitle">Citizen Environmental Monitoring Network</div>
    </div>
    <div class="auth-body">
      <h2 style="margin-bottom:24px;font-size:1.3rem;">Sign In</h2>

      <c:if test="${not empty error}">
        <div class="alert alert-error">⚠️ ${error}</div>
      </c:if>
      <c:if test="${not empty success}">
        <div class="alert alert-success"> ${success}</div>
      </c:if>

      <form method="POST" action="${pageContext.request.contextPath}/login">
        <div class="form-group">
          <label class="form-label" for="email">Email Address <span class="required">*</span></label>
          <input type="email" id="email" name="email" class="form-control"
                 placeholder="you@example.com" required autocomplete="email"/>
        </div>
        <div class="form-group">
          <label class="form-label" for="password">Password <span class="required">*</span></label>
          <input type="password" id="password" name="password" class="form-control"
                 placeholder="••••••••" required autocomplete="current-password"/>
        </div>
        <button type="submit" class="btn btn-primary w-100" style="justify-content:center;padding:12px;">
          Sign In →
        </button>
      </form>
    </div>
    <div class="auth-footer">
      Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

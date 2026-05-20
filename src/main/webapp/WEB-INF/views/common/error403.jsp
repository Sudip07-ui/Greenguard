<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>403 – Access Denied | GreenGuard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;background:var(--bg);">
  <div style="text-align:center;max-width:460px;padding:40px;">
    <div style="font-size:5rem;margin-bottom:16px;"><i class="fa-solid fa-circle-exclamation" style="color: rgb(216, 9, 9);"></i></div>
    <h1 style="font-size:4rem;color:var(--red);margin-bottom:8px;">403</h1>
    <h2 style="margin-bottom:16px;">Access Denied</h2>
    <p style="color:var(--text-mute);margin-bottom:32px;">
      You don't have permission to access this page.
      Please contact the administrator if you believe this is an error.
    </p>
    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">← Go to Login</a>
  </div>
</div>
</body>
</html>

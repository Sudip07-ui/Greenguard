<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>404 – Page Not Found | GreenGuard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;background:var(--bg);">
  <div style="text-align:center;max-width:460px;padding:40px;">
    <div style="font-size:5rem;margin-bottom:16px;">🌿</div>
    <h1 style="font-size:4rem;color:var(--green-600);margin-bottom:8px;">404</h1>
    <h2 style="margin-bottom:16px;">Page Not Found</h2>
    <p style="color:var(--text-mute);margin-bottom:32px;">
      The page you're looking for doesn't exist or has been moved.
    </p>
    <div style="display:flex;gap:12px;justify-content:center;">
      <a href="javascript:history.back()" class="btn btn-secondary">← Go Back</a>
      <a href="${pageContext.request.contextPath}/"  class="btn btn-primary"> Home</a>
    </div>
  </div>
</div>
</body>
</html>

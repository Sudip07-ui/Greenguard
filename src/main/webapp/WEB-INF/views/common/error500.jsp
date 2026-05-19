<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>500 – Server Error | GreenGuard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;background:var(--bg);">
  <div style="text-align:center;max-width:500px;padding:40px;">
    <div style="font-size:5rem;margin-bottom:16px;">⚠️</div>
    <h1 style="font-size:4rem;color:var(--amber);margin-bottom:8px;">500</h1>
    <h2 style="margin-bottom:16px;">Internal Server Error</h2>
    <p style="color:var(--text-mute);margin-bottom:24px;">
      Something went wrong on our end. Please try again or contact support.
    </p>
    <% if (exception != null) { %>
    <div style="background:#fff1f2;border:1px solid #fecdd3;border-radius:8px;padding:12px 16px;
                font-size:.78rem;color:#991b1b;text-align:left;margin-bottom:24px;word-break:break-all;">
      <strong>Error:</strong> <%= exception.getMessage() %>
    </div>
    <% } %>
    <div style="display:flex;gap:12px;justify-content:center;">
      <a href="javascript:history.back()" class="btn btn-secondary">← Go Back</a>
      <a href="${pageContext.request.contextPath}/"  class="btn btn-primary">🏠 Home</a>
    </div>
  </div>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // If already logged in, redirect to dashboard
    if (session.getAttribute("user") != null) {
        com.greenguard.model.User u = (com.greenguard.model.User) session.getAttribute("user");
        String ctx = request.getContextPath();
        switch (u.getRole()) {
            case "ADMIN":     response.sendRedirect(ctx + "/admin/dashboard");     return;
            case "AUTHORITY": response.sendRedirect(ctx + "/authority/dashboard"); return;
            default:          response.sendRedirect(ctx + "/citizen/dashboard");   return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>GreenGuard – Citizen Environmental Monitoring Network</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <link rel="icon" href="<i class='fa-solid fa-leaf' style='color: rgb(31, 144, 9);'></i>"/>
</head>
<body>

<!-- Nav -->
<nav style="position:fixed;top:0;left:0;right:0;z-index:200;background:rgba(10,34,24,.95);
            backdrop-filter:blur(10px);padding:0 40px;height:64px;
            display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid rgba(255,255,255,.08);">
  <div style="font-family:'Syne',sans-serif;font-size:1.2rem;font-weight:800;color:#fff;">
    <i class="fa-solid fa-leaf" style="color: rgb(31, 144, 9);"></i> GreenGuard
  </div>
  <div style="display:flex;gap:12px;">
    <a href="${pageContext.request.contextPath}/login"    class="btn btn-secondary btn-sm" style="color:#fff;border-color:rgba(255,255,255,.3);background:rgba(255,255,255,.1);">Sign In</a>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-amber btn-sm">Join Now</a>
  </div>
</nav>

<!-- Hero -->
<section class="landing-hero" style="padding-top:140px;padding-bottom:100px;">
  <h1>Report. Track. <span>Protect.</span></h1>
  <p>
    GreenGuard empowers citizens to report environmental violations,
    track enforcement actions, and hold authorities accountable — all in one place.
  </p>
  <div class="hero-buttons">
    <a href="${pageContext.request.contextPath}/register" class="btn btn-hero-primary"><i class="fa-solid fa-leaf" style="color: rgb(31, 144, 9);"></i> Get Started — It's Free</a>
    <a href="${pageContext.request.contextPath}/login"  class="btn btn-hero-secondary">Sign In</a>
  </div>

  <!-- Mini Stats Row -->
  <div style="display:flex;gap:40px;justify-content:center;margin-top:60px;flex-wrap:wrap;">
    <div style="text-align:center;">
      <div style="font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;color:var(--green-300);">3</div>
      <div style="font-size:.8rem;color:var(--green-200);margin-top:4px;">User Roles</div>
    </div>
    <div style="text-align:center;">
      <div style="font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;color:var(--green-300);">7</div>
      <div style="font-size:.8rem;color:var(--green-200);margin-top:4px;">Violation Types</div>
    </div>
    <div style="text-align:center;">
      <div style="font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;color:var(--green-300);">Live</div>
      <div style="font-size:.8rem;color:var(--green-200);margin-top:4px;">Status Tracking</div>
    </div>
    <div style="text-align:center;">
      <div style="font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;color:var(--green-300);"><i class="fa-solid fa-medal"></i></div>
      <div style="font-size:.8rem;color:var(--green-200);margin-top:4px;">Green Monitor Program</div>
    </div>
  </div>
</section>

<!-- Features -->
<section class="features-section">
  <h2 style="font-family:'Syne',sans-serif;">How GreenGuard Works</h2>
  <div class="features-grid">
    <div class="feature-card">
      <div class="feature-icon"><i class="fa-solid fa-file-lines"></i></div>
      <h3>Report Violations</h3>
      <p>Citizens upload photos, add descriptions, and share the location of environmental violations like illegal dumping, water pollution, and deforestation.</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon"><i class="fa-solid fa-scale-balanced"></i></div>
      <h3>Authorities Act</h3>
      <p>Enforcement officers receive assigned cases, investigate, take action, and update the status with full transparency throughout the process.</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon"><i class="fa-solid fa-chart-gantt"></i></div>
      <h3>Live Timeline</h3>
      <p>Every action taken on a case is recorded in a public timeline, so citizens can see exactly what happened with their report.</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon"><i class="fa-solid fa-medal"></i></div>
      <h3>Green Monitor Program</h3>
      <p>Trusted citizens can apply to become Certified Green Monitors — a verified badge recognising consistent and impactful environmental reporting.</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon"><i class="fa-solid fa-eye"></i></div>
      <h3>Watchlist Alerts</h3>
      <p>Save areas you care about and get instant notifications whenever a new violation is reported in that zone.</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon"><i class="fa-solid fa-bars-staggered"></i></div>
      <h3>Hotspot Detection</h3>
      <p>Areas with many violation reports are automatically flagged as hotspots, highlighting pollution clusters that need urgent attention.</p>
    </div>
  </div>
</section>

<!-- Violation Types -->
<section style="background:var(--green-900);padding:80px 40px;text-align:center;">
  <h2 style="color:#fff;font-family:'Syne',sans-serif;margin-bottom:12px;">Report Any Environmental Violation</h2>
  <p style="color:var(--green-200);max-width:560px;margin:0 auto 48px;">
    GreenGuard covers a wide range of environmental crimes and violations.
  </p>
  <div style="display:flex;flex-wrap:wrap;gap:12px;justify-content:center;max-width:800px;margin:0 auto;">
    <% String[][] types = {
      {"<i class=\"fa-solid fa-recycle\"></i>", "Illegal Dumping"},
      {"<i class=\"fa-solid fa-droplet\"></i>", "Water Pollution"},
      {"<i class=\"fa-solid fa-smog\"></i>", "Air Pollution"},
      {"<i class=\"fa-solid fa-tree\"></i>", "Deforestation"},
      {"<i class=\"fa-solid fa-volume-xmark\"></i>", "Noise Pollution"},
      {"<i class=\"fa-solid fa-mound\"></i>", "Soil Contamination"},
      {"<i class=\"fa-regular fa-circle-question\"></i>", "Other Violations"}
    };
    for (String[] t : types) { %>
    <div style="background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.15);
                border-radius:40px;padding:10px 20px;color:#fff;font-size:.875rem;font-weight:500;">
      <%= t[0] %> <%= t[1] %>
    </div>
    <% } %>
  </div>
</section>

<!-- CTA -->
<section style="padding:80px 40px;text-align:center;background:var(--green-50);">
  <h2 style="font-family:'Syne',sans-serif;margin-bottom:16px;">Ready to Protect Your Environment?</h2>
  <p style="color:var(--text-mute);max-width:500px;margin:0 auto 32px;">
    Join GreenGuard today. Register your account and start reporting violations in your area.
    Together, we can make a difference.
  </p>
  <a href="${pageContext.request.contextPath}/register" class="btn btn-primary" style="padding:14px 36px;font-size:1rem;">
    <i class="fa-solid fa-leaf" style="color: rgb(31, 144, 9);"></i> Create Your Account
  </a>
</section>

<!-- Footer -->
<footer style="background:var(--green-900);padding:32px 40px;text-align:center;">
  <div style="font-family:'Syne',sans-serif;font-size:1rem;font-weight:700;color:#fff;margin-bottom:8px;">
    <i class="fa-solid fa-leaf" style="color: rgb(31, 144, 9);"></i> GreenGuard
  </div>
  <p style="font-size:.78rem;color:var(--green-400);">
    Citizen Environmental Monitoring Network &nbsp;|&nbsp;
    Itahari International College &nbsp;|&nbsp; London Metropolitan University &nbsp;|&nbsp; 2026
  </p>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

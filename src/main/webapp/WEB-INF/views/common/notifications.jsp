<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.greenguard.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    User sessionUser = (User) session.getAttribute("user");

    String role = sessionUser != null
            ? sessionUser.getRole()
            : "";

    String initials = "";

    if (sessionUser != null &&
            sessionUser.getFullName() != null) {

        String[] parts =
                sessionUser.getFullName()
                        .trim()
                        .split("\\s+");

        for (String p : parts) {

            if (!p.isEmpty()) {
                initials += p.charAt(0);
            }
        }

        if (initials.length() > 2) {
            initials = initials.substring(0, 2);
        }
    }

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8"/>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0"/>

    <title>
        <%= request.getAttribute("pageTitle") != null
                ? request.getAttribute("pageTitle") + " – GreenGuard"
                : "GreenGuard" %>
    </title>

    <link rel="stylesheet"
          href="<%= ctx %>/css/style.css"/>

    <link rel="icon"
          href="data:image/svg+xml,
          <svg xmlns='http://www.w3.org/2000/svg'
          viewBox='0 0 32 32'>
          <text y='28' font-size='28'>🌿</text>
          </svg>"/>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

</head>

<body>

<div id="overlay"
     style="display:none;
     position:fixed;
     inset:0;
     background:rgba(0,0,0,.4);
     z-index:99;">
</div>

<div class="app-shell">

    <!-- ================= SIDEBAR ================= -->

    <aside class="sidebar" id="sidebar">

        <div class="sidebar-logo">

            <div class="logo-mark">
                GreenGuard
            </div>

            <div class="tagline">
                Citizen Environmental Network
            </div>

        </div>

        <nav class="sidebar-nav">

            <% if ("CITIZEN".equals(role)) { %>

            <div class="nav-section-label">
                Citizen
            </div>

            <a href="<%= ctx %>/citizen/dashboard"
               class="nav-item">
                <span class="nav-icon"></span>
                Dashboard
            </a>

            <a href="<%= ctx %>/citizen/report"
               class="nav-item">
                <span class="nav-icon"></span>
                Report Violation
            </a>

            <a href="<%= ctx %>/citizen/my-reports"
               class="nav-item">
                <span class="nav-icon"></span>
                My Reports
            </a>

            <a href="<%= ctx %>/citizen/watchlist"
               class="nav-item">
                <span class="nav-icon"></span>
                Watchlist
            </a>

            <a href="<%= ctx %>/citizen/monitor-apply"
               class="nav-item">
                <span class="nav-icon"></span>
                Green Monitor
            </a>

            <% } %>

            <% if ("AUTHORITY".equals(role)) { %>

            <div class="nav-section-label">
                Authority
            </div>

            <a href="<%= ctx %>/authority/dashboard"
               class="nav-item">
                <span class="nav-icon"></span>
                Dashboard
            </a>

            <a href="<%= ctx %>/authority/cases"
               class="nav-item">
                <span class="nav-icon"></span>
                My Cases
            </a>

            <% } %>

            <% if ("ADMIN".equals(role)) { %>

            <div class="nav-section-label">
                Admin
            </div>

            <a href="<%= ctx %>/admin/dashboard"
               class="nav-item">
                <span class="nav-icon"></span>
                Dashboard
            </a>

            <a href="<%= ctx %>/admin/users"
               class="nav-item">
                <span class="nav-icon"></span>
                Users
            </a>

            <a href="<%= ctx %>/admin/violations"
               class="nav-item">
                <span class="nav-icon"></span>
                Violations
            </a>

            <a href="<%= ctx %>/admin/monitors"
               class="nav-item">
                <span class="nav-icon"></span>
                Monitor Applications
            </a>

            <% } %>

        </nav>

        <!-- ================= SIDEBAR FOOTER ================= -->

        <div class="sidebar-footer">

            <div class="user-card">

                <div class="user-avatar">
                    <%= initials.toUpperCase() %>
                </div>

                <div class="user-info">

                    <div class="user-name">
                        <%= sessionUser != null
                                ? sessionUser.getFullName()
                                : "Guest" %>
                    </div>

                    <div class="user-role">
                        <%= role.toLowerCase() %>
                    </div>

                </div>

            </div>

            <a href="<%= ctx %>/logout"
               class="btn btn-secondary btn-sm w-100 mt-8"
               style="justify-content:center;">

                Sign Out

            </a>

        </div>

    </aside>

    <!-- ================= MAIN CONTENT ================= -->

    <div class="main-content">

        <!-- ================= TOP HEADER ================= -->

        <header class="top-header">

            <div class="d-flex align-center gap-12">

                <span class="hamburger"
                      id="hamburger">

                    ☰

                </span>

                <span class="page-title">

                    <%= request.getAttribute("pageTitle") != null
                            ? request.getAttribute("pageTitle")
                            : "GreenGuard" %>

                </span>

            </div>

            <!-- ================= HEADER ACTIONS ================= -->

            <div class="header-actions">

                <!-- NOTIFICATION BELL -->

                <a href="<%= ctx %>/notifications"
                   id="notifBell"
                   style="position:relative;
                          text-decoration:none;
                          color:inherit;">

                    <div class="notif-bell">

                        <span class="bell-icon">

                            <i class="fa-solid fa-bell"
                               style="color: rgb(255, 212, 59);"></i>

                        </span>

                        <%
                            Integer unread =
                                    (Integer) request.getAttribute("unreadCount");

                            if (unread != null && unread > 0) {
                        %>

                        <span class="notif-badge">

                            <%= unread %>

                        </span>

                        <% } %>

                    </div>

                </a>

            </div>

        </header>

        <!-- ================= PAGE BODY ================= -->

        <div class="page-body">

            <!-- ERROR MESSAGE -->

                <% if (request.getAttribute("error") != null) { %>

            <div class="alert alert-error"
                 data-autodismiss>

                ⚠️ <%= request.getAttribute("error") %>

            </div>

                <% } %>

            <!-- SUCCESS MESSAGE -->

                <% if (request.getAttribute("success") != null) { %>

            <div class="alert alert-success"
                 data-autodismiss>

                <%= request.getAttribute("success") %>

            </div>

<% } %>
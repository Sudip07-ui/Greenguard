package com.greenguard.servlet.citizen;

import com.greenguard.dao.NotificationDAO;
import com.greenguard.dao.ViolationDAO;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/citizen/dashboard")
public class DashboardServlet extends HttpServlet {

    private final ViolationDAO    violationDAO    = new ViolationDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        try {
            req.setAttribute("myReports",      violationDAO.findByReporter(user.getId()));
            req.setAttribute("recentAll",       violationDAO.findRecent(5));
            req.setAttribute("hotspots",        violationDAO.findHotspots());
            req.setAttribute("statsByType",     violationDAO.countByType());
            req.setAttribute("statsByStatus",   violationDAO.countByStatus());
            req.setAttribute("notifications",   notificationDAO.findByUser(user.getId(), 10));
            req.setAttribute("unreadCount",     notificationDAO.countUnread(user.getId()));
            notificationDAO.markAllRead(user.getId());
        } catch (Exception e) {
            req.setAttribute("error", "Could not load dashboard: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/citizen/dashboard.jsp").forward(req, resp);
    }
}

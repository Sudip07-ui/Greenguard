package com.greenguard.controller.admin;

import com.greenguard.dao.MonitorApplicationDAO;
import com.greenguard.dao.NotificationDAO;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/monitors")
public class MonitorReviewServlet extends HttpServlet {

    private final MonitorApplicationDAO appDAO         = new MonitorApplicationDAO();
    private final NotificationDAO        notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("applications", appDAO.findAll());
        } catch (Exception e) {
            req.setAttribute("error", "Error loading applications: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/monitors.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User admin  = (User) req.getSession().getAttribute("user");
        int  appId  = Integer.parseInt(req.getParameter("appId"));
        int  userId = Integer.parseInt(req.getParameter("userId"));
        String status = req.getParameter("status");  // APPROVED | REJECTED
        String notes  = req.getParameter("reviewNotes");

        try {
            appDAO.review(appId, status, admin.getId(), notes);
            String msg = "APPROVED".equals(status)
                    ? "Congratulations! Your Green Monitor application has been approved. You are now a Certified Green Monitor!"
                    : "Your Green Monitor application was reviewed. Status: " + status + ". Notes: " + notes;
            notificationDAO.create(userId, "Monitor Application " + status, msg, null);
            resp.sendRedirect(req.getContextPath() + "/admin/monitors?success=" + status.toLowerCase());
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/monitors?error=" +
                    java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}

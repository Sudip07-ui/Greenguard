package com.greenguard.controller.citizen;

import com.greenguard.dao.MonitorApplicationDAO;
import com.greenguard.model.MonitorApplication;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet("/citizen/monitor-apply")
public class MonitorApplicationServlet extends HttpServlet {

    private final MonitorApplicationDAO appDAO = new MonitorApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        try {
            MonitorApplication existing = appDAO.findByUser(user.getId());
            req.setAttribute("existingApplication", existing);
        } catch (Exception e) {
            req.setAttribute("error", "Could not load application status.");
        }
        req.getRequestDispatcher("/WEB-INF/views/citizen/monitor-apply.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        String motivation = req.getParameter("motivation");
        String experience = req.getParameter("experience");

        if (motivation == null || motivation.trim().length() < 20) {
            req.setAttribute("error", "Please provide a motivation of at least 20 characters.");
            req.getRequestDispatcher("/WEB-INF/views/citizen/monitor-apply.jsp").forward(req, resp);
            return;
        }

        try {
            MonitorApplication existing = appDAO.findByUser(user.getId());
            if (existing != null) {
                req.setAttribute("error", "You have already submitted an application.");
                req.setAttribute("existingApplication", existing);
                req.getRequestDispatcher("/WEB-INF/views/citizen/monitor-apply.jsp").forward(req, resp);
                return;
            }

            MonitorApplication app = new MonitorApplication();
            app.setUserId(user.getId());
            app.setMotivation(motivation.trim());
            app.setExperience(experience != null ? experience.trim() : "");

            if (appDAO.apply(app)) {
                req.setAttribute("success", "Your Green Monitor application has been submitted and is under review.");
                req.setAttribute("existingApplication", appDAO.findByUser(user.getId()));
            } else {
                req.setAttribute("error", "Failed to submit application. Please try again.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/citizen/monitor-apply.jsp").forward(req, resp);
    }
}

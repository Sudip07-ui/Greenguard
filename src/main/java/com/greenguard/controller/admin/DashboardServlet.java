package com.greenguard.controller.admin;

import com.greenguard.dao.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    private final UserDAO             userDAO     = new UserDAO();
    private final ViolationDAO        violDAO     = new ViolationDAO();
    private final EnforcementCaseDAO  caseDAO     = new EnforcementCaseDAO();
    private final MonitorApplicationDAO monitorDAO = new MonitorApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalCitizens",    userDAO.countByRole("CITIZEN"));
            req.setAttribute("totalAuthorities",  userDAO.countByRole("AUTHORITY"));
            req.setAttribute("pendingUsers",      userDAO.findPending());
            req.setAttribute("recentViolations",  violDAO.findRecent(10));
            req.setAttribute("statsByType",       violDAO.countByType());
            req.setAttribute("statsByStatus",     violDAO.countByStatus());
            req.setAttribute("hotspots",          violDAO.findHotspots());
            req.setAttribute("pendingMonitors",   monitorDAO.findPending());
            req.setAttribute("allCases",          caseDAO.findAll());
        } catch (Exception e) {
            req.setAttribute("error", "Dashboard error: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}

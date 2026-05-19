package com.greenguard.controller.authority;

import com.greenguard.dao.EnforcementCaseDAO;
import com.greenguard.dao.NotificationDAO;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/authority/dashboard")
public class DashboardServlet extends HttpServlet {

    private final EnforcementCaseDAO caseDAO        = new EnforcementCaseDAO();
    private final NotificationDAO    notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        try {
            req.setAttribute("cases",          caseDAO.findByAuthority(user.getId()));
            req.setAttribute("totalAssigned",  caseDAO.countByAuthorityAndStatus(user.getId(), "ASSIGNED"));
            req.setAttribute("totalInvestig",  caseDAO.countByAuthorityAndStatus(user.getId(), "INVESTIGATING"));
            req.setAttribute("totalResolved",  caseDAO.countByAuthorityAndStatus(user.getId(), "RESOLVED"));
            req.setAttribute("notifications",  notificationDAO.findByUser(user.getId(), 10));
            req.setAttribute("unreadCount",    notificationDAO.countUnread(user.getId()));
            notificationDAO.markAllRead(user.getId());
        } catch (Exception e) {
            req.setAttribute("error", "Dashboard error: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/authority/dashboard.jsp").forward(req, resp);
    }
}

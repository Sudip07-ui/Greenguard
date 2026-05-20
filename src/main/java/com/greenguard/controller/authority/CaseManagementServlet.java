package com.greenguard.controller.authority;

import com.greenguard.dao.EnforcementCaseDAO;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/authority/cases")
public class CaseManagementServlet extends HttpServlet {

    private final EnforcementCaseDAO caseDAO = new EnforcementCaseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        String idParam = req.getParameter("id");

        try {
            if (idParam != null) {
                // Detail view
                int caseId = Integer.parseInt(idParam);
                com.greenguard.model.EnforcementCase ec = caseDAO.findById(caseId);
                if (ec == null || ec.getAuthorityId() != user.getId()) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                req.setAttribute("enforcementCase", ec);
                req.getRequestDispatcher("/WEB-INF/views/authority/case-detail.jsp").forward(req, resp);
            } else {
                // List view
                req.setAttribute("cases", caseDAO.findByAuthority(user.getId()));
                req.getRequestDispatcher("/WEB-INF/views/authority/cases.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error loading cases: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/authority/cases.jsp").forward(req, resp);
        }
    }
}

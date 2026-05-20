package com.greenguard.controller.citizen;

import com.greenguard.dao.EnforcementCaseDAO;
import com.greenguard.dao.ViolationDAO;
import com.greenguard.model.User;
import com.greenguard.model.Violation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


@WebServlet("/citizen/my-reports")
public class MyReportsServlet extends HttpServlet {

    private final ViolationDAO violationDAO = new ViolationDAO();
    private final EnforcementCaseDAO caseDAO = new EnforcementCaseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        try {
            List<Violation> reports = violationDAO.findByReporter(user.getId());
            req.setAttribute("reports", reports);

            // For each report, attach enforcement case if exists
            java.util.Map<Integer, com.greenguard.model.EnforcementCase> caseMap = new java.util.HashMap<>();
            for (Violation v : reports) {
                com.greenguard.model.EnforcementCase ec = caseDAO.findByViolation(v.getId());
                if (ec != null) caseMap.put(v.getId(), ec);
            }
            req.setAttribute("caseMap", caseMap);

            if ("reported".equals(req.getParameter("success"))) {
                req.setAttribute("success", "Your violation report has been submitted successfully!");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Could not load reports: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/citizen/my-reports.jsp").forward(req, resp);
    }
}

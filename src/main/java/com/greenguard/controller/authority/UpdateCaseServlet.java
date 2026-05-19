package com.greenguard.controller.authority;

import com.greenguard.dao.EnforcementCaseDAO;
import com.greenguard.dao.NotificationDAO;
import com.greenguard.dao.ViolationDAO;
import com.greenguard.model.EnforcementCase;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/authority/cases/update")
public class UpdateCaseServlet extends HttpServlet {

    private final EnforcementCaseDAO caseDAO        = new EnforcementCaseDAO();
    private final ViolationDAO       violationDAO   = new ViolationDAO();
    private final NotificationDAO    notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");

        try {
            int    caseId      = Integer.parseInt(req.getParameter("caseId"));
            String status      = req.getParameter("status");
            String notes       = req.getParameter("notes");
            String action      = req.getParameter("actionTaken");

            EnforcementCase ec = caseDAO.findById(caseId);
            if (ec == null || ec.getAuthorityId() != user.getId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            ec.setStatus(status);
            ec.setNotes(notes);
            ec.setActionTaken(action);
            caseDAO.update(ec);

            // Add timeline entry
            caseDAO.addTimeline(caseId, user.getId(),
                    "Status updated to " + status,
                    notes != null && !notes.isBlank() ? notes : action);

            // Sync violation status
            String violationStatus = mapCaseToViolationStatus(status);
            violationDAO.updateStatus(ec.getViolationId(), violationStatus);

            // Notify the original reporter
            notificationDAO.create(
                ec.getViolation().getReporterId(),
                "Your report status updated",
                "Your violation report #" + ec.getViolationId() + " is now: " + violationStatus,
                req.getContextPath() + "/citizen/my-reports"
            );

            resp.sendRedirect(req.getContextPath() + "/authority/cases?id=" + caseId + "&success=updated");

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/authority/cases?error=" +
                    java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private String mapCaseToViolationStatus(String caseStatus) {
        switch (caseStatus) {
            case "INVESTIGATING":  return "UNDER_REVIEW";
            case "ACTION_TAKEN":   return "IN_PROGRESS";
            case "RESOLVED":       return "RESOLVED";
            case "ESCALATED":      return "UNDER_REVIEW";
            default:               return "SUBMITTED";
        }
    }
}

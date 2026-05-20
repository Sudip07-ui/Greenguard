package com.greenguard.controller.admin;

import com.greenguard.dao.EnforcementCaseDAO;
import com.greenguard.dao.NotificationDAO;
import com.greenguard.dao.UserDAO;
import com.greenguard.dao.ViolationDAO;
import com.greenguard.model.Violation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/admin/violations")
public class AllViolationsServlet extends HttpServlet {

    private final ViolationDAO violationDAO =
            new ViolationDAO();

    private final EnforcementCaseDAO caseDAO =
            new EnforcementCaseDAO();

    private final UserDAO userDAO =
            new UserDAO();

    private final NotificationDAO notificationDAO =
            new NotificationDAO();

    // =====================================================
    // GET
    // =====================================================

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        String type =
                req.getParameter("type");

        String status =
                req.getParameter("status");

        String severity =
                req.getParameter("severity");

        int page =
                req.getParameter("page") != null
                        ? Integer.parseInt(
                        req.getParameter("page")
                )
                        : 1;

        int size = 20;

        try {

            List violations =
                    violationDAO.findAll(
                            type,
                            status,
                            severity,
                            page,
                            size
                    );

            int total =
                    violationDAO.countAll(
                            type,
                            status,
                            severity
                    );

            req.setAttribute(
                    "violations",
                    violations
            );

            req.setAttribute(
                    "total",
                    total
            );

            req.setAttribute(
                    "page",
                    page
            );

            req.setAttribute(
                    "totalPages",
                    (int) Math.ceil(
                            (double) total / size
                    )
            );

            req.setAttribute(
                    "filterType",
                    type
            );

            req.setAttribute(
                    "filterStatus",
                    status
            );

            req.setAttribute(
                    "filterSeverity",
                    severity
            );

            // Load active authorities
            req.setAttribute(
                    "authorities",

                    userDAO.findAll()
                            .stream()
                            .filter(u ->
                                    "AUTHORITY".equals(
                                            u.getRole()
                                    )
                                            &&
                                            "ACTIVE".equals(
                                                    u.getStatus()
                                            )
                            )
                            .collect(
                                    java.util.stream.Collectors
                                            .toList()
                            )
            );

        } catch (Exception e) {

            req.setAttribute(
                    "error",
                    "Error: " + e.getMessage()
            );
        }

        req.getRequestDispatcher(
                "/WEB-INF/views/admin/violations.jsp"
        ).forward(req, resp);
    }

    // =====================================================
    // POST
    // =====================================================

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        String action =
                req.getParameter("action");

        int violationId =
                Integer.parseInt(
                        req.getParameter("violationId")
                );

        try {

            // Find violation
            Violation violation =
                    violationDAO.findById(
                            violationId
                    );

            if (violation == null) {

                throw new Exception(
                        "Violation not found."
                );
            }

            // Citizen who submitted report
            int citizenId =
                    violation.getReporterId();

            // =================================================
            // ASSIGN CASE
            // =================================================

            if ("assign".equals(action)) {

                int authorityId =
                        Integer.parseInt(
                                req.getParameter(
                                        "authorityId"
                                )
                        );

                // Only assign once
                if (caseDAO.findByViolation(
                        violationId
                ) == null) {

                    // Create case
                    caseDAO.assign(
                            violationId,
                            authorityId
                    );

                    // Update status
                    violationDAO.updateStatus(
                            violationId,
                            "UNDER_REVIEW"
                    );

                    // -----------------------------------------
                    // Notify Authority
                    // -----------------------------------------

                    notificationDAO.create(
                            authorityId,

                            "New Case Assigned",

                            "A new violation case #"
                                    + violationId +
                                    " has been assigned to you.",

                            req.getContextPath() +
                                    "/authority/cases"
                    );

                    // -----------------------------------------
                    // Notify Citizen
                    // -----------------------------------------

                    notificationDAO.create(
                            citizenId,

                            "Report Under Review",

                            "Your report #"
                                    + violationId +
                                    " is now under review.",

                            req.getContextPath() +
                                    "/citizen/my-reports"
                    );
                }
            }

            // =================================================
            // CLOSE REPORT
            // =================================================

            else if ("close".equals(action)) {

                violationDAO.updateStatus(
                        violationId,
                        "CLOSED"
                );

                // Notify Citizen
                notificationDAO.create(
                        citizenId,

                        "Report Closed",

                        "Your report #"
                                + violationId +
                                " has been closed.",

                        req.getContextPath() +
                                "/citizen/my-reports"
                );
            }

            // =================================================
            // REJECT REPORT
            // =================================================

            else if ("reject".equals(action)) {

                violationDAO.updateStatus(
                        violationId,
                        "REJECTED"
                );

                // Notify Citizen
                notificationDAO.create(
                        citizenId,

                        "Report Rejected",

                        "Your report #"
                                + violationId +
                                " was rejected by administration.",

                        req.getContextPath() +
                                "/citizen/my-reports"
                );
            }

            // =================================================
            // SUCCESS REDIRECT
            // =================================================

            resp.sendRedirect(
                    req.getContextPath()
                            + "/admin/violations?success="
                            + action
            );

        } catch (Exception e) {

            e.printStackTrace();

            resp.sendRedirect(
                    req.getContextPath()
                            + "/admin/violations?error="
                            + URLEncoder.encode(
                            e.getMessage(),
                            "UTF-8"
                    )
            );
        }
    }
}
package com.greenguard.controller.citizen;

import com.greenguard.dao.NotificationDAO;
import com.greenguard.dao.UserDAO;
import com.greenguard.dao.ViolationDAO;
import com.greenguard.model.User;
import com.greenguard.model.Violation;
import com.greenguard.util.DBUtil;
import com.greenguard.util.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/citizen/report")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 15 * 1024 * 1024,
        maxRequestSize = 50 * 1024 * 1024
)
public class ReportViolationServlet extends HttpServlet {

    private final ViolationDAO violationDAO =
            new ViolationDAO();

    private final NotificationDAO notificationDAO =
            new NotificationDAO();

    private final UserDAO userDAO =
            new UserDAO();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher(
                "/WEB-INF/views/citizen/report.jsp"
        ).forward(req, resp);
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        User user =
                (User) req.getSession()
                        .getAttribute("user");

        if(user == null){

            resp.sendRedirect(
                    req.getContextPath()
                            + "/login"
            );

            return;
        }

        String type =
                req.getParameter("type");

        String title =
                req.getParameter("title");

        String description =
                req.getParameter("description");

        String locationName =
                req.getParameter("locationName");

        String latStr =
                req.getParameter("latitude");

        String lngStr =
                req.getParameter("longitude");

        String severity =
                req.getParameter("severity");

        if(isBlank(type)
                || isBlank(title)
                || isBlank(description)
                || isBlank(locationName)){

            req.setAttribute(
                    "error",
                    "Type, title, description and location are required."
            );

            req.getRequestDispatcher(
                    "/WEB-INF/views/citizen/report.jsp"
            ).forward(req,resp);

            return;
        }

        try{

            Part photo =
                    req.getPart("photo");

            if(photo != null &&
                    photo.getSize() >
                            15 * 1024 * 1024){

                req.setAttribute(
                        "error",
                        "Image too large. Max 15MB."
                );

                req.getRequestDispatcher(
                        "/WEB-INF/views/citizen/report.jsp"
                ).forward(req,resp);

                return;
            }

            String uploadDir =
                    getServletContext()
                            .getRealPath("/")
                            + "uploads/violations";

            String photoUrl =
                    FileUploadUtil.savePhoto(
                            photo,
                            uploadDir
                    );

            Violation v =
                    new Violation();

            v.setReporterId(
                    user.getId()
            );

            v.setType(type);

            v.setTitle(
                    title.trim()
            );

            v.setDescription(
                    description.trim()
            );

            v.setLocationName(
                    locationName.trim()
            );

            v.setLatitude(
                    latStr != null &&
                            !latStr.isEmpty()
                            ? Double.parseDouble(latStr)
                            : 0.0
            );

            v.setLongitude(
                    lngStr != null &&
                            !lngStr.isEmpty()
                            ? Double.parseDouble(lngStr)
                            : 0.0
            );

            v.setPhotoUrl(
                    photoUrl
            );

            v.setSeverity(
                    severity != null
                            ? severity
                            : "MEDIUM"
            );

            int newId =
                    violationDAO.create(v);

            if(newId > 0){

                /*
                 Notify all admins
                */

                String sql =
                        "SELECT id FROM users " +
                                "WHERE role='ADMIN'";

                try(
                        Connection c =
                                DBUtil.getConnection();

                        PreparedStatement ps =
                                c.prepareStatement(sql);

                        ResultSet rs =
                                ps.executeQuery()
                ){

                    while(rs.next()){

                        int adminId =
                                rs.getInt("id");

                        notificationDAO.create(

                                adminId,

                                "New Violation Report",

                                "A new violation \"" +
                                        title +
                                        "\" was reported by "
                                        + user.getFullName(),

                                req.getContextPath()
                                        + "/admin/violations"
                        );
                    }
                }

                /*
                 Notify reporter
                */

                notificationDAO.create(

                        user.getId(),

                        "Report Submitted",

                        "Your report \"" +
                                title +
                                "\" submitted successfully.",

                        req.getContextPath()
                                + "/citizen/my-reports"
                );

                resp.sendRedirect(
                        req.getContextPath()
                                + "/citizen/my-reports?success=reported"
                );

            } else {

                req.setAttribute(
                        "error",
                        "Failed to submit report."
                );

                req.getRequestDispatcher(
                        "/WEB-INF/views/citizen/report.jsp"
                ).forward(req,resp);
            }

        }
        catch(Exception e){

            e.printStackTrace();

            req.setAttribute(
                    "error",
                    "Error: " + e.getMessage()
            );

            req.getRequestDispatcher(
                    "/WEB-INF/views/citizen/report.jsp"
            ).forward(req,resp);
        }
    }

    private boolean isBlank(String s){

        return s == null ||
                s.trim().isEmpty();
    }
}
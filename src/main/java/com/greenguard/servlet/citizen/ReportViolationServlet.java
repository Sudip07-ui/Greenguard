package com.greenguard.servlet.citizen;

import com.greenguard.dao.NotificationDAO;
import com.greenguard.dao.ViolationDAO;
import com.greenguard.model.User;
import com.greenguard.model.Violation;
import com.greenguard.util.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


@WebServlet("/citizen/report")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 15 * 1024 * 1024,      // 15MB per image
        maxRequestSize = 50 * 1024 * 1024    // multiple files support
)
public class ReportViolationServlet extends HttpServlet {

    private final ViolationDAO    violationDAO    = new ViolationDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/citizen/report.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");

        String type         = req.getParameter("type");
        String title        = req.getParameter("title");
        String description  = req.getParameter("description");
        String locationName = req.getParameter("locationName");
        String latStr       = req.getParameter("latitude");
        String lngStr       = req.getParameter("longitude");
        String severity     = req.getParameter("severity");

        // Validation
        if (isBlank(type) || isBlank(title) || isBlank(description) || isBlank(locationName)) {
            req.setAttribute("error", "Type, title, description and location are required.");
            req.getRequestDispatcher("/WEB-INF/views/citizen/report.jsp").forward(req, resp);
            return;
        }

        try {
            // Handle photo upload
            Part photo = req.getPart("photo");

            if (photo.getSize() > 15 * 1024 * 1024) {
                req.setAttribute("error", "Image too large. Max allowed is 15MB.");
                req.getRequestDispatcher("/upload.jsp").forward(req, resp);
                return;
            }
            String uploadDir = getServletContext().getRealPath("/") + "uploads/violations";
            String photoUrl  = FileUploadUtil.savePhoto(photo, uploadDir);

            Violation v = new Violation();
            v.setReporterId(user.getId());
            v.setType(type);
            v.setTitle(title.trim());
            v.setDescription(description.trim());
            v.setLocationName(locationName.trim());
            v.setLatitude(latStr  != null && !latStr.isEmpty()  ? Double.parseDouble(latStr)  : 0.0);
            v.setLongitude(lngStr != null && !lngStr.isEmpty()  ? Double.parseDouble(lngStr)  : 0.0);
            v.setPhotoUrl(photoUrl);
            v.setSeverity(severity != null ? severity : "MEDIUM");

            int newId = violationDAO.create(v);

            if (newId > 0) {
                resp.sendRedirect(req.getContextPath() + "/citizen/my-reports?success=reported");
            } else {
                req.setAttribute("error", "Failed to submit report. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/citizen/report.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error submitting report: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/citizen/report.jsp").forward(req, resp);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}

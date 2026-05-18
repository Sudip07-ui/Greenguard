package com.greenguard.controller.admin;

import com.greenguard.dao.NotificationDAO;
import com.greenguard.dao.UserDAO;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            req.setAttribute("users", userDAO.findAll());
            req.setAttribute("pendingUsers", userDAO.findPending());

        } catch (Exception e) {

            req.setAttribute(
                    "error",
                    "Error loading users: " + e.getMessage()
            );
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {

            switch (action) {

                // =====================================
                // ADD USER BY ADMIN
                // =====================================
                case "addUser": {

                    String fullName = req.getParameter("fullName");
                    String email = req.getParameter("email");
                    String phone = req.getParameter("phone");
                    String password = req.getParameter("password");
                    String role = req.getParameter("role");

                    // ADMIN CREATED USERS = ACTIVE
                    String status = "ACTIVE";

                    // Validation
                    if (isBlank(fullName)
                            || isBlank(email)
                            || isBlank(password)
                            || isBlank(role)) {

                        throw new Exception(
                                "Full name, email, password and role are required."
                        );
                    }

                    if (password.length() < 8) {

                        throw new Exception(
                                "Password must be at least 8 characters."
                        );
                    }

                    // Duplicate Email Check
                    if (userDAO.findByEmail(email.trim()) != null) {

                        throw new Exception(
                                "This email is already registered."
                        );
                    }

                    User user = new User();

                    user.setFullName(fullName.trim());

                    user.setEmail(
                            email.trim().toLowerCase()
                    );

                    user.setPhone(
                            phone != null
                                    ? phone.trim()
                                    : null
                    );

                    // plain password
                    // DAO hashes it
                    user.setPasswordHash(password);

                    user.setRole(role);

                    // FORCE ACTIVE
                    user.setStatus(status);

                    // IMPORTANT:
                    // use createByAdmin()
                    boolean created = userDAO.createByAdmin(user);

                    if (!created) {

                        throw new Exception(
                                "Failed to create user."
                        );
                    }

                    // Fetch created user
                    User createdUser = userDAO.findByEmail(
                            email.trim().toLowerCase()
                    );

                    // Send notification
                    if (createdUser != null) {

                        notificationDAO.create(
                                createdUser.getId(),
                                "Account Created",
                                "Your GreenGuard account has been created by the administrator.",
                                null
                        );
                    }

                    break;
                }

                // =====================================
                // APPROVE USER
                // =====================================
                case "approve": {

                    int userId = Integer.parseInt(
                            req.getParameter("userId")
                    );

                    userDAO.updateStatus(
                            userId,
                            "ACTIVE"
                    );

                    notificationDAO.create(
                            userId,
                            "Account Approved",
                            "Your GreenGuard account has been approved. You can now log in!",
                            null
                    );

                    break;
                }

                // =====================================
                // SUSPEND USER
                // =====================================
                case "suspend": {

                    int userId = Integer.parseInt(
                            req.getParameter("userId")
                    );

                    userDAO.updateStatus(
                            userId,
                            "SUSPENDED"
                    );

                    break;
                }

                // =====================================
                // ACTIVATE USER
                // =====================================
                case "activate": {

                    int userId = Integer.parseInt(
                            req.getParameter("userId")
                    );

                    userDAO.updateStatus(
                            userId,
                            "ACTIVE"
                    );

                    break;
                }
            }

            resp.sendRedirect(
                    req.getContextPath()
                            + "/admin/users?success="
                            + action
            );

        } catch (Exception e) {

            resp.sendRedirect(
                    req.getContextPath()
                            + "/admin/users?error="
                            + java.net.URLEncoder.encode(
                            e.getMessage(),
                            "UTF-8"
                    )
            );
        }
    }

    private boolean isBlank(String s) {

        return s == null || s.trim().isEmpty();
    }
}
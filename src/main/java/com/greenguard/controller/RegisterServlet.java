package com.greenguard.controller;

import com.greenguard.dao.UserDAO;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName        = req.getParameter("fullName");
        String email           = req.getParameter("email");
        String phone           = req.getParameter("phone");
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validation
        if (isBlank(fullName) || isBlank(email) || isBlank(password)) {
            req.setAttribute("error", "Full name, email and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 8) {
            req.setAttribute("error", "Password must be at least 8 characters.");
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            return;
        }

        try {
            // Check duplicate email
            if (userDAO.findByEmail(email.trim()) != null) {
                req.setAttribute("error", "This email is already registered.");
                req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
                return;
            }

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPhone(phone != null ? phone.trim() : null);
            user.setPasswordHash(password); // DAO will hash it

            boolean created = userDAO.register(user);
            if (created) {
                req.setAttribute("success", "Registration successful! Your account is pending admin approval.");
                req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "A system error occurred: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/common/register.jsp").forward(req, resp);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}

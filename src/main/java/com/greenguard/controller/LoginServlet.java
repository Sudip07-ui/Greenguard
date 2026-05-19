package com.greenguard.controller;

import com.greenguard.dao.UserDAO;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Already logged in → redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            redirectToDashboard((User) session.getAttribute("user"), resp, req);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.authenticate(email.trim(), password);
            if (user == null) {
                req.setAttribute("error", "Invalid credentials or account not yet approved.");
                req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 min

            redirectToDashboard(user, resp, req);

        } catch (Exception e) {
            req.setAttribute("error", "A system error occurred. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/common/login.jsp").forward(req, resp);
        }
    }

    private void redirectToDashboard(User user, HttpServletResponse resp, HttpServletRequest req)
            throws IOException {
        String ctx = req.getContextPath();
        switch (user.getRole()) {
            case "ADMIN":     resp.sendRedirect(ctx + "/admin/dashboard");     break;
            case "AUTHORITY": resp.sendRedirect(ctx + "/authority/dashboard"); break;
            default:          resp.sendRedirect(ctx + "/citizen/dashboard");   break;
        }
    }
}

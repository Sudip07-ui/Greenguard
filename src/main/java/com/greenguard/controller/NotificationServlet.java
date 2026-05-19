package com.greenguard.controller;

import com.greenguard.dao.NotificationDAO;
import com.greenguard.model.Notification;
import com.greenguard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );
            return;
        }

        User user =
                (User) session.getAttribute("user");

        try {

            List<Notification> notifications =
                    notificationDAO.findByUser(
                            user.getId(),
                            20
                    );

            int unreadCount =
                    notificationDAO.countUnread(
                            user.getId()
                    );

            request.setAttribute(
                    "notifications",
                    notifications
            );

            request.setAttribute(
                    "unreadCount",
                    unreadCount
            );

            request.setAttribute(
                    "pageTitle",
                    "Notifications"
            );

            notificationDAO.markAllRead(
                    user.getId()
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/common/notifications.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Error loading notifications",
                    e
            );
        }
    }
}
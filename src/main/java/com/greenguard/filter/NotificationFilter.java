package com.greenguard.filter;

import com.greenguard.dao.NotificationDAO;
import com.greenguard.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebFilter("/*")
public class NotificationFilter implements Filter {

    private NotificationDAO notificationDAO;

    @Override
    public void init(FilterConfig filterConfig) {
        notificationDAO = new NotificationDAO();
    }

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpSession session =
                req.getSession(false);

        if (session != null &&
                session.getAttribute("user") != null) {

            User user =
                    (User) session.getAttribute("user");

            try {

                int unreadCount =
                        notificationDAO.countUnread(
                                user.getId()
                        );

                req.setAttribute(
                        "unreadCount",
                        unreadCount
                );

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        chain.doFilter(
                request,
                response
        );
    }
}
package com.greenguard.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AuthFilter – blocks unauthenticated access to /citizen/*, /authority/*, /admin/*
 */
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        if (!loggedIn) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" +
                    request.getRequestURI());
        } else {
            chain.doFilter(req, res);
        }
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}

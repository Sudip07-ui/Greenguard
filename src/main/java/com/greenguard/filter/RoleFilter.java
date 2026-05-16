package com.greenguard.filter;

import com.greenguard.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * RoleFilter – enforces that users can only access paths matching their role.
 * /citizen/*   → CITIZEN (or ADMIN)
 * /authority/* → AUTHORITY (or ADMIN)
 * /admin/*     → ADMIN only
 */
public class RoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        if (session == null) { chain.doFilter(req, res); return; }

        User user = (User) session.getAttribute("user");
        if (user == null) { chain.doFilter(req, res); return; }

        String path = request.getServletPath();
        String role = user.getRole();

        boolean allowed;
        if (path.startsWith("/admin/")) {
            allowed = "ADMIN".equals(role);
        } else if (path.startsWith("/authority/")) {
            allowed = "AUTHORITY".equals(role) || "ADMIN".equals(role);
        } else if (path.startsWith("/citizen/")) {
            allowed = "CITIZEN".equals(role) || "ADMIN".equals(role);
        } else {
            allowed = true;
        }

        if (!allowed) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You don't have permission to access this page.");
        } else {
            chain.doFilter(req, res);
        }
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}

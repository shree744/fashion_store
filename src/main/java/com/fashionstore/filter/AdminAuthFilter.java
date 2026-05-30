package com.fashionstore.filter;

import com.fashionstore.model.Admin;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin-*")
public class AdminAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();

        // Allow access to admin login and register pages without auth
        if (uri.endsWith("/admin-login") || uri.endsWith("/admin-register")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            res.sendRedirect(req.getContextPath() + "/admin-login");
        } else {
            chain.doFilter(request, response);
        }
    }
}

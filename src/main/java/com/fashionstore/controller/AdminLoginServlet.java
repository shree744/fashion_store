package com.fashionstore.controller;

import com.fashionstore.dao.AdminDAO;
import com.fashionstore.dao.impl.AdminDAOImpl;
import com.fashionstore.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin") != null) {
            response.sendRedirect("admin-dashboard");
            return;
        }
        // Redirect to the unified login page with admin tab active
        response.sendRedirect("login");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Admin admin = adminDAO.loginAdmin(email, password);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.removeAttribute("user"); // Ensure user is cleared when admin logs in
            session.setAttribute("admin", admin);
            response.sendRedirect("admin-dashboard");
        } else {
            request.setAttribute("adminError", "Invalid admin credentials");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}

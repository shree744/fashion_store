package com.fashionstore.controller;

import com.fashionstore.dao.AdminDAO;
import com.fashionstore.dao.impl.AdminDAOImpl;
import com.fashionstore.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin-register")
public class AdminRegisterServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/views/admin/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("WEB-INF/views/admin/register.jsp").forward(request, response);
            return;
        }

        if (adminDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("WEB-INF/views/admin/register.jsp").forward(request, response);
            return;
        }

        Admin admin = new Admin();
        admin.setFullName(fullName);
        admin.setEmail(email);
        admin.setPassword(password);
        admin.setPhone(phone);

        if (adminDAO.registerAdmin(admin)) {
            request.setAttribute("success", "Admin account created! Please login.");
            request.getRequestDispatcher("WEB-INF/views/admin/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("WEB-INF/views/admin/register.jsp").forward(request, response);
        }
    }
}

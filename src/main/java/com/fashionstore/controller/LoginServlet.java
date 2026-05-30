package com.fashionstore.controller;

import com.fashionstore.dao.UserDAO;
import com.fashionstore.dao.impl.UserDAOImpl;
import com.fashionstore.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null) {
            email = email.trim().toLowerCase();
        }
        if (password != null) {
            password = password.trim();
        }

        User user = userDAO.loginUser(email, password);

        if (user != null) {

            // ✅ CREATE SESSION
            HttpSession session = request.getSession();
            session.removeAttribute("admin"); // Ensure admin is cleared when user logs in
            session.setAttribute("user", user);

            // ✅ NO CART IN SESSION (DB handles it)
            response.sendRedirect("products");

        } else {

            request.setAttribute("error", "Invalid credentials");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
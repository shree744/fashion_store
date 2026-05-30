package com.fashionstore.controller;

import com.fashionstore.dao.UserDAO;
import com.fashionstore.dao.impl.UserDAOImpl;
import com.fashionstore.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAOImpl();

    // ✅ FIX: OPEN REGISTER PAGE
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
               .forward(request, response);
    }

    // ✅ REGISTER LOGIC
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = new User();

        user.setFullName(request.getParameter("name"));
        String email = request.getParameter("email");
        user.setEmail(email != null ? email.trim().toLowerCase() : null);
        user.setPassword(request.getParameter("password"));
        user.setPhone(request.getParameter("phone"));
        user.setAddressLine1(request.getParameter("address1"));
        user.setAddressLine2(request.getParameter("address2"));
        user.setCity(request.getParameter("city"));
        user.setState(request.getParameter("state"));
        user.setPincode(request.getParameter("pincode"));
        user.setCountry(request.getParameter("country"));

        boolean status = userDAO.registerUser(user);

        if (status) {
            response.sendRedirect("login");
        } else {
            request.setAttribute("error", "Registration Failed");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                   .forward(request, response);
        }
    }
}
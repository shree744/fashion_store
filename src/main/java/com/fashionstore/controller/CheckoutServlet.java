package com.fashionstore.controller;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.dao.impl.CartDAOImpl;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int userId = user.getUserId();

        // ✅ FETCH CART FROM DB
        List<CartItem> cartList = cartDAO.getCartItemsByUserId(userId);

        double total = 0;
        for (CartItem item : cartList) {
            total += item.getTotalPrice();
        }

        // ✅ SEND TO JSP
        request.setAttribute("cart", cartList);
        request.setAttribute("total", total);
        request.setAttribute("user", user);

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp")
               .forward(request, response);
    }
}
package com.fashionstore.controller;

import com.fashionstore.dao.impl.CartDAOImpl;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.User;


import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private CartDAOImpl cartDAO = new CartDAOImpl();

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


        String action = request.getParameter("action");

        // ✅ ADD
        if ("add".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect("product-details?id=" + request.getParameter("productId")); // Fallback if possible
                return;
            }

            int variantId = Integer.parseInt(idParam);
            String qtyStr = request.getParameter("qty");
            int qty = (qtyStr != null) ? Integer.parseInt(qtyStr) : 1;
            
            cartDAO.addToCart(userId, variantId, qty, "");

            session.setAttribute("msg", "Item added successfully");
            response.sendRedirect("cart");
            return;
        }



        // ✅ REMOVE
        if ("remove".equals(action)) {
            int variantId = Integer.parseInt(request.getParameter("id"));
            cartDAO.removeFromCart(userId, variantId);

            session.setAttribute("msg", "Item removed");
            response.sendRedirect("cart");
            return;
        }

        // ✅ UPDATE
        if ("update".equals(action)) {
            int variantId = Integer.parseInt(request.getParameter("id"));
            int qty = Integer.parseInt(request.getParameter("qty"));

            cartDAO.updateQuantity(userId, variantId, qty);

            session.setAttribute("msg", "Cart updated");
            response.sendRedirect("cart");
            return;
        }

        // ✅ VIEW CART
        List<CartItem> cart = cartDAO.getCartItemsByUserId(userId);

        double total = 0;
        for (CartItem c : cart) {
            total += c.getTotalPrice();
        }

        request.setAttribute("cart", cart);
        request.setAttribute("total", total);

        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }
}
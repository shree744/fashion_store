package com.fashionstore.controller;

import com.fashionstore.dao.impl.CartItemDAOImpl;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/order-confirm")
public class OrderConfirmationServlet extends HttpServlet {

    private CartItemDAOImpl cartDAO = new CartItemDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int userId = user.getUserId();

        // ✅ GET CART FROM DB
        List<CartItem> cart = cartDAO.getCartItems(userId);

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        double total = 0;
        for (CartItem item : cart) {
            total += item.getTotalPrice();
        }

        // ✅ DUMMY ORDER DETAILS (you can replace with DB later)
        int orderId = (int) (Math.random() * 10000);
        String orderDate = LocalDateTime.now().toString();
        String payment = "COD";
        String status = "PLACED";

        // ✅ STORE IN SESSION
        session.setAttribute("orderId", orderId);
        session.setAttribute("orderDate", orderDate);
        session.setAttribute("payment", payment);
        session.setAttribute("status", status);
        session.setAttribute("total", total);

        // user details
        session.setAttribute("userDetails", user);

        // clear cart
        cartDAO.clearCart(userId);

        response.sendRedirect("order-success");
    }
}
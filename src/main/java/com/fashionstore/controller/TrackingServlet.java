package com.fashionstore.controller;

import com.fashionstore.dao.OrderDAO;
import com.fashionstore.dao.impl.OrderDAOImpl;
import com.fashionstore.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/track-order")
public class TrackingServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);
        if (order != null) {
            request.setAttribute("order", order);
            request.getRequestDispatcher("WEB-INF/views/order-tracking.jsp").forward(request, response);
        } else {
            response.sendRedirect("order-history");
        }
    }
}

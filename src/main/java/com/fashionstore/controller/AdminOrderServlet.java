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
import java.util.List;

@WebServlet("/admin-orders")
public class AdminOrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        request.setAttribute("admin", session.getAttribute("admin"));

        List<Order> list = orderDAO.getAllOrders();
        request.setAttribute("orders", list);
        request.getRequestDispatcher("WEB-INF/views/admin/orders.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        request.setAttribute("admin", session.getAttribute("admin"));

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        
        if (orderDAO.updateOrderStatus(orderId, status)) {
            // 📧 Trigger Customer Email Notification
            final int finalOrderId = orderId;
            final String finalStatus = status;

            new Thread(() -> {
                try {
                    Order order = orderDAO.getOrderById(finalOrderId);
                    if (order != null) {
                        com.fashionstore.dao.UserDAO userDAO = new com.fashionstore.dao.impl.UserDAOImpl();
                        com.fashionstore.model.User user = userDAO.getUserById(order.getUserId());
                        
                        if (user != null && user.getEmail() != null) {
                            String subject = "Order Status Updated - Order #" + finalOrderId;
                            String message = "Your order status has been updated.";
                            
                            if ("Shipped".equalsIgnoreCase(finalStatus)) {
                                message = "Great news! Your order has been shipped and is on its way.";
                            } else if ("Delivered".equalsIgnoreCase(finalStatus)) {
                                message = "Your order has been successfully delivered. We hope you love your purchase!";
                            } else if ("Cancelled".equalsIgnoreCase(finalStatus)) {
                                message = "Your order has been cancelled as per your request or due to unforeseen circumstances.";
                            }

                            String body = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd;'>" +
                                    "<h2>Hello " + user.getFullName() + ",</h2>" +
                                    "<p>The status of your order <strong>#" + finalOrderId + "</strong> has been updated to: <span style='color: #e67e22; font-weight: bold;'>" + finalStatus.toUpperCase() + "</span></p>" +
                                    "<p>" + message + "</p>" +
                                    "<br><p>Thank you for shopping with Fashion Store!</p>" +
                                    "</div>";

                            com.fashionstore.util.EmailUtil.sendEmail(user.getEmail(), subject, body);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }).start();

            response.getWriter().write("SUCCESS");
        } else {
            response.getWriter().write("FAILURE");
        }
    }
}

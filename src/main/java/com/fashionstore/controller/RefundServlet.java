package com.fashionstore.controller;

import com.fashionstore.dao.RefundDAO;
import com.fashionstore.dao.impl.RefundDAOImpl;
import com.fashionstore.model.Refund;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/refund")
public class RefundServlet extends HttpServlet {
    private RefundDAO refundDAO = new RefundDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("view".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            List<Refund> refunds = refundDAO.getRefundsByOrderId(orderId);
            request.setAttribute("refunds", refunds);
            request.getRequestDispatcher("WEB-INF/views/refund-tracker.jsp").forward(request, response);
        } else if ("admin-list".equals(action)) {
            List<Refund> list = refundDAO.getAllRefunds();
            request.setAttribute("refunds", list);
            request.getRequestDispatcher("WEB-INF/views/admin/refunds.jsp").forward(request, response);
        } else if ("view_all".equals(action)) {
            com.fashionstore.model.User user = (com.fashionstore.model.User) request.getSession().getAttribute("user");
            System.out.println("DEBUG: view_all action triggered. User from session: " + (user != null ? user.getUserId() : "NULL"));
            if (user != null) {
                List<Refund> refunds = refundDAO.getRefundsByUserId(user.getUserId());
                System.out.println("DEBUG: Refunds found for user " + user.getUserId() + ": " + (refunds != null ? refunds.size() : "NULL"));
                request.setAttribute("refunds", refunds);
                request.getRequestDispatcher("WEB-INF/views/refund-tracker.jsp").forward(request, response);
            } else {
                System.out.println("DEBUG: No user in session, redirecting to login.");
                response.sendRedirect("login");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("request".equals(action)) {
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("orderId"));
            } catch (NumberFormatException e) {
                response.sendRedirect("order-history?error=Invalid+order");
                return;
            }
            String reason = request.getParameter("reason");
            if (reason == null || reason.trim().isEmpty()) {
                response.sendRedirect("order-history?error=Reason+is+required");
                return;
            }

            // Duplicate check: prevent re-submission if refund already exists for this order
            List<Refund> existing = refundDAO.getRefundsByOrderId(orderId);
            if (existing != null && !existing.isEmpty()) {
                System.out.println("DEBUG: Duplicate refund prevented for order " + orderId);
                response.sendRedirect("order-history?error=Refund+already+requested+for+this+order");
                return;
            }

            Refund r = new Refund();
            r.setOrderId(orderId);
            r.setReason(reason.trim());
            System.out.println("DEBUG: Refund request for order " + r.getOrderId() + " with reason: " + r.getReason());
            if (refundDAO.requestRefund(r)) {
                System.out.println("DEBUG: Refund request saved successfully.");
                response.sendRedirect("order-history");
            } else {
                System.out.println("DEBUG: Failed to save refund request.");
                response.sendRedirect("order-history?error=Failed+to+request+refund");
            }
        } else if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("refundId"));
                String status = request.getParameter("status");
                if (refundDAO.updateRefundStatus(id, status)) {
                    if ("Refunded".equalsIgnoreCase(status)) {
                        Refund refund = refundDAO.getRefundById(id);
                        if (refund != null) {
                            com.fashionstore.dao.OrderDAO orderDAO = new com.fashionstore.dao.impl.OrderDAOImpl();
                            com.fashionstore.model.Order order = orderDAO.getOrderById(refund.getOrderId());
                            if (order != null) {
                                com.fashionstore.dao.RewardDAO rewardDAO = new com.fashionstore.dao.impl.RewardDAOImpl();
                                rewardDAO.removeOrderReward(order.getUserId(), order.getOrderId());
                            }
                        }
                    }
                    response.sendRedirect("refund?action=admin-list&success=Refund+status+updated+successfully");
                } else {
                    response.sendRedirect("refund?action=admin-list&error=Failed+to+update+refund+status");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("refund?action=admin-list&error=Invalid+request+parameters");
            }
        }
    }
}

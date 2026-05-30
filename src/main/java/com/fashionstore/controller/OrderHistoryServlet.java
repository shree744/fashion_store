package com.fashionstore.controller;

import com.fashionstore.dao.OrderDAO;
import com.fashionstore.dao.impl.OrderDAOImpl;
import com.fashionstore.model.Order;
import com.fashionstore.model.User;
import com.fashionstore.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/order-history", "/faq"})
public class OrderHistoryServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String servletPath = request.getServletPath();
        boolean faqMode = "/faq".equals(servletPath);
        request.setAttribute("faqMode", faqMode);

        if (faqMode) {
            request.setAttribute("faqItems", loadFaqItems());
        } else {
            List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());
            request.setAttribute("orders", orders);
        }

        String error = request.getParameter("error");
        String success = request.getParameter("success");
        if (error != null) request.setAttribute("errorMsg", error);
        if (success != null) request.setAttribute("successMsg", success);

        request.getRequestDispatcher("WEB-INF/views/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/faq".equals(servletPath)) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }

            String questionText = request.getParameter("questionText");
            if (questionText == null || questionText.trim().isEmpty()) {
                response.sendRedirect("faq?error=Please+enter+a+valid+question.");
                return;
            }

            if (saveQuestion(user.getUserId(), questionText.trim())) {
                response.sendRedirect("faq?success=Question+submitted+successfully.");
            } else {
                response.sendRedirect("faq?error=Failed+to+submit+your+question. Please+try+again.");
            }
        } else {
            response.sendRedirect("order-history");
        }
    }

    private boolean saveQuestion(int userId, String questionText) {
        String insertFaq = "INSERT INTO faq (user_id, question_text, status) VALUES (?, ?, 'Pending')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(insertFaq)) {
            ps.setInt(1, userId);
            ps.setString(2, questionText);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private List<Map<String, Object>> loadFaqItems() {
        List<Map<String, Object>> faqItems = new ArrayList<>();
        String query = "SELECT question_id, user_id, question_text, answer_text, status, created_at FROM faq ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("question_id", rs.getInt("question_id"));
                item.put("user_id", rs.getInt("user_id"));
                item.put("question_text", rs.getString("question_text"));
                item.put("answer_text", rs.getString("answer_text"));
                item.put("status", rs.getString("status"));
                item.put("created_at", rs.getTimestamp("created_at"));
                faqItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return faqItems;
    }

}


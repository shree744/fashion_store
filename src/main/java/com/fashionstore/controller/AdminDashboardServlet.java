package com.fashionstore.controller;

import com.fashionstore.dao.OrderDAO;
import com.fashionstore.dao.ProductDAO;
import com.fashionstore.dao.UserDAO;
import com.fashionstore.dao.impl.OrderDAOImpl;
import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.dao.impl.UserDAOImpl;
import com.fashionstore.model.Order;
import com.fashionstore.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/admin-dashboard", "/admin-faq"})
public class AdminDashboardServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAOImpl();
    private OrderDAO orderDAO = new OrderDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Ensure admin object is available for the sidebar
        com.fashionstore.model.Admin admin = (com.fashionstore.model.Admin) session.getAttribute("admin");
        request.setAttribute("admin", admin);

        String servletPath = request.getServletPath();
        String action = request.getParameter("action");

        if ("getSalesData".equals(action)) {
            response.setContentType("application/json");
            String dateParam = request.getParameter("date");
            String viewType = request.getParameter("viewType");
            
            if (dateParam == null || dateParam.trim().isEmpty()) {
                dateParam = java.time.LocalDate.now().toString();
            }
            if (viewType == null || viewType.trim().isEmpty()) {
                viewType = "weekly";
            }
            
            List<String> labels = new ArrayList<>();
            List<Double> data = new ArrayList<>();
            
            if ("daily".equalsIgnoreCase(viewType)) {
                data = getDailySalesData(dateParam);
                java.time.LocalDate selectedDate = java.time.LocalDate.parse(dateParam);
                java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd MMM");
                String datePrefix = selectedDate.format(formatter) + " ";
                for (int i = 0; i < 24; i++) {
                    if (i == 0) {
                        labels.add(datePrefix + "12 AM");
                    } else if (i < 12) {
                        labels.add(datePrefix + i + " AM");
                    } else if (i == 12) {
                        labels.add(datePrefix + "12 PM");
                    } else {
                        labels.add(datePrefix + (i - 12) + " PM");
                    }
                }
            } else {
                java.time.LocalDate selectedDate = java.time.LocalDate.parse(dateParam);
                java.time.LocalDate monday = selectedDate.with(java.time.DayOfWeek.MONDAY);
                for (int i = 0; i < 7; i++) {
                    labels.add(monday.plusDays(i).toString());
                }
                
                Map<String, Double> weeklySalesMap = getWeeklySalesDataMap(monday.toString(), monday.plusDays(7).toString());
                for (String dateLabel : labels) {
                    data.add(weeklySalesMap.getOrDefault(dateLabel, 0.0));
                }
            }
            
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"labels\":[");
            for (int i = 0; i < labels.size(); i++) {
                json.append("\"").append(labels.get(i)).append("\"");
                if (i < labels.size() - 1) json.append(",");
            }
            json.append("],");
            json.append("\"data\":[");
            for (int i = 0; i < data.size(); i++) {
                json.append(data.get(i));
                if (i < data.size() - 1) json.append(",");
            }
            json.append("]");
            json.append("}");
            
            response.getWriter().write(json.toString());
            return;
        }

        List<Order> allOrders = orderDAO.getAllOrders();
        
        // Filter for active, successful orders (exclude Cancelled and Refunded)
        List<Order> successfulOrders = allOrders.stream()
            .filter(o -> !"Cancelled".equalsIgnoreCase(o.getOrderStatus()) 
                      && !"Refunded".equalsIgnoreCase(o.getOrderStatus())
                      && !"Refunded".equalsIgnoreCase(o.getRefundStatus()))
            .toList();

        double totalRevenue = successfulOrders.stream()
            .mapToDouble(Order::getTotalAmount)
            .sum();

        request.setAttribute("totalProducts", productDAO.getAllProducts().size());
        request.setAttribute("totalOrders", successfulOrders.size()); // Count only successful orders
        request.setAttribute("totalUsers", userDAO.getAllUsers().size());
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", allOrders.subList(0, Math.min(allOrders.size(), 5)));

        if ("/admin-faq".equals(servletPath)) {
            request.setAttribute("faqMode", true);
            request.setAttribute("faqItems", loadFaqItems());
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            if (error != null) request.setAttribute("error", error);
            if (success != null) request.setAttribute("success", success);
        }

        request.getRequestDispatcher("WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/admin-faq".equals(servletPath)) {
            String action = request.getParameter("action");
            if ("answer".equals(action)) {
                String questionId = request.getParameter("questionId");
                String answerText = request.getParameter("answerText");
                if (questionId != null && answerText != null && !answerText.trim().isEmpty()) {
                    saveFaqAnswer(questionId, answerText.trim());
                    response.sendRedirect("admin-faq?success=Answer+saved+successfully.");
                    return;
                }
            }
        }
        response.sendRedirect("admin-dashboard");
    }

    private Map<String, Double> getWeeklySalesDataMap(String startDate, String endDate) {
        Map<String, Double> salesMap = new HashMap<>();
        String query = "SELECT DATE(o.order_date) as order_day, SUM(o.total_amount) as total " +
                       "FROM orders o " +
                       "LEFT JOIN refunds r ON o.order_id = r.order_id " +
                       "WHERE o.order_date >= ? " +
                       "AND o.order_date < ? " +
                       "AND o.order_status NOT IN ('Cancelled', 'Refunded') " +
                       "AND (r.status IS NULL OR r.status != 'Refunded') " +
                       "GROUP BY order_day";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.sql.Date orderDay = rs.getDate("order_day");
                    if (orderDay != null) {
                        salesMap.put(orderDay.toString(), rs.getDouble("total"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return salesMap;
    }

    private List<Double> getDailySalesData(String dateStr) {
        List<Double> sales = new ArrayList<>();
        for (int i = 0; i < 24; i++) sales.add(0.0);

        // Query to get sales grouped by hour for the specified date
        String query = "SELECT HOUR(o.order_date) as hour, SUM(o.total_amount) as total " +
                       "FROM orders o " +
                       "LEFT JOIN refunds r ON o.order_id = r.order_id " +
                       "WHERE o.order_date >= ? AND o.order_date <= ? " +
                       "AND o.order_status NOT IN ('Cancelled', 'Refunded') " +
                       "AND (r.status IS NULL OR r.status != 'Refunded') " +
                       "GROUP BY hour";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, dateStr + " 00:00:00");
            ps.setString(2, dateStr + " 23:59:59");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int hour = rs.getInt("hour");
                    double total = rs.getDouble("total");
                    if (hour >= 0 && hour < 24) {
                        sales.set(hour, total);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sales;
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

    private void saveFaqAnswer(String questionId, String answerText) {
        String update = "UPDATE faq SET answer_text = ?, status = 'Answered' WHERE question_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(update)) {
            ps.setString(1, answerText);
            ps.setInt(2, Integer.parseInt(questionId));
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}


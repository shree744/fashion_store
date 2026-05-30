package com.fashionstore.controller;

import com.fashionstore.dao.RewardDAO;
import com.fashionstore.dao.impl.RewardDAOImpl;
import com.fashionstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/claim-reward")
public class RewardServlet extends HttpServlet {
    private RewardDAO rewardDAO = new RewardDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("LOGIN_REQUIRED");
            return;
        }

        String action = request.getParameter("action");

        // Handle clearing the reward toast (called by JS after showing it)
        if ("clear-toast".equals(action)) {
            session.removeAttribute("rewardEarned");
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        // Default: claim daily reward
        if (rewardDAO.claimDailyReward(user.getUserId())) {
            response.getWriter().write("SUCCESS");
        } else {
            response.getWriter().write("ALREADY_CLAIMED");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int userId = user.getUserId();

        // Sync any delivered orders that don't yet have a reward history entry
        rewardDAO.syncMissingOrderRewards(userId);

        request.setAttribute("reward", rewardDAO.getRewardByUserId(userId));
        request.setAttribute("rewardHistory", rewardDAO.getRewardHistory(userId));
        request.getRequestDispatcher("WEB-INF/views/rewards.jsp").forward(request, response);
    }
}

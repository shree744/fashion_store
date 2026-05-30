package com.fashionstore.controller;

import com.fashionstore.dao.ReviewDAO;
import com.fashionstore.dao.impl.ReviewDAOImpl;
import com.fashionstore.model.Review;
import com.fashionstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/submit-review")
public class ReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO = new ReviewDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        if (reviewDAO.hasUserReviewed(user.getUserId(), productId)) {
            session.setAttribute("errorMsg", "You have already reviewed this product.");
        } else {
            Review review = new Review();
            review.setProductId(productId);
            review.setUserId(user.getUserId());
            review.setRating(rating);
            review.setComment(comment);

            if (reviewDAO.addReview(review)) {
                session.setAttribute("succMsg", "Review submitted successfully!");
            } else {
                session.setAttribute("errorMsg", "Something went wrong on server.");
            }
        }

        response.sendRedirect("product-details?id=" + productId);
    }
}

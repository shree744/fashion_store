package com.fashionstore.controller;

import com.fashionstore.dao.CouponDAO;
import com.fashionstore.dao.impl.CouponDAOImpl;
import com.fashionstore.model.Coupon;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin-coupons")
public class AdminCouponServlet extends HttpServlet {
    private CouponDAO couponDAO = new CouponDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        request.setAttribute("admin", session.getAttribute("admin"));

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            couponDAO.deleteCoupon(id);
            response.sendRedirect("admin-coupons");
        } else {
            List<Coupon> list = couponDAO.getAllCoupons();
            request.setAttribute("coupons", list);
            request.getRequestDispatcher("WEB-INF/views/admin/coupons.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        Coupon c = new Coupon();
        c.setCode(request.getParameter("code"));
        c.setDiscountType(request.getParameter("type"));
        c.setDiscountValue(Double.parseDouble(request.getParameter("value")));
        c.setExpiryDate(Date.valueOf(request.getParameter("expiry")));
        c.setUsageLimit(Integer.parseInt(request.getParameter("limit")));

        if ("update".equals(action)) {
            c.setCouponId(Integer.parseInt(request.getParameter("id")));
            if (couponDAO.updateCoupon(c)) {
                response.sendRedirect("admin-coupons?success=Coupon+updated+successfully");
            } else {
                response.sendRedirect("admin-coupons?error=Failed+to+update+coupon");
            }
        } else {
            if (couponDAO.addCoupon(c)) {
                response.sendRedirect("admin-coupons?success=Coupon+added+successfully");
            } else {
                response.sendRedirect("admin-coupons?error=Failed+to+add+coupon");
            }
        }
    }
}

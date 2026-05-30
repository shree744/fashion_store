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

@WebServlet("/apply-coupon")
public class CouponServlet extends HttpServlet {
    private CouponDAO couponDAO = new CouponDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        Coupon coupon = couponDAO.getCouponByCode(code);

        if (coupon != null && coupon.isValid()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"SUCCESS\", \"type\":\"" + coupon.getDiscountType() + "\", \"value\":" + coupon.getDiscountValue() + ", \"id\":" + coupon.getCouponId() + "}");
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"INVALID\"}");
        }
    }
}

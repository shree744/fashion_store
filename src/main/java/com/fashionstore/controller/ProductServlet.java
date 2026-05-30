package com.fashionstore.controller;

import com.fashionstore.dao.CategoryDAO;
import com.fashionstore.dao.impl.CategoryDAOImpl;
import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.model.Category;
import com.fashionstore.model.Product;
import com.fashionstore.model.Coupon;
import com.fashionstore.dao.CouponDAO;
import com.fashionstore.dao.impl.CouponDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private ProductDAOImpl dao = new ProductDAOImpl();
    private CategoryDAO categoryDAO = new CategoryDAOImpl();
    private CouponDAO couponDAO = new CouponDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String categoryStr = request.getParameter("categoryId");
        String minStr = request.getParameter("min");
        String maxStr = request.getParameter("max");
        String sort = request.getParameter("sort");

        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }

        Integer categoryId = null;
        Double min = null;
        Double max = null;

        try {
            if (categoryStr != null && !categoryStr.isEmpty())
                categoryId = Integer.parseInt(categoryStr);

            if (minStr != null && !minStr.isEmpty())
                min = Double.parseDouble(minStr);

            if (maxStr != null && !maxStr.isEmpty())
                max = Double.parseDouble(maxStr);

        } catch (Exception e) {
            e.printStackTrace();
        }

        List<Product> products =
                dao.filterProducts(categoryId, keyword, min, max, sort);

        List<Category> categories = categoryDAO.getAllCategories();

        List<Coupon> coupons = couponDAO.getAllCoupons();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("coupons", coupons);

        request.getRequestDispatcher("/WEB-INF/views/products.jsp")
                .forward(request, response);
    }
}
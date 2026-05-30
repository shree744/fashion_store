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
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CategoryDAO categoryDAO;
    private ProductDAOImpl productDAO;
    private CouponDAO couponDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAOImpl();
        productDAO = new ProductDAOImpl();
        couponDAO = new CouponDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 🔹 Fetch categories
            List<Category> categories = categoryDAO.getAllCategories();

            // 🔹 Fetch latest products
            List<Product> latestProducts = productDAO.getLatestProducts(8);

            // 🔹 Fetch distinct brands
            List<String> brands = productDAO.getAllBrands();

            // 🔹 DEBUG (VERY IMPORTANT)
            System.out.println("Latest Products Count: " + 
                (latestProducts != null ? latestProducts.size() : 0));

            // 🔹 Fetch coupons
            List<Coupon> coupons = couponDAO.getAllCoupons();

            // 🔹 Set attributes
            request.setAttribute("categories", categories);
            request.setAttribute("latestProducts", latestProducts);
            request.setAttribute("brands", brands);
            request.setAttribute("coupons", coupons);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 🔹 Forward
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/WEB-INF/views/home.jsp");

        dispatcher.forward(request, response);
    }
}
package com.fashionstore.controller;

import com.fashionstore.dao.ProductDAO;
import com.fashionstore.dao.ProductVariantDAO;
import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.dao.impl.ProductVariantDAOImpl;
import com.fashionstore.model.Product;
import com.fashionstore.model.ProductVariant;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/product-details")
public class ProductDetailServlet extends HttpServlet {


    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO = new ProductDAOImpl();
    private ProductVariantDAO variantDAO = new ProductVariantDAOImpl();
    private com.fashionstore.dao.ReviewDAO reviewDAO = new com.fashionstore.dao.impl.ReviewDAOImpl();
    private com.fashionstore.dao.ProductImageDAO imageDAO = new com.fashionstore.dao.impl.ProductImageDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        Product product = productDAO.getProductById(id);

        if (product == null) {
            request.setAttribute("error", "Product not found");
        } else {
            List<ProductVariant> variants = variantDAO.getVariantsByProductId(id);
            if (variants != null && !variants.isEmpty()) {
                variants.sort((v1, v2) -> {
                    String s1 = v1.getSize();
                    String s2 = v2.getSize();
                    List<String> clothesOrder = java.util.Arrays.asList("XS", "S", "M", "L", "XL", "XXL");
                    if (clothesOrder.contains(s1) && clothesOrder.contains(s2)) {
                        return Integer.compare(clothesOrder.indexOf(s1), clothesOrder.indexOf(s2));
                    }
                    try {
                        return Integer.compare(Integer.parseInt(s1), Integer.parseInt(s2));
                    } catch (NumberFormatException e) {
                        return s1.compareTo(s2);
                    }
                });
            }
            request.setAttribute("variants", variants);
            request.setAttribute("reviews", reviewDAO.getReviewsByProductId(id));
            request.setAttribute("productImages", imageDAO.getImagesByProductId(id));
            
            // Recommendation logic (existing) - keeping it simple for now as per requirement
            request.setAttribute("recommendedProducts", productDAO.getLatestProducts(4));
        }

        request.setAttribute("product", product);
        request.getRequestDispatcher("/WEB-INF/views/product-details.jsp").forward(request, response);
    }
}
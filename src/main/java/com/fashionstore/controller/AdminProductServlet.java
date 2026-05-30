package com.fashionstore.controller;

import com.fashionstore.dao.ProductDAO;
import com.fashionstore.dao.ProductVariantDAO;
import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.dao.impl.ProductVariantDAOImpl;
import com.fashionstore.model.Product;
import com.fashionstore.model.ProductVariant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-products")
public class AdminProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAOImpl();
    private ProductVariantDAO variantDAO = new ProductVariantDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        request.setAttribute("admin", session.getAttribute("admin"));

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (productDAO.deleteProduct(id)) {
                    response.sendRedirect("admin-products?success=Product+deleted+successfully");
                } else {
                    response.sendRedirect("admin-products?error=Failed+to+delete+product");
                }
            } catch (Exception e) {
                response.sendRedirect("admin-products?error=Error+deleting+product:+Product+might+have+existing+orders");
            }
        } else {
            List<Product> list = productDAO.getAllProducts();
            for (Product p : list) {
                p.setVariants(variantDAO.getVariantsByProductId(p.getProductId()));
            }
            request.setAttribute("products", list);
            request.getRequestDispatcher("WEB-INF/views/admin/products.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        Product p = new Product();
        p.setProductName(request.getParameter("name"));
        p.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        p.setBrand(request.getParameter("brand"));
        p.setDescription(request.getParameter("description"));
        p.setPrice(Double.parseDouble(request.getParameter("price")));
        p.setImageUrl(request.getParameter("imageUrl"));
        p.setActive("true".equals(request.getParameter("active")));

        if ("add".equals(action)) {
            int productId = productDAO.addProduct(p);
            if (productId > 0) {
                String[] sizes = request.getParameterValues("sizes");
                int stock = Integer.parseInt(request.getParameter("stock"));
                
                if (sizes != null) {
                    for (String size : sizes) {
                        ProductVariant v = new ProductVariant();
                        v.setProductId(productId);
                        v.setSize(size);
                        v.setColor(null);
                        v.setStockQuantity(stock);
                        variantDAO.addVariant(v);
                    }
                }
                response.sendRedirect("admin-products?success=Product+added+with+" + (sizes != null ? sizes.length : 0) + "+sizes");
            } else {
                response.sendRedirect("admin-products?error=Failed+to+add+product");
            }
        } else if ("update".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("id"));
            p.setProductId(productId);
            if (productDAO.updateProduct(p)) {
                // Sync sizes
                String[] selectedSizes = request.getParameterValues("sizes");
                String stockParam = request.getParameter("stock");
                int stock = (stockParam != null && !stockParam.isEmpty()) ? Integer.parseInt(stockParam) : 0;

                if (selectedSizes != null) {
                    List<ProductVariant> currentVariants = variantDAO.getVariantsByProductId(productId);
                    java.util.Map<String, ProductVariant> currentVariantMap = new java.util.HashMap<>();
                    for (ProductVariant v : currentVariants) currentVariantMap.put(v.getSize().trim(), v);

                    java.util.Set<String> newSizeNames = new java.util.HashSet<>();
                    for (String s : selectedSizes) newSizeNames.add(s.trim());

                    // Process all selected sizes
                    for (String size : selectedSizes) {
                        String trimmedSize = size.trim();
                        if (currentVariantMap.containsKey(trimmedSize)) {
                            // Update existing size with new fixed stock
                            ProductVariant existing = currentVariantMap.get(trimmedSize);
                            existing.setStockQuantity(stock);
                            variantDAO.updateVariant(existing);
                        } else {
                            // Create new size with fixed stock
                            ProductVariant v = new ProductVariant();
                            v.setProductId(productId);
                            v.setSize(trimmedSize);
                            v.setStockQuantity(stock);
                            variantDAO.addVariant(v);
                        }
                    }

                    // Remove deselected sizes
                    for (ProductVariant v : currentVariants) {
                        if (!newSizeNames.contains(v.getSize().trim())) {
                            variantDAO.deleteVariant(v.getVariantId());
                        }
                    }
                }
                response.sendRedirect("admin-products?success=Product+updated+successfully");
            } else {
                response.sendRedirect("admin-products?error=Failed+to+update+product");
            }
        }
    }
}

package com.fashionstore.controller;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.dao.OrderDAO;
import com.fashionstore.dao.OrderItemDAO;
import com.fashionstore.dao.impl.CartDAOImpl;
import com.fashionstore.dao.impl.OrderDAOImpl;
import com.fashionstore.dao.impl.OrderItemDAOImpl;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.Order;
import com.fashionstore.model.OrderItem;
import com.fashionstore.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/place-order")
public class OrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAOImpl();
    private OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
    private CartDAO cartDAO = new CartDAOImpl();
    private com.fashionstore.dao.ProductVariantDAO variantDAO = new com.fashionstore.dao.impl.ProductVariantDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<CartItem> cartItems = cartDAO.getCartItemsByUserId(user != null ? user.getUserId() : 0);

        if (user == null || cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        double total = 0;
        for (CartItem item : cartItems) {
            total += item.getTotalPrice();
        }

        // Apply discount if coupon was applied
        String appliedCouponCode = request.getParameter("appliedCouponCode");
        int appliedCouponId = 0;
        if (appliedCouponCode != null && !appliedCouponCode.isEmpty()) {
            com.fashionstore.dao.CouponDAO couponDAO = new com.fashionstore.dao.impl.CouponDAOImpl();
            com.fashionstore.model.Coupon coupon = couponDAO.getCouponByCode(appliedCouponCode);
            if (coupon != null && coupon.isValid()) {
                double discount = 0;
                if ("PERCENTAGE".equalsIgnoreCase(coupon.getDiscountType())) {
                    discount = (total * coupon.getDiscountValue()) / 100;
                } else {
                    discount = coupon.getDiscountValue();
                }
                total -= discount;
                appliedCouponId = coupon.getCouponId();
            }
        }

        // Only Cash on Delivery is supported
        String paymentMethod = "COD";

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setTotalAmount(total);
        order.setPaymentMethod(paymentMethod);
        order.setOrderStatus("Ordered");
        order.setTrackingStatus("Ordered");
        
        // Estimated delivery: today + 5 days
        java.time.LocalDate estDate = java.time.LocalDate.now().plusDays(5);
        order.setEstimatedDeliveryDate(estDate.toString());

        order.setDeliveryName(request.getParameter("name") != null ? request.getParameter("name") : user.getFullName());
        order.setDeliveryPhone(request.getParameter("phone") != null ? request.getParameter("phone") : user.getPhone());
        order.setDeliveryAddressLine1(request.getParameter("address1") != null ? request.getParameter("address1") : user.getAddressLine1());
        order.setDeliveryAddressLine2(request.getParameter("address2") != null ? request.getParameter("address2") : user.getAddressLine2());
        order.setDeliveryCity(request.getParameter("city") != null ? request.getParameter("city") : user.getCity());
        order.setDeliveryState(request.getParameter("state") != null ? request.getParameter("state") : user.getState());
        order.setDeliveryPincode(request.getParameter("pincode") != null ? request.getParameter("pincode") : user.getPincode());
        order.setDeliveryCountry(request.getParameter("country") != null ? request.getParameter("country") : user.getCountry());

        int orderId = orderDAO.placeOrder(order);

        if (orderId > 0) {
            List<OrderItem> itemsToSave = new ArrayList<>();
            for (CartItem ci : cartItems) {
                OrderItem oi = new OrderItem();
                oi.setOrderId(orderId);
                oi.setVariantId(ci.getVariantId());
                oi.setQuantity(ci.getQuantity());
                oi.setPrice(ci.getProduct().getPrice());
                itemsToSave.add(oi);
                
                // Deduct Stock
                com.fashionstore.model.ProductVariant variant = variantDAO.getVariantById(ci.getVariantId());
                if (variant != null) {
                    variantDAO.updateStock(variant.getVariantId(), variant.getStockQuantity() - ci.getQuantity());
                }
            }
            
            boolean itemsSaved = orderItemDAO.addOrderItems(itemsToSave);

            if (itemsSaved) {
                cartDAO.clearCart(user.getUserId());
                session.removeAttribute("cart");

                // Update coupon usage if one was applied
                if (appliedCouponId > 0) {
                    com.fashionstore.dao.CouponDAO couponDAO = new com.fashionstore.dao.impl.CouponDAOImpl();
                    couponDAO.updateCouponUsage(appliedCouponId);
                }

                // Award reward points for this order
                com.fashionstore.dao.RewardDAO rewardDAO = new com.fashionstore.dao.impl.RewardDAOImpl();
                boolean rewarded = rewardDAO.addOrderReward(user.getUserId(), orderId, total);
                if (rewarded) {
                    int earnedPoints = Math.max(5, (int)(total / 100));
                    if (total >= 5000) earnedPoints += 25;
                    else if (total >= 2000) earnedPoints += 10;
                    else if (total >= 1000) earnedPoints += 5;
                    session.setAttribute("rewardEarned", earnedPoints);
                }

                session.setAttribute("orderId", orderId);
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a");
                sdf.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Kolkata"));
                session.setAttribute("orderDate", sdf.format(new java.util.Date()));
                session.setAttribute("payment", paymentMethod);
                session.setAttribute("status", "Confirmed");
                session.setAttribute("total", total);
                session.setAttribute("userDetails", user);

                // 📧 Trigger Admin Email Notification
                final String adminEmail = "admin@fashionstore.com"; // Can be moved to config
                final int finalOrderId = orderId;
                final User finalUser = user;
                final double finalTotal = total;
                final List<CartItem> finalItems = new ArrayList<>(cartItems);
                final String finalPayment = paymentMethod;

                new Thread(() -> {
                    try {
                        StringBuilder itemHtml = new StringBuilder();
                        itemHtml.append("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                        itemHtml.append("<tr style='background-color: #f2f2f2;'><th>Product</th><th>Qty</th><th>Price</th></tr>");
                        for (CartItem ci : finalItems) {
                            itemHtml.append("<tr>")
                                    .append("<td>").append(ci.getProduct().getProductName()).append("</td>")
                                    .append("<td>").append(ci.getQuantity()).append("</td>")
                                    .append("<td>₹").append(ci.getProduct().getPrice()).append("</td>")
                                    .append("</tr>");
                        }
                        itemHtml.append("</table>");

                        String body = "<h2>New Order Received!</h2>" +
                                "<p><strong>Order ID:</strong> #" + finalOrderId + "</p>" +
                                "<p><strong>Customer:</strong> " + finalUser.getFullName() + "</p>" +
                                "<p><strong>Phone:</strong> " + finalUser.getPhone() + "</p>" +
                                "<p><strong>Address:</strong> " + finalUser.getAddressLine1() + ", " + finalUser.getCity() + "</p>" +
                                "<h3>Order Items:</h3>" + itemHtml.toString() +
                                "<p><strong>Total Amount:</strong> ₹" + finalTotal + "</p>" +
                                "<p><strong>Payment Method:</strong> " + finalPayment + "</p>" +
                                "<br><p>Log in to admin panel to manage this order.</p>";

                        com.fashionstore.util.EmailUtil.sendEmail(adminEmail, "New Order Received - Order #" + finalOrderId, body);
                    } catch (Exception e) {
                        e.printStackTrace(); // Log but don't break flow
                    }
                }).start();

                response.sendRedirect("order-success");
            } else {
                request.setAttribute("error", "Failed to save order items.");
                request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Failed to place order.");
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        }
    }
}
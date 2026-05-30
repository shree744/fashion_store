<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Track Order #${order.orderId} | FashionStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #6366f1; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; }
        body { font-family: 'Outfit', sans-serif; background: #0f172a; color: var(--text); margin: 0; min-height: 100vh; }
        .container { max-width: 800px; margin: 80px auto; padding: 2rem; }
        .card { background: var(--card-bg); backdrop-filter: blur(12px); border-radius: 24px; border: 1px solid rgba(255,255,255,0.1); padding: 2rem; }
        
        .tracking-timeline { position: relative; margin: 3rem 0; padding-left: 50px; }
        .tracking-timeline::before { content: ''; position: absolute; left: 20px; top: 0; bottom: 0; width: 2px; background: rgba(255,255,255,0.1); }
        .step { position: relative; margin-bottom: 2rem; }
        .step::before { content: ''; position: absolute; left: -38px; top: 5px; width: 14px; height: 14px; border-radius: 50%; background: #334155; border: 4px solid #0f172a; z-index: 1; }
        .step.active::before { background: var(--primary); box-shadow: 0 0 15px var(--primary); }
        .step.completed::before { background: #4ade80; }
        .step-content h3 { margin: 0; font-size: 1.1rem; }
        .step-content p { margin: 0; color: #94a3b8; font-size: 0.9rem; }
    </style>
</head>
<body>
    <%@ include file="partials/navbar.jsp" %>
    <div class="container">
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2rem;">
                <div>
                    <h1>Order #${order.orderId}</h1>
                    <p style="color: #94a3b8;">Placed on <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a" timeZone="Asia/Kolkata" /></p>
                </div>
                <div style="text-align: right;">
                    <p style="color: #94a3b8;">Estimated Delivery</p>
                    <h2 style="color: #4ade80;">${order.estimatedDeliveryDate}</h2>
                </div>
            </div>

            <div class="tracking-timeline">
                <div class="step ${order.trackingStatus == 'Ordered' ? 'active' : 'completed'}">
                    <div class="step-content">
                        <h3>Order Placed</h3>
                        <p>We have received your order.</p>
                    </div>
                </div>
                <div class="step ${order.trackingStatus == 'Packed' ? 'active' : (order.trackingStatus == 'Shipped' || order.trackingStatus == 'Out for Delivery' || order.trackingStatus == 'Delivered' ? 'completed' : '')}">
                    <div class="step-content">
                        <h3>Packed</h3>
                        <p>Your item has been packed and is ready for shipment.</p>
                    </div>
                </div>
                <div class="step ${order.trackingStatus == 'Shipped' ? 'active' : (order.trackingStatus == 'Out for Delivery' || order.trackingStatus == 'Delivered' ? 'completed' : '')}">
                    <div class="step-content">
                        <h3>Shipped</h3>
                        <p>Your order is on its way.</p>
                    </div>
                </div>
                <div class="step ${order.trackingStatus == 'Out for Delivery' ? 'active' : (order.trackingStatus == 'Delivered' ? 'completed' : '')}">
                    <div class="step-content">
                        <h3>Out for Delivery</h3>
                        <p>Our delivery partner is nearby.</p>
                    </div>
                </div>
                <div class="step ${order.trackingStatus == 'Delivered' ? 'completed' : ''}">
                    <div class="step-content">
                        <h3>Delivered</h3>
                        <p>Order successfully delivered.</p>
                    </div>
                </div>
            </div>

            <div style="background: rgba(255,255,255,0.03); padding: 1.5rem; border-radius: 15px; border: 1px solid rgba(255,255,255,0.05);">
                <h3>Shipping Address</h3>
                <p style="color: #cbd5e1; line-height: 1.6;">
                    ${order.deliveryName}<br>
                    ${order.deliveryAddressLine1}, ${order.deliveryAddressLine2}<br>
                    ${order.deliveryCity}, ${order.deliveryState} - ${order.deliveryPincode}<br>
                    ${order.deliveryCountry}<br>
                    Phone: ${order.deliveryPhone}
                </p>
            </div>

            <c:if test="${not empty order.refundStatus}">
                <div style="margin-top: 2rem; background: rgba(99, 102, 241, 0.05); padding: 1.5rem; border-radius: 15px; border: 1px solid rgba(99, 102, 241, 0.2);">
                    <h3 style="color: #818cf8; margin-top: 0;">Refund Status</h3>
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <span style="padding: 6px 16px; border-radius: 20px; font-weight: 700; background: rgba(99, 102, 241, 0.2); color: #818cf8; text-transform: uppercase; font-size: 0.9rem;">
                            ${order.refundStatus}
                        </span>
                        <p style="margin: 0; color: #94a3b8;">Your refund request is currently being <strong>${order.refundStatus.toLowerCase()}</strong>.</p>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>

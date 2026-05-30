<%@ page import="com.fashionstore.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - Fashion Store</title>

    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        :root {
            --primary: #6366f1;
            --secondary: #a855f7;
            --accent: #22d3ee;
            --bg: #0f172a;
            --card-bg: rgba(30, 41, 59, 0.7);
            --text: #f8fafc;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: radial-gradient(circle at top right, #1e1b4b, #0f172a);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .success-card {
            max-width: 600px;
            width: 100%;
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 32px;
            padding: 50px;
            text-align: center;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        .tick-container {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #22c55e, #10b981);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            font-size: 50px;
            color: white;
            box-shadow: 0 10px 20px rgba(16, 185, 129, 0.3);
            animation: scaleIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
        }

        h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 12px;
            color: #fff;
        }

        .subtitle {
            color: #94a3b8;
            margin-bottom: 40px;
            line-height: 1.6;
        }

        .order-info {
            background: rgba(255, 255, 255, 0.03);
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 30px;
            text-align: left;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 15px;
        }

        .info-row span:first-child {
            color: #94a3b8;
        }

        .info-row span:last-child {
            font-weight: 600;
            color: #fff;
        }

        .info-row.total {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 18px;
        }

        .info-row.total span:last-child {
            color: var(--accent);
            font-size: 22px;
        }

        .delivery-details {
            text-align: left;
            margin-bottom: 40px;
            padding: 0 10px;
        }

        .delivery-details h3 {
            font-size: 18px;
            margin-bottom: 12px;
            color: #cbd5e1;
        }

        .delivery-details p {
            color: #94a3b8;
            font-size: 14px;
            line-height: 1.5;
        }

        .btn-home {
            display: block;
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            text-decoration: none;
            border-radius: 16px;
            font-weight: 700;
            font-size: 18px;
            transition: 0.3s;
            box-shadow: 0 10px 20px -10px rgba(99, 102, 241, 0.5);
        }

        .btn-home:hover {
            transform: translateY(-3px);
            filter: brightness(1.1);
        }

        .reward-toast {
            position: fixed;
            top: 30px;
            right: 30px;
            background: linear-gradient(135deg, #f59e0b, #d97706);
            padding: 18px 28px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            gap: 14px;
            box-shadow: 0 15px 35px rgba(245,158,11,0.35);
            animation: slideInRight 0.6s cubic-bezier(0.175,0.885,0.32,1.275), fadeOutUp 0.5s ease 4s forwards;
            z-index: 1000;
            color: white;
            font-weight: 600;
        }
        .reward-toast .icon {
            font-size: 28px;
            animation: bounce 0.6s ease 0.5s;
        }
        .reward-toast .pts {
            font-size: 22px;
            font-weight: 700;
        }
        .reward-toast .label {
            font-size: 13px;
            opacity: 0.9;
        }
        @keyframes slideInRight {
            from { transform: translateX(120%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @keyframes fadeOutUp {
            to { transform: translateY(-30px); opacity: 0; pointer-events: none; }
        }
        @keyframes bounce {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.3); }
        }

        .reward-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, rgba(245,158,11,0.15), rgba(217,119,6,0.15));
            border: 1px solid rgba(245,158,11,0.3);
            padding: 10px 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            color: #fbbf24;
            font-weight: 600;
            animation: scaleIn 0.5s ease 0.3s both;
        }
    </style>
</head>

<body>

<div class="success-card">
    <div class="tick-container">✓</div>
    <h1>Thank You For Your Order!</h1>

    <%
        Integer rewardEarned = (Integer) session.getAttribute("rewardEarned");
        if (rewardEarned != null && rewardEarned > 0) {
    %>
    <div class="reward-badge">
        🎁 You earned <strong><%= rewardEarned %> reward points</strong> with this order!
    </div>
    <% session.removeAttribute("rewardEarned"); } %>

    <p class="subtitle">Your order has been placed successfully. We'll send you an email confirmation shortly.</p>

    <div class="order-info">
        <div class="info-row">
            <span>Order Number</span>
            <span>#<%= session.getAttribute("orderId") %></span>
        </div>
        <div class="info-row">
            <span>Date</span>
            <span><%= session.getAttribute("orderDate") %></span>
        </div>
        <div class="info-row">
            <span>Payment Method</span>
            <span>💵 Cash on Delivery</span>
        </div>
        <div class="info-row">
            <span>Order Status</span>
            <span style="color: #22c55e;"><%= session.getAttribute("status") %></span>
        </div>
        <div class="info-row total">
            <span>Total Amount</span>
            <span>₹ <%= session.getAttribute("total") %></span>
        </div>
    </div>

    <%
        User u = (User) session.getAttribute("userDetails");
        if (u != null) {
    %>
    <div class="delivery-details">
        <h3>Shipping to:</h3>
        <p><strong><%= u.getFullName() %></strong></p>
        <p><%= u.getAddressLine1() %></p>
        <% if(u.getAddressLine2() != null && !u.getAddressLine2().isEmpty()) { %>
            <p><%= u.getAddressLine2() %></p>
        <% } %>
        <p><%= u.getCity() %>, <%= u.getState() %> - <%= u.getPincode() %></p>
        <p><%= u.getCountry() %></p>
    </div>
    <% } %>

    <a href="${pageContext.request.contextPath}/products" class="btn-home">Continue Shopping</a>
</div>

<%
    Integer rp = (Integer) session.getAttribute("rewardEarned");
    if (rp != null && rp > 0) {
%>
<div class="reward-toast">
    <span class="icon">🏆</span>
    <div>
        <div class="pts">+<%= rp %> Points</div>
        <div class="label">Reward points earned!</div>
    </div>
</div>
<% } %>

</body>
</html>

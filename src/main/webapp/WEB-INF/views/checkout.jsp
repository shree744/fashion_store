<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.CartItem" %>
<%@ page import="com.fashionstore.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%!
    // HTML-escape to prevent quotes/special chars from breaking value attributes
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;").replace("'", "&#39;");
    }
%>
<%
    List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
    Double total = (Double) request.getAttribute("total");
    User user = (User) request.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Fashion Store</title>

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
        }

        .checkout-container {
            max-width: 1100px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .checkout-header {
            text-align: center;
            margin-bottom: 50px;
        }

        h1 {
            font-size: 42px;
            font-weight: 700;
            background: linear-gradient(to right, #fff, #94a3b8);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;

        }

        .checkout-layout {
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 40px;
        }

        @media (max-width: 992px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }
        }

        /* SECTION STYLING */
        .checkout-section {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 30px;
            margin-bottom: 30px;
        }

        h2 {
            font-size: 22px;
            margin-bottom: 24px;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* FORM STYLING */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group.full {
            grid-column: span 2;
        }

        label {
            display: block;
            font-size: 14px;
            color: #94a3b8;
            margin-bottom: 8px;
        }

        input {
            width: 100%;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: #fff;
            font-size: 15px;
            outline: none;
        }

        input[readonly] {
            cursor: not-allowed;
            color: #cbd5e1;
        }

        /* ORDER SUMMARY BOX */
        .order-summary-box {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding-bottom: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .item-name {
            font-weight: 600;
            font-size: 16px;
        }

        .item-meta {
            font-size: 13px;
            color: #94a3b8;
        }

        .item-price {
            font-weight: 700;
            color: var(--accent);
        }

        .total-row {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid rgba(255, 255, 255, 0.1);
            display: flex;
            justify-content: space-between;
            font-size: 24px;
            font-weight: 700;
        }

        /* BUTTON */
        .place-order-btn {
            display: block;
            width: 100%;
            padding: 20px;
            margin-top: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            border: none;
            border-radius: 18px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 15px 25px -10px rgba(99, 102, 241, 0.5);
        }

        .place-order-btn:hover {
            transform: translateY(-4px);
            filter: brightness(1.1);
            box-shadow: 0 20px 30px -10px rgba(99, 102, 241, 0.6);
        }

        .payment-options {
            display: flex;
            gap: 20px;
            margin-top: 10px;
        }

        .payment-option {
            flex: 1;
            padding: 12px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }
    </style>
</head>

<body>

<%@ include file="partials/navbar.jsp" %>

<div class="checkout-container">
    <div class="checkout-header">
        <h1>Complete Your Order</h1>
    </div>

    <div class="checkout-layout">
        <!-- LEFT: DELIVERY DETAILS -->
        <div class="left-column">
            <form id="orderForm" action="${pageContext.request.contextPath}/place-order" method="post">
                <div class="checkout-section">
                    <h2>Delivery Information</h2>
                    <div class="form-grid">
                        <div class="form-group full">
                            <label>Full Name</label>
                            <input type="text" name="name" value="<%= esc(user.getFullName()) %>" required>
                        </div>
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="text" value="<%= esc(user.getEmail()) %>" readonly>
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phone" value="<%= esc(user.getPhone()) %>" required>
                        </div>
                        <div class="form-group full">
                            <label>Address Line 1</label>
                            <input type="text" name="address1" value="<%= esc(user.getAddressLine1()) %>" required>
                        </div>
                        <div class="form-group full">
                            <label>Address Line 2</label>
                            <input type="text" name="address2" value="<%= esc(user.getAddressLine2()) %>">
                        </div>
                        <div class="form-group">
                            <label>City</label>
                            <input type="text" name="city" value="<%= esc(user.getCity()) %>" required>
                        </div>
                        <div class="form-group">
                            <label>State</label>
                            <input type="text" name="state" value="<%= esc(user.getState()) %>" required>
                        </div>
                        <div class="form-group">
                            <label>Pincode</label>
                            <input type="text" name="pincode" value="<%= esc(user.getPincode()) %>" required>
                        </div>
                        <div class="form-group">
                            <label>Country</label>
                            <input type="text" name="country" value="<%= esc(user.getCountry()) %>" required>
                        </div>
                    </div>
                </div>

                <div class="checkout-section">
                    <h2>Payment Method</h2>
                    <input type="hidden" name="paymentMethod" value="COD">
                    <input type="hidden" name="appliedCouponCode" id="appliedCouponCode" value="">
                    <div class="payment-options">
                        <div class="payment-option" style="flex: 1; border-color: rgba(34, 211, 238, 0.4); background: rgba(34, 211, 238, 0.08);">
                            <span style="font-size: 24px;">💵</span>
                            <div>
                                <span style="font-weight: 600; color: #fff;">Cash on Delivery</span>
                                <p style="margin: 4px 0 0; font-size: 12px; color: #94a3b8;">Pay when your order arrives at your doorstep</p>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- RIGHT: ORDER SUMMARY -->
        <div class="right-column">
            <div class="checkout-section">
                <h2>Coupon Code</h2>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="couponCode" placeholder="Enter Code" style="margin-bottom: 0;">
                    <button type="button" class="btn-add" style="padding: 10px 20px; font-size: 14px;" onclick="applyCoupon()">Apply</button>
                </div>
                <p id="couponMsg" style="margin-top: 10px; font-size: 13px;"></p>
            </div>

            <div class="checkout-section">
                <h2>Order Summary</h2>
                <div class="order-summary-box">
                    <% if (cart != null && !cart.isEmpty()) { %>
                        <% for (CartItem item : cart) { %>
                            <div class="summary-item">
                                <div>
                                    <p class="item-name"><%= item.getProduct().getProductName() %></p>
                                    <p class="item-meta">Size: <%= item.getSize() %> | Qty: <%= item.getQuantity() %></p>
                                </div>
                                <div class="item-price">₹ <%= item.getTotalPrice() %></div>
                            </div>
                        <% } %>
                    <% } %>
                    
                    <div id="discountRow" class="summary-item" style="display: none; color: #4ade80; border-bottom: none;">
                        <span>Discount Applied</span>
                        <span id="discountVal">-₹ 0</span>
                    </div>

                    <div class="total-row">
                        <span>Total Amount</span>
                        <span id="grandTotal">₹ <%= total == null ? 0 : total %></span>
                    </div>
                </div>
            </div>

            <button type="button" class="place-order-btn" onclick="document.getElementById('orderForm').submit()">
                Confirm & Place Order
            </button>
        </div>
    </div>

    <input type="hidden" id="baseTotalVal" value="<%= total == null ? 0 : total %>">
    <script>
        let baseTotal = parseFloat(document.getElementById('baseTotalVal').value);
        function applyCoupon() {
            const code = document.getElementById('couponCode').value;
            const msg = document.getElementById('couponMsg');
            
            fetch('apply-coupon', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'code=' + encodeURIComponent(code)
            }).then(res => res.json()).then(data => {
                if (data.status === 'SUCCESS') {
                    let discount = 0;
                    if (data.type === 'PERCENTAGE') {
                        discount = (baseTotal * data.value) / 100;
                    } else {
                        discount = data.value;
                    }
                    
                    document.getElementById('discountRow').style.display = 'flex';
                    document.getElementById('discountVal').innerText = '-₹ ' + discount.toFixed(2);
                    document.getElementById('grandTotal').innerText = '₹ ' + (baseTotal - discount).toFixed(2);
                    document.getElementById('appliedCouponCode').value = code;
                    msg.innerText = 'Coupon applied successfully!';
                    msg.style.color = '#4ade80';
                } else {
                    msg.innerText = 'Invalid or expired coupon code.';
                    msg.style.color = '#ef4444';
                }
            });
        }
    </script>
</div>

<%@ include file="partials/footer.jsp" %>

</body>
</html>


<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.CartItem" %>
<%@ page import="com.fashionstore.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    User user = (User) session.getAttribute("user");

    double total = 0;
    if (cart != null) {
        for (CartItem item : cart) {
            total += item.getTotalPrice();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orderconfirmation.css">
</head>

<body>

<div class="container">

    <h1>Order Confirmation</h1>
    <p class="subtitle">Please review your details before placing the order</p>

    <div class="layout">

        <!-- LEFT -->
        <div class="left">

            <h2>Shipping Details</h2>

            <input value="<%= user.getFullName() %>" readonly>
            <input value="<%= user.getPhone() %>" readonly>
            <input value="<%= user.getAddressLine1() %>" readonly>
            <input value="<%= user.getAddressLine2() %>" readonly>

            <div class="row">
                <input value="<%= user.getCity() %>" readonly>
                <input value="<%= user.getState() %>" readonly>
            </div>

            <div class="row">
                <input value="<%= user.getPincode() %>" readonly>
                <input value="<%= user.getCountry() %>" readonly>
            </div>

        </div>

        <!-- RIGHT -->
        <div class="right">

            <h2>Order Summary</h2>

            <% if (cart != null && !cart.isEmpty()) { %>

                <% for (CartItem item : cart) { %>

                    <div class="item">

                        <div>
                            <p><%= item.getProduct().getProductName() %></p>
                            <p class="meta">
                                Size: <%= item.getSize() %> | Qty: <%= item.getQuantity() %>
                            </p>
                        </div>

                        <div>
                            ₹ <%= item.getTotalPrice() %>
                        </div>

                    </div>

                <% } %>

            <% } else { %>
                <p>No items in cart</p>
            <% } %>

            <div class="total">
                <span>Total</span>
                <span>₹ <%= total %></span>
            </div>

        </div>

    </div>

    <!-- CENTER BUTTON -->
    <div class="btn-container">
        <form action="order-confirm" method="post">
            <button class="btn">Confirm & Place Order</button>
        </form>

        <a href="cart" class="back">Back to Cart</a>
    </div>

</div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Orders | FashionStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #6366f1; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; }
        body { font-family: 'Outfit', sans-serif; background: #0f172a; color: var(--text); margin: 0; display: flex; }
        .main-content { flex: 1; padding: 2.5rem 3.5rem; margin-left: 280px; max-width: calc(100vw - 280px - 4rem); }
        h1 { font-size: 2.25rem; font-weight: 700; margin-bottom: 2rem; letter-spacing: -0.025em; }
        .card { background: var(--card-bg); border-radius: 24px; padding: 2rem; border: 1px solid rgba(255,255,255,0.1); backdrop-filter: blur(10px); }
        
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th { text-align: left; padding: 1rem; color: #94a3b8; border-bottom: 1px solid rgba(255,255,255,0.1); }
        td { padding: 1rem; border-bottom: 1px solid rgba(255,255,255,0.05); }

        select { background: rgba(15, 23, 42, 0.5); color: white; border: 1px solid rgba(255,255,255,0.1); padding: 0.5rem; border-radius: 8px; }
        .btn-update { background: var(--primary); color: white; border: none; padding: 0.5rem 1rem; border-radius: 8px; cursor: pointer; }
    </style>
</head>
<body>
    <jsp:include page="partials/sidebar.jsp">
        <jsp:param name="activePage" value="orders" />
    </jsp:include>

    <div class="main-content">
        <h1>Manage Orders</h1>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Payment</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>#${o.orderId}</td>
                            <td><fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy, hh:mm a" timeZone="Asia/Kolkata" /></td>
                            <td>₹${o.totalAmount}</td>
                            <td>${o.paymentMethod}</td>
                            <td>
                                <select id="status-${o.orderId}">
                                    <option value="Ordered" ${o.orderStatus == 'Ordered' ? 'selected' : ''}>Ordered</option>
                                    <option value="Packed" ${o.orderStatus == 'Packed' ? 'selected' : ''}>Packed</option>
                                    <option value="Shipped" ${o.orderStatus == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                    <option value="Out for Delivery" ${o.orderStatus == 'Out for Delivery' ? 'selected' : ''}>Out for Delivery</option>
                                    <option value="Delivered" ${o.orderStatus == 'Delivered' ? 'selected' : ''}>Delivered</option>
                                </select>
                            </td>
                            <td>
                                <button class="btn-update" onclick="updateStatus('${o.orderId}')">Update</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function updateStatus(orderId) {
            const status = document.getElementById('status-' + orderId).value;
            fetch('admin-orders', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'orderId=' + orderId + '&status=' + encodeURIComponent(status)
            }).then(res => res.text()).then(text => {
                if (text === 'SUCCESS') alert('Order status updated!');
                else alert('Failed to update status.');
            });
        }
    </script>
</body>
</html>

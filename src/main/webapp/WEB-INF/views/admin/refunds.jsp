<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Refunds | FashionStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #6366f1; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; }
        body { font-family: 'Outfit', sans-serif; background: #0f172a; color: var(--text); margin: 0; display: flex; }
        .main-content { flex: 1; padding: 2.5rem 3.5rem; margin-left: 280px; max-width: calc(100vw - 280px - 4rem); }
        .nav-link { display: flex; align-items: center; padding: 1rem; color: #94a3b8; text-decoration: none; border-radius: 12px; margin-bottom: 0.5rem; transition: 0.3s; }
        .nav-link:hover, .nav-link.active { background: var(--primary); color: white; }
        .nav-link i { margin-right: 1rem; }
        
        .card { background: var(--card-bg); border-radius: 20px; padding: 1.5rem; border: 1px solid rgba(255,255,255,0.1); }
        
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 1rem; color: #94a3b8; border-bottom: 1px solid rgba(255,255,255,0.1); }
        td { padding: 1rem; border-bottom: 1px solid rgba(255,255,255,0.05); }

        select { background: rgba(15, 23, 42, 0.5); color: white; border: 1px solid rgba(255,255,255,0.1); padding: 0.5rem; border-radius: 8px; outline: none; }
        .btn-update { background: var(--primary); color: white; border: none; padding: 0.5rem 1rem; border-radius: 8px; cursor: pointer; transition: 0.3s; }
        .btn-update:hover { filter: brightness(1.1); transform: translateY(-1px); }

        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-requested { background: rgba(99, 102, 241, 0.2); color: #818cf8; }
        .status-approved { background: rgba(34, 211, 238, 0.2); color: #22d3ee; }
        .status-processing { background: rgba(251, 191, 36, 0.2); color: #fbbf24; }
        .status-refunded { background: rgba(52, 211, 153, 0.2); color: #34d399; }
        .status-rejected { background: rgba(248, 113, 113, 0.2); color: #f87171; }

        .toast { position: fixed; bottom: 2rem; right: 2rem; padding: 1rem 2rem; border-radius: 12px; color: white; z-index: 1000; animation: slideIn 0.3s ease; }
        .toast-success { background: #10b981; }
        .toast-error { background: #ef4444; }
        @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>
<body>
    <jsp:include page="partials/sidebar.jsp">
        <jsp:param name="activePage" value="refunds" />
    </jsp:include>

    <div class="main-content">
        <h1>Manage Refunds</h1>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Order ID</th>
                        <th>Reason</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${refunds}">
                        <tr>
                            <td>#${r.refundId}</td>
                            <td>#${r.orderId}</td>
                            <td>${r.reason}</td>
                            <td>${r.requestDate}</td>
                            <td>
                                <span class="status-badge status-${r.status.toLowerCase()}">${r.status}</span>
                            </td>
                            <td>
                                <form action="refund" method="post" style="display: flex; gap: 0.5rem;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="refundId" value="${r.refundId}">
                                    <select name="status">
                                        <option value="Requested" ${r.status == 'Requested' ? 'selected' : ''}>Requested</option>
                                        <option value="Approved" ${r.status == 'Approved' ? 'selected' : ''}>Approved</option>
                                        <option value="Processing" ${r.status == 'Processing' ? 'selected' : ''}>Processing</option>
                                        <option value="Refunded" ${r.status == 'Refunded' ? 'selected' : ''}>Refunded</option>
                                        <option value="Returned" ${r.status == 'Returned' ? 'selected' : ''}>Returned</option>
                                        <option value="Cancelled" ${r.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                        <option value="Rejected" ${r.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                                    </select>
                                    <button type="submit" class="btn-update">Update</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');

            if (success) showToast(success, 'success');
            if (error) showToast(error, 'error');
        }

        function showToast(msg, type) {
            const toast = document.createElement('div');
            toast.className = `toast toast-${type}`;
            toast.innerText = msg;
            document.body.appendChild(toast);
            setTimeout(() => toast.remove(), 3000);
        }
    </script>
</body>
</html>

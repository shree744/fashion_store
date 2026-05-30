<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Refund Tracker | FashionStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #6366f1; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; }
        body { font-family: 'Outfit', sans-serif; background: #0f172a; color: var(--text); margin: 0; }
        .container { max-width: 800px; margin: 80px auto; padding: 2rem; }
        .card { background: var(--card-bg); border-radius: 24px; padding: 2rem; border: 1px solid rgba(255,255,255,0.1); }
        .refund-item { border-bottom: 1px solid rgba(255,255,255,0.05); padding: 1.5rem 0; }
        .status { padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .status-requested { background: rgba(99, 102, 241, 0.2); color: #818cf8; }
        .status-approved { background: rgba(34, 211, 238, 0.2); color: #22d3ee; }
        .status-processing { background: rgba(251, 191, 36, 0.2); color: #fbbf24; }
        .status-refunded { background: rgba(52, 211, 153, 0.2); color: #34d399; }
        .status-returned { background: rgba(168, 85, 247, 0.2); color: #c084fc; }
        .status-cancelled { background: rgba(148, 163, 184, 0.2); color: #94a3b8; }
        .status-rejected { background: rgba(248, 113, 113, 0.2); color: #f87171; }
    </style>
</head>
<body>
    <%@ include file="partials/navbar.jsp" %>
    <div class="container">
        <div class="card">
            <h1>Refund History</h1>
            <c:forEach var="r" items="${refunds}">
                <div class="refund-item">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <strong>Refund #${r.refundId}</strong>
                        <span class="status status-${r.status.toLowerCase()}">${r.status}</span>
                    </div>
                    <p style="color: #94a3b8; font-size: 0.9rem;">Order ID: #${r.orderId}</p>
                    <p style="margin: 0.5rem 0;">Reason: ${r.reason}</p>
                    <p style="color: #64748b; font-size: 0.8rem;">Requested on ${r.requestDate}</p>
                </div>
            </c:forEach>
            <c:if test="${empty refunds}">
                <p style="text-align: center; color: #94a3b8; padding: 2rem;">No refund requests found.</p>
            </c:if>
        </div>
    </div>
</body>
</html>

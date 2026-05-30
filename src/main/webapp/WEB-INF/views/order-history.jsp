<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order History | FashionStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #6366f1; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; }
        body { font-family: 'Outfit', sans-serif; background: #0f172a; color: var(--text); margin: 0; }
        .container { max-width: 1000px; margin: 80px auto; padding: 2rem; }
        h1 { margin-bottom: 2rem; }
        .order-card { background: var(--card-bg); border-radius: 24px; padding: 2rem; border: 1px solid rgba(255,255,255,0.1); margin-bottom: 2rem; transition: 0.3s; }
        .order-card:hover { border-color: var(--primary); transform: translateY(-3px); }
        .order-header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 1rem; margin-bottom: 1rem; }
        .status { padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .status-ordered    { background: rgba(59, 130, 246, 0.2); color: #60a5fa; }
        .status-packed     { background: rgba(168, 85, 247, 0.2); color: #c084fc; }
        .status-shipped    { background: rgba(234, 179, 8, 0.2); color: #facc15; }
        .status-out-for-delivery { background: rgba(249, 115, 22, 0.2); color: #fb923c; }
        .status-delivered  { background: rgba(34, 197, 94, 0.2); color: #4ade80; }
        .status-cancelled  { background: rgba(239, 68, 68, 0.2); color: #f87171; }

        .btn { background: rgba(255,255,255,0.05); color: white; border: 1px solid rgba(255,255,255,0.1); padding: 0.6rem 1.2rem; border-radius: 12px; text-decoration: none; font-size: 0.9rem; transition: 0.3s; cursor: pointer; font-family: inherit; }
        .btn:hover { background: var(--primary); border-color: var(--primary); }
        .btn-refund { background: rgba(248, 113, 113, 0.1); color: #f87171; border-color: rgba(248,113,113,0.3); }
        .btn-refund:hover { background: rgba(248, 113, 113, 0.3); border-color: #f87171; }
        .btn-disabled { background: rgba(100,116,139,0.1); color: #64748b; border-color: rgba(100,116,139,0.2); cursor: not-allowed; opacity: 0.6; }
        .btn-disabled:hover { background: rgba(100,116,139,0.1); border-color: rgba(100,116,139,0.2); color: #64748b; transform: none; }

        .refund-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; margin-left: 8px; text-transform: uppercase; }
        .refund-requested  { background: rgba(99, 102, 241, 0.15); color: #818cf8; border: 1px solid rgba(99, 102, 241, 0.3); }
        .refund-approved   { background: rgba(34, 211, 238, 0.15); color: #22d3ee; border: 1px solid rgba(34, 211, 238, 0.3); }
        .refund-processing { background: rgba(251, 191, 36, 0.15); color: #fbbf24; border: 1px solid rgba(251, 191, 36, 0.3); }
        .refund-refunded   { background: rgba(52, 211, 153, 0.15); color: #34d399; border: 1px solid rgba(52, 211, 153, 0.3); }
        .refund-returned   { background: rgba(168, 85, 247, 0.15); color: #c084fc; border: 1px solid rgba(168, 85, 247, 0.3); }
        .refund-cancelled  { background: rgba(148, 163, 184, 0.15); color: #94a3b8; border: 1px solid rgba(148, 163, 184, 0.3); }
        .refund-rejected   { background: rgba(248, 113, 113, 0.15); color: #f87171; border: 1px solid rgba(248, 113, 113, 0.3); }

        .faq-section {
            margin-bottom: 2rem;
        }

        .faq-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 22px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: transform 0.2s ease, border-color 0.2s ease;
        }

        .faq-card:hover {
            border-color: rgba(99, 102, 241, 0.4);
            transform: translateY(-1px);
        }

        .faq-question-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            cursor: pointer;
        }

        .faq-question {
            font-size: 1rem;
            line-height: 1.5;
            color: #f8fafc;
            font-weight: 600;
            background: none;
            border: none;
            width: 100%;
            text-align: left;
            padding: 0;
            cursor: pointer;
        }

        .faq-status {
            padding: 0.35rem 0.9rem;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 700;
            background: rgba(148, 163, 184, 0.18);
            color: #cbd5e1;
        }

        .faq-answer {
            margin-top: 1rem;
            color: #cbd5e1;
            display: none;
            line-height: 1.75;
        }

        .faq-answer.open {
            display: block;
        }

        .faq-form {
            display: grid;
            gap: 1rem;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 24px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .faq-form textarea {
            min-height: 120px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 16px;
            padding: 1rem;
            color: white;
            resize: vertical;
        }

        .policy-section {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 24px;
            padding: 1.75rem;
            margin-top: 2rem;
        }

        .policy-section h2 { margin-top: 0; }

        .policy-block {
            margin-bottom: 1.75rem;
        }

        .policy-block p {
            color: #cbd5e1;
            line-height: 1.8;
            margin: 0.75rem 0 0;
        }

        .policy-block small {
            color: #94a3b8;
        }

        .faq-toggle-icon {
            margin-left: 1rem;
            transition: transform 0.3s ease;
        }
        .faq-toggle-icon.open {
            transform: rotate(180deg);
        }

        .btn-submit { width: fit-content; }

        .reward-toast {
            position: fixed; top: 80px; right: 24px; z-index: 9999;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            color: white; padding: 16px 24px; border-radius: 16px;
            font-weight: 600; font-size: 0.95rem;
            box-shadow: 0 10px 30px rgba(99,102,241,0.4);
            animation: slideIn 0.4s ease, fadeOut 0.4s ease 3.5s forwards;
            display: flex; align-items: center; gap: 10px;
        }
        @keyframes slideIn { from { opacity: 0; transform: translateX(60px); } to { opacity: 1; transform: translateX(0); } }
        @keyframes fadeOut { from { opacity: 1; } to { opacity: 0; pointer-events: none; } }
    </style>
</head>
<body>
    <%@ include file="partials/navbar.jsp" %>

    <%-- Show reward toast if reward was earned from latest order --%>
    <c:if test="${not empty rewardEarned}">
        <div class="reward-toast" id="rewardToast">
            <i class="fas fa-star"></i>
            You earned <strong>&nbsp;${rewardEarned} points&nbsp;</strong> for your order!
        </div>
        <script>
            setTimeout(() => {
                const t = document.getElementById('rewardToast');
                if (t) t.remove();
                // Clear session attribute so toast won't show again on refresh
                const fd = new FormData();
                fd.append('action', 'clear-toast');
                fetch('claim-reward', { method: 'POST', body: fd }).catch(() => {});
            }, 4000);
        </script>
    </c:if>

    <div class="container">
        <c:choose>
            <c:when test="${faqMode}">
                <h1><i class="fas fa-question-circle" style="color:#6366f1;margin-right:12px;"></i>FAQs</h1>
                <p style="color: #94a3b8; margin-bottom: 2rem; max-width: 780px;">Ask a question about delivery, returns, products, or orders. Your question will be stored and answered by the support team.</p>
            </c:when>
            <c:otherwise>
                <h1><i class="fas fa-box-open" style="color:#6366f1;margin-right:12px;"></i>Order History</h1>
            </c:otherwise>
        </c:choose>

        <%-- Flash messages from servlet --%>
        <c:if test="${not empty errorMsg}">
            <div style="background: rgba(248,113,113,0.1); border: 1px solid rgba(248,113,113,0.3); color: #f87171; padding: 14px 20px; border-radius: 14px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-exclamation-circle"></i> ${errorMsg}
            </div>
        </c:if>
        <c:if test="${not empty successMsg}">
            <div style="background: rgba(52,211,153,0.1); border: 1px solid rgba(52,211,153,0.3); color: #34d399; padding: 14px 20px; border-radius: 14px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle"></i> ${successMsg}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${faqMode}">
                <div class="faq-form">
                    <label for="questionText" style="font-weight: 700;">Post a question</label>
                    <form action="faq" method="post" style="display: grid; gap: 1rem;">
                        <textarea id="questionText" name="questionText" placeholder="Ask us anything about shipping, returns, or your order." required></textarea>
                        <button type="submit" class="btn btn-submit" style="background: var(--primary);">Submit Question</button>
                    </form>
                </div>

                <div class="faq-section">
                    <c:forEach var="faq" items="${faqItems}">
                        <div class="faq-card">
                            <div class="faq-question-row" onclick="toggleFaq(this)">
                                <button type="button" class="faq-question">${faq.question_text}</button>
                                <div style="display: flex; align-items: center; gap: 0.75rem;">
                                    <span class="faq-status">${faq.status}</span>
                                    <i class="fas fa-chevron-down faq-toggle-icon"></i>
                                </div>
                            </div>
                            <div class="faq-answer">
                                <c:choose>
                                    <c:when test="${not empty faq.answer_text}">
                                        <p style="margin-top: 1rem;">${faq.answer_text}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="margin-top: 1rem; color: #94a3b8;">This question is pending response from our support team.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="o" items="${orders}">
            <div class="order-card">
                <div class="order-header">
                    <div>
                        <h3 style="margin: 0;">Order #${o.orderId}</h3>
                        <p style="color: #94a3b8; font-size: 0.9rem; margin: 5px 0 0 0;">
                            <i class="fas fa-calendar-alt" style="margin-right:5px;"></i>Placed on <fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy, hh:mm a" timeZone="Asia/Kolkata" />
                        </p>
                    </div>
                    <div style="text-align: right;">
                        <c:set var="statusClass" value="${o.orderStatus.toLowerCase().replace(' ', '-')}" />
                        <span class="status status-${statusClass}">${o.orderStatus}</span>

                        <%-- Refund status badge - shown whenever refundStatus is present --%>
                        <c:if test="${not empty o.refundStatus}">
                            <span class="refund-badge refund-${o.refundStatus.toLowerCase()}">
                                <i class="fas fa-undo-alt"></i>
                                Refund: ${o.refundStatus}
                            </span>
                        </c:if>

                        <p style="font-weight: 700; margin: 8px 0 0 0; font-size: 1.1rem;">₹ ${o.totalAmount}</p>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: center;">
                    <a href="track-order?id=${o.orderId}" class="btn">
                        <i class="fas fa-map-marker-alt" style="margin-right:5px;"></i>Track Order
                    </a>

                    <%-- Return/Refund button: only for Delivered orders with NO existing refund --%>
                    <c:if test="${o.orderStatus == 'Delivered' && empty o.refundStatus}">
                        <button class="btn btn-refund" onclick="requestRefund('${o.orderId}', this)">
                            <i class="fas fa-undo-alt" style="margin-right:5px;"></i>Return/Refund
                        </button>
                    </c:if>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty orders}">
            <div style="text-align: center; padding: 4rem;">
                <i class="fas fa-shopping-bag" style="font-size: 4rem; color: #1e293b; margin-bottom: 1.5rem;"></i>
                <h2>No orders found</h2>
                <p style="color: #94a3b8;">You haven't placed any orders yet.</p>
                <a href="products" class="btn" style="display: inline-block; margin-top: 1rem; background: var(--primary);">Shop Now</a>
            </div>
        </c:if>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function requestRefund(orderId, btn) {
            const reason = prompt("Please enter the reason for your return/refund request:");
            if (!reason || reason.trim() === '') return;

            // Immediately disable button to prevent double-click
            btn.disabled = true;
            btn.classList.add('btn-disabled');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin" style="margin-right:5px;"></i>Submitting...';

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'refund';

            const fields = { action: 'request', orderId: orderId, reason: reason.trim() };
            Object.entries(fields).forEach(([name, value]) => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            });

            document.body.appendChild(form);
            form.submit();
        }

        function toggleFaq(buttonRow) {
            const card = buttonRow.closest('.faq-card');
            if (!card) return;
            const answer = card.querySelector('.faq-answer');
            const icon = card.querySelector('.faq-toggle-icon');
            if (answer) {
                const isOpen = answer.classList.toggle('open');
                if (icon) icon.classList.toggle('open', isOpen);
            }
        }
    </script>
</body>
</html>

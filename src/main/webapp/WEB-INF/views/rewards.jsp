<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rewards | FashionStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        :root { --primary: #6366f1; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; }
        body { font-family: 'Outfit', sans-serif; background: radial-gradient(circle at top right, #1e1b4b, #0f172a); color: var(--text); min-height: 100vh; margin: 0; }
        .page-wrapper { max-width: 900px; margin: 100px auto 60px; padding: 0 20px; }

        .reward-hero {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        .points-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border-radius: 24px;
            border: 1px solid rgba(255,255,255,0.1);
            padding: 35px;
            text-align: center;
        }
        .points-total {
            font-size: 52px;
            font-weight: 700;
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 10px 0 5px;
        }
        .points-label { color: #94a3b8; font-size: 15px; }

        .daily-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border-radius: 24px;
            border: 1px solid rgba(255,255,255,0.1);
            padding: 35px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .reward-box {
            width: 90px; height: 90px;
            background: linear-gradient(135deg, #f59e0b, #d97706);
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem; color: white;
            cursor: pointer; transition: all 0.3s;
            box-shadow: 0 12px 25px rgba(245,158,11,0.3);
            margin: 15px 0;
        }
        .reward-box:hover { transform: scale(1.08) rotate(5deg); }
        .reward-box.claimed { filter: grayscale(1); cursor: not-allowed; transform: none; }

        .streak-row {
            display: flex; justify-content: center; gap: 8px; margin-top: 15px;
        }
        .streak-dot {
            width: 32px; height: 32px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 12px; font-weight: 600;
            transition: all 0.3s;
        }
        .streak-active { background: var(--primary); box-shadow: 0 4px 12px rgba(99,102,241,0.4); }
        .streak-inactive { background: rgba(255,255,255,0.06); color: #64748b; }

        /* History Section */
        .history-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border-radius: 24px;
            border: 1px solid rgba(255,255,255,0.1);
            padding: 30px;
        }
        .history-card h2 { margin-bottom: 20px; font-size: 20px; }
        .history-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .history-item:last-child { border: none; }
        .history-left { display: flex; align-items: center; gap: 14px; }
        .history-icon {
            width: 42px; height: 42px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 16px;
        }
        .icon-order { background: rgba(34,197,94,0.1); color: #4ade80; }
        .icon-daily { background: rgba(99,102,241,0.1); color: #818cf8; }
        .history-type { font-weight: 600; font-size: 14px; }
        .history-date { color: #64748b; font-size: 12px; }
        .history-points {
            font-weight: 700; font-size: 16px; color: #fbbf24;
        }
        .empty-history {
            text-align: center; padding: 40px; color: #64748b;
        }

        #rewardMsg {
            font-size: 14px; margin-top: 10px; min-height: 20px;
        }

        @media (max-width: 768px) {
            .reward-hero { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <%@ include file="partials/navbar.jsp" %>

    <div class="page-wrapper">
        <div class="reward-hero">
            <!-- Total Points -->
            <div class="points-card">
                <i class="fas fa-coins" style="font-size: 28px; color: #fbbf24;"></i>
                <div class="points-total">${reward.points != null ? reward.points : 0}</div>
                <div class="points-label">Total Reward Points</div>
            </div>

            <!-- Daily Claim -->
            <div class="daily-card">
                <h3 style="margin: 0;">Daily Reward</h3>
                <div id="rewardBox" class="reward-box" onclick="claimReward()">
                    <i class="fas fa-gift"></i>
                </div>
                <p style="color: #94a3b8; font-size: 13px; margin: 0;">Tap to claim +10 points</p>
                <p id="rewardMsg"></p>

                <div style="margin-top: 12px;">
                    <p style="color: #94a3b8; font-size: 13px; margin-bottom: 8px;">Streak: ${reward.streakCount != null ? reward.streakCount : 0} Days</p>
                    <div class="streak-row">
                        <c:forEach var="i" begin="1" end="7">
                            <div class="streak-dot ${reward.streakCount >= i ? 'streak-active' : 'streak-inactive'}">
                                ${i}
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reward History -->
        <div class="history-card">
            <h2><i class="fas fa-history" style="margin-right: 10px; color: var(--primary);"></i>Reward History</h2>

            <c:choose>
                <c:when test="${not empty rewardHistory}">
                    <c:forEach var="entry" items="${rewardHistory}">
                        <div class="history-item">
                            <div class="history-left">
                                <div class="history-icon ${entry.rewardType == 'ORDER' ? 'icon-order' : 'icon-daily'}">
                                    <i class="fas ${entry.rewardType == 'ORDER' ? 'fa-shopping-bag' : 'fa-gift'}"></i>
                                </div>
                                <div>
                                    <div class="history-type">
                                        ${entry.rewardType == 'ORDER' ? 'Order Reward' : 'Daily Claim'}
                                        <c:if test="${entry.orderId > 0}">
                                            <span style="color: #64748b; font-weight: 400;"> — Order #${entry.orderId}</span>
                                        </c:if>
                                    </div>
                                    <div class="history-date">${entry.createdAt}</div>
                                </div>
                            </div>
                            <div class="history-points">+${entry.points}</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-history">
                        <i class="far fa-star" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i>
                        <p>No reward history yet. Place orders or claim daily rewards to earn points!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function claimReward() {
            fetch('claim-reward', { method: 'POST' })
            .then(res => res.text())
            .then(text => {
                const msg = document.getElementById('rewardMsg');
                if (text === 'SUCCESS') {
                    msg.innerText = '🎉 Reward claimed! +10 points added.';
                    msg.style.color = '#4ade80';
                    document.getElementById('rewardBox').classList.add('claimed');
                    setTimeout(() => location.reload(), 1500);
                } else if (text === 'ALREADY_CLAIMED') {
                    msg.innerText = "You've already claimed today's reward.";
                    msg.style.color = '#f87171';
                    document.getElementById('rewardBox').classList.add('claimed');
                } else {
                    msg.innerText = 'Please login to claim rewards.';
                    msg.style.color = '#f87171';
                }
            });
        }
    </script>
</body>
</html>

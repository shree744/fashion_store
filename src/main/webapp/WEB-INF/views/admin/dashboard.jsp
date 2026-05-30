<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin Dashboard | FashionStore</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <style>
                :root {
                    --primary: #6366f1;
                    --secondary: #a855f7;
                    --bg: #0f172a;
                    --card-bg: rgba(30, 41, 59, 0.7);
                    --text: #f8fafc;
                }

                body {
                    font-family: 'Outfit', sans-serif;
                    background: radial-gradient(circle at top left, #1e1b4b, #0f172a);
                    color: var(--text);
                    margin: 0;
                    display: flex;
                    min-height: 100vh;
                }

                .main-content {
                    flex: 1;
                    padding: 2.5rem 3.5rem;
                    margin-left: 280px;
                    max-width: calc(1600px - 280px);
                }
                
                h1 {
                    font-size: 2.25rem;
                    font-weight: 700;
                    margin-bottom: 0.5rem;
                    letter-spacing: -0.025em;
                }

                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                    gap: 1.5rem;
                    margin-bottom: 2rem;
                }

                .stat-card {
                    background: var(--card-bg);
                    backdrop-filter: blur(12px);
                    padding: 1.5rem;
                    border-radius: 20px;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    display: flex;
                    align-items: center;
                }

                .stat-icon {
                    width: 60px;
                    height: 60px;
                    border-radius: 15px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.5rem;
                    margin-right: 1.5rem;
                }

                .stat-info h3 {
                    margin: 0;
                    font-size: 0.9rem;
                    color: #94a3b8;
                }

                .stat-info p {
                    margin: 0;
                    font-size: 1.8rem;
                    font-weight: 600;
                }

                .chart-container {
                    background: var(--card-bg);
                    backdrop-filter: blur(12px);
                    padding: 2rem;
                    border-radius: 24px;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    margin-bottom: 2rem;
                }

                .table-container {
                    background: var(--card-bg);
                    backdrop-filter: blur(12px);
                    padding: 1.5rem;
                    border-radius: 24px;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                }

                th {
                    text-align: left;
                    padding: 1rem;
                    color: #94a3b8;
                    font-weight: 400;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                }

                td {
                    padding: 1rem;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
                }

                .status {
                    padding: 0.25rem 0.75rem;
                    border-radius: 20px;
                    font-size: 0.8rem;
                }

                .status-delivered {
                    background: rgba(34, 197, 94, 0.2);
                    color: #4ade80;
                }

                .status-ordered {
                    background: rgba(59, 130, 246, 0.2);
                    color: #60a5fa;
                }

                .faq-card {
                    background: rgba(255, 255, 255, 0.03);
                    border: 1px solid rgba(255, 255, 255, 0.08);
                    border-radius: 16px;
                    transition: transform 0.2s, background 0.2s, box-shadow 0.2s;
                }
                .faq-card:hover {
                    background: rgba(255, 255, 255, 0.06);
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
                }
            </style>
        </head>

        <body>
            <jsp:include page="partials/sidebar.jsp">
                <jsp:param name="activePage" value="${faqMode ? 'faq' : 'dashboard'}" />
            </jsp:include>

            <div class="main-content">
                <c:choose>
                    <c:when test="${faqMode}">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2.5rem;">
                            <div>
                                <h1>FAQ Management</h1>
                                <p style="color: #94a3b8; max-width: 680px; margin: 0.5rem 0 0 0;">Review and answer customer questions, and keep shipping and return policies up to date.</p>
                            </div>
                        </div>

                        <c:if test="${not empty success}">
                            <div style="background: rgba(52,211,153,0.1); border: 1px solid rgba(52,211,153,0.3); color: #34d399; padding: 14px 20px; border-radius: 14px; margin-bottom: 1.5rem;">
                                ${success}
                            </div>
                        </c:if>

                        <div class="table-container" style="margin-top: 2rem;">
                            <h3>Customer FAQ Queue</h3>
                            <c:forEach var="faq" items="${faqItems}">
                                <div class="faq-card" style="margin-bottom: 1rem; padding: 1.25rem;">
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 1rem;">
                                        <div>
                                            <h4 style="margin: 0 0 0.5rem 0;">${faq.question_text}</h4>
                                            <p style="margin: 0; color: #94a3b8;">User #${faq.user_id} • ${faq.created_at}</p>
                                            <span class="faq-status" style="margin-top: 0.75rem; display: inline-block;">${faq.status}</span>
                                        </div>
                                    </div>
                                    <div style="margin-top: 1rem;">
                                        <c:choose>
                                            <c:when test="${not empty faq.answer_text}">
                                                <p style="margin: 0; line-height: 1.75;">${faq.answer_text}</p>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="admin-faq" method="post" style="display: grid; gap: 0.75rem; margin-top: 1rem;">
                                                    <input type="hidden" name="action" value="answer" />
                                                    <input type="hidden" name="questionId" value="${faq.question_id}" />
                                                    <textarea name="answerText" rows="3" placeholder="Type your answer here..." style="width: 100%; border-radius: 14px; border: 1px solid rgba(255,255,255,0.12); background: rgba(255,255,255,0.04); color: #fff; padding: 1rem;"></textarea>
                                                    <button type="submit" class="btn" style="background: #22c55e;">Submit Answer</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.5rem;">
                            <h1>Dashboard Overview</h1>
                        </div>

                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-icon" style="background: rgba(99, 102, 241, 0.2); color: #818cf8;"><i
                                        class="fas fa-dollar-sign"></i></div>
                                <div class="stat-info">
                                    <h3>Total Revenue</h3>
                                    <p>₹${totalRevenue}</p>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background: rgba(168, 85, 247, 0.2); color: #c084fc;"><i
                                        class="fas fa-shopping-cart"></i></div>
                                <div class="stat-info">
                                    <h3>Total Orders</h3>
                                    <p>${totalOrders}</p>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background: rgba(34, 197, 94, 0.2); color: #4ade80;"><i
                                        class="fas fa-box"></i></div>
                                <div class="stat-info">
                                    <h3>Total Products</h3>
                                    <p>${totalProducts}</p>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background: rgba(245, 158, 11, 0.2); color: #fbbf24;"><i
                                        class="fas fa-users"></i></div>
                                <div class="stat-info">
                                    <h3>Customers</h3>
                                    <p>${totalUsers}</p>
                                </div>
                            </div>
                        </div>

                        <div class="chart-container">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
                                <h3 style="margin: 0;"><i class="fas fa-chart-line" style="color: var(--primary); margin-right: 10px;"></i>Sales Analytics</h3>
                                
                                <div style="display: flex; gap: 10px; align-items: center;">
                                    <!-- View Type Selector -->
                                    <select id="viewType" onchange="updateChart()" style="background: rgba(15, 23, 42, 0.6); color: white; border: 1px solid rgba(255,255,255,0.15); padding: 0.5rem 1rem; border-radius: 12px; cursor: pointer; font-family: inherit; outline: none;">
                                        <option value="weekly" selected>Weekly View</option>
                                        <option value="daily">Daily View (Hourly)</option>
                                    </select>
                                    
                                    <!-- Date Picker Selector -->
                                    <input type="date" id="analyticsDate" onchange="updateChart()" onclick="this.showPicker()" style="background: rgba(15, 23, 42, 0.6); color: white; border: 1px solid rgba(255,255,255,0.15); padding: 0.5rem 1rem; border-radius: 12px; cursor: pointer; font-family: inherit; outline: none;" />
                                    
                                    <button type="button" onclick="updateChart()" style="background: var(--primary); color: white; border: none; padding: 0.5rem 1.2rem; border-radius: 12px; cursor: pointer; font-family: inherit; font-weight: 600; transition: transform 0.2s;">
                                        Refresh
                                    </button>
                                </div>
                            </div>
                            <canvas id="salesChart" height="100"></canvas>
                        </div>

                        <div class="table-container">
                            <h3>Recent Orders</h3>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Date</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${recentOrders}">
                                        <tr>
                                            <td>#${order.orderId}</td>
                                            <td>User #${order.userId}</td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a" timeZone="Asia/Kolkata" /></td>
                                            <td>₹${order.totalAmount}</td>
                                            <td><span
                                                    class="status status-${order.orderStatus.toLowerCase()}">${order.orderStatus}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <script>
                // Initialize date picker to today's local date
                const todayStr = new Date().toLocaleDateString('sv-SE'); // YYYY-MM-DD in local time
                const dateInput = document.getElementById('analyticsDate');
                if (dateInput) {
                    dateInput.value = todayStr;
                }

                const ctx = document.getElementById('salesChart').getContext('2d');
                let salesChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                        datasets: [{
                            label: 'Sales (₹)',
                            data: [0, 0, 0, 0, 0, 0, 0], // Default zeros
                            borderColor: '#6366f1',
                            backgroundColor: 'rgba(99, 102, 241, 0.1)',
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { 
                                beginAtZero: true,
                                grid: { color: 'rgba(255,255,255,0.05)' } 
                            },
                            x: { grid: { display: false } }
                        }
                    }
                });

                // Fetch real-time data
                async function updateChart() {
                    const dateVal = document.getElementById('analyticsDate').value || todayStr;
                    const viewTypeVal = document.getElementById('viewType').value || 'weekly';
                    try {
                        const response = await fetch('admin-dashboard?action=getSalesData&date=' + dateVal + '&viewType=' + viewTypeVal);
                        if (!response.ok) throw new Error('Network response was not ok');
                        const result = await response.json();
                        
                        salesChart.data.labels = result.labels;
                        salesChart.data.datasets[0].data = result.data;
                        salesChart.update();
                    } catch (error) {
                        console.error('Error fetching sales data:', error);
                    }
                }

                // Initial load
                updateChart();
            </script>
        </body>

        </html>
<%@ page pageEncoding="UTF-8" %>

    <footer
        style="background: rgba(15, 23, 42, 0.9); border-top: 1px solid rgba(255, 255, 255, 0.1); padding: 80px 0 40px; margin-top: 100px;">
        <div
            style="max-width: 1300px; margin: 0 auto; padding: 0 40px; display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 60px;">

            <div>
                <h4 style="color: #fff; margin-bottom: 24px; font-size: 18px;">About Us</h4>
                <p style="color: #94a3b8; line-height: 1.6; font-size: 15px;">Your ultimate destination for modern,
                    premium, and trendy fashion styles.</p>
            </div>

            <div>
                <h4 style="color: #fff; margin-bottom: 24px; font-size: 18px;">Shop</h4>
                <ul style="list-style: none; padding: 0; margin: 0;">
                    <li style="margin-bottom: 12px;"><a href="${pageContext.request.contextPath}/products?categoryId=1"
                            style="color: #94a3b8; text-decoration: none; transition: 0.3s;">Men</a></li>
                    <li style="margin-bottom: 12px;"><a href="${pageContext.request.contextPath}/products?categoryId=2"
                            style="color: #94a3b8; text-decoration: none; transition: 0.3s;">Women</a></li>
                    <li style="margin-bottom: 12px;"><a href="${pageContext.request.contextPath}/products?categoryId=3"
                            style="color: #94a3b8; text-decoration: none; transition: 0.3s;">Kids</a></li>
                </ul>
            </div>

            <div>
                <h4 style="color: #fff; margin-bottom: 24px; font-size: 18px;">Support</h4>
                <ul style="list-style: none; padding: 0; margin: 0;">
                    <li style="margin-bottom: 12px;"><a href="${pageContext.request.contextPath}/faq"
                            style="color: #94a3b8; text-decoration: none;">FAQs</a></li>
                    <li style="margin-bottom: 12px;"><a
                            href="${pageContext.request.contextPath}/order-history#shipping-rules"
                            style="color: #94a3b8; text-decoration: none;">Shipping</a></li>
                    <li style="margin-bottom: 12px;"><a
                            href="${pageContext.request.contextPath}/order-history#return-rules"
                            style="color: #94a3b8; text-decoration: none;">Return</a></li>
                </ul>
            </div>

            <div>
                <h4 style="color: #fff; margin-bottom: 24px; font-size: 18px;">Contact Us</h4>
                <ul style="list-style: none; padding: 0; margin: 0;">
                    <li style="margin-bottom: 15px; color: #94a3b8; display: flex; align-items: flex-start; gap: 10px;">
                        <i class="fas fa-envelope" style="color: #a855f7; margin-top: 4px;"></i>
                        <div>
                            <span
                                style="display: block; font-size: 13px; font-weight: 600; color: #cbd5e1; margin-bottom: 2px;">Email</span>
                            <a href="https://mail.google.com/mail/?view=cm&fs=1&to=shreegowrimathada@gmail.com"
                                target="_blank" style="color: #94a3b8; text-decoration: none; transition: 0.3s;"
                                onmouseover="this.style.color='#fff'"
                                onmouseout="this.style.color='#94a3b8'">admin@fashionstore.com</a>
                        </div>
                    </li>
                    <li style="margin-bottom: 15px; color: #94a3b8; display: flex; align-items: flex-start; gap: 10px;">
                        <i class="fas fa-phone-alt" style="color: #6366f1; margin-top: 4px;"></i>
                        <div>
                            <span
                                style="display: block; font-size: 13px; font-weight: 600; color: #cbd5e1; margin-bottom: 2px;">Phone</span>
                            <a href="tel:+91 9019984302"
                                style="color: #94a3b8; text-decoration: none; transition: 0.3s;"
                                onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#94a3b8'">+91
                                9019984302</a>
                        </div>
                    </li>
                </ul>
            </div>

        </div>

        <div
            style="max-width: 1300px; margin: 60px auto 0; padding: 40px; border-top: 1px solid rgba(255,255,255,0.05); text-align: center; color: #64748b; font-size: 14px;">
            &copy; 2026 Fashion Store. All rights reserved. Made with Love for Premium Fashion.
        </div>
    </footer>
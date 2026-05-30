package com.fashionstore.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtil {

    // 🔹 GMAIL SMTP CONFIG (USER: PLEASE UPDATE THESE)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "your-email@gmail.com"; // Replace with your Gmail
    private static final String APP_PASSWORD = "your-app-password";    // Replace with your App Password

    private static final String ADMIN_EMAIL = "admin@fashionstore.com"; // Admin notification recipient

    public static void sendEmail(String to, String subject, String content) {
        
        // 1. Set SMTP Properties
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        // 2. Create Session with Authenticator
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        try {
            // 3. Create Message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            
            // Send as HTML
            message.setContent(content, "text/html; charset=utf-8");

            // 4. Send Email
            Transport.send(message);
            System.out.println("Email sent successfully to: " + to);

        } catch (MessagingException e) {
            System.err.println("Failed to send email to " + to + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Helper for Admin Notification
    public static void notifyAdmin(String subject, String content) {
        sendEmail(ADMIN_EMAIL, subject, content);
    }
}

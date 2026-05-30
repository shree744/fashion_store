package com.fashionstore.controller;

import com.fashionstore.dao.AdminDAO;
import com.fashionstore.dao.impl.AdminDAOImpl;
import com.fashionstore.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

@WebServlet("/admin-profile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class AdminProfileServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");
        String fullName = request.getParameter("fullName");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Name cannot be empty.");
            request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
            return;
        }

        admin.setFullName(fullName.trim());

        // Handle Image Upload
        try {
            Part filePart = request.getPart("profilePicture");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = "admin_" + admin.getAdminId() + "_" + System.currentTimeMillis() + ".png";
                String uploadPath = getServletContext().getRealPath("/assets/images/profiles");
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                File file = new File(uploadDir, fileName);
                try (InputStream input = filePart.getInputStream();
                     FileOutputStream output = new FileOutputStream(file)) {
                    byte[] buffer = new byte[1024];
                    int length;
                    while ((length = input.read(buffer)) > 0) {
                        output.write(buffer, 0, length);
                    }
                }
                admin.setProfileImage("assets/images/profiles/" + fileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (adminDAO.updateAdmin(admin)) {
            session.setAttribute("admin", admin);
            request.setAttribute("message", "Profile updated successfully.");
        } else {
            request.setAttribute("error", "Unable to update profile.");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
    }
}

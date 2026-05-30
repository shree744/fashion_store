package com.fashionstore.controller;

import com.fashionstore.dao.UserDAO;
import com.fashionstore.dao.impl.UserDAOImpl;
import com.fashionstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/profile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String profileImagePath = getProfileImagePath(request, user.getUserId());
        request.setAttribute("profileImagePath", profileImagePath);

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String addressLine1 = request.getParameter("addressLine1");
        String addressLine2 = request.getParameter("addressLine2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String country = request.getParameter("country");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name cannot be empty.");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        user.setFullName(fullName.trim());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddressLine1(addressLine1 != null ? addressLine1.trim() : "");
        user.setAddressLine2(addressLine2 != null ? addressLine2.trim() : "");
        user.setCity(city != null ? city.trim() : "");
        user.setState(state != null ? state.trim() : "");
        user.setPincode(pincode != null ? pincode.trim() : "");
        user.setCountry(country != null ? country.trim() : "");

        Part profilePart = request.getPart("profilePicture");
        if (profilePart != null && profilePart.getSize() > 0) {
            String savedProfilePath = saveProfileImage(request, user.getUserId(), profilePart);
            if (savedProfilePath != null) {
                String dbPath = savedProfilePath.contains("?") ? savedProfilePath.split("\\?")[0] : savedProfilePath;
                if (dbPath.startsWith(request.getContextPath())) {
                    dbPath = dbPath.substring(request.getContextPath().length());
                }
                if (dbPath.startsWith("/")) {
                    dbPath = dbPath.substring(1);
                }
                user.setProfileImage(dbPath);
                request.setAttribute("profileImagePath", savedProfilePath);
            }
        } else {
            request.setAttribute("profileImagePath", getProfileImagePath(request, user.getUserId()));
        }

        if (userDAO.updateUser(user)) {
            session.setAttribute("user", user);
            request.setAttribute("message", "Your profile has been updated successfully.");
        } else {
            request.setAttribute("error", "Unable to update your profile right now. Please try again.");
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    private String getProfileImagePath(HttpServletRequest request, int userId) {
        String profileDir = request.getServletContext().getRealPath("/assets/images/profiles");
        if (profileDir == null) return null;

        File dir = new File(profileDir);
        if (!dir.exists() && !dir.mkdirs()) return null;

        String[] extensions = {".png", ".jpg", ".jpeg", ".gif", ".webp"};
        for (String ext : extensions) {
            File candidate = new File(dir, "user_" + userId + ext);
            if (candidate.exists()) {
                return request.getContextPath() + "/assets/images/profiles/" + candidate.getName() + "?t=" + System.currentTimeMillis();
            }
        }
        return null;
    }

    private String saveProfileImage(HttpServletRequest request, int userId, Part profilePart) throws IOException {
        String fileName = profilePart.getSubmittedFileName();
        if (fileName == null) return null;

        String extension = ".png";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            String ext = fileName.substring(dotIndex).toLowerCase();
            if (ext.matches("\\.(png|jpe?g|gif|webp)$")) extension = ext;
        }

        String profileDir = request.getServletContext().getRealPath("/assets/images/profiles");
        if (profileDir == null) return null;

        File dir = new File(profileDir);
        if (!dir.exists() && !dir.mkdirs()) return null;

        for (String ext : new String[]{".png", ".jpg", ".jpeg", ".gif", ".webp"}) {
            File existing = new File(dir, "user_" + userId + ext);
            if (existing.exists()) existing.delete();
        }

        File savedFile = new File(dir, "user_" + userId + extension);
        try (InputStream input = profilePart.getInputStream(); FileOutputStream output = new FileOutputStream(savedFile)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) output.write(buffer, 0, bytesRead);
        }

        return request.getContextPath() + "/assets/images/profiles/" + savedFile.getName() + "?t=" + System.currentTimeMillis();
    }
}

package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validation
        if (email == null || email.isBlank() || password == null || password.isBlank() ||
            name == null || name.isBlank() || phone == null || phone.isBlank()) {
            request.setAttribute("error", "Semua field harus diisi!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Password tidak cocok!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password minimal 6 karakter!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User newUser = userDAO.register(email, password, name, phone, address);

        if (newUser != null) {
            request.setAttribute("success", "Registrasi berhasil! Silakan login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Email sudah terdaftar atau terjadi kesalahan!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}

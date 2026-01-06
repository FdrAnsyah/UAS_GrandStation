package controller;

import dao.ContactDAO;
import model.Contact;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        Contact contact = new Contact(name, email, phone, message);
        ContactDAO contactDAO = new ContactDAO();

        boolean success = contactDAO.insert(contact);

        if (success) {
            request.setAttribute("successMsg", "Pesan Anda telah tersimpan! Terima kasih telah menghubungi kami.");
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMsg", "Gagal mengirim pesan. Silahkan coba lagi.");
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        }
    }
}

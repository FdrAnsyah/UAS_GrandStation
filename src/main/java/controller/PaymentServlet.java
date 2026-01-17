package controller;

import dao.BookingDAO;
import dao.PaymentDAO;
import model.Booking;
import model.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class PaymentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object user = session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingId = request.getParameter("bookingId");

        if (bookingId == null || bookingId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?halaman=home");
            return;
        }

        try {
            int bId = Integer.parseInt(bookingId);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = null;
            List<Booking> allBookings = bookingDAO.getAll();
            for (Booking b : allBookings) {
                if (b.getId() == bId) {
                    booking = b;
                    break;
                }
            }

            if (booking == null) {
                request.setAttribute("error", "Booking tidak ditemukan!");
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
                return;
            }

            // Check booking status - only approved bookings can proceed to payment
            if (!"approved".equalsIgnoreCase(booking.getStatus())) {
                request.setAttribute("error", "Booking belum disetujui oleh admin. Silakan tunggu persetujuan admin.");
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?halaman=home");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userId = session.getAttribute("userId");

        // Check if user is logged in
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingId = request.getParameter("bookingId");
        String method = request.getParameter("method");

        if (bookingId == null || bookingId.isEmpty() || method == null || method.isEmpty()) {
            request.setAttribute("error", "Data pembayaran tidak lengkap!");
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
            return;
        }

        try {
            int bId = Integer.parseInt(bookingId);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = null;
            List<Booking> allBookings = bookingDAO.getAll();
            for (Booking b : allBookings) {
                if (b.getId() == bId) {
                    booking = b;
                    break;
                }
            }

            if (booking == null) {
                request.setAttribute("error", "Booking tidak ditemukan!");
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
                return;
            }

            // Check booking status - only approved bookings can proceed to payment
            if (!"approved".equalsIgnoreCase(booking.getStatus())) {
                request.setAttribute("error", "Booking belum disetujui oleh admin. Silakan tunggu persetujuan admin.");
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
                return;
            }

            // Create payment record
            PaymentDAO paymentDAO = new PaymentDAO();
            long totalPrice = (long) booking.getTotalPrice();
            Payment payment = paymentDAO.createPayment(bId, totalPrice, method);

            if (payment != null) {
                request.setAttribute("payment", payment);
                request.setAttribute("booking", booking);
                request.setAttribute("success", "Pembayaran berhasil diproses!");
                request.getRequestDispatcher("/payment_success.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Gagal membuat transaksi pembayaran!");
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Data tidak valid!");
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
        }
    }
}

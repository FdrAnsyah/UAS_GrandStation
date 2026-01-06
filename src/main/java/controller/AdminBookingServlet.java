package controller;

import dao.BookingDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class AdminBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if admin
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        BookingDAO bookingDAO = new BookingDAO();

        if ("approve".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            int adminId = (Integer) session.getAttribute("userId");
            boolean success = bookingDAO.approveBooking(bookingId, adminId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin-bookings?success=approved");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin-bookings?error=approve_failed");
            }
            return;
        }

        if ("reject".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            int adminId = (Integer) session.getAttribute("userId");
            boolean success = bookingDAO.rejectBooking(bookingId, adminId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin-bookings?success=rejected");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin-bookings?error=reject_failed");
            }
            return;
        }

        // Default: show pending bookings
        List<Booking> pendingBookings = bookingDAO.getPendingBookings();
        request.setAttribute("pendingBookings", pendingBookings);
        request.getRequestDispatcher("/admin-approve-bookings.jsp").forward(request, response);
    }
}

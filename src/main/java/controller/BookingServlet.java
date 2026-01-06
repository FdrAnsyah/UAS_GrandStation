package controller;

import dao.BookingDAO;
import dao.ScheduleDAO;
import model.Booking;
import model.Schedule;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check authentication
        HttpSession session = request.getSession();
        Object userId = session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String scheduleIdParam = request.getParameter("scheduleId");
            System.out.println("DEBUG BookingServlet - scheduleId parameter: " + scheduleIdParam);

            if (scheduleIdParam == null || scheduleIdParam.trim().isEmpty()) {
                request.setAttribute("halaman", "home");
                request.setAttribute("error", "Parameter scheduleId tidak ditemukan.");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            int scheduleId = Integer.parseInt(scheduleIdParam);
            System.out.println("DEBUG BookingServlet - parsed scheduleId: " + scheduleId);

            Schedule schedule = new ScheduleDAO().getById(scheduleId);
            System.out.println("DEBUG BookingServlet - schedule found: " + (schedule != null));

            if (schedule == null) {
                request.setAttribute("halaman", "home");
                request.setAttribute("error", "Jadwal tidak ditemukan.");
            } else {
                request.setAttribute("halaman", "booking");
                request.setAttribute("schedule", schedule);
            }
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            System.out.println("DEBUG BookingServlet - NumberFormatException: " + e.getMessage());
            request.setAttribute("halaman", "home");
            request.setAttribute("error", "Parameter jadwal tidak valid (bukan angka).");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("DEBUG BookingServlet - Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("halaman", "home");
            request.setAttribute("error", "Terjadi kesalahan: " + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check authentication
        HttpSession session = request.getSession();
        Object userId = session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            String name = request.getParameter("passengerName");
            String phone = request.getParameter("passengerPhone");
            int seats = Integer.parseInt(request.getParameter("seats"));

            Schedule schedule = new ScheduleDAO().getById(scheduleId);
            if (schedule == null) {
                request.setAttribute("halaman", "home");
                request.setAttribute("error", "Jadwal tidak ditemukan.");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            if (name == null || name.isBlank() || phone == null || phone.isBlank()) {
                request.setAttribute("halaman", "booking");
                request.setAttribute("schedule", schedule);
                request.setAttribute("error", "Nama dan nomor HP wajib diisi.");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.createBooking(scheduleId, (Integer) userId, name.trim(), phone.trim(), seats);

            if (booking == null) {
                request.setAttribute("halaman", "booking");
                request.setAttribute("schedule", schedule);
                request.setAttribute("error", "Gagal membuat pesanan. Pastikan jumlah kursi valid dan masih tersedia.");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            booking.setSchedule(schedule);
            request.setAttribute("halaman", "booking_success");
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("halaman", "home");
            request.setAttribute("error", "Data pemesanan tidak valid.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}

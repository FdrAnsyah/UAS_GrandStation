package controller;

import dao.ScheduleDAO;
import dao.ScheduleRequestDAO;
import model.Schedule;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

public class SearchScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int originId = Integer.parseInt(request.getParameter("originId"));
            int destinationId = Integer.parseInt(request.getParameter("destinationId"));
            LocalDate travelDate = LocalDate.parse(request.getParameter("travelDate"));

            ScheduleDAO dao = new ScheduleDAO();
            List<Schedule> schedules = dao.search(originId, destinationId, travelDate);

            // If no schedules found, save user request for admin
            if (schedules == null || schedules.isEmpty()) {
                HttpSession session = request.getSession(false);
                Integer userId = null;
                if (session != null) {
                    User user = (User) session.getAttribute("user");
                    if (user != null) {
                        userId = user.getId();
                    }
                }
                ScheduleRequestDAO requestDAO = new ScheduleRequestDAO();
                requestDAO.saveRequest(userId, originId, destinationId, travelDate);
            }

            request.setAttribute("halaman", "schedules");
            request.setAttribute("schedules", schedules);
            request.setAttribute("originId", originId);
            request.setAttribute("destinationId", destinationId);
            request.setAttribute("travelDate", travelDate);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("halaman", "home");
            request.setAttribute("error", "Form pencarian belum lengkap atau format tanggal salah.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}

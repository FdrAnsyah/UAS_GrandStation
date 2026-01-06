package controller;

import dao.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class AdminManagementServlet extends HttpServlet {

    private final StationDAO stationDAO = new StationDAO();
    private final TrainDAO trainDAO = new TrainDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");

        if (!"admin".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        try {
            switch (action) {
                case "manage_stations":
                    showStations(request, response);
                    break;
                case "add_station_form":
                    request.getRequestDispatcher("/admin-station-form.jsp").forward(request, response);
                    break;
                case "edit_station":
                    showEditStation(request, response);
                    break;
                case "delete_station":
                    deleteStation(request, response);
                    break;
                case "manage_trains":
                    showTrains(request, response);
                    break;
                case "add_train_form":
                    showAddTrainForm(request, response);
                    break;
                case "edit_train":
                    showEditTrain(request, response);
                    break;
                case "delete_train":
                    deleteTrain(request, response);
                    break;
                case "manage_schedules":
                    showSchedules(request, response);
                    break;
                case "add_schedule_form":
                    showAddScheduleForm(request, response);
                    break;
                case "edit_schedule":
                    showEditSchedule(request, response);
                    break;
                case "delete_schedule":
                    deleteSchedule(request, response);
                    break;
                case "all_bookings":
                    showAllBookings(request, response);
                    break;
                default:
                    request.getRequestDispatcher("/admin-panel.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Terjadi kesalahan: " + e.getMessage());
            request.getRequestDispatcher("/admin-panel.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");

        if (!"admin".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add_station":
                    addStation(request, response);
                    break;
                case "update_station":
                    updateStation(request, response);
                    break;
                case "add_train":
                    addTrain(request, response);
                    break;
                case "update_train":
                    updateTrain(request, response);
                    break;
                case "add_schedule":
                    addSchedule(request, response);
                    break;
                case "update_schedule":
                    updateSchedule(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin-manage");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Terjadi kesalahan: " + e.getMessage());
            request.getRequestDispatcher("/admin-panel.jsp").forward(request, response);
        }
    }

    // ========== STATION CRUD ==========
    private void showStations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Station> stations = stationDAO.getAll();
        request.setAttribute("stations", stations);
        request.getRequestDispatcher("/admin-stations.jsp").forward(request, response);
    }

    private void showEditStation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Station station = stationDAO.getById(id);
        request.setAttribute("station", station);
        request.getRequestDispatcher("/admin-station-form.jsp").forward(request, response);
    }

    private void addStation(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String city = request.getParameter("city");

        Station station = new Station();
        station.setCode(code.toUpperCase());
        station.setName(name);
        station.setCity(city);

        if (stationDAO.add(station)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_stations&success=add");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=add_station_form&error=add");
        }
    }

    private void updateStation(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String city = request.getParameter("city");

        Station station = new Station();
        station.setId(id);
        station.setCode(code.toUpperCase());
        station.setName(name);
        station.setCity(city);

        if (stationDAO.update(station)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_stations&success=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=edit_station&id=" + id + "&error=update");
        }
    }

    private void deleteStation(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (stationDAO.delete(id)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_stations&success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_stations&error=delete");
        }
    }

    // ========== TRAIN CRUD ==========
    private void showTrains(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Train> trains = trainDAO.getAll();
        request.setAttribute("trains", trains);
        request.getRequestDispatcher("/admin-trains.jsp").forward(request, response);
    }

    private void showAddTrainForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/admin-train-form.jsp").forward(request, response);
    }

    private void showEditTrain(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Train train = trainDAO.getById(id);
        request.setAttribute("train", train);
        request.getRequestDispatcher("/admin-train-form.jsp").forward(request, response);
    }

    private void addTrain(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String trainClass = request.getParameter("train_class");
        int seatsTotal = Integer.parseInt(request.getParameter("seats_total"));

        Train train = new Train();
        train.setCode(code.toUpperCase());
        train.setName(name);
        train.setTrainClass(trainClass);
        train.setSeatsTotal(seatsTotal);

        if (trainDAO.add(train)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_trains&success=add");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=add_train_form&error=add");
        }
    }

    private void updateTrain(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String trainClass = request.getParameter("train_class");
        int seatsTotal = Integer.parseInt(request.getParameter("seats_total"));

        Train train = new Train();
        train.setId(id);
        train.setCode(code.toUpperCase());
        train.setName(name);
        train.setTrainClass(trainClass);
        train.setSeatsTotal(seatsTotal);

        if (trainDAO.update(train)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_trains&success=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=edit_train&id=" + id + "&error=update");
        }
    }

    private void deleteTrain(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (trainDAO.delete(id)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_trains&success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_trains&error=delete");
        }
    }

    // ========== SCHEDULE CRUD ==========
    private void showSchedules(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Schedule> schedules = scheduleDAO.getAll();
        request.setAttribute("schedules", schedules);
        request.getRequestDispatcher("/admin-schedules.jsp").forward(request, response);
    }

    private void showAddScheduleForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Station> stations = stationDAO.getAll();
        List<Train> trains = trainDAO.getAll();
        request.setAttribute("stations", stations);
        request.setAttribute("trains", trains);
        request.getRequestDispatcher("/admin-schedule-form.jsp").forward(request, response);
    }

    private void showEditSchedule(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Schedule schedule = scheduleDAO.getById(id);
        List<Station> stations = stationDAO.getAll();
        List<Train> trains = trainDAO.getAll();
        request.setAttribute("schedule", schedule);
        request.setAttribute("stations", stations);
        request.setAttribute("trains", trains);
        request.getRequestDispatcher("/admin-schedule-form.jsp").forward(request, response);
    }

    private void addSchedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int trainId = Integer.parseInt(request.getParameter("train_id"));
        int originId = Integer.parseInt(request.getParameter("origin_id"));
        int destinationId = Integer.parseInt(request.getParameter("destination_id"));
        String departTimeStr = request.getParameter("depart_time");
        String arriveTimeStr = request.getParameter("arrive_time");
        double price = Double.parseDouble(request.getParameter("price"));
        int seatsAvailable = Integer.parseInt(request.getParameter("seats_available"));

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime departTime = LocalDateTime.parse(departTimeStr, formatter);
        LocalDateTime arriveTime = LocalDateTime.parse(arriveTimeStr, formatter);

        Schedule schedule = new Schedule();
        Train train = new Train();
        train.setId(trainId);
        schedule.setTrain(train);

        Station origin = new Station();
        origin.setId(originId);
        schedule.setOrigin(origin);

        Station destination = new Station();
        destination.setId(destinationId);
        schedule.setDestination(destination);

        schedule.setDepartTime(departTime);
        schedule.setArriveTime(arriveTime);
        schedule.setPrice(price);
        schedule.setSeatsAvailable(seatsAvailable);

        if (scheduleDAO.add(schedule)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_schedules&success=add");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=add_schedule_form&error=add");
        }
    }

    private void updateSchedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int trainId = Integer.parseInt(request.getParameter("train_id"));
        int originId = Integer.parseInt(request.getParameter("origin_id"));
        int destinationId = Integer.parseInt(request.getParameter("destination_id"));
        String departTimeStr = request.getParameter("depart_time");
        String arriveTimeStr = request.getParameter("arrive_time");
        double price = Double.parseDouble(request.getParameter("price"));
        int seatsAvailable = Integer.parseInt(request.getParameter("seats_available"));

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime departTime = LocalDateTime.parse(departTimeStr, formatter);
        LocalDateTime arriveTime = LocalDateTime.parse(arriveTimeStr, formatter);

        Schedule schedule = new Schedule();
        schedule.setId(id);

        Train train = new Train();
        train.setId(trainId);
        schedule.setTrain(train);

        Station origin = new Station();
        origin.setId(originId);
        schedule.setOrigin(origin);

        Station destination = new Station();
        destination.setId(destinationId);
        schedule.setDestination(destination);

        schedule.setDepartTime(departTime);
        schedule.setArriveTime(arriveTime);
        schedule.setPrice(price);
        schedule.setSeatsAvailable(seatsAvailable);

        if (scheduleDAO.update(schedule)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_schedules&success=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=edit_schedule&id=" + id + "&error=update");
        }
    }

    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (scheduleDAO.delete(id)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_schedules&success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_schedules&error=delete");
        }
    }

    private void showAllBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings;

        if (statusFilter != null && !statusFilter.isEmpty()) {
            bookings = bookingDAO.getByStatus(statusFilter);
        } else {
            bookings = bookingDAO.getAll();
        }

        request.setAttribute("bookings", bookings);
        request.setAttribute("halaman", "admin-all-bookings");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}

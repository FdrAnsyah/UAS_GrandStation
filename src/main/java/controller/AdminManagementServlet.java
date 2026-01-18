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
import java.util.Map;

public class AdminManagementServlet extends HttpServlet {

    private final StationDAO stationDAO = new StationDAO();
    private final TrainDAO trainDAO = new TrainDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();
    private final GalleryDAO galleryDAO = new GalleryDAO();

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
                    request.setAttribute("pageTitle", "Tambah Stasiun");
                    request.setAttribute("pageSubtitle", "Tambahkan stasiun baru ke sistem");
                    request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
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
                case "manage_gallery":
                    showGallery(request, response);
                    break;
                case "add_gallery_form":
                    request.setAttribute("pageTitle", "Tambah Foto");
                    request.setAttribute("pageSubtitle", "Tambahkan foto baru ke galeri");
                    request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
                    break;
                case "edit_gallery":
                    showEditGallery(request, response);
                    break;
                case "delete_gallery":
                    deleteGallery(request, response);
                    break;
                case "all_bookings":
                    showAllBookings(request, response);
                    break;
                case "approve_bookings":
                    showApproveBookings(request, response);
                    break;
                case "approve_booking":
                    approveBooking(request, response);
                    break;
                case "reject_booking":
                    rejectBooking(request, response);
                    break;
                case "view_booking_details":
                    viewBookingDetails(request, response);
                    break;
                case "schedule_requests":
                    showScheduleRequests(request, response);
                    break;
                case "review_schedule_request":
                    reviewScheduleRequest(request, response);
                    break;
                case "add_schedule_from_request":
                    addScheduleFromRequest(request, response);
                    break;
                case "dashboard":
                    showDashboard(request, response);
                    break;
                default:
                    // Forward to unified admin dashboard
                    request.setAttribute("pageTitle", "Dashboard Admin");
                    request.setAttribute("pageSubtitle", "Kelola sistem GrandStation");
                    request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
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
                case "add_gallery":
                    addGallery(request, response);
                    break;
                case "update_gallery":
                    updateGallery(request, response);
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
        request.setAttribute("pageTitle", "Kelola Stasiun");
        request.setAttribute("pageSubtitle", "Tambah, ubah, atau hapus stasiun");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }

    private void showEditStation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Station station = stationDAO.getById(id);
        request.setAttribute("station", station);
        request.setAttribute("pageTitle", "Edit Stasiun");
        request.setAttribute("pageSubtitle", "Ubah informasi stasiun");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
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
        request.setAttribute("pageTitle", "Kelola Kereta");
        request.setAttribute("pageSubtitle", "Tambah, ubah, atau hapus kereta");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }

    private void showAddTrainForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Train> trains = trainDAO.getAll();
        List<Station> stations = stationDAO.getAll();
        request.setAttribute("trains", trains);
        request.setAttribute("stations", stations);
        request.setAttribute("pageTitle", "Tambah Kereta");
        request.setAttribute("pageSubtitle", "Tambahkan kereta baru ke sistem");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }

    private void showEditTrain(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Train train = trainDAO.getById(id);
        List<Train> trains = trainDAO.getAll();
        List<Station> stations = stationDAO.getAll();
        request.setAttribute("train", train);
        request.setAttribute("trains", trains);
        request.setAttribute("stations", stations);
        request.setAttribute("pageTitle", "Edit Kereta");
        request.setAttribute("pageSubtitle", "Ubah informasi kereta");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
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
        List<Train> trains = trainDAO.getAll();
        List<Station> stations = stationDAO.getAll();
        request.setAttribute("schedules", schedules);
        request.setAttribute("trains", trains);
        request.setAttribute("stations", stations);
        request.setAttribute("pageTitle", "Kelola Jadwal");
        request.setAttribute("pageSubtitle", "Tambah, ubah, atau hapus jadwal keberangkatan");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }

    private void showAddScheduleForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Station> stations = stationDAO.getAll();
        List<Train> trains = trainDAO.getAll();
        request.setAttribute("stations", stations);
        request.setAttribute("trains", trains);
        // Optional prefill from request parameters
        try {
            String preOrigin = request.getParameter("prefillOriginId");
            String preDest = request.getParameter("prefillDestinationId");
            String preDate = request.getParameter("prefillDate");
            if (preOrigin != null && !preOrigin.isBlank()) {
                request.setAttribute("prefillOriginId", Integer.parseInt(preOrigin));
            }
            if (preDest != null && !preDest.isBlank()) {
                request.setAttribute("prefillDestinationId", Integer.parseInt(preDest));
            }
            if (preDate != null && !preDate.isBlank()) {
                request.setAttribute("prefillDate", preDate);
            }
            String sourceReq = request.getParameter("sourceRequestId");
            if (sourceReq != null && !sourceReq.isBlank()) {
                request.setAttribute("sourceRequestId", Integer.parseInt(sourceReq));
            }
        } catch (Exception ignore) {}
        request.setAttribute("pageTitle", "Tambah Jadwal");
        request.setAttribute("pageSubtitle", "Buat jadwal keberangkatan baru");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }

    private void showEditSchedule(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Schedule schedule = scheduleDAO.getById(id);
        List<Station> stations = stationDAO.getAll();
        List<Train> trains = trainDAO.getAll();
        request.setAttribute("schedule", schedule);
        request.setAttribute("stations", stations);
        request.setAttribute("trains", trains);
        request.setAttribute("pageTitle", "Edit Jadwal");
        request.setAttribute("pageSubtitle", "Ubah jadwal keberangkatan");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
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
            // If created from a schedule request, mark it as created
            String sourceReq = request.getParameter("source_request_id");
            if (sourceReq != null && !sourceReq.isBlank()) {
                try {
                    int reqId = Integer.parseInt(sourceReq);
                    new ScheduleRequestDAO().updateStatus(reqId, "created", null);
                } catch (Exception ignore) {}
            }
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

    // ========== GALLERY CRUD ==========
    private void showGallery(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<GalleryItem> galleries = galleryDAO.getAll();
        request.setAttribute("galleries", galleries);
        request.setAttribute("pageTitle", "Galeri Foto");
        request.setAttribute("pageSubtitle", "Kelola foto dan gambar di galeri");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }

    private void showEditGallery(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        GalleryItem item = galleryDAO.getById(id);
        request.setAttribute("galleryItem", item);
        request.getRequestDispatcher("/admin-gallery-form.jsp").forward(request, response);
    }

    private void addGallery(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("image_url");
        String description = request.getParameter("description");
        boolean featured = request.getParameter("featured") != null;

        GalleryItem item = new GalleryItem();
        item.setTitle(title);
        item.setCategory(category);
        item.setImageUrl(imageUrl);
        item.setDescription(description);
        item.setFeatured(featured);

        if (galleryDAO.add(item)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_gallery&success=add");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=add_gallery_form&error=add");
        }
    }

    private void updateGallery(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("image_url");
        String description = request.getParameter("description");
        boolean featured = request.getParameter("featured") != null;

        GalleryItem item = new GalleryItem();
        item.setId(id);
        item.setTitle(title);
        item.setCategory(category);
        item.setImageUrl(imageUrl);
        item.setDescription(description);
        item.setFeatured(featured);

        if (galleryDAO.update(item)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_gallery&success=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=edit_gallery&id=" + id + "&error=update");
        }
    }

    private void deleteGallery(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (galleryDAO.delete(id)) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_gallery&success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=manage_gallery&error=delete");
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
        request.setAttribute("pageTitle", "Kelola Pesanan");
        request.setAttribute("pageSubtitle", "Kelola dan setujui pesanan penumpang");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }

    private void showApproveBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Tetap arahkan ke halaman unified bookings dengan filter pending
        response.sendRedirect(request.getContextPath() + "/admin-manage?action=all_bookings&status=pending");
    }

    private void approveBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        BookingDAO bookingDAO = new BookingDAO();

        Booking booking = bookingDAO.getById(bookingId);
        if (booking != null && "pending".equals(booking.getStatus())) {
            // Get admin ID from session
            Integer adminId = (Integer) request.getSession().getAttribute("userId");
            if (adminId == null) adminId = 0; // Default to 0 if not found

            // Use the specific approveBooking method which handles seat reduction
            if (bookingDAO.approveBooking(bookingId, adminId)) {
                response.sendRedirect(request.getContextPath() + "/admin-manage?action=all_bookings&success=approved");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin-manage?action=all_bookings&error=approve_failed");
    }

    private void rejectBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        BookingDAO bookingDAO = new BookingDAO();

        Booking booking = bookingDAO.getById(bookingId);
        if (booking != null && "pending".equals(booking.getStatus())) {
            // Get admin ID from session
            Integer adminId = (Integer) request.getSession().getAttribute("userId");
            if (adminId == null) adminId = 0; // Default to 0 if not found

            // Use the specific rejectBooking method
            if (bookingDAO.rejectBooking(bookingId, adminId)) {
                response.sendRedirect(request.getContextPath() + "/admin-manage?action=all_bookings&success=rejected");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin-manage?action=all_bookings&error=reject_failed");
    }

    private void viewBookingDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getById(bookingId);

        if (booking != null) {
            request.setAttribute("booking", booking);
            request.setAttribute("pageTitle", "Detail Pesanan");
            request.setAttribute("pageSubtitle", "Informasi lengkap tentang pesanan");
            // The action parameter is already "view_booking_details" from the request
            request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=all_bookings&error=not_found");
        }
    }

    private void showScheduleRequests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ScheduleRequestDAO requestDAO = new ScheduleRequestDAO();
        List<Map<String, Object>> scheduleRequests = requestDAO.getPendingRequests();

        request.setAttribute("scheduleRequests", scheduleRequests);
        request.setAttribute("pageTitle", "Request Jadwal User");
        request.setAttribute("pageSubtitle", "Kelola permintaan jadwal dari pengguna");
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }

    private void reviewScheduleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int reqId = Integer.parseInt(idParam);
                new ScheduleRequestDAO().updateStatus(reqId, "reviewed", null);
            } catch (Exception ignore) {}
        }
        response.sendRedirect(request.getContextPath() + "/admin-manage?action=schedule_requests&success=reviewed");
    }

    private void addScheduleFromRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=schedule_requests&error=invalid_id");
            return;
        }
        try {
            int reqId = Integer.parseInt(idParam);
            ScheduleRequestDAO requestDAO = new ScheduleRequestDAO();
            Map<String, Object> req = requestDAO.getById(reqId);
            if (req == null) {
                response.sendRedirect(request.getContextPath() + "/admin-manage?action=schedule_requests&error=not_found");
                return;
            }
            int originId = (int) req.get("origin_station_id");
            int destId = (int) req.get("destination_station_id");
            Object dateObj = req.get("requested_date");
            String dateStr = dateObj != null ? dateObj.toString() : "";
            // Redirect to add_schedule_form with prefill params and source request id
            String redirectUrl = String.format("%s/admin-manage?action=add_schedule_form&prefillOriginId=%d&prefillDestinationId=%d&prefillDate=%s&sourceRequestId=%d",
                    request.getContextPath(), originId, destId, dateStr, reqId);
            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin-manage?action=schedule_requests&error=exception");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        TrainDAO trainDAO = new TrainDAO();
        StationDAO stationDAO = new StationDAO();

        // Get all data needed for dashboard
        List<Booking> bookings = bookingDAO.getAll();
        List<Train> trains = trainDAO.getAll();
        List<Station> stations = stationDAO.getAll();

        // Set attributes for JSP
        request.setAttribute("bookings", bookings);
        request.setAttribute("trains", trains);
        request.setAttribute("stations", stations);
        request.setAttribute("pageTitle", "Dashboard Admin");
        request.setAttribute("pageSubtitle", "Statistik dan ringkasan sistem");

        // Forward to unified admin dashboard
        request.getRequestDispatcher("/admin-dashboard-unified.jsp").forward(request, response);
    }
}

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.*, model.*, java.util.*, java.time.format.DateTimeFormatter" %>

<%
    // Check authentication
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String action = request.getParameter("action") != null ? request.getParameter("action") : "dashboard";
    String pageTitle = "Dashboard Admin";
    String pageSubtitle = "Kelola sistem GrandStation";
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");

    // Get DAOs
    BookingDAO bookingDAO = new BookingDAO();
    TrainDAO trainDAO = new TrainDAO();
    StationDAO stationDAO = new StationDAO();
    ScheduleDAO scheduleDAO = new ScheduleDAO();
    GalleryDAO galleryDAO = new GalleryDAO();

    // Get data
    List<Booking> allBookings = bookingDAO.getAll();
    List<Train> trains = trainDAO.getAll();
    List<Station> stations = stationDAO.getAll();
    List<Schedule> schedules = scheduleDAO.getAll();
    List<GalleryItem> galleries = galleryDAO.getAll();

    int bookingCount = allBookings != null ? allBookings.size() : 0;
    int trainCount = trains != null ? trains.size() : 0;
    int stationCount = stations != null ? stations.size() : 0;

    // Set attributes for JSP content
    request.setAttribute("pageTitle", pageTitle);
    request.setAttribute("pageSubtitle", pageSubtitle);
    request.setAttribute("action", action);
    request.setAttribute("bookings", allBookings);
    request.setAttribute("trains", trains);
    request.setAttribute("stations", stations);
    request.setAttribute("schedules", schedules);
    request.setAttribute("galleries", galleries);
    request.setAttribute("bookingCount", bookingCount);
    request.setAttribute("trainCount", trainCount);
    request.setAttribute("stationCount", stationCount);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - GrandStation Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Space Grotesk', sans-serif;
        }

        .sidebar-gradient {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 45%, #7f1d1d 100%);
        }

        /* Static Sidebar for Desktop */
        @media (min-width: 768px) {
            body {
                display: flex;
            }
            .admin-sidebar {
                position: fixed;
                left: 0;
                top: 0;
                width: 256px;
                height: 100vh;
                overflow-y: auto;
                z-index: 40;
            }
            .admin-main {
                margin-left: 256px;
                width: calc(100% - 256px);
            }
        }

        /* Mobile Sidebar */
        @media (max-width: 767px) {
            .admin-sidebar {
                position: fixed;
                left: 0;
                top: 0;
                width: 100%;
                height: 100vh;
                z-index: 50;
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            .admin-sidebar.show {
                transform: translateX(0);
            }
            .sidebar-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.5);
                z-index: 40;
                display: none;
            }
            .sidebar-overlay.show {
                display: block;
            }
            .admin-main {
                margin-left: 0;
            }
        }

        .sidebar-link {
            @apply flex items-center gap-3 px-4 py-3 rounded-lg transition;
        }

        .sidebar-link.active {
            @apply bg-white/20 text-white;
        }

        .sidebar-link:not(.active) {
            @apply hover:bg-white/10 text-white/90;
        }
    </style>
</head>
<body class="bg-gray-100">
    <!-- Sidebar Overlay (Mobile) -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- Sidebar -->
    <aside class="admin-sidebar sidebar-gradient text-white flex flex-col" id="adminSidebar">
        <!-- Sidebar Header -->
        <div class="p-6 border-b border-white/10">
            <div class="flex items-center justify-between mb-8">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-lg bg-white text-red-700 flex items-center justify-center font-bold">GS</div>
                    <div>
                        <div class="font-bold text-lg">GrandStation</div>
                        <div class="text-xs opacity-75">Admin Panel</div>
                    </div>
                </div>
                <button class="md:hidden text-white hover:bg-white/10 p-2 rounded-lg" id="closeSidebar">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                </button>
            </div>
        </div>

        <!-- Navigation Menu -->
        <nav class="flex-1 overflow-y-auto px-3 py-4 space-y-2">
            <a href="<%= request.getContextPath() %>/admin-manage" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-lg transition <%= "dashboard".equals(action) || action.isEmpty() ? "bg-white/20 text-white" : "text-white/90 hover:bg-white/10" %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
                </svg>
                <span class="font-medium">Dashboard</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin-manage?action=manage_stations" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-lg transition <%= "manage_stations".equals(action) || "add_station_form".equals(action) || "edit_station".equals(action) ? "bg-white/20 text-white" : "text-white/90 hover:bg-white/10" %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-2 2 2 0 000 2z" clip-rule="evenodd" />
                </svg>
                <span class="font-medium">Stasiun</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin-manage?action=manage_trains" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-lg transition <%= "manage_trains".equals(action) || "add_train_form".equals(action) || "edit_train".equals(action) ? "bg-white/20 text-white" : "text-white/90 hover:bg-white/10" %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path d="M8 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM15 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0z" />
                    <path d="M3 4a1 1 0 00-1 1v10a1 1 0 001 1h1.05a2.5 2.5 0 014.9 0H10a1 1 0 001-1v-1h4.05a2.5 2.5 0 014.9 0H20a1 1 0 001-1v-4a1 1 0 00-.293-.707l-4-4A1 1 0 0016 4H3z" />
                </svg>
                <span class="font-medium">Kereta</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-lg transition <%= "manage_schedules".equals(action) || "add_schedule_form".equals(action) || "edit_schedule".equals(action) ? "bg-white/20 text-white" : "text-white/90 hover:bg-white/10" %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
                </svg>
                <span class="font-medium">Jadwal</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin-manage?action=manage_gallery" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-lg transition <%= "manage_gallery".equals(action) || "add_gallery_form".equals(action) || "edit_gallery".equals(action) ? "bg-white/20 text-white" : "text-white/90 hover:bg-white/10" %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z" clip-rule="evenodd" />
                </svg>
                <span class="font-medium">Galeri</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin-manage?action=all_bookings" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-lg transition <%= "all_bookings".equals(action) || "approve_bookings".equals(action) ? "bg-white/20 text-white" : "text-white/90 hover:bg-white/10" %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
                    <path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd" />
                </svg>
                <span class="font-medium">Kelola Pesanan</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin-manage?action=schedule_requests" class="sidebar-link flex items-center gap-3 px-4 py-3 rounded-lg transition <%= "schedule_requests".equals(action) ? "bg-white/20 text-white" : "text-white/90 hover:bg-white/10" %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                </svg>
                <span class="font-medium">Request User</span>
            </a>
        </nav>

        <!-- Admin Profile & Actions -->
        <div class="p-4 border-t border-white/10 space-y-3 mt-auto">
            <div class="flex items-center gap-3 px-3 py-2">
                <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center flex-shrink-0">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-6-3a2 2 0 11-4 0 2 2 0 014 0zm-2 4a5 5 0 00-4.546 2.916A5.986 5.986 0 005 10a6 6 0 0012 0c0-.35-.036-.687-.101-1.004A5 5 0 0010 11z" clip-rule="evenodd" />
                    </svg>
                </div>
                <div class="min-w-0 flex-1">
                    <div class="font-medium">Admin</div>
                    <div class="text-xs opacity-75">Administrator</div>
                </div>
            </div>

            <a href="<%= request.getContextPath() %>/index.jsp?halaman=home" class="flex items-center gap-2 px-3 py-2 rounded-lg bg-white/10 hover:bg-white/20 transition text-sm">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 11-16 0 8 8 0 0116 0zm.707-10.293a1 1 0 00-1.414 0l-3 3a1 1 0 000 1.414l3 3a1 1 0 001.414-1.414L9.414 11H13a1 1 0 100-2H9.414l1.293-1.293z" clip-rule="evenodd" />
                </svg>
                <span>Halaman Utama</span>
            </a>

            <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-2 px-3 py-2 rounded-lg bg-red-600/20 hover:bg-red-600/30 transition text-sm text-red-100">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M3 3a1 1 0 00-1 1v12a1 1 0 102 0V4a1 1 0 00-1-1zm10.293 9.293a1 1 0 001.414 1.414l3-3a1 1 0 000-1.414l-3-3a1 1 0 00-1.414 1.414L14.586 9H7a1 1 0 100 2h7.586l-1.293 1.293z" clip-rule="evenodd" />
                </svg>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="admin-main flex flex-col min-h-screen">
        <!-- Top Header -->
        <header class="bg-white shadow-sm sticky top-0 z-30">
            <div class="px-4 sm:px-6 lg:px-8 py-4 flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <button class="md:hidden p-2 hover:bg-gray-100 rounded-lg" id="openSidebar">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>
                    <div>
                        <h1 class="text-xl sm:text-2xl font-bold text-gray-900"><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Admin Dashboard" %></h1>
                        <p class="text-xs sm:text-sm text-gray-600"><%= request.getAttribute("pageSubtitle") != null ? request.getAttribute("pageSubtitle") : "Kelola sistem GrandStation" %></p>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <div class="text-right hidden sm:block">
                        <div class="font-medium text-gray-900">Admin</div>
                        <div class="text-xs text-gray-600">Administrator</div>
                    </div>
                    <div class="w-8 h-8 sm:w-10 sm:h-10 rounded-full bg-gradient-to-br from-red-500 to-red-700 flex items-center justify-center text-white font-bold">A</div>
                </div>
            </div>
        </header>

        <!-- Page Content -->
        <div class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8 bg-gray-50">
            <div class="max-w-7xl mx-auto">
                <!-- DASHBOARD -->
                <% if ("dashboard".equals(action) || action.isEmpty()) { %>
                    <jsp:include page="/admin-content/dashboard.jsp" />
                <% } %>

                <!-- STATIONS MANAGEMENT -->
                <% if ("manage_stations".equals(action)) { %>
                    <jsp:include page="/admin-content/stations-list.jsp" />
                <% } %>
                <% if ("add_station_form".equals(action) || "edit_station".equals(action)) { %>
                    <jsp:include page="/admin-content/station-form.jsp" />
                <% } %>

                <!-- TRAINS MANAGEMENT -->
                <% if ("manage_trains".equals(action)) { %>
                    <jsp:include page="/admin-content/trains-list.jsp" />
                <% } %>
                <% if ("add_train_form".equals(action) || "edit_train".equals(action)) { %>
                    <jsp:include page="/admin-content/train-form.jsp" />
                <% } %>

                <!-- SCHEDULES MANAGEMENT -->
                <% if ("manage_schedules".equals(action)) { %>
                    <jsp:include page="/admin-content/schedules-list.jsp" />
                <% } %>
                <% if ("add_schedule_form".equals(action) || "edit_schedule".equals(action)) { %>
                    <jsp:include page="/admin-content/schedule-form.jsp" />
                <% } %>

                <!-- GALLERY MANAGEMENT -->
                <% if ("manage_gallery".equals(action)) { %>
                    <jsp:include page="/admin-content/gallery-list.jsp" />
                <% } %>
                <% if ("add_gallery_form".equals(action) || "edit_gallery".equals(action)) { %>
                    <jsp:include page="/admin-content/gallery-form.jsp" />
                <% } %>

                <!-- BOOKINGS MANAGEMENT -->
                <% if ("all_bookings".equals(action)) { %>
                    <jsp:include page="/admin-content/bookings-list.jsp" />
                <% } %>

                <!-- APPROVE BOOKINGS -->
                <% if ("approve_bookings".equals(action)) { %>
                    <jsp:include page="/admin-content/bookings-list.jsp" />
                <% } %>

                <!-- SCHEDULE REQUESTS -->
                <% if ("schedule_requests".equals(action)) { %>
                    <jsp:include page="/admin-content/schedule-requests.jsp" />
                <% } %>
            </div>
        </div>
    </main>

    <script>
        const adminSidebar = document.getElementById('adminSidebar');
        const sidebarOverlay = document.getElementById('sidebarOverlay');
        const openSidebarBtn = document.getElementById('openSidebar');
        const closeSidebarBtn = document.getElementById('closeSidebar');

        function openSidebar() {
            adminSidebar?.classList.add('show');
            sidebarOverlay?.classList.add('show');
        }

        function closeSidebar() {
            adminSidebar?.classList.remove('show');
            sidebarOverlay?.classList.remove('show');
        }

        openSidebarBtn?.addEventListener('click', openSidebar);
        closeSidebarBtn?.addEventListener('click', closeSidebar);
        sidebarOverlay?.addEventListener('click', closeSidebar);

        // Close sidebar when a link is clicked (mobile)
        if (window.innerWidth < 768) {
            document.querySelectorAll('.sidebar-link').forEach(link => {
                link.addEventListener('click', closeSidebar);
            });
        }
    </script>
</body>
</html>

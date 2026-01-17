<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.*, java.util.*, java.time.format.DateTimeFormatter" %>

<%
    // Check role - only admin can access this page
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?halaman=home&error=access_denied");
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (request.getAttribute("schedule") != null) ? "Edit Jadwal" : "Tambah Jadwal Baru" %> - GrandStation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Space Grotesk', sans-serif;
        }
        .sidebar-gradient {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 45%, #7f1d1d 100%);
        }
        .tab-active {
            border-bottom: 4px solid #dc2626;
            color: #dc2626;
            font-weight: 700;
        }
        .tab-inactive {
            border-bottom: 4px solid transparent;
            color: #64748b;
        }
    </style>
</head>
<body class="bg-gray-100 h-screen flex flex-col md:flex-row overflow-hidden">
    <!-- Sidebar -->
    <aside class="sidebar-gradient text-white w-full md:w-64 h-screen flex flex-col overflow-y-hidden">
        <div class="p-6">
            <div class="flex items-center gap-3 mb-10">
                <div class="w-10 h-10 rounded-lg bg-white text-red-700 flex items-center justify-center font-bold">GS</div>
                <div>
                    <div class="font-bold text-lg">GrandStation</div>
                    <div class="text-xs opacity-80">Admin Dashboard</div>
                </div>
            </div>

            <nav class="space-y-1">
                <a href="<%= request.getContextPath() %>/admin-manage" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
                    </svg>
                    <span>Dashboard</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_stations" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
                    </svg>
                    <span>Stasiun</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_trains" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M8 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM15 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0z" />
                        <path d="M3 4a1 1 0 00-1 1v10a1 1 0 001 1h1.05a2.5 2.5 0 014.9 0H10a1 1 0 001-1v-1h4.05a2.5 2.5 0 014.9 0H20a1 1 0 001-1v-4a1 1 0 00-.293-.707l-4-4A1 1 0 0016 4H3z" />
                    </svg>
                    <span>Kereta</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-white/20 hover:bg-white/30 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
                    </svg>
                    <span>Jadwal</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_gallery" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z" clip-rule="evenodd" />
                    </svg>
                    <span>Galeri</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=all_bookings" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
                        <path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd" />
                    </svg>
                    <span>Kelola Pesanan</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-schedule-requests.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                    </svg>
                    <span>Request User</span>
                </a>
            </nav>
        </div>

        <div class="w-full md:w-64 p-4 bg-black/10 mt-auto">
            <div class="flex items-center gap-3 mb-3">
                <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-6-3a2 2 0 11-4 0 2 2 0 014 0zm-2 4a5 5 0 00-4.546 2.916A5.986 5.986 0 005 10a6 6 0 0012 0c0-.35-.036-.687-.101-1.004A5 5 0 0010 11z" clip-rule="evenodd" />
                    </svg>
                </div>
                <div>
                    <div class="font-medium">Admin</div>
                    <div class="text-xs opacity-80">Administrator</div>
                </div>
            </div>

            <div class="space-y-1">
                <a href="${pageContext.request.contextPath}/index.jsp?halaman=home" class="flex w-full px-4 py-2 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
                    </svg>
                    <span>Halaman Utama</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin-manage" class="flex w-full px-4 py-2 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10 12a2 2 0 100-4 2 2 0 000 4z" />
                        <path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd" />
                    </svg>
                    <span>Dashboard Admin</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="flex w-full px-4 py-2 rounded-lg text-red-200 hover:bg-red-600 hover:text-white transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M3 3a1 1 0 00-1 1v12a1 1 0 102 0V4a1 1 0 00-1-1zm10.293 9.293a1 1 0 001.414 1.414l3-3a1 1 0 000-1.414l-3-3a1 1 0 10-1.414 1.414L14.586 9H7a1 1 0 100 2h7.586l-1.293 1.293z" clip-rule="evenodd" />
                    </svg>
                    <span>Logout</span>
                </a>
            </div>
        </div>
    </aside>

    <!-- Mobile sidebar toggle button -->
    <div class="fixed top-4 left-4 z-50 md:hidden">
        <button id="sidebar-toggle" class="p-2 rounded-lg bg-red-600 text-white">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
        </button>
    </div>

    <!-- Mobile sidebar overlay -->
    <div id="sidebar-overlay" class="fixed inset-0 z-40 bg-black/50 hidden md:hidden"></div>

    <!-- Mobile sidebar -->
    <aside id="mobile-sidebar" class="fixed top-0 left-0 z-50 w-64 h-full bg-gradient-to-b from-red-700 to-red-900 text-white transform -translate-x-full transition-transform duration-300 ease-in-out md:hidden">
        <div class="p-6 pt-16">
            <div class="flex items-center gap-3 mb-10">
                <div class="w-10 h-10 rounded-lg bg-white text-red-700 flex items-center justify-center font-bold">GS</div>
                <div>
                    <div class="font-bold text-lg">GrandStation</div>
                    <div class="text-xs opacity-80">Admin Dashboard</div>
                </div>
            </div>

            <nav class="space-y-1">
                <a href="<%= request.getContextPath() %>/admin-manage" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
                    </svg>
                    <span>Dashboard</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_stations" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
                    </svg>
                    <span>Stasiun</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_trains" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M8 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM15 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0z" />
                        <path d="M3 4a1 1 0 00-1 1v10a1 1 0 001 1h1.05a2.5 2.5 0 014.9 0H10a1 1 0 001-1v-1h4.05a2.5 2.5 0 014.9 0H20a1 1 0 001-1v-4a1 1 0 00-.293-.707l-4-4A1 1 0 0016 4H3z" />
                    </svg>
                    <span>Kereta</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-white/20 hover:bg-white/30 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
                    </svg>
                    <span>Jadwal</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_gallery" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z" clip-rule="evenodd" />
                    </svg>
                    <span>Galeri</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage?action=all_bookings" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
                        <path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd" />
                    </svg>
                    <span>Kelola Pesanan</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-schedule-requests.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                    </svg>
                    <span>Request User</span>
                </a>
            </nav>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col overflow-y-auto">
        <!-- Top bar -->
        <header class="bg-white shadow-sm">
            <div class="px-6 py-4 flex items-center justify-between">
                <div>
                    <%
                        Schedule schedule = (Schedule) request.getAttribute("schedule");
                        List<Station> stations = (List<Station>) request.getAttribute("stations");
                        List<Train> trains = (List<Train>) request.getAttribute("trains");
                        boolean isEdit = (schedule != null);
                        String title = isEdit ? "Edit Jadwal" : "Tambah Jadwal Baru";
                        String subtitle = isEdit ? "Ubah informasi jadwal berikut" : "Lengkapi informasi jadwal perjalanan";

                        DateTimeFormatter dtFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                        String departTimeValue = isEdit ? schedule.getDepartTime().format(dtFormatter) : "";
                        String arriveTimeValue = isEdit ? schedule.getArriveTime().format(dtFormatter) : "";
                    %>
                    <h1 class="text-2xl font-bold text-gray-800"><%= title %></h1>
                    <p class="text-gray-600"><%= subtitle %></p>
                </div>
                <div class="flex items-center gap-4">
                    <button class="p-2 rounded-lg hover:bg-gray-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                        </svg>
                    </button>
                    <div class="flex items-center gap-2">
                        <div class="w-8 h-8 rounded-full bg-red-100 flex items-center justify-center">
                            <span class="text-red-700 font-bold">A</span>
                        </div>
                        <span class="font-medium text-gray-700">Admin</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- Page content -->
        <main class="flex-1 p-6 bg-gray-50 overflow-y-auto">
            <%
                String error = request.getParameter("error");
                if (error != null) {
            %>
                <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 rounded">
                    <p class="text-red-700 font-semibold">Gagal <%= isEdit ? "mengupdate" : "menambahkan" %> jadwal. Silakan coba lagi.</p>
                </div>
            <% } %>

            <!-- Form Card -->
            <div class="bg-white rounded-xl shadow border border-gray-200 p-8 max-w-4xl mx-auto">
                <%
                    String action = isEdit ? "update_schedule" : "add_schedule";
                    String buttonText = isEdit ? "Perbarui Jadwal" : "Tambah Jadwal";
                %>

                <form method="POST" action="<%= request.getContextPath() %>/admin-manage" class="space-y-6">
                    <input type="hidden" name="action" value="<%= action %>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%= schedule.getId() %>">
                    <% } %>

                    <!-- Kereta -->
                    <div>
                        <label for="train_id" class="block text-sm font-semibold text-gray-700 mb-2">
                            Kereta <span class="text-red-500">*</span>
                        </label>
                        <select
                            id="train_id"
                            name="train_id"
                            required
                            class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500"
                        >
                            <option value="">-- Pilih Kereta --</option>
                            <% if (trains != null) {
                                for (Train t : trains) { %>
                                    <option value="<%= t.getId() %>" <%= isEdit && schedule.getTrain().getId() == t.getId() ? "selected" : "" %>>
                                        <%= t.getCode() %> - <%= t.getName() %> (<%= t.getTrainClass() %>)
                                    </option>
                                <% }
                            } %>
                        </select>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Stasiun Asal -->
                        <div>
                            <label for="origin_id" class="block text-sm font-semibold text-gray-700 mb-2">
                                Stasiun Asal <span class="text-red-500">*</span>
                            </label>
                            <select
                                id="origin_id"
                                name="origin_id"
                                required
                                class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500"
                            >
                                <option value="">-- Pilih Stasiun Asal --</option>
                                <% if (stations != null) {
                                    for (Station s : stations) { %>
                                        <option value="<%= s.getId() %>" <%= isEdit && schedule.getOrigin().getId() == s.getId() ? "selected" : "" %>>
                                            <%= s.getName() %> (<%= s.getCity() %>)
                                        </option>
                                    <% }
                                } %>
                            </select>
                        </div>

                        <!-- Stasiun Tujuan -->
                        <div>
                            <label for="destination_id" class="block text-sm font-semibold text-gray-700 mb-2">
                                Stasiun Tujuan <span class="text-red-500">*</span>
                            </label>
                            <select
                                id="destination_id"
                                name="destination_id"
                                required
                                class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500"
                            >
                                <option value="">-- Pilih Stasiun Tujuan --</option>
                                <% if (stations != null) {
                                    for (Station s : stations) { %>
                                        <option value="<%= s.getId() %>" <%= isEdit && schedule.getDestination().getId() == s.getId() ? "selected" : "" %>>
                                            <%= s.getName() %> (<%= s.getCity() %>)
                                        </option>
                                    <% }
                                } %>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Waktu Keberangkatan -->
                        <div>
                            <label for="depart_time" class="block text-sm font-semibold text-gray-700 mb-2">
                                Waktu Keberangkatan <span class="text-red-500">*</span>
                            </label>
                            <input
                                type="datetime-local"
                                id="depart_time"
                                name="depart_time"
                                value="<%= departTimeValue %>"
                                required
                                class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500"
                            >
                        </div>

                        <!-- Waktu Kedatangan -->
                        <div>
                            <label for="arrive_time" class="block text-sm font-semibold text-gray-700 mb-2">
                                Waktu Kedatangan <span class="text-red-500">*</span>
                            </label>
                            <input
                                type="datetime-local"
                                id="arrive_time"
                                name="arrive_time"
                                value="<%= arriveTimeValue %>"
                                required
                                class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500"
                            >
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Harga -->
                        <div>
                            <label for="price" class="block text-sm font-semibold text-gray-700 mb-2">
                                Harga (Rp) <span class="text-red-500">*</span>
                            </label>
                            <input
                                type="number"
                                id="price"
                                name="price"
                                value="<%= isEdit ? (int)schedule.getPrice() : "" %>"
                                required
                                min="0"
                                step="1000"
                                placeholder="Contoh: 150000"
                                class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500"
                            >
                        </div>

                        <!-- Kursi Tersedia -->
                        <div>
                            <label for="seats_available" class="block text-sm font-semibold text-gray-700 mb-2">
                                Kursi Tersedia <span class="text-red-500">*</span>
                            </label>
                            <input
                                type="number"
                                id="seats_available"
                                name="seats_available"
                                value="<%= isEdit ? schedule.getSeatsAvailable() : "" %>"
                                required
                                min="0"
                                placeholder="Contoh: 200"
                                class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500"
                            >
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="flex gap-4 pt-6 border-t-2 border-gray-100">
                        <button
                            type="submit"
                            class="flex-1 py-3 bg-gradient-to-r from-red-500 to-red-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg"
                        >
                            <%= buttonText %>
                        </button>
                        <a
                            href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules"
                            class="flex-1 py-3 border-2 border-gray-300 text-gray-700 font-bold rounded-lg hover:bg-gray-50 transition text-center"
                        >
                            Batal
                        </a>
                    </div>
                </form>
            </div>

            <!-- Info Box -->
            <div class="mt-8 p-4 bg-red-50 border-l-4 border-red-500 rounded max-w-4xl mx-auto">
                <p class="text-sm text-red-800">
                    <strong>Catatan:</strong> Pastikan informasi jadwal lengkap dan akurat sebelum menyimpan.
                </p>
            </div>
        </main>
    </div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.*, model.*, java.util.*" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - GrandStation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Space Grotesk', sans-serif;
        }
        .hero-gradient {
            background: linear-gradient(135deg, #0369a1 0%, #0284c7 45%, #0f172a 100%);
        }
        .tab-active {
            border-bottom: 4px solid #0284c7;
            color: #0369a1;
            font-weight: 700;
        }
        .tab-inactive {
            border-bottom: 4px solid transparent;
            color: #64748b;
        }
    </style>
</head>
<body class="bg-slate-50 flex flex-col min-h-screen">
    <jsp:include page="menu.jsp" />

    <div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8 py-12 flex-grow">
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="mb-6 p-4 bg-rose-50 border-l-4 border-rose-500 rounded">
                <p class="text-rose-700 font-semibold"><%= error %></p>
            </div>
        <% } %>

        <%
            String success = (String) request.getAttribute("success");
            if (success != null) {
        %>
            <div class="mb-6 p-4 bg-emerald-50 border-l-4 border-emerald-500 rounded">
                <p class="text-emerald-700 font-semibold"><%= success %></p>
            </div>
        <% } %>

        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-4xl font-bold text-sky-700 mb-2">Admin Dashboard</h1>
            <p class="text-slate-600">Kelola stasiun, kereta, dan jadwal perjalanan</p>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mb-8">
            <%
                try {
                    StationDAO stationDAO = new StationDAO();
                    TrainDAO trainDAO = new TrainDAO();
                    ScheduleDAO scheduleDAO = new ScheduleDAO();
                    BookingDAO bookingDAO = new BookingDAO();
                    int pendingCount = bookingDAO.getPendingBookings().size();
            %>
                <div class="bg-white rounded-xl shadow border border-slate-100 p-6">
                    <p class="text-sm text-slate-600 font-semibold mb-2">Total Stasiun</p>
                    <p class="text-3xl font-bold text-sky-700"><%= stationDAO.getAll().size() %></p>
                </div>
                <div class="bg-white rounded-xl shadow border border-slate-100 p-6">
                    <p class="text-sm text-slate-600 font-semibold mb-2">Total Kereta</p>
                    <p class="text-3xl font-bold text-sky-700"><%= trainDAO.getAll().size() %></p>
                </div>
                <div class="bg-white rounded-xl shadow border border-slate-100 p-6">
                    <p class="text-sm text-slate-600 font-semibold mb-2">Total Jadwal</p>
                    <p class="text-3xl font-bold text-sky-700"><%= scheduleDAO.getAll().size() %></p>
                </div>
                <div class="bg-white rounded-xl shadow border border-slate-100 p-6">
                    <p class="text-sm text-slate-600 font-semibold mb-2">Total Pemesanan</p>
                    <p class="text-3xl font-bold text-sky-700"><%= bookingDAO.getAll().size() %></p>
                </div>
                <a href="<%= request.getContextPath() %>/admin-bookings" class="bg-gradient-to-br from-amber-500 to-orange-600 rounded-xl shadow-lg p-6 hover:shadow-xl hover:-translate-y-1 transition-all">
                    <p class="text-sm text-white font-semibold mb-2">⏳ Perlu Approve</p>
                    <p class="text-3xl font-bold text-white"><%= pendingCount %></p>
                </a>
            <%
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>

        <!-- Tab Navigation -->
        <div class="flex gap-4 mb-8 border-b-2 border-slate-200 overflow-x-auto">
            <a href="<%= request.getContextPath() %>/admin-manage" class="tab-active pb-4 whitespace-nowrap">
                Ringkasan
            </a>
            <a href="<%= request.getContextPath() %>/admin-manage?action=manage_stations" class="tab-inactive pb-4 hover:text-sky-600 whitespace-nowrap">
                Stasiun
            </a>
            <a href="<%= request.getContextPath() %>/admin-manage?action=manage_trains" class="tab-inactive pb-4 hover:text-sky-600 whitespace-nowrap">
                Kereta
            </a>
            <a href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules" class="tab-inactive pb-4 hover:text-sky-600 whitespace-nowrap">
                Jadwal
            </a>
            <a href="<%= request.getContextPath() %>/admin-bookings" class="tab-inactive pb-4 hover:text-sky-600 whitespace-nowrap">
                Approve Pesanan
            </a>
            <a href="<%= request.getContextPath() %>/admin-manage?action=all_bookings" class="tab-inactive pb-4 hover:text-sky-600 whitespace-nowrap">
                Riwayat Pesanan
            </a>
            <a href="<%= request.getContextPath() %>/admin-schedule-requests.jsp" class="tab-inactive pb-4 hover:text-sky-600 whitespace-nowrap">
                Request User
            </a>
        </div>

        <!-- Main Content -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left Side -->
            <div class="lg:col-span-2">
                <!-- Quick Actions -->
                <div class="bg-white rounded-xl shadow border border-slate-100 p-6 mb-8">
                    <h2 class="text-xl font-bold text-slate-900 mb-4">Tindakan Cepat</h2>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <a href="<%= request.getContextPath() %>/admin-bookings" class="px-4 py-3 bg-gradient-to-r from-amber-500 to-orange-600 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg">
                            ⏳ Approve Pesanan
                        </a>
                        <a href="<%= request.getContextPath() %>/admin-manage?action=all_bookings" class="px-4 py-3 bg-gradient-to-r from-emerald-500 to-teal-600 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg">
                            📋 Riwayat Pesanan
                        </a>
                        <a href="<%= request.getContextPath() %>/admin-manage?action=add_station_form" class="px-4 py-3 bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg">
                            + Tambah Stasiun
                        </a>
                        <a href="<%= request.getContextPath() %>/admin-manage?action=manage_stations" class="px-4 py-3 border-2 border-sky-600 text-sky-700 font-bold rounded-lg hover:bg-sky-50 transition">
                            Kelola Stasiun
                        </a>
                        <a href="<%= request.getContextPath() %>/admin-manage?action=manage_trains" class="px-4 py-3 border-2 border-sky-600 text-sky-700 font-bold rounded-lg hover:bg-sky-50 transition">
                            Kelola Kereta
                        </a>
                        <a href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules" class="px-4 py-3 border-2 border-sky-600 text-sky-700 font-bold rounded-lg hover:bg-sky-50 transition">
                            Kelola Jadwal
                        </a>
                    </div>
                </div>

                <!-- Recent Bookings -->
                <div class="bg-white rounded-xl shadow border border-slate-100 p-6">
                    <h2 class="text-xl font-bold text-slate-900 mb-4">Pemesanan Terbaru</h2>
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm">
                            <thead class="border-b-2 border-slate-200">
                                <tr>
                                    <th class="text-left py-3 px-4 font-bold text-slate-700">Kode Booking</th>
                                    <th class="text-left py-3 px-4 font-bold text-slate-700">Penumpang</th>
                                    <th class="text-left py-3 px-4 font-bold text-slate-700">Rute</th>
                                    <th class="text-left py-3 px-4 font-bold text-slate-700">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        BookingDAO bookingDAO = new BookingDAO();
                                        // List<Booking> bookings = bookingDAO.getAll();
                                        // Show placeholder for now
                                %>
                                    <tr class="border-b border-slate-100 hover:bg-slate-50">
                                        <td colspan="4" class="text-center py-6 text-slate-600">
                                            Data akan ditampilkan setelah database terhubung
                                        </td>
                                    </tr>
                                <%
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- Right Side -->
                <div class="bg-white rounded-xl shadow border border-slate-100 p-6">
                    <h3 class="font-bold text-slate-900 mb-3">🔧 Bantuan</h3>
                    <p class="text-sm text-slate-600 mb-4">
                        Jika Anda memerlukan bantuan dalam mengelola sistem, hubungi tim support kami.
                    </p>
                    <button class="w-full px-4 py-2 border-2 border-slate-300 text-slate-700 font-bold rounded-lg hover:bg-slate-50 transition">
                        Hubungi Support
                    </button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

    <script>
        // Navigation setup
        document.addEventListener('DOMContentLoaded', function() {
            // Add active tab logic if needed
        });
    </script>
</body>
</html>

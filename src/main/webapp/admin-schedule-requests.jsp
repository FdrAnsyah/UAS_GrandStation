<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ScheduleRequestDAO, java.util.*, java.time.format.DateTimeFormatter" %>

<%
    // Check authentication
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Jadwal - GrandStation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Space Grotesk', sans-serif;
        }
        .sidebar-gradient {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 45%, #7f1d1d 100%);
        }
    </style>
</head>
<body class="bg-gray-100 h-screen overflow-hidden flex flex-col md:flex-row">
    <!-- Sidebar -->
    <aside class="sidebar-gradient text-white w-full md:w-64 h-auto md:h-screen flex flex-col overflow-y-auto hidden md:flex">
        <div class="p-6">
            <div class="flex items-center gap-3 mb-10">
                <div class="w-10 h-10 rounded-lg bg-white text-red-700 flex items-center justify-center font-bold">GS</div>
                <div>
                    <div class="font-bold text-lg">GrandStation</div>
                    <div class="text-xs opacity-80">Admin Dashboard</div>
                </div>
            </div>

            <nav class="space-y-1">
                <a href="<%= request.getContextPath() %>/admin.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
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
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-white/10 transition">
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
                <a href="<%= request.getContextPath() %>/admin-schedule-requests.jsp" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-white/20 hover:bg-white/30 transition">
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
            <div class="space-y-2">
                <a href="<%= request.getContextPath() %>/index.jsp?halaman=home" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-white/10 hover:bg-white/20 transition border border-white/20 block">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm.707-10.293a1 1 0 00-1.414-1.414l-3 3a1 1 0 000 1.414l3 3a1 1 0 001.414-1.414L9.414 11H13a1 1 0 100-2H9.414l1.293-1.293z" clip-rule="evenodd" />
                    </svg>
                    <span class="font-medium">Ke Halaman Utama</span>
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-white/10 hover:bg-white/20 transition border border-white/20 block">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M3 3a1 1 0 00-1 1v12a1 1 0 102 0V4a1 1 0 00-1-1zm10.293 9.293a1 1 0 001.414 1.414l3-3a1 1 0 000-1.414l-3-3a1 1 0 10-1.414 1.414L14.586 9H7a1 1 0 100 2h7.586l-1.293 1.293z" clip-rule="evenodd" />
                    </svg>
                    <span class="font-medium">Logout</span>
                </a>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col h-full md:h-screen overflow-y-auto">
        <!-- Top bar -->
        <header class="bg-white shadow-sm">
            <div class="px-6 py-4 flex items-center justify-between">
                <div>
                    <a href="<%= request.getContextPath() %>/admin.jsp" class="inline-flex items-center gap-2 text-gray-600 hover:text-red-700 mb-2 transition">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd" />
                        </svg>
                        <span class="font-medium">Kembali ke Dashboard</span>
                    </a>
                    <h1 class="text-2xl font-bold text-gray-800">Request Jadwal dari User</h1>
                    <p class="text-gray-600">User yang mencari jadwal tetapi tidak ditemukan akan tercatat di sini.</p>
                </div>
                <div class="flex items-center gap-4">
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
        <main class="flex-1 p-4 sm:p-6 bg-gray-50 overflow-y-auto">
            <div class="max-w-screen-xl mx-auto">
                <%
                    ScheduleRequestDAO requestDAO = new ScheduleRequestDAO();
                    List<Map<String, Object>> requests = requestDAO.getPendingRequests();
                    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy");
                %>

                <% if (requests.isEmpty()) { %>
                    <div class="bg-white rounded-xl shadow border border-gray-200 p-12 text-center">
                        <div class="text-6xl mb-4">✅</div>
                        <h2 class="text-2xl font-bold text-gray-900 mb-2">Belum Ada Request</h2>
                        <p class="text-gray-600">Semua jadwal yang dicari user sudah tersedia atau belum ada user yang mencari.</p>
                    </div>
                <% } else { %>
                    <div class="bg-white rounded-xl shadow border border-gray-200 overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-gray-50 border-b-2 border-gray-200">
                                    <tr>
                                        <th class="px-6 py-4 text-left font-bold text-gray-700">Request Count</th>
                                        <th class="px-6 py-4 text-left font-bold text-gray-700">Rute</th>
                                        <th class="px-6 py-4 text-left font-bold text-gray-700">Tanggal Diminta</th>
                                        <th class="px-6 py-4 text-left font-bold text-gray-700">User</th>
                                        <th class="px-6 py-4 text-left font-bold text-gray-700">Terakhir Request</th>
                                        <th class="px-6 py-4 text-center font-bold text-gray-700">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> req : requests) {
                                        int count = (Integer) req.get("request_count");
                                        String badge = count >= 5 ? "bg-rose-100 text-rose-700" : count >= 3 ? "bg-amber-100 text-amber-700" : "bg-red-100 text-red-700";
                                    %>
                                        <tr class="border-b border-gray-100 hover:bg-gray-50">
                                            <td class="px-6 py-4">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-bold <%= badge %>">
                                                    <%= count %>x request
                                                </span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="font-bold text-red-700"><%= req.get("origin_code") %> - <%= req.get("destination_code") %></div>
                                                <div class="text-xs text-gray-500"><%= req.get("origin_name") %> ke <%= req.get("destination_name") %></div>
                                            </td>
                                            <td class="px-6 py-4"><%= ((java.time.LocalDate)req.get("requested_date")).format(dtf) %></td>
                                            <td class="px-6 py-4">
                                                <div class="font-medium"><%= req.get("user_name") %></div>
                                                <div class="text-xs text-gray-500"><%= req.get("user_email") %></div>
                                            </td>
                                            <td class="px-6 py-4 text-sm text-gray-600">
                                                <%= new java.text.SimpleDateFormat("dd MMM HH:mm").format((java.sql.Timestamp)req.get("last_requested_at")) %>
                                            </td>
                                            <td class="px-6 py-4 text-center">
                                                <a href="<%= request.getContextPath() %>/admin-manage?action=add_schedule_form"
                                                   class="px-4 py-2 bg-gradient-to-r from-red-500 to-red-700 text-white text-sm font-bold rounded-lg hover:shadow-lg transition">
                                                    Buat Jadwal
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Info Card -->
                    <div class="mt-8 grid sm:grid-cols-2 gap-6">
                        <div class="p-6 rounded-xl bg-red-50 border border-red-200">
                            <h3 class="font-bold text-red-900 mb-2">💡 Tips</h3>
                            <p class="text-sm text-red-800">
                                Prioritaskan request dengan count tertinggi. Semakin banyak user meminta rute tertentu, semakin tinggi demand-nya.
                            </p>
                        </div>
                        <div class="p-6 rounded-xl bg-emerald-50 border border-emerald-200">
                            <h3 class="font-bold text-emerald-900 mb-2">✅ Action</h3>
                            <p class="text-sm text-emerald-800">
                                Setelah membuat jadwal baru, request akan otomatis ter-update dan user dapat langsung melihat jadwal tersedia.
                            </p>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>

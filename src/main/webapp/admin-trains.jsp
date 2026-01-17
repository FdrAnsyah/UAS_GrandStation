<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.*, model.*, java.util.*" %>

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
    <title>Kelola Kereta - GrandStation</title>
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
<body class="bg-gray-100 h-screen overflow-hidden flex flex-col md:flex-row">
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
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_trains" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-white/20 hover:bg-white/30 transition">
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
                <a href="<%= request.getContextPath() %>/index.jsp?halaman=home" class="flex w-full px-4 py-2 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
                    </svg>
                    <span>Halaman Utama</span>
                </a>
                <a href="<%= request.getContextPath() %>/admin-manage" class="flex w-full px-4 py-2 rounded-lg hover:bg-white/10 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10 12a2 2 0 100-4 2 2 0 000 4z" />
                        <path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd" />
                    </svg>
                    <span>Dashboard Admin</span>
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="flex w-full px-4 py-2 rounded-lg text-red-200 hover:bg-red-600 hover:text-white transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M3 3a1 1 0 00-1 1v12a1 1 0 102 0V4a1 1 0 00-1-1zm10.293 9.293a1 1 0 001.414 1.414l3-3a1 1 0 000-1.414l-3-3a1 1 0 10-1.414 1.414L14.586 9H7a1 1 0 100 2h7.586l-1.293 1.293z" clip-rule="evenodd" />
                    </svg>
                    <span>Logout</span>
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
                    <h1 class="text-2xl font-bold text-gray-800">Kelola Kereta</h1>
                    <p class="text-gray-600">Kelola data kereta dan kapasitasnya</p>
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
        <main class="flex-1 p-6 bg-gray-50">
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 rounded">
                    <p class="text-red-700 font-semibold"><%= error %></p>
                </div>
            <% } %>

            <%
                String success = (String) request.getAttribute("success");
                if (success != null) {
            %>
                <div class="mb-6 p-4 bg-green-50 border-l-4 border-green-500 rounded">
                    <p class="text-green-700 font-semibold">
                        <% if ("add".equals(success)) { %>
                            Kereta berhasil ditambahkan!
                        <% } else if ("update".equals(success)) { %>
                            Kereta berhasil diupdate!
                        <% } else if ("delete".equals(success)) { %>
                            Kereta berhasil dihapus!
                        <% } %>
                    </p>
                </div>
            <% } %>

            <!-- Header -->
            <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-8 gap-4">
                <div>                    <a href="<%= request.getContextPath() %>/admin.jsp" class="inline-flex items-center gap-2 text-gray-600 hover:text-red-700 mb-2 transition">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd" />
                        </svg>
                        <span class="font-medium">Kembali ke Dashboard</span>
                    </a>                    <h1 class="text-3xl font-bold text-gray-800">Kelola Kereta</h1>
                    <p class="text-gray-600">Kelola data kereta dan kapasitasnya</p>
                </div>
                <a href="<%= request.getContextPath() %>/admin-manage?action=add_train_form" class="px-6 py-3 bg-gradient-to-r from-red-500 to-red-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg">
                    + Tambah Kereta
                </a>
            </div>

            <!-- Trains Table -->
            <div class="bg-white rounded-xl shadow border border-gray-200 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b-2 border-gray-200">
                            <tr>
                                <th class="px-6 py-4 text-left font-bold text-gray-700">Kode</th>
                                <th class="px-6 py-4 text-left font-bold text-gray-700">Nama Kereta</th>
                                <th class="px-6 py-4 text-left font-bold text-gray-700">Kelas</th>
                                <th class="px-6 py-4 text-left font-bold text-gray-700">Kapasitas</th>
                                <th class="px-6 py-4 text-center font-bold text-gray-700">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Train> trains = (List<Train>) request.getAttribute("trains");
                                if (trains != null && !trains.isEmpty()) {
                                    for (Train t : trains) {
                            %>
                                        <tr class="border-b border-gray-100 hover:bg-gray-50">
                                            <td class="px-6 py-4 font-bold text-red-700"><%= t.getCode() %></td>
                                            <td class="px-6 py-4"><%= t.getName() %></td>
                                            <td class="px-6 py-4"><%= t.getTrainClass() %></td>
                                            <td class="px-6 py-4"><%= t.getSeatsTotal() %> kursi</td>
                                            <td class="px-6 py-4 text-center">
                                                <div class="flex gap-2 justify-center">
                                                    <a href="<%= request.getContextPath() %>/admin-manage?action=edit_train&id=<%= t.getId() %>"
                                                       class="px-4 py-2 bg-red-500 text-white text-sm font-bold rounded hover:bg-red-600 transition">
                                                        Edit
                                                    </a>
                                                    <a href="<%= request.getContextPath() %>/admin-manage?action=delete_train&id=<%= t.getId() %>"
                                                       onclick="return confirm('Yakin ingin menghapus kereta <%= t.getName() %>?')"
                                                       class="px-4 py-2 bg-red-700 text-white text-sm font-bold rounded hover:bg-red-800 transition">
                                                        Hapus
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                    <tr>
                                        <td colspan="5" class="px-6 py-8 text-center text-gray-600">
                                            Belum ada data kereta. <a href="<%= request.getContextPath() %>/admin-manage?action=add_train_form" class="text-red-600 font-bold hover:underline">Tambah kereta pertama</a>
                                        </td>
                                    </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Info -->
            <div class="mt-8 p-4 bg-red-50 border-l-4 border-red-500 rounded">
                <p class="text-sm text-red-800">
                    💡 <strong>Tips:</strong> Kelola kereta dari database untuk mengatur kapasitas dan jenis layanan
                </p>
            </div>
        </main>
    </div>

    <script>
        // Mobile sidebar toggle
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarToggle = document.getElementById('sidebar-toggle');
            const mobileSidebar = document.getElementById('mobile-sidebar');
            const sidebarOverlay = document.getElementById('sidebar-overlay');

            sidebarToggle.addEventListener('click', function() {
                mobileSidebar.classList.toggle('-translate-x-full');
                sidebarOverlay.classList.toggle('hidden');
            });

            sidebarOverlay.addEventListener('click', function() {
                mobileSidebar.classList.add('-translate-x-full');
                sidebarOverlay.classList.add('hidden');
            });
        });
    </script>
</body>
</html>

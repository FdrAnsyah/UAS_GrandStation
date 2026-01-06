<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.*, model.*, java.util.*, java.time.format.DateTimeFormatter" %>

<%
    // Check role - only admin can access this page
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?halaman=home");
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Jadwal - GrandStation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Space Grotesk', sans-serif;
        }
    </style>
</head>
<body class="bg-slate-50 flex flex-col min-h-screen">
    <jsp:include page="menu.jsp" />

    <div class="max-w-7xl mx-auto px-4 py-12 flex-grow">
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="mb-6 p-4 bg-rose-50 border-l-4 border-rose-500 rounded">
                <p class="text-rose-700 font-semibold"><%= error %></p>
            </div>
        <% } %>

        <%
            String success = request.getParameter("success");
            if (success != null) {
        %>
            <div class="mb-6 p-4 bg-emerald-50 border-l-4 border-emerald-500 rounded">
                <p class="text-emerald-700 font-semibold">
                    <% if ("add".equals(success)) { %>
                        Jadwal berhasil ditambahkan!
                    <% } else if ("update".equals(success)) { %>
                        Jadwal berhasil diupdate!
                    <% } else if ("delete".equals(success)) { %>
                        Jadwal berhasil dihapus!
                    <% } %>
                </p>
            </div>
        <% } %>

        <!-- Header -->
        <div class="flex items-center justify-between mb-8">
            <div>
                <h1 class="text-4xl font-bold text-sky-700 mb-2">Kelola Jadwal</h1>
                <p class="text-slate-600">Kelola jadwal keberangkatan dan jadwal tiba</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin-manage?action=add_schedule_form" class="px-6 py-3 bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg">
                + Tambah Jadwal
            </a>
        </div>

        <!-- Schedules Table -->
        <div class="bg-white rounded-xl shadow border border-slate-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-slate-50 border-b-2 border-slate-200">
                        <tr>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Kereta</th>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Rute</th>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Berangkat</th>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Tiba</th>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Harga</th>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Kursi</th>
                            <th class="px-6 py-4 text-center font-bold text-slate-700">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Schedule> schedules = (List<Schedule>) request.getAttribute("schedules");
                            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");
                            if (schedules != null && !schedules.isEmpty()) {
                                for (Schedule s : schedules) {
                        %>
                                    <tr class="border-b border-slate-100 hover:bg-slate-50">
                                        <td class="px-6 py-4">
                                            <div class="font-bold text-sky-700"><%= s.getTrain().getName() %></div>
                                            <div class="text-xs text-slate-500"><%= s.getTrain().getCode() %> &bull; <%= s.getTrain().getTrainClass() %></div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="font-semibold"><%= s.getOrigin().getName() %></div>
                                            <div class="text-xs text-slate-500">↓</div>
                                            <div class="font-semibold"><%= s.getDestination().getName() %></div>
                                        </td>
                                        <td class="px-6 py-4"><%= s.getDepartTime().format(dtf) %></td>
                                        <td class="px-6 py-4"><%= s.getArriveTime().format(dtf) %></td>
                                        <td class="px-6 py-4 font-bold">Rp <%= String.format("%,.0f", s.getPrice()) %></td>
                                        <td class="px-6 py-4"><%= s.getSeatsAvailable() %> kursi</td>
                                        <td class="px-6 py-4 text-center">
                                            <div class="flex gap-2 justify-center">
                                                <a href="<%= request.getContextPath() %>/admin-manage?action=edit_schedule&id=<%= s.getId() %>"
                                                   class="px-4 py-2 bg-blue-500 text-white text-sm font-bold rounded hover:bg-blue-600 transition">
                                                    Edit
                                                </a>
                                                <a href="<%= request.getContextPath() %>/admin-manage?action=delete_schedule&id=<%= s.getId() %>"
                                                   onclick="return confirm('Yakin ingin menghapus jadwal ini?')"
                                                   class="px-4 py-2 bg-rose-500 text-white text-sm font-bold rounded hover:bg-rose-600 transition">
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
                                    <td colspan="7" class="px-6 py-8 text-center text-slate-600">
                                        Belum ada data jadwal. <a href="<%= request.getContextPath() %>/admin-manage?action=add_schedule_form" class="text-sky-600 font-bold hover:underline">Tambah jadwal pertama</a>
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
        <div class="mt-8 p-4 bg-blue-50 border-l-4 border-blue-500 rounded">
            <p class="text-sm text-blue-800">
                💡 <strong>Tips:</strong> Pastikan jadwal keberangkatan selalu lebih awal dari jadwal tiba
            </p>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

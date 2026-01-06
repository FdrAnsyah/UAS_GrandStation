<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.*, model.*, java.util.*" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Stasiun - GrandStation</title>
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
            String success = (String) request.getAttribute("success");
            if (success != null) {
        %>
            <div class="mb-6 p-4 bg-emerald-50 border-l-4 border-emerald-500 rounded">
                <p class="text-emerald-700 font-semibold">
                    <% if ("add".equals(success)) { %>
                        Stasiun berhasil ditambahkan!
                    <% } else if ("update".equals(success)) { %>
                        Stasiun berhasil diupdate!
                    <% } else if ("delete".equals(success)) { %>
                        Stasiun berhasil dihapus!
                    <% } %>
                </p>
            </div>
        <% } %>

        <!-- Header -->
        <div class="flex items-center justify-between mb-8">
            <div>
                <h1 class="text-4xl font-bold text-sky-700 mb-2">Kelola Stasiun</h1>
                <p class="text-slate-600">Tambah, edit, dan hapus stasiun kereta</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin-manage?action=add_station_form" class="px-6 py-3 bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg">
                + Tambah Stasiun
            </a>
        </div>

        <!-- Stations Table -->
        <div class="bg-white rounded-xl shadow border border-slate-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-slate-50 border-b-2 border-slate-200">
                        <tr>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Kode</th>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Nama Stasiun</th>
                            <th class="px-6 py-4 text-left font-bold text-slate-700">Kota</th>
                            <th class="px-6 py-4 text-center font-bold text-slate-700">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Station> stations = (List<Station>) request.getAttribute("stations");
                            if (stations != null && !stations.isEmpty()) {
                                for (Station s : stations) {
                        %>
                                    <tr class="border-b border-slate-100 hover:bg-slate-50">
                                        <td class="px-6 py-4 font-bold text-sky-700"><%= s.getCode() %></td>
                                        <td class="px-6 py-4"><%= s.getName() %></td>
                                        <td class="px-6 py-4"><%= s.getCity() %></td>
                                        <td class="px-6 py-4 text-center">
                                            <div class="flex gap-2 justify-center">
                                                <a href="<%= request.getContextPath() %>/admin-manage?action=edit_station&id=<%= s.getId() %>"
                                                   class="px-4 py-2 bg-blue-500 text-white text-sm font-bold rounded hover:bg-blue-600 transition">
                                                    Edit
                                                </a>
                                                <a href="<%= request.getContextPath() %>/admin-manage?action=delete_station&id=<%= s.getId() %>"
                                                   onclick="return confirm('Yakin ingin menghapus stasiun <%= s.getName() %>?')"
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
                                    <td colspan="4" class="px-6 py-8 text-center text-slate-600">
                                        Belum ada data stasiun. <a href="<%= request.getContextPath() %>/admin-manage?action=add_station_form" class="text-sky-600 font-bold hover:underline">Tambah stasiun pertama</a>
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
                💡 <strong>Tips:</strong> Pastikan kode stasiun unik dan mudah diingat (contoh: CGK, BDG, SBY)
            </p>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

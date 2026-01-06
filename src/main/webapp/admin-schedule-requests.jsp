<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ScheduleRequestDAO, java.util.*, java.time.format.DateTimeFormatter" %>

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
    </style>
</head>
<body class="bg-slate-50 flex flex-col min-h-screen">
    <jsp:include page="menu.jsp" />

    <div class="max-w-7xl mx-auto px-4 py-12 flex-grow">
        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-4xl font-bold text-sky-700 mb-2">Request Jadwal dari User</h1>
            <p class="text-slate-600">User yang mencari jadwal tetapi tidak ditemukan akan tercatat di sini. Buat jadwal baru berdasarkan permintaan terbanyak.</p>
        </div>

        <%
            ScheduleRequestDAO requestDAO = new ScheduleRequestDAO();
            List<Map<String, Object>> requests = requestDAO.getPendingRequests();
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy");
        %>

        <% if (requests.isEmpty()) { %>
            <div class="bg-white rounded-xl shadow border border-slate-100 p-12 text-center">
                <div class="text-6xl mb-4">✅</div>
                <h2 class="text-2xl font-bold text-slate-900 mb-2">Belum Ada Request</h2>
                <p class="text-slate-600">Semua jadwal yang dicari user sudah tersedia atau belum ada user yang mencari.</p>
            </div>
        <% } else { %>
            <div class="bg-white rounded-xl shadow border border-slate-100 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-slate-50 border-b-2 border-slate-200">
                            <tr>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Request Count</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Rute</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Tanggal Diminta</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">User</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Terakhir Request</th>
                                <th class="px-6 py-4 text-center font-bold text-slate-700">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> req : requests) {
                                int count = (Integer) req.get("request_count");
                                String badge = count >= 5 ? "bg-rose-100 text-rose-700" : count >= 3 ? "bg-amber-100 text-amber-700" : "bg-sky-100 text-sky-700";
                            %>
                                <tr class="border-b border-slate-100 hover:bg-slate-50">
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-bold <%= badge %>">
                                            <%= count %>x request
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="font-bold text-sky-700"><%= req.get("origin_code") %> → <%= req.get("destination_code") %></div>
                                        <div class="text-xs text-slate-500"><%= req.get("origin_name") %> ke <%= req.get("destination_name") %></div>
                                    </td>
                                    <td class="px-6 py-4"><%= ((java.time.LocalDate)req.get("requested_date")).format(dtf) %></td>
                                    <td class="px-6 py-4">
                                        <div class="font-medium"><%= req.get("user_name") %></div>
                                        <div class="text-xs text-slate-500"><%= req.get("user_email") %></div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-slate-600">
                                        <%= new java.text.SimpleDateFormat("dd MMM HH:mm").format((java.sql.Timestamp)req.get("last_requested_at")) %>
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <a href="<%= request.getContextPath() %>/admin-manage?action=add_schedule_form"
                                           class="px-4 py-2 bg-gradient-to-r from-sky-500 to-blue-700 text-white text-sm font-bold rounded-lg hover:shadow-lg transition">
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
                <div class="p-6 rounded-xl bg-blue-50 border border-blue-200">
                    <h3 class="font-bold text-blue-900 mb-2">💡 Tips</h3>
                    <p class="text-sm text-blue-800">
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

    <jsp:include page="footer.jsp" />
</body>
</html>

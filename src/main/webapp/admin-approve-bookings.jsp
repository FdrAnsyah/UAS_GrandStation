<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.*, java.util.*, java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Pesanan - GrandStation</title>
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

    <div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8 py-12 flex-grow">
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
        %>
            <div class="mb-6 p-4 bg-emerald-50 border-l-4 border-emerald-500 rounded">
                <p class="text-emerald-700 font-semibold">
                    <% if ("approved".equals(success)) { %>
                        Pesanan berhasil disetujui!
                    <% } else if ("rejected".equals(success)) { %>
                        Pesanan berhasil ditolak.
                    <% } %>
                </p>
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="mb-6 p-4 bg-rose-50 border-l-4 border-rose-500 rounded">
                <p class="text-rose-700 font-semibold">
                    <% if ("approve_failed".equals(error)) { %>
                        Gagal menyetujui pesanan. Mungkin kursi tidak cukup atau sudah diproses.
                    <% } else if ("reject_failed".equals(error)) { %>
                        Gagal menolak pesanan.
                    <% } %>
                </p>
            </div>
        <% } %>

        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-4xl font-bold text-sky-700 mb-2">Approve Pesanan User</h1>
            <p class="text-slate-600">Review dan setujui pesanan tiket kereta dari user</p>
        </div>

        <%
            List<Booking> pendingBookings = (List<Booking>) request.getAttribute("pendingBookings");
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
        %>

        <% if (pendingBookings == null || pendingBookings.isEmpty()) { %>
            <div class="bg-white rounded-xl shadow border border-slate-100 p-12 text-center">
                <div class="text-6xl mb-4">✅</div>
                <h2 class="text-2xl font-bold text-slate-900 mb-2">Tidak Ada Pesanan Pending</h2>
                <p class="text-slate-600">Semua pesanan sudah diproses atau belum ada pesanan baru.</p>
            </div>
        <% } else { %>
            <div class="bg-white rounded-xl shadow border border-slate-100 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-slate-50 border-b-2 border-slate-200">
                            <tr>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Kode Booking</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Penumpang</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Kereta & Rute</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Keberangkatan</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Kursi</th>
                                <th class="px-6 py-4 text-left font-bold text-slate-700">Total</th>
                                <th class="px-6 py-4 text-center font-bold text-slate-700">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Booking b : pendingBookings) {
                                Schedule s = b.getSchedule();
                            %>
                                <tr class="border-b border-slate-100 hover:bg-slate-50">
                                    <td class="px-6 py-4">
                                        <div class="font-bold text-sky-700"><%= b.getBookingCode() %></div>
                                        <div class="text-xs text-slate-500"><%= b.getCreatedAt() != null ? b.getCreatedAt().format(dtf) : "-" %></div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="font-semibold"><%= b.getPassengerName() %></div>
                                        <div class="text-xs text-slate-500"><%= b.getPassengerPhone() %></div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="font-bold"><%= s.getTrain().getName() %></div>
                                        <div class="text-sm text-slate-600"><%= s.getOrigin().getCode() %> -> <%= s.getDestination().getCode() %></div>
                                        <div class="text-xs text-slate-500"><%= s.getTrain().getTrainClass() %></div>
                                    </td>
                                    <td class="px-6 py-4 text-sm">
                                        <%= s.getDepartTime() != null ? s.getDepartTime().format(dtf) : "-" %>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="px-3 py-1 rounded-full text-sm font-bold bg-sky-100 text-sky-700">
                                            <%= b.getSeats() %> kursi
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 font-bold text-slate-900">
                                        Rp <%= String.format("%,.0f", b.getTotalPrice()) %>
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <div class="flex gap-2 justify-center">
                                            <a href="<%= request.getContextPath() %>/admin-bookings?action=approve&id=<%= b.getId() %>"
                                               onclick="return confirm('Yakin ingin menyetujui pesanan ini?')"
                                               class="px-4 py-2 bg-emerald-500 text-white text-sm font-bold rounded-lg hover:bg-emerald-600 transition">
                                                ✓ Approve
                                            </a>
                                            <a href="<%= request.getContextPath() %>/admin-bookings?action=reject&id=<%= b.getId() %>"
                                               onclick="return confirm('Yakin ingin menolak pesanan ini?')"
                                               class="px-4 py-2 bg-rose-500 text-white text-sm font-bold rounded-lg hover:bg-rose-600 transition">
                                                ✗ Tolak
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Info Cards -->
            <div class="mt-8 grid sm:grid-cols-2 gap-6">
                <div class="p-6 rounded-xl bg-blue-50 border border-blue-200">
                    <h3 class="font-bold text-blue-900 mb-2">💡 Approve</h3>
                    <p class="text-sm text-blue-800">
                        Saat di-approve, kursi otomatis dikurangi dari jadwal. Pastikan kursi masih tersedia.
                    </p>
                </div>
                <div class="p-6 rounded-xl bg-amber-50 border border-amber-200">
                    <h3 class="font-bold text-amber-900 mb-2">⚠️ Tolak</h3>
                    <p class="text-sm text-amber-800">
                        Pesanan yang ditolak tidak akan mengurangi kursi dan user akan melihat status "Ditolak".
                    </p>
                </div>
            </div>
        <% } %>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

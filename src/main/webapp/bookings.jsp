<%@page import="java.util.List"%>
<%@page import="model.Booking"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
    // Check if user is admin - admin should not see booking page
    String userRole = (String) session.getAttribute("userRole");
    if ("admin".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/admin-manage?action=all_bookings");
        return;
    }

    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
%>

<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-5">
<div class="flex items-start justify-between gap-4">
    <div>
        <p class="text-xs uppercase tracking-wide text-sky-700 font-semibold">GrandStation</p>
        <h2 class="text-xl font-semibold">Pesanan Saya</h2>
    </div>
    <a href="${pageContext.request.contextPath}/index.jsp?halaman=home#cari" class="text-sm px-3 py-2 rounded-lg border border-slate-200 bg-white hover:bg-slate-50">Pesan Lagi</a>
</div>

<div class="mt-5 bg-white rounded-2xl border border-slate-200 overflow-hidden shadow-sm">
    <% if (bookings == null || bookings.isEmpty()) { %>
        <div class="px-5 py-10 text-center">
            <div class="text-lg font-semibold">Belum ada pesanan</div>
            <p class="mt-2 text-sm text-slate-600">Mulai dari pencarian jadwal di halaman beranda.</p>
        </div>
    <% } else { %>
        <div class="overflow-x-auto">
            <table class="min-w-full text-sm">
                <thead class="bg-slate-50 text-slate-600">
                    <tr>
                        <th class="text-left font-medium px-5 py-3">Kode</th>
                        <th class="text-left font-medium px-5 py-3">Penumpang</th>
                        <th class="text-left font-medium px-5 py-3">Rute</th>
                        <th class="text-left font-medium px-5 py-3">Berangkat</th>
                        <th class="text-left font-medium px-5 py-3">Kursi</th>
                        <th class="text-left font-medium px-5 py-3">Total</th>
                        <th class="text-left font-medium px-5 py-3">Status</th>
                        <th class="text-left font-medium px-5 py-3">Dibuat</th>
                        <th class="text-left font-medium px-5 py-3">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                <% for (Booking b : bookings) {
                    String statusClass = "bg-amber-100 text-amber-800 border-amber-200";
                    String statusText = "Pending";

                    if (b.getStatus() != null) {
                        switch (b.getStatus()) {
                            case "approved":
                                statusClass = "bg-emerald-100 text-emerald-800 border-emerald-200";
                                statusText = "Disetujui";
                                break;
                            case "rejected":
                                statusClass = "bg-rose-100 text-rose-800 border-rose-200";
                                statusText = "Ditolak";
                                break;
                            default:
                                statusClass = "bg-amber-100 text-amber-800 border-amber-200";
                                statusText = "Pending";
                        }
                    }
                %>
                    <tr class="hover:bg-slate-50">
                        <td class="px-5 py-4 font-semibold">
                            <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-800 border border-slate-200"><%= b.getBookingCode() %></span>
                        </td>
                        <td class="px-5 py-4">
                            <div class="font-medium"><%= b.getPassengerName() %></div>
                            <div class="text-xs text-slate-500"><%= b.getPassengerPhone() %></div>
                        </td>
                        <td class="px-5 py-4">
                            <%= b.getSchedule() != null ? (b.getSchedule().getOrigin().getCode() + " -> " + b.getSchedule().getDestination().getCode()) : "-" %>
                        </td>
                        <td class="px-5 py-4">
                            <%= (b.getSchedule() != null && b.getSchedule().getDepartTime() != null) ? b.getSchedule().getDepartTime().format(dt) : "-" %>
                        </td>
                        <td class="px-5 py-4"><%= b.getSeats() %></td>
                        <td class="px-5 py-4 font-semibold text-sky-700">Rp <%= String.format("%,.0f", b.getTotalPrice()) %></td>
                        <td class="px-5 py-4">
                            <span class="inline-flex px-3 py-1 rounded-full text-xs font-medium border <%= statusClass %>">
                                <%= statusText %>
                            </span>
                        </td>
                        <td class="px-5 py-4"><%= b.getCreatedAt() != null ? b.getCreatedAt().format(dt) : "-" %></td>
                        <td class="px-5 py-4">
                            <% if ("approved".equals(b.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/payment?bookingId=<%= b.getId() %>" class="px-3 py-1 text-xs bg-gradient-to-r from-sky-500 to-sky-700 text-white rounded hover:shadow-md transition">
                                    Lanjutkan Pembayaran
                                </a>
                            <% } else if ("pending".equals(b.getStatus())) { %>
                                <span class="text-xs text-slate-500 text-amber-600">Menunggu Persetujuan</span>
                            <% } else if ("rejected".equals(b.getStatus())) { %>
                                <span class="text-xs text-slate-500 text-red-600">Ditolak</span>
                            <% } else { %>
                                <span class="text-xs text-slate-500">-</span>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

</div>

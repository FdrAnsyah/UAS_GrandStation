<%@page import="java.util.List"%>
<%@page import="model.Booking"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
    String filterStatus = request.getParameter("status");
%>

<div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
<div class="flex items-start justify-between gap-4 mb-6">
    <div>
        <p class="text-xs uppercase tracking-wide text-sky-700 font-semibold">GrandStation Admin</p>
        <h2 class="text-2xl font-bold">Riwayat Semua Pesanan</h2>
        <p class="text-sm text-slate-600 mt-1">Lihat dan kelola semua pesanan dari user dengan status lengkap</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin-bookings" class="text-sm px-4 py-2 rounded-lg bg-gradient-to-r from-amber-500 to-orange-600 text-white font-bold hover:shadow-lg transition">
        ⏳ Approve Pesanan
    </a>
</div>

<!-- Filter Status -->
<div class="flex gap-3 mb-6 flex-wrap">
    <a href="${pageContext.request.contextPath}/admin-manage?action=all_bookings"
       class="px-4 py-2 rounded-lg font-semibold <%= (filterStatus == null) ? "bg-sky-600 text-white" : "bg-white text-slate-600 border border-slate-200 hover:bg-slate-50" %>">
        Semua
    </a>
    <a href="${pageContext.request.contextPath}/admin-manage?action=all_bookings&status=pending"
       class="px-4 py-2 rounded-lg font-semibold <%= "pending".equals(filterStatus) ? "bg-amber-500 text-white" : "bg-white text-slate-600 border border-slate-200 hover:bg-slate-50" %>">
        Pending
    </a>
    <a href="${pageContext.request.contextPath}/admin-manage?action=all_bookings&status=approved"
       class="px-4 py-2 rounded-lg font-semibold <%= "approved".equals(filterStatus) ? "bg-emerald-500 text-white" : "bg-white text-slate-600 border border-slate-200 hover:bg-slate-50" %>">
        Disetujui
    </a>
    <a href="${pageContext.request.contextPath}/admin-manage?action=all_bookings&status=rejected"
       class="px-4 py-2 rounded-lg font-semibold <%= "rejected".equals(filterStatus) ? "bg-rose-500 text-white" : "bg-white text-slate-600 border border-slate-200 hover:bg-slate-50" %>">
        Ditolak
    </a>
</div>

<div class="bg-white rounded-2xl border border-slate-200 overflow-hidden shadow-lg">
    <% if (bookings == null || bookings.isEmpty()) { %>
        <div class="px-5 py-12 text-center">
            <div class="text-6xl mb-4">📦</div>
            <div class="text-xl font-bold">Tidak Ada Pesanan</div>
            <p class="mt-2 text-sm text-slate-600">Belum ada pesanan yang masuk ke sistem.</p>
        </div>
    <% } else { %>
        <!-- Stats Summary -->
        <div class="px-6 py-4 bg-gradient-to-r from-slate-50 to-sky-50 border-b border-slate-200">
            <%
                int totalPending = 0, totalApproved = 0, totalRejected = 0;
                double totalRevenue = 0;
                for (Booking b : bookings) {
                    if ("pending".equals(b.getStatus())) totalPending++;
                    else if ("approved".equals(b.getStatus())) {
                        totalApproved++;
                        totalRevenue += b.getTotalPrice();
                    }
                    else if ("rejected".equals(b.getStatus())) totalRejected++;
                }
            %>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
                <div>
                    <p class="text-xs text-slate-600 font-semibold">Total Pesanan</p>
                    <p class="text-2xl font-bold text-sky-700"><%= bookings.size() %></p>
                </div>
                <div>
                    <p class="text-xs text-amber-600 font-semibold">Pending</p>
                    <p class="text-2xl font-bold text-amber-600"><%= totalPending %></p>
                </div>
                <div>
                    <p class="text-xs text-emerald-600 font-semibold">Disetujui</p>
                    <p class="text-2xl font-bold text-emerald-600"><%= totalApproved %></p>
                </div>
                <div>
                    <p class="text-xs text-slate-600 font-semibold">Total Pendapatan</p>
                    <p class="text-xl font-bold text-sky-700">Rp <%= String.format("%,.0f", totalRevenue) %></p>
                </div>
            </div>
        </div>

        <div class="overflow-x-auto">
            <table class="min-w-full text-sm">
                <thead class="bg-slate-50 text-slate-600 border-b-2 border-slate-200">
                    <tr>
                        <th class="text-left font-bold px-5 py-3">#</th>
                        <th class="text-left font-bold px-5 py-3">Kode Booking</th>
                        <th class="text-left font-bold px-5 py-3">Penumpang</th>
                        <th class="text-left font-bold px-5 py-3">Kereta & Rute</th>
                        <th class="text-left font-bold px-5 py-3">Keberangkatan</th>
                        <th class="text-left font-bold px-5 py-3">Kursi</th>
                        <th class="text-left font-bold px-5 py-3">Total</th>
                        <th class="text-left font-bold px-5 py-3">Status</th>
                        <th class="text-left font-bold px-5 py-3">Dibuat</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                <%
                int no = 1;
                for (Booking b : bookings) {
                    String statusClass = "bg-amber-100 text-amber-800 border-amber-200";
                    String statusText = "Pending";

                    if (b.getStatus() != null) {
                        switch (b.getStatus()) {
                            case "approved":
                                statusClass = "bg-emerald-100 text-emerald-800 border-emerald-200";
                                statusText = "✓ Disetujui";
                                break;
                            case "rejected":
                                statusClass = "bg-rose-100 text-rose-800 border-rose-200";
                                statusText = "✗ Ditolak";
                                break;
                            default:
                                statusClass = "bg-amber-100 text-amber-800 border-amber-200";
                                statusText = "⏳ Pending";
                        }
                    }
                %>
                    <tr class="hover:bg-slate-50 transition">
                        <td class="px-5 py-4 text-slate-500 font-medium"><%= no++ %></td>
                        <td class="px-5 py-4">
                            <span class="inline-flex items-center px-3 py-1.5 rounded-full bg-slate-100 text-slate-800 border border-slate-200 font-mono text-xs font-bold">
                                <%= b.getBookingCode() %>
                            </span>
                        </td>
                        <td class="px-5 py-4">
                            <div class="font-semibold text-slate-900"><%= b.getPassengerName() %></div>
                            <div class="text-xs text-slate-500"><%= b.getPassengerPhone() %></div>
                        </td>
                        <td class="px-5 py-4">
                            <div class="font-semibold text-sky-700">
                                <%= b.getSchedule() != null && b.getSchedule().getTrain() != null ? b.getSchedule().getTrain().getLabel() : "-" %>
                            </div>
                            <div class="text-xs text-slate-600">
                                <%= b.getSchedule() != null ? (b.getSchedule().getOrigin().getCode() + " -> " + b.getSchedule().getDestination().getCode()) : "-" %>
                            </div>
                        </td>
                        <td class="px-5 py-4 text-slate-700">
                            <%= (b.getSchedule() != null && b.getSchedule().getDepartTime() != null) ? b.getSchedule().getDepartTime().format(dt) : "-" %>
                        </td>
                        <td class="px-5 py-4">
                            <span class="inline-flex items-center px-2 py-1 rounded bg-blue-50 text-blue-700 font-semibold text-xs">
                                <%= b.getSeats() %> kursi
                            </span>
                        </td>
                        <td class="px-5 py-4 font-bold text-sky-700">
                            Rp <%= String.format("%,.0f", b.getTotalPrice()) %>
                        </td>
                        <td class="px-5 py-4">
                            <span class="inline-flex px-3 py-1.5 rounded-full text-xs font-bold border <%= statusClass %>">
                                <%= statusText %>
                            </span>
                        </td>
                        <td class="px-5 py-4 text-slate-600 text-xs">
                            <%= b.getCreatedAt() != null ? b.getCreatedAt().format(dt) : "-" %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>
</div>

<%-- Bookings List --%>
<%@ page import="java.util.*, model.*" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>

<div class="space-y-6">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
            <div>
                <h3 class="text-lg font-bold text-gray-900">Daftar Pesanan</h3>
                <p class="text-sm text-gray-600 mt-1">Kelola pesanan tiket kereta</p>
            </div>
        </div>

        <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="text-center py-10">
                <p class="text-gray-600">Belum ada pesanan terdaftar</p>
            </div>
        <% } else { %>
            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-y border-gray-200">
                        <tr>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Kode</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3 hidden sm:table-cell">Penumpang</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3 hidden md:table-cell">Rute</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3 hidden lg:table-cell">Total</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Status</th>
                            <th class="text-center font-semibold text-gray-700 px-4 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <% for (Booking b : bookings) {
                        String statusColor = "pending".equals(b.getStatus()) ? "bg-yellow-100 text-yellow-700" :
                                            "approved".equals(b.getStatus()) ? "bg-green-100 text-green-700" :
                                            "bg-red-100 text-red-700";
                        String statusText = "pending".equals(b.getStatus()) ? "Menunggu" :
                                          "approved".equals(b.getStatus()) ? "Disetujui" : "Ditolak";
                    %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-3 font-semibold text-gray-900"><%= b.getBookingCode() %></td>
                            <td class="px-4 py-3 hidden sm:table-cell">
                                <div>
                                    <div class="font-medium text-gray-900"><%= b.getPassengerName() %></div>
                                    <div class="text-xs text-gray-500"><%= b.getPassengerPhone() %></div>
                                </div>
                            </td>
                            <td class="px-4 py-3 hidden md:table-cell">
                                <% if (b.getSchedule() != null && b.getSchedule().getOrigin() != null && b.getSchedule().getDestination() != null) { %>
                                    <div class="font-medium text-gray-900"><%= b.getSchedule().getOrigin().getCode() %></div>
                                    <div class="text-xs text-gray-500">ke <%= b.getSchedule().getDestination().getCode() %></div>
                                <% } else { %>
                                    <span class="text-gray-400">-</span>
                                <% } %>
                            </td>
                            <td class="px-4 py-3 hidden lg:table-cell font-semibold text-red-600">
                                Rp <%= String.format("%,.0f", b.getTotalPrice()) %>
                            </td>
                            <td class="px-4 py-3">
                                <span class="px-2 py-1 rounded-full text-xs font-medium <%= statusColor %>"><%= statusText %></span>
                            </td>
                            <td class="px-4 py-3 text-center">
                                <% if ("pending".equals(b.getStatus())) { %>
                                    <div class="flex gap-2 justify-center">
                                        <a href="<%= request.getContextPath() %>/admin-manage?action=approve_booking&id=<%= b.getId() %>" class="px-3 py-1 text-xs bg-green-100 text-green-700 rounded hover:bg-green-200 transition">Approve</a>
                                        <a href="<%= request.getContextPath() %>/admin-manage?action=reject_booking&id=<%= b.getId() %>" class="px-3 py-1 text-xs bg-red-100 text-red-700 rounded hover:bg-red-200 transition">Reject</a>
                                    </div>
                                <% } else { %>
                                    <span class="text-xs text-gray-500">-</span>
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
<%-- Dashboard Content --%>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
    // Get attributes from request with null-safe defaults
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    List<Train> trains = (List<Train>) request.getAttribute("trains");
    List<Station> stations = (List<Station>) request.getAttribute("stations");

    // Stats calculations
    int totalBookings = bookings != null ? bookings.size() : 0;
    int totalTrains = trains != null ? trains.size() : 0;
    int totalStations = stations != null ? stations.size() : 0;

    // Calculate revenue
    double totalRevenue = 0;
    if (bookings != null) {
        for (Booking b : bookings) {
            if ("approved".equals(b.getStatus()) || "completed".equals(b.getStatus())) {
                totalRevenue += b.getTotalPrice();
            }
        }
    }
%>

<div class="space-y-6">
    <!-- Stats Cards -->
    <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="rounded-2xl border border-gray-200 bg-white p-4 sm:p-6 shadow-sm">
            <div class="flex items-start justify-between">
                <div>
                    <div class="text-xs uppercase tracking-wide text-gray-500 font-semibold">Total Pesanan</div>
                    <div class="text-2xl sm:text-3xl font-bold text-gray-900 mt-2"><%= totalBookings %></div>
                </div>
                <div class="p-3 rounded-lg bg-blue-100">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-600" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
                        <path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd" />
                    </svg>
                </div>
            </div>
        </div>

        <div class="rounded-2xl border border-gray-200 bg-white p-4 sm:p-6 shadow-sm">
            <div class="flex items-start justify-between">
                <div>
                    <div class="text-xs uppercase tracking-wide text-gray-500 font-semibold">Total Kereta</div>
                    <div class="text-2xl sm:text-3xl font-bold text-gray-900 mt-2"><%= totalTrains %></div>
                </div>
                <div class="p-3 rounded-lg bg-red-100">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-red-600" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M8 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM15 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0z" />
                        <path fill-rule="evenodd" d="M3 4a1 1 0 00-1 1v10a1 1 0 001 1h1.05a2.5 2.5 0 014.9 0H10a1 1 0 001-1v-1h4.05a2.5 2.5 0 014.9 0H20a1 1 0 001-1v-4a1 1 0 00-.293-.707l-4-4A1 1 0 0016 4H3z" clip-rule="evenodd" />
                    </svg>
                </div>
            </div>
        </div>

        <div class="rounded-2xl border border-gray-200 bg-white p-4 sm:p-6 shadow-sm">
            <div class="flex items-start justify-between">
                <div>
                    <div class="text-xs uppercase tracking-wide text-gray-500 font-semibold">Total Stasiun</div>
                    <div class="text-2xl sm:text-3xl font-bold text-gray-900 mt-2"><%= totalStations %></div>
                </div>
                <div class="p-3 rounded-lg bg-green-100">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-600" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
                    </svg>
                </div>
            </div>
        </div>

        <div class="rounded-2xl border border-gray-200 bg-white p-4 sm:p-6 shadow-sm">
            <div class="flex items-start justify-between">
                <div>
                    <div class="text-xs uppercase tracking-wide text-gray-500 font-semibold">Total Pendapatan</div>
                    <div class="text-2xl sm:text-3xl font-bold text-gray-900 mt-2">Rp <%= String.format("%,.0f", totalRevenue) %></div>
                </div>
                <div class="p-3 rounded-lg bg-amber-100">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-amber-600" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M8.433 7.418c.155-.103.346-.196.567-.267v1.698a2.305 2.305 0 01-.567-.267C8.07 8.34 8 8.114 8 8c0-.114.07-.34.433-.582zM11 12.5a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0zm2.5-4a1.5 1.5 0 10-3 0 1.5 1.5 0 003 0z" />
                        <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
                    </svg>
                </div>
            </div>
        </div>
    </section>

    <!-- Recent Bookings -->
    <section class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="px-4 sm:px-6 py-4 border-b border-gray-200">
            <h3 class="font-bold text-gray-900">Pesanan Terbaru</h3>
        </div>
        <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="px-4 sm:px-6 py-10 text-center">
                <p class="text-gray-600">Belum ada pesanan</p>
            </div>
        <% } else { %>
            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-t border-gray-200">
                        <tr>
                            <th class="text-left font-semibold text-gray-700 px-4 sm:px-6 py-3">Kode</th>
                            <th class="text-left font-semibold text-gray-700 px-4 sm:px-6 py-3 hidden sm:table-cell">Penumpang</th>
                            <th class="text-left font-semibold text-gray-700 px-4 sm:px-6 py-3 hidden md:table-cell">Rute</th>
                            <th class="text-left font-semibold text-gray-700 px-4 sm:px-6 py-3 hidden lg:table-cell">Total</th>
                            <th class="text-left font-semibold text-gray-700 px-4 sm:px-6 py-3">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <% for (int i = 0; i < Math.min(bookings.size(), 5); i++) {
                        Booking b = bookings.get(i);
                        String statusColor = "pending".equals(b.getStatus()) ? "bg-yellow-100 text-yellow-700" :
                                            "approved".equals(b.getStatus()) ? "bg-green-100 text-green-700" :
                                            "bg-red-100 text-red-700";
                        String statusText = "pending".equals(b.getStatus()) ? "Menunggu" :
                                          "approved".equals(b.getStatus()) ? "Disetujui" : "Ditolak";
                    %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 sm:px-6 py-4">
                                <span class="font-mono font-bold text-gray-900"><%= b.getBookingCode() %></span>
                            </td>
                            <td class="px-4 sm:px-6 py-4 hidden sm:table-cell">
                                <div>
                                    <div class="font-medium text-gray-900"><%= b.getPassengerName() %></div>
                                    <div class="text-xs text-gray-500"><%= b.getPassengerPhone() != null ? b.getPassengerPhone() : "-" %></div>
                                </div>
                            </td>
                            <td class="px-4 sm:px-6 py-4 hidden md:table-cell">
                                <% if (b.getSchedule() != null && b.getSchedule().getOrigin() != null && b.getSchedule().getDestination() != null) { %>
                                    <div class="font-medium text-gray-900"><%= b.getSchedule().getOrigin().getCode() %></div>
                                    <div class="text-xs text-gray-500">ke <%= b.getSchedule().getDestination().getCode() %></div>
                                <% } else { %>
                                    <span class="text-gray-400">-</span>
                                <% } %>
                            </td>
                            <td class="px-4 sm:px-6 py-4 hidden lg:table-cell font-semibold text-red-600">
                                Rp <%= String.format("%,.0f", b.getTotalPrice()) %>
                            </td>
                            <td class="px-4 sm:px-6 py-4">
                                <span class="px-2 py-1 rounded-full text-xs font-medium <%= statusColor %>"><%= statusText %></span>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <div class="px-4 sm:px-6 py-4 bg-gray-50 border-t border-gray-200">
                <a href="<%= request.getContextPath() %>/admin-manage?action=all_bookings" class="text-sm text-blue-600 hover:text-blue-800 font-medium">Lihat semua pesanan →</a>
            </div>
        <% } %>
    </section>
</div>
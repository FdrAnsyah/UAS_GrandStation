<%-- Booking Detail --%>
<%@ page import="model.*, java.time.format.DateTimeFormatter" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
%>

<div class="max-w-4xl mx-auto">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-8">
        <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4 mb-6">
            <div>
                <h3 class="text-xl sm:text-2xl font-bold text-gray-900">Detail Pesanan</h3>
                <p class="text-sm text-gray-600 mt-1">Informasi lengkap tentang pesanan <%= booking != null ? booking.getBookingCode() : "" %></p>
            </div>
            <a href="<%= request.getContextPath() %>/admin-manage?action=all_bookings" class="px-4 py-2 rounded-lg border border-gray-200 text-gray-700 font-medium hover:bg-gray-50 transition text-center">
                Kembali
            </a>
        </div>

        <% if (booking == null) { %>
            <div class="text-center py-10">
                <p class="text-gray-600">Booking tidak ditemukan</p>
            </div>
        <% } else { %>
            <%
                String status = booking.getStatus();
                String statusText = "Menunggu";
                String statusColor = "bg-amber-100 text-amber-800 border-amber-200";

                if ("approved".equalsIgnoreCase(status)) {
                    statusText = "Disetujui";
                    statusColor = "bg-emerald-100 text-emerald-800 border-emerald-200";
                } else if ("rejected".equalsIgnoreCase(status)) {
                    statusText = "Ditolak";
                    statusColor = "bg-rose-100 text-rose-800 border-rose-200";
                }
            %>

            <!-- Booking Status -->
            <div class="mb-8">
                <div class="flex flex-wrap items-center justify-between gap-4">
                    <div>
                        <h4 class="text-lg font-bold text-gray-900">Kode Booking: <%= booking.getBookingCode() %></h4>
                        <p class="text-sm text-gray-600">Dibuat: <%= booking.getCreatedAt() != null ? booking.getCreatedAt().format(dt) : "-" %></p>
                    </div>
                    <span class="inline-block px-4 py-2 rounded-full border <%= statusColor %> font-semibold text-sm">
                        Status: <%= statusText %>
                    </span>
                </div>
            </div>

            <!-- Booking Information Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
                <!-- Passenger Info -->
                <div class="bg-gray-50 rounded-xl p-5">
                    <h4 class="font-bold text-gray-900 mb-4">Info Penumpang</h4>
                    <div class="space-y-3">
                        <div>
                            <p class="text-sm text-gray-600">Nama</p>
                            <p class="font-medium text-gray-900"><%= booking.getPassengerName() %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Nomor HP</p>
                            <p class="font-medium text-gray-900"><%= booking.getPassengerPhone() %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Jumlah Kursi</p>
                            <p class="font-medium text-gray-900"><%= booking.getSeats() %> Orang</p>
                        </div>
                    </div>
                </div>

                <!-- Journey Info -->
                <div class="bg-gray-50 rounded-xl p-5">
                    <h4 class="font-bold text-gray-900 mb-4">Info Perjalanan</h4>
                    <div class="space-y-3">
                        <div>
                            <p class="text-sm text-gray-600">Kereta</p>
                            <p class="font-medium text-gray-900"><%= booking.getSchedule() != null && booking.getSchedule().getTrain() != null ? booking.getSchedule().getTrain().getName() : "-" %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Rute</p>
                            <p class="font-medium text-gray-900">
                                <%= booking.getSchedule() != null && booking.getSchedule().getOrigin() != null ? booking.getSchedule().getOrigin().getName() : "-" %> →
                                <%= booking.getSchedule() != null && booking.getSchedule().getDestination() != null ? booking.getSchedule().getDestination().getName() : "-" %>
                            </p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Tanggal Berangkat</p>
                            <p class="font-medium text-gray-900"><%= booking.getSchedule() != null && booking.getSchedule().getDepartTime() != null ? booking.getSchedule().getDepartTime().format(dt) : "-" %></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pricing -->
            <div class="bg-gray-50 rounded-xl p-5 mb-8">
                <h4 class="font-bold text-gray-900 mb-4">Rincian Harga</h4>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <p class="text-sm text-gray-600">Harga per kursi</p>
                        <p class="font-medium text-gray-900">Rp <%= String.format("%,.0f", booking.getSchedule() != null ? booking.getSchedule().getPrice() : 0) %></p>
                    </div>
                    <div>
                        <p class="text-sm text-gray-600">Jumlah kursi</p>
                        <p class="font-medium text-gray-900"><%= booking.getSeats() %> kursi</p>
                    </div>
                    <div class="col-span-2 pt-3 border-t border-gray-200">
                        <div class="flex justify-between items-center">
                            <p class="text-sm text-gray-600 font-medium">Total Harga</p>
                            <p class="text-xl font-bold text-red-600">Rp <%= String.format("%,.0f", booking.getTotalPrice()) %></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex flex-wrap gap-3">
                <% if ("pending".equalsIgnoreCase(booking.getStatus())) { %>
                    <a href="<%= request.getContextPath() %>/admin-manage?action=approve_booking&id=<%= booking.getId() %>" class="px-6 py-3 rounded-lg bg-gradient-to-r from-green-500 to-green-600 text-white font-bold hover:shadow-lg transition">
                        Setujui Booking
                    </a>
                    <a href="<%= request.getContextPath() %>/admin-manage?action=reject_booking&id=<%= booking.getId() %>" class="px-6 py-3 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-bold hover:shadow-lg transition">
                        Tolak Booking
                    </a>
                <% } %>
                <a href="<%= request.getContextPath() %>/admin-manage?action=all_bookings" class="px-6 py-3 rounded-lg border border-gray-200 text-gray-700 font-bold hover:bg-gray-50 transition">
                    Kembali ke Daftar
                </a>
            </div>
        <% } %>
    </div>
</div>
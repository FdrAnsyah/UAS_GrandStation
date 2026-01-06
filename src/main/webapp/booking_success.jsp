<%@page import="model.Booking"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
    Booking b = (Booking) request.getAttribute("booking");
    DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
%>

<div class="max-w-4xl mx-auto px-4 py-8 md:py-12">
    <div class="bg-white rounded-2xl border border-slate-200 p-6 md:p-8 shadow-sm">
        <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4 mb-6">
            <div>
                <p class="text-xs uppercase tracking-wide text-sky-700 font-semibold">GrandStation</p>
                <h2 class="text-2xl md:text-3xl font-semibold mt-1">Booking Berhasil</h2>
                <p class="text-sm text-slate-600 mt-2">Simpan kode booking kamu untuk pengecekan.</p>
            </div>
            <a href="${pageContext.request.contextPath}/bookings" class="text-sm px-4 py-2 rounded-lg border border-slate-200 hover:bg-slate-50 transition whitespace-nowrap">Lihat Pesanan</a>
        </div>

        <% if (b == null || b.getSchedule() == null) { %>
            <div class="text-center py-8">
                <p class="text-slate-700">Data booking tidak ditemukan.</p>
            </div>
        <% } else { %>
            <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6">
                <div class="rounded-2xl border border-slate-200 p-5 md:p-6">
                    <div class="text-sm text-slate-500 font-medium">Kode Booking</div>
                    <div class="mt-2 text-2xl md:text-3xl font-bold tracking-wider text-sky-700"><%= b.getBookingCode() %></div>
                    <div class="mt-5 text-sm space-y-3">
                        <div class="flex justify-between gap-3">
                            <span class="text-slate-500">Penumpang</span>
                            <span class="font-medium text-right"><%= b.getPassengerName() %></span>
                        </div>
                        <div class="flex justify-between gap-3">
                            <span class="text-slate-500">No. HP</span>
                            <span class="font-medium text-right"><%= b.getPassengerPhone() %></span>
                        </div>
                        <div class="flex justify-between gap-3">
                            <span class="text-slate-500">Jumlah Kursi</span>
                            <span class="font-medium text-right"><%= b.getSeats() %> Orang</span>
                        </div>
                        <div class="flex justify-between gap-3 pt-3 border-t border-slate-200">
                            <span class="text-slate-500 font-medium">Total Harga</span>
                            <span class="font-bold text-sky-700">Rp <%= String.format("%,.0f", b.getTotalPrice()) %></span>
                        </div>
                    </div>
                </div>

                <div class="rounded-2xl border border-slate-200 p-5 md:p-6">
                    <div class="text-sm text-slate-500 font-medium">Detail Perjalanan</div>
                    <div class="mt-3 text-lg font-semibold text-slate-900"><%= b.getSchedule().getTrain() != null ? b.getSchedule().getTrain().getLabel() : "-" %></div>
                    <div class="mt-4 text-sm space-y-3">
                        <div class="flex justify-between gap-3">
                            <span class="text-slate-500">Rute</span>
                            <span class="font-medium text-right"><%= b.getSchedule().getOrigin().getCode() %> → <%= b.getSchedule().getDestination().getCode() %></span>
                        </div>
                        <div class="flex justify-between gap-3">
                            <span class="text-slate-500">Berangkat</span>
                            <span class="font-medium text-right"><%= b.getSchedule().getDepartTime() != null ? b.getSchedule().getDepartTime().format(dt) : "-" %></span>
                        </div>
                        <div class="flex justify-between gap-3">
                            <span class="text-slate-500">Tiba</span>
                            <span class="font-medium text-right"><%= b.getSchedule().getArriveTime() != null ? b.getSchedule().getArriveTime().format(dt) : "-" %></span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-8 flex flex-col sm:flex-row gap-3">
                <a href="${pageContext.request.contextPath}/payment?bookingId=<%= b.getId() %>" class="px-6 py-3 rounded-xl border-2 border-sky-600 text-sky-700 bg-white hover:bg-sky-50 font-bold transition text-center">
                    Lanjut Pembayaran
                </a>
                <a href="${pageContext.request.contextPath}/bookings" class="px-6 py-3 rounded-xl bg-gradient-to-r from-sky-500 to-sky-700 text-white font-bold shadow-lg hover:-translate-y-0.5 transition-all text-center">
                    Ke Daftar Pesanan
                </a>
            </div>
        <% } %>
    </div>
</div>

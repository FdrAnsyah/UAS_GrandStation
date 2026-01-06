<%@page import="dao.BookingDAO"%>
<%@page import="dao.TrainDAO"%>
<%@page import="dao.StationDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Booking"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%
    // Check if user is logged in and has admin role
    String userRole = (String) session.getAttribute("userRole");
    Object user = session.getAttribute("user");

    if (user == null) {
        // Not logged in - redirect to login
        response.sendRedirect(request.getContextPath() + "/login?error=login_required");
        return;
    }

    if (!"admin".equals(userRole)) {
        // Logged in but not admin - show access denied
        response.sendRedirect(request.getContextPath() + "/index.jsp?halaman=home&error=access_denied");
        return;
    }

    // User is admin - proceed
    BookingDAO bookingDAO = new BookingDAO();
    TrainDAO trainDAO = new TrainDAO();
    StationDAO stationDAO = new StationDAO();
    List<Booking> bookings = bookingDAO.getAll();
    int bookingCount = bookings != null ? bookings.size() : 0;
    int trainCount = trainDAO.getAll().size();
    int stationCount = stationDAO.getAll().size();
    DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
%>

<div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8 py-5">
<div class="flex flex-wrap items-start justify-between gap-4">
    <div>
        <p class="text-xs uppercase tracking-wide text-sky-700 font-semibold">Admin Panel</p>
        <h2 class="text-2xl font-bold text-slate-900">Dashboard GrandStation</h2>
        <p class="text-sm text-slate-600 mt-1">Tambah jadwal, kelola stasiun/kereta, pantau booking terbaru.</p>
    </div>
    <div class="flex flex-wrap gap-2 text-sm">
        <a class="px-4 py-2 rounded-lg border border-slate-200 bg-white hover:bg-slate-50 transition" href="${pageContext.request.contextPath}/index.jsp?halaman=home">Ke Landing</a>
        <a class="px-4 py-2 rounded-lg bg-sky-600 text-white font-semibold shadow-sm hover:bg-sky-700" href="${pageContext.request.contextPath}/bookings">Semua Pesanan</a>
    </div>
</div>

<section class="mt-5 grid grid-cols-1 sm:grid-cols-3 gap-3">
    <div class="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
        <div class="text-xs text-slate-500">Total Booking</div>
        <div class="text-2xl font-semibold text-slate-900"><%= bookingCount %></div>
        <p class="text-xs text-slate-500 mt-1">Kode booking unik, urut terbaru.</p>
    </div>
    <div class="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
        <div class="text-xs text-slate-500">Kereta terdaftar</div>
        <div class="text-2xl font-semibold text-slate-900"><%= trainCount %></div>
        <p class="text-xs text-slate-500 mt-1">Periksa atau edit detail armada.</p>
    </div>
    <div class="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
        <div class="text-xs text-slate-500">Stasiun aktif</div>
        <div class="text-2xl font-semibold text-slate-900"><%= stationCount %></div>
        <p class="text-xs text-slate-500 mt-1">Terhubung ke jadwal keberangkatan.</p>
    </div>
</section>

<section class="mt-6 grid gap-4 lg:grid-cols-3">
    <div class="lg:col-span-2 space-y-4">
        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5">
            <div class="flex items-center justify-between mb-3">
                <div>
                    <div class="text-sm font-semibold text-slate-900">Tindakan cepat</div>
                    <p class="text-xs text-slate-600">Mulai dari yang paling sering dipakai.</p>
                </div>
                <a class="text-sm px-3 py-2 rounded-lg border border-slate-200 bg-slate-50 hover:bg-slate-100" href="${pageContext.request.contextPath}/admin-manage">Lihat semua</a>
            </div>
            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-3 text-sm">
                <a href="${pageContext.request.contextPath}/admin-manage?action=manage_schedules" class="px-4 py-3 rounded-lg bg-gradient-to-r from-sky-500 to-sky-700 text-white font-semibold shadow hover:shadow-lg transition">+ Jadwal keberangkatan</a>
                <a href="${pageContext.request.contextPath}/admin-manage?action=manage_trains" class="px-4 py-3 rounded-lg border-2 border-sky-600 text-sky-700 font-semibold hover:bg-sky-50 transition">Kelola kereta</a>
                <a href="${pageContext.request.contextPath}/admin-manage?action=manage_stations" class="px-4 py-3 rounded-lg border-2 border-slate-200 text-slate-800 font-semibold hover:bg-slate-50 transition">Kelola stasiun</a>
            </div>
        </div>

        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="px-5 py-4 border-b border-slate-200 flex items-center justify-between gap-3">
                <div>
                    <div class="text-sm font-semibold">Booking terbaru</div>
                    <p class="text-xs text-slate-500">Menampilkan 5 pesanan terakhir.</p>
                </div>
                <a class="text-sm px-3 py-2 rounded-lg border border-slate-200 bg-white hover:bg-slate-50" href="${pageContext.request.contextPath}/bookings">Semua pesanan</a>
            </div>
            <% if (bookings == null || bookings.isEmpty()) { %>
                <div class="px-5 py-10 text-center">
                    <div class="text-lg font-semibold">Belum ada data booking</div>
                    <p class="text-sm text-slate-600">Mulai dengan melakukan pemesanan pada halaman utama.</p>
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
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                        <%
                            int limit = Math.min(bookings.size(), 5);
                            for (int i = 0; i < limit; i++) {
                                Booking b = bookings.get(i);
                        %>
                            <tr class="hover:bg-slate-50">
                                <td class="px-5 py-4">
                                    <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-800 border border-slate-200"><%= b.getBookingCode() %></span>
                                </td>
                                <td class="px-5 py-4">
                                    <div class="font-medium"><%= b.getPassengerName() %></div>
                                    <div class="text-xs text-slate-500"><%= b.getPassengerPhone() %></div>
                                </td>
                                <td class="px-5 py-4">
                                    <%= b.getSchedule() != null ? (b.getSchedule().getOrigin().getCode() + " → " + b.getSchedule().getDestination().getCode()) : "-" %>
                                </td>
                                <td class="px-5 py-4">
                                    <%= (b.getSchedule() != null && b.getSchedule().getDepartTime() != null) ? b.getSchedule().getDepartTime().format(dt) : "-" %>
                                </td>
                                <td class="px-5 py-4"><%= b.getSeats() %></td>
                                <td class="px-5 py-4 font-semibold text-sky-700">Rp <%= String.format("%,.0f", b.getTotalPrice()) %></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5 space-y-4">
        <div>
            <div class="text-sm font-semibold text-slate-900">Ringkas</div>
            <p class="text-xs text-slate-600">Data inti untuk jadwal dan booking.</p>
            <ul class="mt-3 text-sm text-slate-700 space-y-2">
                <li><span class="font-semibold text-slate-900"><%= stationCount %></span> stasiun aktif</li>
                <li><span class="font-semibold text-slate-900"><%= trainCount %></span> kereta tersedia</li>
                <li><span class="font-semibold text-slate-900"><%= bookingCount %></span> booking terdata</li>
            </ul>
        </div>

        <div class="border-t border-slate-200 pt-4 space-y-3">
            <div class="text-sm font-semibold text-slate-900">Akses cepat</div>
            <div class="flex flex-col gap-2 text-sm">
                <a class="px-3 py-2 rounded-lg border border-slate-200 hover:bg-slate-50" href="${pageContext.request.contextPath}/admin-manage?action=add_station">+ Tambah stasiun</a>
                <a class="px-3 py-2 rounded-lg border border-slate-200 hover:bg-slate-50" href="${pageContext.request.contextPath}/admin-manage?action=add_train">+ Tambah kereta</a>
                <a class="px-3 py-2 rounded-lg border border-sky-200 text-sky-700 hover:bg-sky-50" href="${pageContext.request.contextPath}/admin-manage?action=manage_schedules">Kelola jadwal</a>
            </div>
        </div>


    </div>
</section>
</div>

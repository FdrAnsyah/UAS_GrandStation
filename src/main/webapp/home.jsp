<%
    String err = (String) request.getAttribute("error");
    String currentUserRole = (String) session.getAttribute("userRole");
    Object currentUser = session.getAttribute("user");
    String currentUserName = (String) session.getAttribute("userName");
    boolean loggedIn = currentUser != null;
%>

<%@page import="dao.StationDAO"%>
<%@page import="dao.ScheduleDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Station"%>
<%@page import="model.Schedule"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Locale"%>

<%
    StationDAO stationDAO = new StationDAO();
    List<Station> stations = stationDAO.getAll();

    // Load all schedules for display (guest can see, but not book)
    ScheduleDAO scheduleDAO = new ScheduleDAO();
    List<Schedule> allSchedules = scheduleDAO.getAll();
    DateTimeFormatter dateLabel = DateTimeFormatter.ofPattern("EEEE, dd MMM yyyy", new Locale("id", "ID"));
%>

<!-- Hero Section with full-bleed background -->
<section class="relative w-screen left-1/2 right-1/2 -ml-[50vw] -mr-[50vw] overflow-hidden min-h-[500px] md:min-h-[520px] bg-cover bg-center">
    <!-- Background Image -->
    <div class="absolute inset-0 bg-cover bg-center bg-no-repeat" style="background-image: url('https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=1600&q=90'); filter: brightness(0.7) contrast(1.1);" aria-hidden="true"></div>

    <!-- Overlay Gradient -->
    <div class="absolute inset-0 bg-gradient-to-b from-black/70 via-black/40 to-black/60"></div>

    <div class="relative h-full flex items-center py-12">
        <div class="max-w-6xl mx-auto w-full px-4 sm:px-6 lg:px-8">
            <div class="text-white z-10 max-w-2xl">
                <h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold leading-tight mb-4">
                    Tiket Kereta<br/>Mudah & Cepat
                </h1>
                <p class="text-sm sm:text-base lg:text-lg text-slate-100 mb-4 max-w-2xl leading-relaxed">
                    Pesan tiket kereta online dengan harga terbaik. Proses mudah, pembayaran aman, perjalanan nyaman. Mulai rencanakan perjalanan Anda sekarang.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- Search Card Section -->
<section class="bg-white border-b border-slate-200 py-8">
    <div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-10">
        <div class="bg-white rounded-lg shadow-md border border-slate-200 p-6 sm:p-8">
            <% if (!loggedIn) { %>
                <div class="mb-4 rounded-xl border-l-4 border-sky-500 bg-sky-50 px-4 py-3">
                    <p class="text-sm font-semibold text-sky-900">Login untuk mencari & memesan</p>
                    <div class="mt-2 flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/login" class="text-sm px-4 py-2 bg-sky-600 text-white font-bold rounded-lg hover:bg-sky-700">Login</a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="text-sm px-4 py-2 border-2 border-sky-600 text-sky-600 font-bold rounded-lg hover:bg-sky-50">Buat Akun</a>
                    </div>
                </div>
            <% } %>

            <form method="get" action="${pageContext.request.contextPath}/search" class="space-y-4">
                <div class="grid md:grid-cols-4 gap-4 items-end">
                    <!-- From -->
                    <div>
                        <label class="block text-sm font-bold text-slate-900 mb-2">Dari</label>
                        <select name="originId" required class="w-full px-4 py-3 rounded-lg border-2 border-slate-300 focus:ring-2 focus:ring-sky-500 focus:border-sky-500 outline-none" <%= loggedIn ? "" : "disabled" %>>
                            <option value="">Pilih stasiun asal</option>
                            <% for (Station s : stations) { %>
                                <option value="<%= s.getId() %>"><%= s.getName() %> (<%= s.getCode() %>)</option>
                            <% } %>
                        </select>
                    </div>

                    <!-- To -->
                    <div>
                        <label class="block text-sm font-bold text-slate-900 mb-2">Ke</label>
                        <select name="destinationId" required class="w-full px-4 py-3 rounded-lg border-2 border-slate-300 focus:ring-2 focus:ring-sky-500 focus:border-sky-500 outline-none" <%= loggedIn ? "" : "disabled" %>>
                            <option value="">Pilih stasiun tujuan</option>
                            <% for (Station s : stations) { %>
                                <option value="<%= s.getId() %>"><%= s.getName() %> (<%= s.getCode() %>)</option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Date -->
                    <div>
                        <label class="block text-sm font-bold text-slate-900 mb-2">Tanggal</label>
                        <input type="date" name="travelDate" required class="w-full px-4 py-3 rounded-lg border-2 border-slate-300 focus:ring-2 focus:ring-sky-500 focus:border-sky-500 outline-none" <%= loggedIn ? "" : "disabled" %> />
                    </div>

                    <!-- Search Button -->
                    <div>
                        <button type="submit" class="w-full px-6 py-3 bg-gradient-to-r from-sky-500 to-blue-600 text-white font-bold rounded-lg hover:shadow-lg transition-all <%= loggedIn ? "" : "opacity-60 cursor-not-allowed" %>" <%= loggedIn ? "" : "disabled" %>>
                            Cari Kereta
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- Featured Schedules Section (Visible to All) -->
<section class="pt-16 pb-12 bg-slate-50">
    <div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-10">
        <div class="mb-8">
            <h2 class="text-3xl sm:text-4xl font-bold text-slate-900 mb-2">Jadwal Kereta Tersedia</h2>
            <p class="text-sm sm:text-base text-slate-600">Lihat jadwal kereta yang sedang beroperasi. <%= loggedIn ? "Klik Pesan untuk memesan tiket." : "Login untuk memesan tiket." %></p>
        </div>

        <% if (allSchedules == null || allSchedules.isEmpty()) { %>
            <div class="rounded-2xl border border-slate-200 bg-white p-12 text-center">
                <p class="text-slate-600">Belum ada jadwal kereta yang tersedia saat ini.</p>
            </div>
        <% } else { %>
            <div class="space-y-3">
                <% for (Schedule s : allSchedules) {
                    java.time.LocalDateTime departTime = s.getDepartTime();
                    java.time.LocalDateTime arriveTime = s.getArriveTime();

                    // Skip jika jadwal sudah lewat hari ini
                    java.time.LocalDate today = java.time.LocalDate.now();
                    java.time.LocalDate scheduleDate = departTime != null ? departTime.toLocalDate() : null;
                    if (scheduleDate == null || scheduleDate.isBefore(today)) {
                        continue;
                    }

                    int seatsLeft = s.getSeatsAvailable();
                    boolean isSoldOut = seatsLeft <= 0;
                    String badgeClass = seatsLeft <= 5 ? "bg-rose-50 text-rose-700 border border-rose-100" : "bg-emerald-50 text-emerald-700 border border-emerald-100";
                    java.time.format.DateTimeFormatter timeOnly = java.time.format.DateTimeFormatter.ofPattern("HH:mm");
                %>
                <div class="border border-slate-200 bg-white p-4 hover:shadow-md transition rounded-lg <%= isSoldOut ? "opacity-60" : "" %>">
                    <div class="flex flex-col md:flex-row md:items-center gap-3 md:gap-4">
                        <!-- Train Info -->
                        <div class="flex-shrink-0 md:w-40">
                            <div class="font-bold text-base"><%= s.getTrain() != null ? s.getTrain().getLabel() : "-" %></div>
                            <div class="text-xs text-slate-500"><%= s.getTrain() != null ? s.getTrain().getTrainClass() : "" %></div>
                        </div>

                        <!-- Timeline & Route -->
                        <div class="flex-1 flex items-center gap-2 md:gap-3">
                            <!-- Dari -->
                            <div class="text-center flex-shrink-0">
                                <div class="text-base font-bold"><%= departTime != null ? departTime.format(timeOnly) : "-" %></div>
                                <div class="text-xs text-slate-500"><%= s.getOrigin() != null ? s.getOrigin().getCode() : "-" %></div>
                                <div class="text-xs text-slate-600"><%= s.getOrigin() != null ? s.getOrigin().getName() : "" %></div>
                            </div>

                            <!-- Garis -->
                            <div class="flex-1 hidden sm:flex flex-col items-center">
                                <div class="h-0.5 w-full bg-gradient-to-r from-sky-500 to-blue-600 rounded-full"></div>
                                <div class="text-xs text-slate-500 mt-1 font-semibold whitespace-nowrap">
                                    <% if (departTime != null && arriveTime != null) {
                                        long minutes = java.time.temporal.ChronoUnit.MINUTES.between(departTime, arriveTime);
                                        long hours = minutes / 60;
                                        long mins = minutes % 60;
                                    %>
                                        <%= hours %>h <%= mins %>m
                                    <% } %>
                                </div>
                            </div>

                            <!-- Ke -->
                            <div class="text-center flex-shrink-0">
                                <div class="text-base font-bold"><%= arriveTime != null ? arriveTime.format(timeOnly) : "-" %></div>
                                <div class="text-xs text-slate-500"><%= s.getDestination() != null ? s.getDestination().getCode() : "-" %></div>
                                <div class="text-xs text-slate-600"><%= s.getDestination() != null ? s.getDestination().getName() : "" %></div>
                            </div>
                        </div>

                        <!-- Price -->
                        <div class="hidden md:flex flex-col items-center">
                            <div class="text-xs text-slate-500 font-semibold">Harga</div>
                            <div class="text-base font-bold text-sky-600">Rp <%= String.format("%,.0f", s.getPrice()) %></div>
                        </div>

                        <!-- Seats -->
                        <div class="flex flex-col items-center">
                            <div class="text-xs text-slate-500 font-semibold">Kursi</div>
                            <span class="px-2 py-1 rounded-full text-xs font-semibold <%= badgeClass %>">
                                <% if (isSoldOut) { %>
                                    Habis
                                <% } else { %>
                                    <%= seatsLeft %>
                                <% } %>
                            </span>
                        </div>

                        <!-- Button -->
                        <div class="md:w-20">
                            <% if (isSoldOut) { %>
                                <button disabled class="w-full px-3 py-1.5 bg-slate-300 text-slate-600 font-semibold rounded text-xs cursor-not-allowed">
                                    Habis
                                </button>
                            <% } else if (loggedIn) { %>
                                <a href="${pageContext.request.contextPath}/book?scheduleId=<%= s.getId() %>" class="w-full px-3 py-1.5 bg-gradient-to-r from-sky-500 to-blue-600 text-white font-semibold rounded text-xs text-center block hover:shadow-md transition">
                                    Pesan
                                </a>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/login" class="w-full px-3 py-1.5 bg-sky-50 text-sky-700 font-semibold rounded text-xs text-center block border border-sky-200 hover:bg-sky-100 transition">
                                    Login
                                </a>
                            <% } %>
                        </div>
                    </div>
                    <div class="text-xs text-slate-500 mt-2 pt-2 border-t border-slate-100">
                        <%= departTime != null ? departTime.format(dateLabel) : "-" %>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>
</section>

<%@page import="java.util.List"%>
<%@page import="model.Schedule"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="dao.ScheduleDAO"%>

<%
    String ctx = request.getContextPath();
    List<Schedule> schedules = (List<Schedule>) request.getAttribute("schedules");
    Object travelDateObj = request.getAttribute("travelDate");
    DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");

    // Check if user is admin and logged in
    String userRole = (String) session.getAttribute("userRole");
    Object userId = session.getAttribute("userId");
    boolean isAdmin = "admin".equals(userRole);
    boolean loggedIn = userId != null;

    // Fallback: if schedules attribute is missing, try to load via params or default list
    if (schedules == null) {
        String originParam = request.getParameter("originId");
        String destParam = request.getParameter("destinationId");
        String dateParam = request.getParameter("travelDate");
        try {
            if (originParam != null && destParam != null && dateParam != null &&
                !originParam.isBlank() && !destParam.isBlank() && !dateParam.isBlank()) {
                int originId = Integer.parseInt(originParam);
                int destinationId = Integer.parseInt(destParam);
                java.time.LocalDate travelDate = java.time.LocalDate.parse(dateParam);
                schedules = new ScheduleDAO().search(originId, destinationId, travelDate);
                travelDateObj = travelDate;
            } else {
                schedules = new ScheduleDAO().getAll();
            }
        } catch (Exception ignore) {
            schedules = new ScheduleDAO().getAll();
        }
    }
%>

<div class="mb-8">
    <!-- Search Bar -->
    <div class="bg-white rounded-2xl shadow-md p-4 mb-6">
        <form method="get" action="${pageContext.request.contextPath}/search" class="grid grid-cols-1 md:grid-cols-5 gap-3 items-end">
            <div>
                <label class="block text-xs font-bold text-slate-700 mb-2">Dari</label>
                <input type="text" placeholder="Station asal" class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" readonly />
            </div>
            <div>
                <label class="block text-xs font-bold text-slate-700 mb-2">Ke</label>
                <input type="text" placeholder="Station tujuan" class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" readonly />
            </div>
            <div>
                <label class="block text-xs font-bold text-slate-700 mb-2">Tanggal</label>
                <input type="text" value="<%= (travelDateObj != null ? travelDateObj.toString() : "-") %>" class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" readonly />
            </div>
            <div class="md:col-span-2 flex gap-2">
                <a href="${pageContext.request.contextPath}/index.jsp?halaman=home" class="flex-1 px-4 py-2 border-2 border-slate-300 text-slate-700 font-bold rounded-lg hover:bg-slate-50 transition text-center text-sm">
                    Ubah
                </a>
                <button type="submit" class="flex-1 px-4 py-2 bg-gradient-to-r from-sky-500 to-blue-600 text-white font-bold rounded-lg hover:shadow-lg transition text-sm">
                    Cari
                </button>
            </div>
        </form>
    </div>

    <!-- Filter Buttons -->
    <div class="flex gap-2 mb-6 overflow-x-auto pb-2">
        <button class="px-4 py-2 border border-slate-300 rounded-full text-sm font-semibold hover:border-sky-500 hover:text-sky-600 transition whitespace-nowrap">Filter & Sort</button>
        <button class="px-4 py-2 border border-slate-300 rounded-full text-sm font-semibold hover:border-sky-500 hover:text-sky-600 transition whitespace-nowrap">Harga Terendah</button>
        <button class="px-4 py-2 border border-slate-300 rounded-full text-sm font-semibold hover:border-sky-500 hover:text-sky-600 transition whitespace-nowrap">06:00 - 12:00</button>
        <button class="px-4 py-2 border border-slate-300 rounded-full text-sm font-semibold hover:border-sky-500 hover:text-sky-600 transition whitespace-nowrap">12:00 - 18:00</button>
        <button class="px-4 py-2 border border-slate-300 rounded-full text-sm font-semibold hover:border-sky-500 hover:text-sky-600 transition whitespace-nowrap">18:00 - 00:00</button>
    </div>
</div>

<div>
    <% if (schedules == null || schedules.isEmpty()) { %>
        <div class="rounded-2xl border border-slate-200 bg-white p-12 text-center">
            <div class="max-w-md mx-auto">
                <div class="text-2xl font-bold text-slate-900 mb-2">Jadwal Tidak Ditemukan</div>
                <p class="text-slate-600 mb-6">
                    Maaf, belum ada jadwal kereta untuk rute dan tanggal yang Anda pilih.
                    <strong>Permintaan Anda telah dicatat</strong> dan admin akan segera membuat jadwal baru berdasarkan kebutuhan Anda.
                </p>
                <div class="p-4 rounded-xl bg-sky-50 border border-sky-200 text-sm text-sky-800 mb-6">
                    <p class="font-semibold mb-1">Request Anda akan diproses!</p>
                    <p>Tim kami akan segera menambahkan jadwal untuk rute ini. Coba cari lagi nanti atau pilih rute lain.</p>
                </div>
                <div class="flex gap-3 justify-center">
                    <a href="${pageContext.request.contextPath}/index.jsp?halaman=home"
                       class="px-6 py-3 rounded-xl bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold hover:shadow-lg transition">
                        Coba Rute Lain
                    </a>
                </div>
            </div>
        </div>
    <% } else { %>
        <div class="space-y-3">
            <% for (Schedule s : schedules) {
                int seatsLeft = s.getSeatsAvailable();
                String badgeClass = seatsLeft <= 5 ? "bg-rose-50 text-rose-700 border border-rose-100" : "bg-emerald-50 text-emerald-700 border border-emerald-100";
                java.time.LocalDateTime departTime = s.getDepartTime();
                java.time.LocalDateTime arriveTime = s.getArriveTime();
                java.time.format.DateTimeFormatter timeOnly = java.time.format.DateTimeFormatter.ofPattern("HH:mm");
            %>
            <div class="rounded-2xl border border-slate-200 bg-white p-6 hover:shadow-lg transition">
                <div class="grid md:grid-cols-12 gap-4 items-start">
                    <!-- Train Info -->
                    <div class="md:col-span-2">
                        <div class="font-bold text-lg"><%= s.getTrain() != null ? s.getTrain().getLabel() : "-" %></div>
                        <div class="text-xs text-slate-500 font-medium"><%= s.getTrain() != null ? s.getTrain().getTrainClass() : "" %></div>
                    </div>

                    <!-- Timeline -->
                    <div class="md:col-span-5">
                        <div class="flex items-center justify-between gap-3">
                            <div>
                                <div class="text-2xl font-bold"><%= departTime != null ? departTime.format(timeOnly) : "-" %></div>
                                <div class="text-xs text-slate-500"><%= s.getOrigin() != null ? s.getOrigin().getCode() : "-" %></div>
                            </div>
                            <div class="flex-1">
                                <div class="h-0.5 bg-gradient-to-r from-sky-500 to-blue-600 rounded-full"></div>
                                <div class="text-xs text-slate-500 text-center mt-1">
                                    <% if (departTime != null && arriveTime != null) {
                                        long minutes = java.time.temporal.ChronoUnit.MINUTES.between(departTime, arriveTime);
                                        long hours = minutes / 60;
                                        long mins = minutes % 60;
                                    %>
                                        <%= hours %>h <%= mins %>m
                                    <% } %>
                                </div>
                            </div>
                            <div>
                                <div class="text-2xl font-bold"><%= arriveTime != null ? arriveTime.format(timeOnly) : "-" %></div>
                                <div class="text-xs text-slate-500"><%= s.getDestination() != null ? s.getDestination().getCode() : "-" %></div>
                            </div>
                        </div>
                    </div>

                    <!-- Price & Seats -->
                    <div class="md:col-span-3 flex flex-col items-end gap-2">
                        <div class="text-right">
                            <div class="text-2xl font-bold text-sky-600">Rp <%= String.format("%,.0f", s.getPrice()) %></div>
                        </div>
                        <div class="flex items-center gap-2">
                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold <%= badgeClass %>">
                                <%= seatsLeft %> kursi
                            </span>
                            <% if (seatsLeft <= 5) { %>
                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-semibold bg-rose-100 text-rose-700">Harga Terendah</span>
                            <% } %>
                        </div>
                    </div>

                    <!-- Action Button -->
                    <div class="md:col-span-12 border-t border-slate-100 pt-4 flex justify-end">
                        <% if (isAdmin) { %>
                            <span class="inline-flex items-center px-6 py-2 rounded-xl bg-slate-100 text-slate-500 text-sm font-semibold">Admin View</span>
                        <% } else if (loggedIn) { %>
                            <a href="${pageContext.request.contextPath}/book?scheduleId=<%= s.getId() %>" class="px-6 py-2 bg-gradient-to-r from-sky-500 to-blue-600 text-white font-bold rounded-lg hover:shadow-lg transition text-sm">
                                Pesan
                            </a>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/login" class="px-6 py-2 bg-sky-50 text-sky-700 font-bold rounded-lg border border-sky-200 hover:bg-sky-100 transition text-sm">
                                Login Dulu
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>
</div>

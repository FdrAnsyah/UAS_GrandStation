<%@page import="model.Schedule"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
    String ctx = request.getContextPath();
    Schedule schedule = (Schedule) request.getAttribute("schedule");
    String err = (String) request.getAttribute("error");
    DateTimeFormatter dt = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
%>

<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-10 py-5 lg:py-7">
    <div class="flex items-start justify-between gap-4">
        <div>
            <p class="text-xs uppercase tracking-wide text-sky-700 font-semibold">GrandStation</p>
            <h2 class="text-xl font-semibold">Form Pemesanan</h2>
            <p class="text-sm text-slate-600 mt-1">Lengkapi data penumpang. Kursi akan langsung dikurangi setelah submit.</p>
        </div>
        <a href="${pageContext.request.contextPath}/index.jsp?halaman=home#cari" class="text-sm px-3 py-2 rounded-lg border border-slate-200 bg-white hover:bg-slate-50">Kembali</a>
    </div>

    <% if (schedule == null) { %>
        <div class="mt-5 rounded-2xl border border-slate-200 bg-white p-6">
            <p class="text-slate-700">Jadwal tidak ditemukan.</p>
        </div>
    <% } else { %>
        <div class="mt-5 grid grid-cols-1 lg:grid-cols-5 gap-4">
            <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                <div class="text-sm text-slate-500">Detail Jadwal</div>
                <div class="mt-2 font-semibold"><%= schedule.getTrain() != null ? schedule.getTrain().getLabel() : "-" %></div>
                <div class="mt-3 text-sm">
                    <div class="flex justify-between gap-3"><span class="text-slate-500">Rute</span><span class="font-medium"><%= schedule.getOrigin().getCode() %> - <%= schedule.getDestination().getCode() %></span></div>
                    <div class="flex justify-between gap-3 mt-2"><span class="text-slate-500">Berangkat</span><span class="font-medium"><%= schedule.getDepartTime() != null ? schedule.getDepartTime().format(dt) : "-" %></span></div>
                    <div class="flex justify-between gap-3 mt-2"><span class="text-slate-500">Tiba</span><span class="font-medium"><%= schedule.getArriveTime() != null ? schedule.getArriveTime().format(dt) : "-" %></span></div>
                    <div class="flex justify-between gap-3 mt-2"><span class="text-slate-500">Harga / kursi</span><span class="font-medium">Rp <%= String.format("%,.0f", schedule.getPrice()) %></span></div>
                    <div class="flex justify-between gap-3 mt-2"><span class="text-slate-500">Sisa kursi</span><span class="font-medium"><%= schedule.getSeatsAvailable() %></span></div>
                </div>
            </div>

            <div class="lg:col-span-3 bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                <% if (err != null) { %>
                <div class="mb-4 rounded-xl border border-rose-200 bg-rose-50 text-rose-800 px-4 py-3 text-sm">
                    <b>Oops:</b> <%= err %>
                </div>
                <% } %>

                <form method="post" action="<%= ctx %>/book" class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <input type="hidden" name="scheduleId" value="<%= schedule.getId() %>" />

                    <div class="sm:col-span-2">
                        <label class="text-sm font-semibold text-slate-700">Nama penumpang</label>
                        <input name="passengerName" type="text" placeholder="Contoh: Ferdi" class="mt-1 w-full rounded-xl border-2 border-slate-300 px-3 py-2 outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500" />
                    </div>

                    <div>
                        <label class="text-sm font-semibold text-slate-700">No. HP</label>
                        <input name="passengerPhone" type="text" placeholder="08xxxxxxxxxx" class="mt-1 w-full rounded-xl border-2 border-slate-300 px-3 py-2 outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500" />
                    </div>

                    <div>
                        <label class="text-sm font-semibold text-slate-700">Jumlah kursi</label>
                        <input name="seats" type="number" min="1" value="1" class="mt-1 w-full rounded-xl border-2 border-slate-300 px-3 py-2 outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500" />
                    </div>

                    <div class="sm:col-span-2 flex items-center justify-between gap-3 pt-2">
                        <p class="text-xs text-slate-500">Total otomatis dihitung saat submit (harga × kursi).</p>
                        <button class="px-4 py-2 rounded-xl bg-gradient-to-r from-sky-500 to-sky-700 text-white font-bold hover:shadow-lg hover:-translate-y-0.5 shadow-md transition-all">Buat Booking</button>
                    </div>
                </form>
            </div>
        </div>
    <% } %>
</div>

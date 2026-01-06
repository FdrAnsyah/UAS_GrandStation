<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.*, java.util.*, java.time.format.DateTimeFormatter" %>
<%
    Schedule schedule = (Schedule) request.getAttribute("schedule");
    List<Station> stations = (List<Station>) request.getAttribute("stations");
    List<Train> trains = (List<Train>) request.getAttribute("trains");
    boolean isEdit = (schedule != null);
    String error = request.getParameter("error");

    DateTimeFormatter dtFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    String departTimeValue = isEdit ? schedule.getDepartTime().format(dtFormatter) : "";
    String arriveTimeValue = isEdit ? schedule.getArriveTime().format(dtFormatter) : "";
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Jadwal" : "Tambah Jadwal" %> - GrandStation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Space Grotesk', sans-serif;
        }
    </style>
</head>
<body class="bg-slate-50 flex flex-col min-h-screen">
    <jsp:include page="menu.jsp" />

    <main class="max-w-3xl mx-auto px-4 py-12 flex-grow">
        <% if (error != null) { %>
            <div class="mb-6 p-4 bg-rose-50 border-l-4 border-rose-500 rounded">
                <p class="text-rose-700 font-semibold">Gagal <%= isEdit ? "mengupdate" : "menambahkan" %> jadwal. Silakan coba lagi.</p>
            </div>
        <% } %>

        <div class="bg-white rounded-xl shadow border border-slate-100 p-8">
            <div class="mb-6">
                <h1 class="text-3xl font-bold text-sky-700 mb-2"><%= isEdit ? "Edit Jadwal" : "Tambah Jadwal Baru" %></h1>
                <p class="text-slate-600">Lengkapi informasi jadwal perjalanan</p>
            </div>

            <form action="<%= request.getContextPath() %>/admin-manage" method="POST">
                <input type="hidden" name="action" value="<%= isEdit ? "update_schedule" : "add_schedule" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= schedule.getId() %>">
                <% } %>

                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">Kereta *</label>
                        <select name="train_id" required
                            class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600">
                            <option value="">-- Pilih Kereta --</option>
                            <% if (trains != null) {
                                for (Train t : trains) { %>
                                    <option value="<%= t.getId() %>" <%= isEdit && schedule.getTrain().getId() == t.getId() ? "selected" : "" %>>
                                        <%= t.getCode() %> - <%= t.getName() %> (<%= t.getTrainClass() %>)
                                    </option>
                                <% }
                            } %>
                        </select>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-2">Stasiun Asal *</label>
                            <select name="origin_id" required
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600">
                                <option value="">-- Pilih Stasiun Asal --</option>
                                <% if (stations != null) {
                                    for (Station s : stations) { %>
                                        <option value="<%= s.getId() %>" <%= isEdit && schedule.getOrigin().getId() == s.getId() ? "selected" : "" %>>
                                            <%= s.getName() %> (<%= s.getCity() %>)
                                        </option>
                                    <% }
                                } %>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-2">Stasiun Tujuan *</label>
                            <select name="destination_id" required
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600">
                                <option value="">-- Pilih Stasiun Tujuan --</option>
                                <% if (stations != null) {
                                    for (Station s : stations) { %>
                                        <option value="<%= s.getId() %>" <%= isEdit && schedule.getDestination().getId() == s.getId() ? "selected" : "" %>>
                                            <%= s.getName() %> (<%= s.getCity() %>)
                                        </option>
                                    <% }
                                } %>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-2">Waktu Keberangkatan *</label>
                            <input type="datetime-local" name="depart_time" value="<%= departTimeValue %>"
                                required
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600">
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-2">Waktu Kedatangan *</label>
                            <input type="datetime-local" name="arrive_time" value="<%= arriveTimeValue %>"
                                required
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600">
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-2">Harga (Rp) *</label>
                            <input type="number" name="price" value="<%= isEdit ? (int)schedule.getPrice() : "" %>"
                                required min="0" step="1000"
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600"
                                placeholder="Contoh: 150000">
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-slate-700 mb-2">Kursi Tersedia *</label>
                            <input type="number" name="seats_available" value="<%= isEdit ? schedule.getSeatsAvailable() : "" %>"
                                required min="0"
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600"
                                placeholder="Contoh: 200">
                        </div>
                    </div>
                </div>

                <div class="flex gap-4 mt-8">
                    <button type="submit"
                        class="flex-1 px-6 py-3 bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg">
                        <%= isEdit ? "Update Jadwal" : "Tambah Jadwal" %>
                    </button>
                    <a href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules"
                        class="flex-1 px-6 py-3 border-2 border-slate-300 text-slate-700 font-bold rounded-lg hover:bg-slate-50 transition text-center">
                        Batal
                    </a>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="footer.jsp" />
</body>
</html>

<%-- Schedule Form (Add/Edit) --%>
<%@ page import="model.*, java.util.*, java.time.format.DateTimeFormatter" %>
<%
    Schedule schedule = (Schedule) request.getAttribute("schedule");
    List<Train> trains = (List<Train>) request.getAttribute("trains");
    List<Station> stations = (List<Station>) request.getAttribute("stations");
    boolean isEdit = schedule != null;
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
%>

<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-8">
        <h3 class="text-xl sm:text-2xl font-bold text-gray-900 mb-6">
            <%= isEdit ? "Edit Jadwal" : "Tambah Jadwal Baru" %>
        </h3>

        <form method="POST" action="<%= request.getContextPath() %>/admin-manage" class="space-y-6">
            <input type="hidden" name="action" value="<%= isEdit ? "update_schedule" : "add_schedule" %>">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= schedule.getId() %>">
            <% } %>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Kereta</label>
                <select name="train_id" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent" required>
                    <option value="">Pilih kereta</option>
                    <% if (trains != null) { %>
                        <% for (Train t : trains) { %>
                            <option value="<%= t.getId() %>" <%= isEdit && schedule.getTrain() != null && schedule.getTrain().getId() == t.getId() ? "selected" : "" %>><%= t.getName() %> (<%= t.getTrainClass() %>)</option>
                        <% } %>
                    <% } %>
                </select>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Stasiun Asal</label>
                <select name="origin_id" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent" required>
                    <option value="">Pilih stasiun asal</option>
                    <% if (stations != null) { %>
                        <% for (Station s : stations) { %>
                            <option value="<%= s.getId() %>" <%= isEdit && schedule.getOrigin() != null && schedule.getOrigin().getId() == s.getId() ? "selected" : "" %>><%= s.getName() %> (<%= s.getCode() %>)</option>
                        <% } %>
                    <% } %>
                </select>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Stasiun Tujuan</label>
                <select name="destination_id" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent" required>
                    <option value="">Pilih stasiun tujuan</option>
                    <% if (stations != null) { %>
                        <% for (Station s : stations) { %>
                            <option value="<%= s.getId() %>" <%= isEdit && schedule.getDestination() != null && schedule.getDestination().getId() == s.getId() ? "selected" : "" %>><%= s.getName() %> (<%= s.getCode() %>)</option>
                        <% } %>
                    <% } %>
                </select>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold text-gray-900 mb-2">Waktu Berangkat</label>
                    <input type="datetime-local" name="depart_time" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                           value="<%= isEdit && schedule.getDepartTime() != null ? schedule.getDepartTime().format(formatter) : "" %>" required>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-900 mb-2">Waktu Tiba</label>
                    <input type="datetime-local" name="arrive_time" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                           value="<%= isEdit && schedule.getArriveTime() != null ? schedule.getArriveTime().format(formatter) : "" %>" required>
                </div>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Harga Tiket</label>
                <input type="number" name="price" placeholder="Contoh: 150000" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? String.valueOf(schedule.getPrice()) : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Jumlah Kursi Tersedia</label>
                <input type="number" name="seats_available" placeholder="Contoh: 100" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? String.valueOf(schedule.getSeatsAvailable()) : "" %>" required>
            </div>

            <div class="flex gap-3 pt-4">
                <button type="submit" class="px-6 py-3 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold hover:shadow-lg transition flex-1">
                    <%= isEdit ? "Update Jadwal" : "Tambah Jadwal" %>
                </button>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_schedules" class="px-6 py-3 rounded-lg border border-gray-200 text-gray-700 font-semibold hover:bg-gray-50 transition flex-1 text-center">
                    Batal
                </a>
            </div>
        </form>
    </div>
</div>
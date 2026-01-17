<%-- Station Form (Add/Edit) --%>
<%@ page import="model.*" %>
<%
    Station station = (Station) request.getAttribute("station");
    boolean isEdit = station != null;
%>

<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-8">
        <h3 class="text-xl sm:text-2xl font-bold text-gray-900 mb-6">
            <%= isEdit ? "Edit Stasiun" : "Tambah Stasiun Baru" %>
        </h3>

        <form method="POST" action="<%= request.getContextPath() %>/admin-manage" class="space-y-6">
            <input type="hidden" name="action" value="<%= isEdit ? "update_station" : "add_station" %>">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= station.getId() %>">
            <% } %>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Kode Stasiun</label>
                <input type="text" name="code" placeholder="Contoh: GMR, BD, YK" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? station.getCode() : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Nama Stasiun</label>
                <input type="text" name="name" placeholder="Contoh: Gambir, Bandung, Yogyakarta" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? station.getName() : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Kota</label>
                <input type="text" name="city" placeholder="Contoh: Jakarta, Bandung, Yogyakarta" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? station.getCity() : "" %>" required>
            </div>

            <div class="flex gap-3 pt-4">
                <button type="submit" class="px-6 py-3 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold hover:shadow-lg transition flex-1">
                    <%= isEdit ? "Update Stasiun" : "Tambah Stasiun" %>
                </button>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_stations" class="px-6 py-3 rounded-lg border border-gray-200 text-gray-700 font-semibold hover:bg-gray-50 transition flex-1 text-center">
                    Batal
                </a>
            </div>
        </form>
    </div>
</div>
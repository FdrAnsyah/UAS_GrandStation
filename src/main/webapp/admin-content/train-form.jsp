<%-- Train Form (Add/Edit) --%>
<%@ page import="model.*" %>
<%
    Train train = (Train) request.getAttribute("train");
    boolean isEdit = train != null;
%>

<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-8">
        <h3 class="text-xl sm:text-2xl font-bold text-gray-900 mb-6">
            <%= isEdit ? "Edit Kereta" : "Tambah Kereta Baru" %>
        </h3>

        <form method="POST" action="<%= request.getContextPath() %>/admin-manage" class="space-y-6">
            <input type="hidden" name="action" value="<%= isEdit ? "update_train" : "add_train" %>">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= train.getId() %>">
            <% } %>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Kode Kereta</label>
                <input type="text" name="code" placeholder="Contoh: ARJ, ARG, SRB" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? train.getCode() : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Nama Kereta</label>
                <input type="text" name="name" placeholder="Contoh: Ekspres Jakarta-Bandung" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? train.getName() : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Kelas Kereta</label>
                <input type="text" name="train_class" placeholder="Contoh: Ekonomi, Bisnis, Ekskutif" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? train.getTrainClass() : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Kapasitas Kursi</label>
                <input type="number" name="seats_total" placeholder="Contoh: 100" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? train.getSeatsTotal() : "" %>" required>
            </div>

            <div class="flex gap-3 pt-4">
                <button type="submit" class="px-6 py-3 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold hover:shadow-lg transition flex-1">
                    <%= isEdit ? "Update Kereta" : "Tambah Kereta" %>
                </button>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_trains" class="px-6 py-3 rounded-lg border border-gray-200 text-gray-700 font-semibold hover:bg-gray-50 transition flex-1 text-center">
                    Batal
                </a>
            </div>
        </form>
    </div>
</div>
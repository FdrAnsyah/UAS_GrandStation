<%-- Trains List --%>
<%@ page import="java.util.*, model.*" %>
<%
    List<Train> trains = (List<Train>) request.getAttribute("trains");
%>

<div class="space-y-6">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
            <div>
                <h3 class="text-lg font-bold text-gray-900">Daftar Kereta</h3>
                <p class="text-sm text-gray-600 mt-1">Kelola armada kereta dalam sistem</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin-manage?action=add_train_form"
               class="px-4 py-2 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold hover:shadow-lg transition w-full sm:w-auto text-center">
                + Tambah Kereta
            </a>
        </div>

        <% if (trains == null || trains.isEmpty()) { %>
            <div class="text-center py-10">
                <p class="text-gray-600">Belum ada kereta terdaftar</p>
            </div>
        <% } else { %>
            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-y border-gray-200">
                        <tr>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Nama</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3 hidden sm:table-cell">Kelas</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3 hidden md:table-cell">Kapasitas</th>
                            <th class="text-center font-semibold text-gray-700 px-4 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <% for (Train t : trains) { %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-3 font-semibold text-gray-900"><%= t.getName() %></td>
                            <td class="px-4 py-3 hidden sm:table-cell text-gray-700"><%= t.getTrainClass() %></td>
                            <td class="px-4 py-3 hidden md:table-cell text-gray-700"><%= t.getSeatsTotal() %> kursi</td>
                            <td class="px-4 py-3 text-center">
                                <div class="flex gap-2 justify-center">
                                    <a href="<%= request.getContextPath() %>/admin-manage?action=edit_train&id=<%= t.getId() %>" class="px-3 py-1 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200 transition">Edit</a>
                                    <a href="<%= request.getContextPath() %>/admin-manage?action=delete_train&id=<%= t.getId() %>" onclick="return confirm('Yakin?')" class="px-3 py-1 text-xs bg-red-100 text-red-700 rounded hover:bg-red-200 transition">Hapus</a>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>
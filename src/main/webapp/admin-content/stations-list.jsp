<%-- Stations List --%>
<%@ page import="java.util.*, model.*" %>
<%
    List<Station> stations = (List<Station>) request.getAttribute("stations");
%>

<div class="space-y-6">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
            <div>
                <h3 class="text-lg font-bold text-gray-900">Daftar Stasiun</h3>
                <p class="text-sm text-gray-600 mt-1">Kelola stasiun kereta dalam sistem</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin-manage?action=add_station_form"
               class="px-4 py-2 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold hover:shadow-lg transition w-full sm:w-auto text-center">
                + Tambah Stasiun
            </a>
        </div>

        <% if (stations == null || stations.isEmpty()) { %>
            <div class="text-center py-10">
                <p class="text-gray-600">Belum ada stasiun terdaftar</p>
            </div>
        <% } else { %>
            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-y border-gray-200">
                        <tr>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Kode</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Nama</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3 hidden sm:table-cell">Kota</th>
                            <th class="text-center font-semibold text-gray-700 px-4 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <% for (Station s : stations) { %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-3 font-semibold text-gray-900"><%= s.getCode() %></td>
                            <td class="px-4 py-3 text-gray-700"><%= s.getName() %></td>
                            <td class="px-4 py-3 hidden sm:table-cell text-gray-700"><%= s.getCity() %></td>
                            <td class="px-4 py-3 text-center">
                                <div class="flex gap-2 justify-center">
                                    <a href="<%= request.getContextPath() %>/admin-manage?action=edit_station&id=<%= s.getId() %>" class="px-3 py-1 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200 transition">Edit</a>
                                    <a href="<%= request.getContextPath() %>/admin-manage?action=delete_station&id=<%= s.getId() %>" onclick="return confirm('Yakin?')" class="px-3 py-1 text-xs bg-red-100 text-red-700 rounded hover:bg-red-200 transition">Hapus</a>
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
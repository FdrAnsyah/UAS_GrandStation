<%-- Schedules List --%>
<%@ page import="java.util.*, model.*" %>
<%
    List<Schedule> schedules = (List<Schedule>) request.getAttribute("schedules");
%>

<div class="space-y-6">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
            <div>
                <h3 class="text-lg font-bold text-gray-900">Daftar Jadwal</h3>
                <p class="text-sm text-gray-600 mt-1">Kelola jadwal keberangkatan kereta</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin-manage?action=add_schedule_form"
               class="px-4 py-2 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold hover:shadow-lg transition w-full sm:w-auto text-center">
                + Tambah Jadwal
            </a>
        </div>

        <% if (schedules == null || schedules.isEmpty()) { %>
            <div class="text-center py-10">
                <p class="text-gray-600">Belum ada jadwal terdaftar</p>
            </div>
        <% } else { %>
            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-y border-gray-200">
                        <tr>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Kereta</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Rute</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3 hidden md:table-cell">Berangkat</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3 hidden md:table-cell">Tiba</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Harga</th>
                            <th class="text-center font-semibold text-gray-700 px-4 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <% for (Schedule s : schedules) { %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-3">
                                <div class="font-medium text-gray-900"><%= s.getTrain() != null ? s.getTrain().getName() : "-" %></div>
                                <div class="text-xs text-gray-500"><%= s.getTrain() != null ? s.getTrain().getTrainClass() : "" %></div>
                            </td>
                            <td class="px-4 py-3">
                                <div class="font-medium text-gray-900"><%= s.getOrigin() != null ? s.getOrigin().getName() : "-" %></div>
                                <div class="text-xs text-gray-500">→ <%= s.getDestination() != null ? s.getDestination().getName() : "-" %></div>
                            </td>
                            <td class="px-4 py-3 hidden md:table-cell">
                                <%= s.getDepartTime() != null ? s.getDepartTime().toString() : "-" %>
                            </td>
                            <td class="px-4 py-3 hidden md:table-cell">
                                <%= s.getArriveTime() != null ? s.getArriveTime().toString() : "-" %>
                            </td>
                            <td class="px-4 py-3 font-semibold text-red-600">
                                Rp <%= String.format("%,.0f", s.getPrice()) %>
                            </td>
                            <td class="px-4 py-3 text-center">
                                <div class="flex gap-2 justify-center">
                                    <a href="<%= request.getContextPath() %>/admin-manage?action=edit_schedule&id=<%= s.getId() %>" class="px-3 py-1 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200 transition">Edit</a>
                                    <a href="<%= request.getContextPath() %>/admin-manage?action=delete_schedule&id=<%= s.getId() %>" onclick="return confirm('Yakin?')" class="px-3 py-1 text-xs bg-red-100 text-red-700 rounded hover:bg-red-200 transition">Hapus</a>
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
<%-- Schedule Requests --%>
<%@ page import="java.util.*, java.time.format.DateTimeFormatter" %>
<%
    List<Map<String, Object>> scheduleRequests = (List<Map<String, Object>>) request.getAttribute("scheduleRequests");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy");
%>

<div class="space-y-6">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
            <div>
                <h3 class="text-lg font-bold text-gray-900">Request Jadwal dari Pengguna</h3>
                <p class="text-sm text-gray-600 mt-1">Permintaan rute perjalanan yang diajukan oleh pengguna</p>
            </div>
            <div class="text-sm text-gray-500">
                <%= scheduleRequests != null ? scheduleRequests.size() : 0 %> request
            </div>
        </div>

        <% if (scheduleRequests == null || scheduleRequests.isEmpty()) { %>
            <div class="text-center py-10">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Tidak Ada Request Jadwal</h3>
                <p class="text-gray-600">Belum ada permintaan jadwal dari pengguna saat ini.</p>
            </div>
        <% } else { %>
            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-y border-gray-200">
                        <tr>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Rute</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Tanggal Diminta</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Jumlah Permintaan</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Pengguna</th>
                            <th class="text-left font-semibold text-gray-700 px-4 py-3">Waktu Terakhir</th>
                            <th class="text-center font-semibold text-gray-700 px-4 py-3">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <% for (Map<String, Object> req : scheduleRequests) { %>
                    <tr class="hover:bg-gray-50">
                        <td class="px-4 py-3">
                            <div class="text-sm font-medium text-gray-900">
                                <%= req.get("origin_code") %> - <%= req.get("destination_code") %>
                            </div>
                            <div class="text-sm text-gray-500">
                                <%= req.get("origin_name") %> - <%= req.get("destination_name") %>
                            </div>
                        </td>
                        <td class="px-4 py-3">
                            <div class="text-sm text-gray-900">
                                <%= req.get("requested_date") != null ? req.get("requested_date") : "-" %>
                            </div>
                        </td>
                        <td class="px-4 py-3">
                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                <%= req.get("request_count") %> kali
                            </span>
                        </td>
                        <td class="px-4 py-3">
                            <div class="text-sm font-medium text-gray-900">
                                <%= req.get("user_name") != null ? req.get("user_name") : "-" %>
                            </div>
                            <div class="text-sm text-gray-500">
                                <%= req.get("user_email") != null ? req.get("user_email") : "-" %>
                            </div>
                        </td>
                        <td class="px-4 py-3 text-sm text-gray-500">
                            <%= req.get("last_requested_at") != null ? req.get("last_requested_at").toString().substring(0, 19) : "-" %>
                        </td>
                        <td class="px-4 py-3 text-center">
                            <div class="flex flex-wrap gap-2 justify-center">
                                <a href="<%= request.getContextPath() %>/admin-manage?action=review_schedule_request&id=<%= req.get("id") %>" class="px-3 py-1 text-xs bg-indigo-100 text-indigo-700 rounded hover:bg-indigo-200 transition">Tinjau</a>
                                <a href="<%= request.getContextPath() %>/admin-manage?action=add_schedule_from_request&id=<%= req.get("id") %>" class="px-3 py-1 text-xs bg-green-100 text-green-700 rounded hover:bg-green-200 transition">Buat Jadwal</a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <!-- Stats Summary -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="bg-white rounded-xl shadow border border-gray-200 p-5">
            <div class="text-sm text-gray-600">Total Request</div>
            <div class="text-2xl font-bold text-gray-900"><%= scheduleRequests != null ? scheduleRequests.size() : 0 %></div>
            <div class="text-xs text-gray-500 mt-1">Permintaan jadwal masuk</div>
        </div>
        <div class="bg-white rounded-xl shadow border border-gray-200 p-5">
            <div class="text-sm text-blue-600">Rute Paling Diminta</div>
            <div class="text-2xl font-bold text-blue-700">
                <% if (scheduleRequests != null && !scheduleRequests.isEmpty()) {
                    Map<String, Object> topReq = scheduleRequests.get(0);
                    out.print(topReq.get("origin_code") + "-" + topReq.get("destination_code"));
                } else {
                    out.print("N/A");
                } %>
            </div>
            <div class="text-xs text-blue-500 mt-1">Berdasarkan jumlah permintaan</div>
        </div>
        <div class="bg-white rounded-xl shadow border border-gray-200 p-5">
            <div class="text-sm text-emerald-600">Rata-rata Request</div>
            <div class="text-2xl font-bold text-emerald-700">
                <% if (scheduleRequests != null && !scheduleRequests.isEmpty()) {
                    int total = 0;
                    for (Map<String, Object> req : scheduleRequests) {
                        total += (Integer) req.get("request_count");
                    }
                    out.print(String.format("%.1f", (double) total / scheduleRequests.size()));
                } else {
                    out.print("0");
                } %>
            </div>
            <div class="text-xs text-emerald-500 mt-1">Per permintaan</div>
        </div>
    </div>
</div>
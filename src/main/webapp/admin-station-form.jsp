<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Station" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah/Edit Stasiun - GrandStation</title>
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

    <div class="max-w-7xl mx-auto px-4 py-12 flex-grow">
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="mb-6 p-4 bg-rose-50 border-l-4 border-rose-500 rounded">
                <p class="text-rose-700 font-semibold"><%= error %></p>
            </div>
        <% } %>

        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-4xl font-bold text-sky-700 mb-2">Tambah Stasiun Baru</h1>
            <p class="text-slate-600">Isi form di bawah untuk menambahkan stasiun baru</p>
        </div>

        <!-- Form Card -->
        <div class="bg-white rounded-xl shadow border border-slate-100 p-8">
            <%
                Station station = (Station) request.getAttribute("station");
                String action = station != null ? "update_station" : "add_station";
                String buttonText = station != null ? "Perbarui Stasiun" : "Tambah Stasiun";
            %>

            <form method="POST" action="<%= request.getContextPath() %>/admin-manage" class="space-y-6">
                <input type="hidden" name="action" value="<%= action %>">
                <% if (station != null) { %>
                    <input type="hidden" name="id" value="<%= station.getId() %>">
                <% } %>

                <!-- Kode Stasiun -->
                <div>
                    <label for="code" class="block text-sm font-semibold text-slate-700 mb-2">
                        Kode Stasiun <span class="text-rose-500">*</span>
                    </label>
                    <input
                        type="text"
                        id="code"
                        name="code"
                        placeholder="Contoh: CGK, BDG, SBY"
                        value="<%= station != null ? station.getCode() : "" %>"
                        required
                        maxlength="10"
                        class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 uppercase"
                    >
                    <p class="text-xs text-slate-500 mt-1">Kode harus unik (3-10 karakter)</p>
                </div>

                <!-- Nama Stasiun -->
                <div>
                    <label for="name" class="block text-sm font-semibold text-slate-700 mb-2">
                        Nama Stasiun <span class="text-rose-500">*</span>
                    </label>
                    <input
                        type="text"
                        id="name"
                        name="name"
                        placeholder="Contoh: Stasiun Soekarno Hatta"
                        value="<%= station != null ? station.getName() : "" %>"
                        required
                        class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500"
                    >
                </div>

                <!-- Kota -->
                <div>
                    <label for="city" class="block text-sm font-semibold text-slate-700 mb-2">
                        Kota <span class="text-rose-500">*</span>
                    </label>
                    <input
                        type="text"
                        id="city"
                        name="city"
                        placeholder="Contoh: Jakarta, Bandung, Surabaya"
                        value="<%= station != null ? station.getCity() : "" %>"
                        required
                        class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500"
                    >
                </div>

                <!-- Buttons -->
                <div class="flex gap-4 pt-6 border-t-2 border-slate-100">
                    <button
                        type="submit"
                        class="flex-1 py-3 bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg"
                    >
                        <%= buttonText %>
                    </button>
                    <a
                        href="<%= request.getContextPath() %>/admin-manage?action=manage_stations"
                        class="flex-1 py-3 border-2 border-slate-300 text-slate-700 font-bold rounded-lg hover:bg-slate-50 transition text-center"
                    >
                        Batal
                    </a>
                </div>
            </form>
        </div>

        <!-- Info Box -->
        <div class="mt-8 p-4 bg-blue-50 border-l-4 border-blue-500 rounded">
            <p class="text-sm text-blue-800">
                <strong>Catatan:</strong> Pastikan kode stasiun unik dan mudah diingat. Kode tidak dapat diubah setelah dibuat.
            </p>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

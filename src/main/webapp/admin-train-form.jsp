<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Train" %>
<%
    Train train = (Train) request.getAttribute("train");
    boolean isEdit = (train != null);
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Kereta" : "Tambah Kereta" %> - GrandStation</title>
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
                <p class="text-rose-700 font-semibold">Gagal <%= isEdit ? "mengupdate" : "menambahkan" %> kereta. Silakan coba lagi.</p>
            </div>
        <% } %>

        <div class="bg-white rounded-xl shadow border border-slate-100 p-8">
            <div class="mb-6">
                <h1 class="text-3xl font-bold text-sky-700 mb-2"><%= isEdit ? "Edit Kereta" : "Tambah Kereta Baru" %></h1>
                <p class="text-slate-600">Lengkapi informasi kereta di bawah</p>
            </div>

            <form action="<%= request.getContextPath() %>/admin-manage" method="POST">
                <input type="hidden" name="action" value="<%= isEdit ? "update_train" : "add_train" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= train.getId() %>">
                <% } %>

                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">Kode Kereta *</label>
                        <input type="text" name="code" value="<%= isEdit ? train.getCode() : "" %>"
                            required maxlength="10"
                            class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600"
                            placeholder="Contoh: ARG001">
                        <p class="mt-1 text-xs text-slate-500">Kode unik untuk identifikasi kereta</p>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">Nama Kereta *</label>
                        <input type="text" name="name" value="<%= isEdit ? train.getName() : "" %>"
                            required maxlength="100"
                            class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600"
                            placeholder="Contoh: Argo Bromo Anggrek">
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">Kelas Kereta *</label>
                        <select name="train_class" required
                            class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600">
                            <option value="">-- Pilih Kelas --</option>
                            <option value="Eksekutif" <%= isEdit && "Eksekutif".equals(train.getTrainClass()) ? "selected" : "" %>>Eksekutif</option>
                            <option value="Bisnis" <%= isEdit && "Bisnis".equals(train.getTrainClass()) ? "selected" : "" %>>Bisnis</option>
                            <option value="Ekonomi" <%= isEdit && "Ekonomi".equals(train.getTrainClass()) ? "selected" : "" %>>Ekonomi</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">Total Kursi *</label>
                        <input type="number" name="seats_total" value="<%= isEdit ? train.getSeatsTotal() : "" %>"
                            required min="1" max="1000"
                            class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:border-sky-600"
                            placeholder="Contoh: 200">
                        <p class="mt-1 text-xs text-slate-500">Jumlah kursi yang tersedia di kereta</p>
                    </div>
                </div>

                <div class="flex gap-4 mt-8">
                    <button type="submit"
                        class="flex-1 px-6 py-3 bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg">
                        <%= isEdit ? "Update Kereta" : "Tambah Kereta" %>
                    </button>
                    <a href="<%= request.getContextPath() %>/admin-manage?action=manage_trains"
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

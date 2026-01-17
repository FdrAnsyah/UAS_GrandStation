<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Booking" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pembayaran - GrandStation</title>
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

    <div class="max-w-6xl mx-auto px-4 py-8 md:py-12 flex-grow">
        <h1 class="text-3xl md:text-4xl font-bold text-sky-700 mb-6 md:mb-8">Pembayaran Tiket</h1>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="mb-6 p-4 bg-rose-50 border-l-4 border-rose-500 rounded">
                <p class="text-rose-700 font-semibold"><%= error %></p>
            </div>
        <% } %>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8">
            <!-- Payment Form -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-xl shadow-lg border border-slate-100 p-6 md:p-8">
                    <h2 class="text-xl md:text-2xl font-bold text-slate-900 mb-6">Metode Pembayaran</h2>

                    <%
                        Booking booking = (Booking) request.getAttribute("booking");
                        if (booking != null) {
                    %>
                        <form method="POST" action="<%= request.getContextPath() %>/payment" class="space-y-6">
                            <input type="hidden" name="bookingId" value="<%= booking.getId() %>">

                            <!-- Payment Methods -->
                            <div class="space-y-3">
                                <label class="flex items-start p-4 border-2 border-slate-300 rounded-lg cursor-pointer hover:bg-sky-50 transition">
                                    <input type="radio" name="method" value="TRANSFER" required class="w-5 h-5 text-sky-600 mt-1 flex-shrink-0">
                                    <div class="ml-4 flex-1">
                                        <p class="font-bold text-slate-900">Transfer Bank</p>
                                        <p class="text-sm text-slate-600">Transfer ke rekening BCA, BRI, Mandiri, atau Bank lainnya</p>
                                    </div>
                                </label>

                                <label class="flex items-start p-4 border-2 border-slate-300 rounded-lg cursor-pointer hover:bg-sky-50 transition">
                                    <input type="radio" name="method" value="CARD" required class="w-5 h-5 text-sky-600 mt-1 flex-shrink-0">
                                    <div class="ml-4 flex-1">
                                        <p class="font-bold text-slate-900">Kartu Kredit</p>
                                        <p class="text-sm text-slate-600">Visa, Mastercard, atau kartu kredit lainnya</p>
                                    </div>
                                </label>

                                <label class="flex items-start p-4 border-2 border-slate-300 rounded-lg cursor-pointer hover:bg-sky-50 transition">
                                    <input type="radio" name="method" value="E_WALLET" required class="w-5 h-5 text-sky-600 mt-1 flex-shrink-0">
                                    <div class="ml-4 flex-1">
                                        <p class="font-bold text-slate-900">E-Wallet</p>
                                        <p class="text-sm text-slate-600">GoPay, OVO, DANA, LinkAja, atau e-wallet lainnya</p>
                                    </div>
                                </label>
                            </div>

                            <!-- Submit Button -->
                            <button
                                type="submit"
                                class="w-full py-3 bg-gradient-to-r from-sky-500 to-sky-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg"
                            >
                                payment
                            </button>
                        </form>
                    <% } else { %>
                        <div class="text-center py-8">
                            <p class="text-slate-600 text-lg">Data booking tidak ditemukan. Silakan coba lagi.</p>
                            <a href="<%= request.getContextPath() %>/bookings" class="inline-block mt-4 px-6 py-2 bg-sky-600 text-white rounded-lg hover:bg-sky-700 transition">
                                Kembali ke Booking
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-xl shadow-lg border border-slate-100 p-6 md:p-8">
                    <h3 class="text-lg md:text-xl font-bold text-slate-900 mb-6">Ringkasan Pesanan</h3>

                    <%
                        if (booking != null) {
                            // Format tanggal untuk tampilan yang lebih baik
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy 'Pukul' HH:mm", new Locale("id", "ID"));
                            String tanggalBerangkat = booking.getTanggal_berangkat() != null ?
                                booking.getTanggal_berangkat().format(formatter) : "-";
                    %>
                        <div class="space-y-4 pb-6 border-b-2 border-slate-100">
                            <div>
                                <p class="text-sm text-slate-600">Kode Booking</p>
                                <p class="font-bold text-sky-700 text-base md:text-lg font-mono"><%= booking.getKodeBooking() %></p>
                            </div>
                            <div>
                                <p class="text-sm text-slate-600">Rute</p>
                                <p class="font-semibold text-slate-900 text-sm md:text-base"><%= booking.getStasiun_asal() %> - <%= booking.getStasiun_tujuan() %></p>
                            </div>
                            <div>
                                <p class="text-sm text-slate-600">Tanggal Keberangkatan</p>
                                <p class="font-semibold text-slate-900 text-sm md:text-base"><%= tanggalBerangkat %></p>
                            </div>
                            <div>
                                <p class="text-sm text-slate-600">Jumlah Penumpang</p>
                                <p class="font-semibold text-slate-900 text-sm md:text-base"><%= booking.getJumlah_penumpang() %> Orang</p>
                            </div>
                        </div>

                        <!-- Price -->
                        <div class="space-y-3 py-6">
                            <div class="flex justify-between items-center gap-2">
                                <span class="text-slate-700 text-sm">Harga Satuan</span>
                                <span class="font-semibold text-slate-900 text-sm">Rp <%= String.format("%,d", (long)booking.getHarga()) %></span>
                            </div>
                            <div class="flex justify-between items-center gap-2">
                                <span class="text-slate-700 text-sm">Jumlah Tiket</span>
                                <span class="font-semibold text-slate-900 text-sm"><%= booking.getJumlah_penumpang() %></span>
                            </div>
                            <div class="flex justify-between items-center gap-2 pt-3 border-t-2 border-slate-100">
                                <span class="font-bold text-slate-900 text-sm">Total Pembayaran</span>
                                <span class="text-xl md:text-2xl font-bold text-sky-600">Rp <%= String.format("%,d", (long)(booking.getHarga() * booking.getJumlah_penumpang())) %></span>
                            </div>
                        </div>

                        <!-- Status Badge -->
                        <div class="bg-emerald-50 border border-emerald-200 rounded-lg p-4">
                            <p class="text-sm font-semibold text-emerald-700">✓ Booking Valid</p>
                        </div>
                    <% } else { %>
                        <div class="text-center py-8 text-slate-500">
                            <p>Data booking tidak tersedia</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

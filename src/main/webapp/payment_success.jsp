<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Payment, model.Booking" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pembayaran Berhasil - GrandStation</title>
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

    <div class="flex-grow flex items-center justify-center px-4 py-12">
        <div class="w-full max-w-2xl">
            <%
                Payment payment = (Payment) request.getAttribute("payment");
                Booking booking = (Booking) request.getAttribute("booking");
                String success = (String) request.getAttribute("success");

                if (payment != null && booking != null) {
            %>
                <!-- Success Card -->
                <div class="bg-white rounded-2xl shadow-2xl border border-slate-100 overflow-hidden">
                    <!-- Success Header -->
                    <div class="bg-gradient-to-r from-emerald-500 to-emerald-600 p-12 text-center">
                        <div class="w-20 h-20 rounded-full bg-white flex items-center justify-center mx-auto mb-4">
                            <svg class="w-10 h-10 text-emerald-600" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <h1 class="text-3xl font-bold text-white mb-2">Pembayaran Berhasil!</h1>
                        <p class="text-emerald-100">Tiket Anda sudah siap</p>
                    </div>

                    <!-- Content -->
                    <div class="p-8">
                        <!-- Payment Code -->
                        <div class="text-center mb-8 p-4 bg-slate-50 rounded-lg border-2 border-emerald-200">
                            <p class="text-sm text-slate-600 mb-2">Kode Pembayaran</p>
                            <p class="text-2xl font-bold text-emerald-700 font-mono"><%= payment.getPaymentCode() %></p>
                            <p class="text-xs text-slate-500 mt-2">Simpan kode ini untuk referensi</p>
                        </div>

                        <!-- Two Column Layout -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
                            <!-- Booking Details -->
                            <div>
                                <h3 class="font-bold text-slate-900 mb-4 text-sky-700">Detail Booking</h3>
                                <div class="space-y-3 text-sm">
                                    <div>
                                        <p class="text-slate-600">Kode Booking</p>
                                        <p class="font-bold text-slate-900"><%= booking.getKodeBooking() %></p>
                                    </div>
                                    <div>
                                        <p class="text-slate-600">Status</p>
                                        <p class="font-bold text-emerald-600">TERKONFIRMASI</p>
                                    </div>
                                    <div>
                                        <p class="text-slate-600">Penumpang</p>
                                        <p class="font-bold text-slate-900"><%= booking.getNama_pemesan() %></p>
                                    </div>
                                    <div>
                                        <p class="text-slate-600">Jumlah Tiket</p>
                                        <p class="font-bold text-slate-900"><%= booking.getJumlah_penumpang() %> Orang</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Details -->
                            <div>
                                <h3 class="font-bold text-slate-900 mb-4 text-sky-700">Detail Pembayaran</h3>
                                <div class="space-y-3 text-sm">
                                    <div>
                                        <p class="text-slate-600">Metode Pembayaran</p>
                                        <p class="font-bold text-slate-900">
                                            <%
                                                String method = payment.getMethod();
                                                if ("TRANSFER".equals(method)) {
                                                    out.print("Transfer Bank");
                                                } else if ("CARD".equals(method)) {
                                                    out.print("Kartu Kredit");
                                                } else if ("E_WALLET".equals(method)) {
                                                    out.print("E-Wallet");
                                                }
                                            %>
                                        </p>
                                    </div>
                                    <div>
                                        <p class="text-slate-600">Status Pembayaran</p>
                                        <p class="font-bold text-emerald-600"><%= payment.getStatus() %></p>
                                    </div>
                                    <div>
                                        <p class="text-slate-600">Waktu Pembayaran</p>
                                        <p class="font-bold text-slate-900"><%= payment.getCreatedAt() %></p>
                                    </div>
                                    <div>
                                        <p class="text-slate-600">Total Bayar</p>
                                        <p class="font-bold text-lg text-sky-700">Rp <%= String.format("%,d", payment.getAmount()) %></p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Divider -->
                        <div class="border-t-2 border-slate-100 my-8"></div>

                        <!-- Journey Info -->
                        <div class="bg-slate-50 rounded-lg p-6 mb-8">
                            <h3 class="font-bold text-slate-900 mb-4">Rute Perjalanan</h3>
                            <div class="flex items-center justify-between">
                                <div class="text-center">
                                    <p class="text-sm text-slate-600 mb-2">Berangkat dari</p>
                                    <p class="font-bold text-lg text-slate-900"><%= booking.getStasiun_asal() %></p>
                                    <p class="text-xs text-slate-600 mt-1"><%= booking.getTanggal_berangkat() %></p>
                                </div>
                                <div class="flex-1 mx-4 flex items-center justify-center">
                                    <svg class="w-6 h-6 text-sky-600" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <div class="text-center">
                                    <p class="text-sm text-slate-600 mb-2">Tujuan</p>
                                    <p class="font-bold text-lg text-slate-900"><%= booking.getStasiun_tujuan() %></p>
                                    <p class="text-xs text-slate-600 mt-1"><%= booking.getTanggal_sampai() %></p>
                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <a href="<%= request.getContextPath() %>/bookings" class="px-6 py-3 border-2 border-sky-600 text-sky-700 font-bold rounded-lg hover:bg-sky-50 transition text-center">
                                Lihat Pesanan Saya
                            </a>
                            <a href="<%= request.getContextPath() %>/index.jsp?halaman=home" class="px-6 py-3 bg-gradient-to-r from-sky-500 to-sky-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition text-center">
                                Pesan Tiket Lagi
                            </a>
                        </div>
                    </div>

                    <!-- Footer Info -->
                    <div class="px-8 py-4 bg-emerald-50 border-t border-emerald-100">
                        <p class="text-sm text-emerald-800 text-center">
                            ✓ Tiket digital telah dikirim ke email Anda
                        </p>
                        <p class="text-xs text-emerald-700 text-center mt-1">
                            Periksa folder spam jika tidak menerima email
                        </p>
                    </div>
                </div>

                <!-- Additional Info -->
                <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="bg-white rounded-lg p-6 shadow border border-slate-100">
                        <p class="text-sm font-semibold text-slate-900 mb-2">Hubungi Customer Service</p>
                        <p class="text-xs text-slate-600">Tersedia 24/7 untuk membantu Anda</p>
                    </div>
                    <div class="bg-white rounded-lg p-6 shadow border border-slate-100">
                        <p class="text-sm font-semibold text-slate-900 mb-2">Tiket Digital</p>
                        <p class="text-xs text-slate-600">Tunjukkan di loket saat check-in</p>
                    </div>
                    <div class="bg-white rounded-lg p-6 shadow border border-slate-100">
                        <p class="text-sm font-semibold text-slate-900 mb-2">💳 Transaksi Aman</p>
                        <p class="text-xs text-slate-600">Terenkripsi dan terlindungi</p>
                    </div>
                </div>
            <% } else { %>
                <div class="bg-white rounded-2xl shadow-lg border border-slate-100 p-12 text-center">
                    <p class="text-slate-700">Data pembayaran tidak ditemukan.</p>
                    <a href="<%= request.getContextPath() %>/index.jsp?halaman=home" class="mt-4 inline-block px-6 py-3 bg-gradient-to-r from-sky-500 to-sky-700 text-white font-bold rounded-lg">
                        Kembali ke Beranda
                    </a>
                </div>
            <% } %>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

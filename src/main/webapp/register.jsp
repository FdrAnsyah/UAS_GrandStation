<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - GrandStation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Space Grotesk', sans-serif;
        }
        .input-focus {
            transition: all 0.3s ease;
        }
        .input-focus:focus {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.18);
        }
    </style>
</head>
<body class="bg-slate-50 flex flex-col min-h-screen">
    <!-- Navbar -->
    <nav class="bg-white shadow-md border-b-2 border-sky-700 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-4">
                <div class="flex items-center gap-2">
                    <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-sky-500 to-sky-700 text-white flex items-center justify-center font-bold text-lg">
                        GS
                    </div>
                    <div>
                        <div class="font-bold text-sky-700 text-lg">GrandStation</div>
                        <div class="text-xs text-slate-500">Pesan Kereta Cerdas</div>
                    </div>
                </div>
                <div class="hidden md:flex items-center gap-6">
                    <a href="<%= request.getContextPath() %>/index.jsp?halaman=home" class="text-slate-700 hover:text-sky-700 font-semibold transition">Home</a>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="px-6 py-2 bg-gradient-to-r from-sky-500 to-sky-700 text-white rounded-lg font-bold hover:-translate-y-0.5 transition">
                        Masuk
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Register Form Container -->
    <div class="flex-grow flex items-center justify-center px-4 py-12">
        <div class="w-full max-w-2xl">
            <!-- Card -->
            <div class="bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden">
                <!-- Header Gradient -->
                <div class="p-8 text-center bg-gradient-to-br from-sky-700 via-sky-600 to-slate-900">
                    <h1 class="text-4xl font-bold text-white mb-2">Daftar Akun</h1>
                    <p class="text-slate-100 text-sm">Buat akun untuk memesan tiket keretamu</p>
                </div>

                <!-- Form Body -->
                <div class="p-8">
                    <!-- Error Alert -->
                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) { %>
                        <div class="mb-6 p-4 bg-rose-50 border-l-4 border-rose-500 rounded">
                            <p class="text-rose-700 font-semibold text-sm"><%= error %></p>
                        </div>
                    <% } %>

                    <!-- Success Alert -->
                    <% String success = (String) request.getAttribute("success"); %>
                    <% if (success != null) { %>
                        <div class="mb-6 p-4 bg-emerald-50 border-l-4 border-emerald-500 rounded">
                            <p class="text-emerald-700 font-semibold text-sm"><%= success %></p>
                        </div>
                    <% } %>

                    <form method="POST" action="<%= request.getContextPath() %>/register" class="space-y-5">
                        <!-- Email Field -->
                        <div>
                            <label for="email" class="block text-sm font-semibold text-slate-700 mb-2">
                                Email
                            </label>
                            <input
                                type="email"
                                id="email"
                                name="email"
                                placeholder="nama@email.com"
                                required
                                class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 input-focus"
                            >
                        </div>

                        <!-- Full Name Field -->
                        <div>
                            <label for="name" class="block text-sm font-semibold text-slate-700 mb-2">
                                Nama Lengkap
                            </label>
                            <input
                                type="text"
                                id="name"
                                name="name"
                                placeholder="John Doe"
                                required
                                class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 input-focus"
                            >
                        </div>

                        <!-- Phone Field -->
                        <div>
                            <label for="phone" class="block text-sm font-semibold text-slate-700 mb-2">
                                Nomor Telepon
                            </label>
                            <input
                                type="tel"
                                id="phone"
                                name="phone"
                                placeholder="08xxxxxxxxxx"
                                required
                                class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 input-focus"
                            >
                        </div>

                        <!-- Address Field -->
                        <div>
                            <label for="address" class="block text-sm font-semibold text-slate-700 mb-2">
                                Alamat
                            </label>
                            <textarea
                                id="address"
                                name="address"
                                rows="3"
                                placeholder="Jl. Gatot Subroto No. 1..."
                                required
                                class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 input-focus resize-none"
                            ></textarea>
                        </div>

                        <!-- Password Field -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label for="password" class="block text-sm font-semibold text-slate-700 mb-2">
                                    Password
                                </label>
                                <input
                                    type="password"
                                    id="password"
                                    name="password"
                                    placeholder="Minimal 6 karakter"
                                    required
                                    class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 input-focus"
                                >
                            </div>

                            <!-- Confirm Password Field -->
                            <div>
                                <label for="confirmPassword" class="block text-sm font-semibold text-slate-700 mb-2">
                                    Konfirmasi Password
                                </label>
                                <input
                                    type="password"
                                    id="confirmPassword"
                                    name="confirmPassword"
                                    placeholder="Masukkan ulang password"
                                    required
                                    class="w-full px-4 py-3 border-2 border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 input-focus"
                                >
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <button
                            type="submit"
                            class="w-full py-3 bg-gradient-to-r from-sky-500 to-sky-700 text-white font-bold rounded-lg hover:-translate-y-0.5 transition shadow-lg mt-6"
                        >
                            Daftar Sekarang
                        </button>
                    </form>

                    <!-- Divider -->
                    <div class="flex items-center gap-4 my-6">
                        <div class="flex-1 h-px bg-slate-200"></div>
                        <span class="text-sm text-slate-500">atau</span>
                        <div class="flex-1 h-px bg-slate-200"></div>
                    </div>

                    <!-- Login Link -->
                    <p class="text-center text-slate-600">
                        Sudah punya akun?
                        <a href="<%= request.getContextPath() %>/login" class="text-sky-600 font-bold hover:text-sky-700">
                            Masuk di sini
                        </a>
                    </p>
                </div>

                <!-- Footer Info -->
                <div class="px-8 py-4 bg-slate-50 border-t border-slate-100">
                    <p class="text-xs text-slate-500 text-center">
                        Data Anda aman dan terenkripsi
                    </p>
                </div>
            </div>

            <!-- Footer -->
            <div class="mt-8 text-center">
                <p class="text-slate-600 text-sm">
                    GrandStation © 2025 | Platform pemesanan kereta terpercaya
                </p>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

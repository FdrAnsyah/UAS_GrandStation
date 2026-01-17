<!doctype html>
<html lang="id">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Kontak - GrandStation</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
        <script>
            window.tailwind = window.tailwind || {};
            window.tailwind.config = {
                theme: {
                    extend: {
                        fontFamily: {
                            sans: ['"Space Grotesk"', 'ui-sans-serif', 'system-ui'],
                        }
                    }
                }
            }
        </script>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-slate-50 text-slate-900 flex flex-col min-h-screen">
        <%@ include file="menu.jsp" %>
        <main class="max-w-6xl mx-auto px-4 py-8 flex-grow w-full">
            <div class="bg-gradient-to-b from-slate-50 to-white rounded-2xl border border-slate-200 p-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6">
        <!-- Header -->
        <div class="text-center mb-12">
            <span class="inline-block px-3 py-1 rounded-full bg-sky-100 text-sky-700 text-xs font-bold uppercase tracking-wide mb-3">Hubungi Kami</span>
            <h1 class="text-5xl font-extrabold text-slate-900 mb-4">
                Kirim <span class="bg-gradient-to-r from-sky-600 to-blue-600 bg-clip-text text-transparent">Pesan Anda</span>
            </h1>
            <p class="text-xl text-slate-600 max-w-2xl mx-auto">
                Tim customer service kami siap membantu Anda 24/7. Kirim pesan dan kami akan merespon secepatnya.
            </p>
        </div>

        <!-- Contact Form -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-lg p-8 sm:p-12">
            <h2 class="text-2xl font-bold text-slate-900 mb-8">Formulir Kontak</h2>

            <% String successMsg = (String) request.getAttribute("successMsg"); %>
            <% String errorMsg = (String) request.getAttribute("errorMsg"); %>

            <% if (successMsg != null) { %>
                <div class="mb-8 rounded-lg border border-emerald-300 bg-emerald-50 px-6 py-4">
                    <p class="text-sm font-medium text-emerald-800"><%= successMsg %></p>
                </div>
            <% } %>

            <% if (errorMsg != null) { %>
                <div class="mb-8 rounded-lg border border-rose-300 bg-rose-50 px-6 py-4">
                    <p class="text-sm font-medium text-rose-800"><%= errorMsg %></p>
                </div>
            <% } %>

            <form method="POST" action="${pageContext.request.contextPath}/contact" class="space-y-6">
                <!-- Name Field -->
                <div>
                    <label class="block text-sm font-semibold text-slate-900 mb-2">
                        Nama Lengkap
                    </label>
                    <input type="text" name="name" required
                           class="w-full rounded-lg border border-slate-300 bg-white text-slate-900 px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent transition-all"
                           placeholder="Masukkan nama Anda" />
                </div>

                <!-- Email Field -->
                <div>
                    <label class="block text-sm font-semibold text-slate-900 mb-2">
                        Email
                    </label>
                    <input type="email" name="email" required
                           class="w-full rounded-lg border border-slate-300 bg-white text-slate-900 px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent transition-all"
                           placeholder="email@example.com" />
                </div>

                <!-- Phone Field -->
                <div>
                    <label class="block text-sm font-semibold text-slate-900 mb-2">
                        Nomor Telepon
                    </label>
                    <input type="tel" name="phone" required
                           class="w-full rounded-lg border border-slate-300 bg-white text-slate-900 px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent transition-all"
                           placeholder="+62 xxx xxxx xxxx" />
                </div>

                <!-- Message Field -->
                <div>
                    <label class="block text-sm font-semibold text-slate-900 mb-2">
                        Pesan
                    </label>
                    <textarea name="message" rows="5" required
                              class="w-full rounded-lg border border-slate-300 bg-white text-slate-900 px-4 py-2.5 text-sm outline-none focus:ring-2 focus:ring-sky-500 focus:border-transparent transition-all resize-none"
                              placeholder="Tulis pesan Anda di sini..."></textarea>
                </div>

                <!-- Submit Button -->
                <button type="submit"
                        class="w-full rounded-lg bg-blue-600 text-white font-semibold px-6 py-3 text-sm hover:bg-blue-700 transition-colors duration-200">
                    Kirim Pesan
                </button>
            </form>
            </div>
        </div>
        </main>
        <%@ include file="footer.jsp" %>
    </body>
</html>

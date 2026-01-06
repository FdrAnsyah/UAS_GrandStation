<%@ page contentType="text/html; charset=UTF-8" %>


<header class="sticky top-0 z-40 bg-white shadow-md border-b border-slate-200">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-3 flex items-center justify-between gap-4">
        <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-3 group">
            <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-sky-500 to-blue-700 text-white flex items-center justify-center font-bold text-xs shadow-lg transform group-hover:scale-110 transition-transform">GS</div>
            <div>
                <div class="font-bold text-slate-900 group-hover:text-sky-700 transition-colors text-sm sm:text-base">GrandStation</div>
                <div class="text-xs text-sky-600">Cepat dalam perjalanan</div>
            </div>
        </a>

        <button id="nav-toggle" class="md:hidden inline-flex items-center justify-center p-2 rounded-lg border-2 border-sky-600 text-sky-700 hover:bg-sky-50" aria-label="Toggle navigation">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M4 7h16M4 12h16M4 17h16" /></svg>
        </button>

        <nav class="hidden md:flex items-center gap-1 text-sm font-medium">
            <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700 transition" href="${pageContext.request.contextPath}/index.jsp?halaman=home">Beranda</a>
            <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700 transition" href="${pageContext.request.contextPath}/contact.jsp">Kontak</a>
            <%
                Object navUser = session.getAttribute("user");
                String navUserRole = (String) session.getAttribute("userRole");
                if (navUser != null) {
                    if ("admin".equals(navUserRole)) {
            %>
                <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700 transition" href="${pageContext.request.contextPath}/admin-bookings">Approve Pesanan</a>
            <%
                    } else {
            %>
                <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700 transition" href="${pageContext.request.contextPath}/bookings">Pesanan Saya</a>
            <%
                    }
                }
            %>
        </nav>

        <div class="hidden md:flex items-center gap-2 text-sm">
            <%
                Object user = session.getAttribute("user");
                String userName = (String) session.getAttribute("userName");
                String userRole = (String) session.getAttribute("userRole");
            %>
            <% if (user != null) { %>
                <span class="px-3 py-2 text-slate-700 font-semibold">Halo, <%= userName %>!</span>
                <% if ("admin".equals(userRole)) { %>
                    <a class="px-3 py-2 rounded-lg border border-sky-600 text-sky-700 hover:bg-sky-50 font-semibold transition" href="${pageContext.request.contextPath}/index.jsp?halaman=admin">Dashboard Admin</a>
                <% } %>
                <a class="px-4 py-2 rounded-lg bg-gradient-to-r from-sky-500 to-blue-700 text-white font-semibold shadow-lg hover:shadow-blue-600/40 hover:-translate-y-0.5 transition-all text-sm" href="${pageContext.request.contextPath}/logout">Logout</a>
            <% } else { %>
                <a class="px-4 py-2 rounded-lg border border-sky-600 text-sky-700 hover:bg-sky-50 font-semibold transition" href="${pageContext.request.contextPath}/login">Login</a>
                <a class="px-4 py-2 rounded-lg bg-gradient-to-r from-sky-500 to-blue-700 text-white font-semibold shadow-lg hover:shadow-blue-600/40 hover:-translate-y-0.5 transition-all text-sm" href="${pageContext.request.contextPath}/register.jsp">Register</a>
            <% } %>
        </div>
    </div>

    <div id="nav-panel" class="md:hidden hidden border-t border-slate-200 bg-white shadow-lg">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-3 grid grid-cols-2 gap-3 text-sm font-medium">
            <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700 transition" href="${pageContext.request.contextPath}/index.jsp?halaman=home">Beranda</a>
            <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700 transition" href="${pageContext.request.contextPath}/contact.jsp">Kontak</a>
            <%
                Object mobileUser = session.getAttribute("user");
                String mobileUserRole = (String) session.getAttribute("userRole");
                if (mobileUser != null) {
                    if ("admin".equals(mobileUserRole)) {
            %>
                <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700" href="${pageContext.request.contextPath}/admin-bookings">Approve Pesanan</a>
            <%
                    } else {
            %>
                <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700" href="${pageContext.request.contextPath}/bookings">Pesanan Saya</a>
            <%
                    }
                }
            %>
            <%
                Object user3 = session.getAttribute("user");
                String userRole3 = (String) session.getAttribute("userRole");
                if (user3 != null && "admin".equals(userRole3)) {
            %>
                <a class="col-span-2 px-3 py-2 rounded-lg bg-amber-50 border border-amber-200 text-amber-700 font-semibold" href="${pageContext.request.contextPath}/index.jsp?halaman=admin">Dashboard Admin</a>
            <% } %>
            <%
                Object user2 = session.getAttribute("user");
                String userName2 = (String) session.getAttribute("userName");
            %>
            <% if (user2 != null) { %>
                <span class="col-span-2 px-3 py-2 text-slate-700 font-semibold text-xs">Halo, <%= userName2 %>!</span>
                    <a class="col-span-2 px-3 py-2 rounded-lg bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold shadow-lg" href="${pageContext.request.contextPath}/logout">Logout</a>
            <% } else { %>
                <a class="px-3 py-2 rounded-lg hover:bg-sky-50 text-slate-700" href="${pageContext.request.contextPath}/login">Login</a>
                <a class="px-3 py-2 rounded-lg bg-gradient-to-r from-sky-500 to-blue-700 text-white font-bold shadow-lg" href="${pageContext.request.contextPath}/register.jsp">Register</a>
            <% } %>
        </div>
    </div>
</header>
<script>
    (function() {
        const toggle = document.getElementById('nav-toggle');
        const panel = document.getElementById('nav-panel');
        if (!toggle || !panel) return;
        toggle.addEventListener('click', function() {
            panel.classList.toggle('hidden');
        });
    })();
</script>

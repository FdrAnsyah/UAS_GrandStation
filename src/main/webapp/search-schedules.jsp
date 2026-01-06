<%@page import="dao.StationDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Station"%>

<%
    String err = (String) request.getAttribute("error");
    Object currentUser = session.getAttribute("user");
    boolean loggedIn = currentUser != null;

    StationDAO stationDAO = new StationDAO();
    List<Station> stations = stationDAO.getAll();
%>

<div class="max-w-3xl mx-auto">
    <div class="mb-8">
        <h1 class="text-4xl font-extrabold text-slate-900 mb-4">
            Cari <span class="bg-gradient-to-r from-sky-600 to-blue-600 bg-clip-text text-transparent">Jadwal Kereta</span>
        </h1>
        <p class="text-lg text-slate-600">
            Temukan jadwal kereta yang sesuai dengan rencana perjalanan Anda.
        </p>
    </div>

    <% if (err != null) { %>
        <div class="mb-6 rounded-2xl border-2 border-rose-300 bg-rose-50 px-6 py-4">
            <p class="font-semibold text-rose-800"><%= err %></p>
        </div>
    <% } %>

    <% if (!loggedIn) { %>
        <div class="mb-8 rounded-2xl border-2 border-amber-400 bg-amber-50 px-6 py-5">
            <div class="mb-4">
                <p class="font-semibold text-amber-900">Login Diperlukan</p>
                <p class="text-sm text-amber-800 mt-1">Silakan login terlebih dahulu untuk mengakses fitur pencarian jadwal kereta.</p>
            </div>
            <div class="flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/login"
                    class="flex-1 px-5 py-3 rounded-xl bg-sky-600 text-white font-bold text-center hover:bg-sky-700 transition-all">
                    Login Sekarang
                </a>
                <a href="${pageContext.request.contextPath}/register.jsp"
                    class="flex-1 px-5 py-3 rounded-xl border-2 border-sky-600 text-sky-700 font-bold text-center hover:bg-sky-50 transition-all">
                    Buat Akun
                </a>
            </div>
        </div>
    <% } %>

    <div class="bg-white rounded-3xl border-2 border-slate-200 shadow-xl p-8">
        <form method="get" action="${pageContext.request.contextPath}/search" class="space-y-6">
            <fieldset <%= loggedIn ? "" : "disabled" %> class="space-y-6 <%= loggedIn ? "" : "opacity-50 cursor-not-allowed" %>">
                <div class="grid sm:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-bold text-slate-900 mb-3">
                            Stasiun Asal
                        </label>
                        <select name="originId" required
                                class="w-full rounded-xl border-2 border-slate-300 bg-white text-slate-900 px-5 py-3.5 outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 font-medium transition-all">
                            <option value="" disabled selected>Pilih stasiun keberangkatan</option>
                            <% for (Station s : stations) { %>
                                <option value="<%= s.getId() %>"><%= s.getLabel() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-900 mb-3">
                            Stasiun Tujuan
                        </label>
                        <select name="destinationId" required
                                class="w-full rounded-xl border-2 border-slate-300 bg-white text-slate-900 px-5 py-3.5 outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 font-medium transition-all">
                            <option value="" disabled selected>Pilih stasiun tujuan</option>
                            <% for (Station s : stations) { %>
                                <option value="<%= s.getId() %>"><%= s.getLabel() %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-900 mb-3">
                        Tanggal Keberangkatan
                    </label>
                    <input type="date" name="travelDate" required
                           class="w-full rounded-xl border-2 border-slate-300 bg-white text-slate-900 px-5 py-3.5 outline-none focus:ring-2 focus:ring-sky-500 focus:border-sky-500 font-medium transition-all" />
                </div>

                <button type="submit"
                        class="w-full rounded-2xl bg-gradient-to-r from-blue-500 via-blue-600 to-blue-700 text-white font-bold text-lg px-6 py-4 hover:shadow-2xl hover:scale-[1.02] transition-all duration-300">
                    Cari Jadwal Kereta
                </button>
            </fieldset>
        </form>
    </div>

    <div class="mt-8 grid sm:grid-cols-3 gap-4 text-center">
        <div class="p-6 rounded-2xl bg-gradient-to-br from-blue-50 to-blue-100 border border-blue-200">
            <div class="text-3xl font-bold text-blue-700 mb-1">320</div>
            <div class="text-sm text-blue-600">km/jam Max</div>
        </div>
        <div class="p-6 rounded-2xl bg-gradient-to-br from-emerald-50 to-emerald-100 border border-emerald-200">
            <div class="text-3xl font-bold text-emerald-700 mb-1">24/7</div>
            <div class="text-sm text-emerald-600">Service</div>
        </div>
        <div class="p-6 rounded-2xl bg-gradient-to-br from-purple-50 to-purple-100 border border-purple-200">
            <div class="text-3xl font-bold text-purple-700 mb-1">100%</div>
            <div class="text-sm text-purple-600">Aman</div>
        </div>
    </div>
</div>

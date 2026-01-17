<%-- Gallery List --%>
<%@ page import="java.util.*, model.*" %>
<%
    List<GalleryItem> galleries = (List<GalleryItem>) request.getAttribute("galleries");
%>

<div class="space-y-6">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
            <div>
                <h3 class="text-lg font-bold text-gray-900">Daftar Galeri</h3>
                <p class="text-sm text-gray-600 mt-1">Kelola foto stasiun dan kereta</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin-manage?action=add_gallery_form"
               class="px-4 py-2 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold hover:shadow-lg transition w-full sm:w-auto text-center">
                + Tambah Foto
            </a>
        </div>

        <% if (galleries == null || galleries.isEmpty()) { %>
            <div class="text-center py-10">
                <p class="text-gray-600">Belum ada foto terdaftar</p>
            </div>
        <% } else { %>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                <% for (GalleryItem g : galleries) { %>
                    <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
                        <div class="h-40 bg-gray-200 overflow-hidden">
                            <img src="<%= g.getImageUrl() %>" alt="<%= g.getTitle() %>" class="w-full h-full object-cover">
                        </div>
                        <div class="p-4">
                            <h4 class="font-bold text-gray-900 mb-1"><%= g.getTitle() %></h4>
                            <p class="text-sm text-gray-600 mb-2"><%= g.getCategory() %></p>
                            <p class="text-xs text-gray-500 mb-3 line-clamp-2"><%= g.getDescription() %></p>
                            <div class="flex flex-wrap gap-2">
                                <% if (g.isFeatured()) { %>
                                    <span class="px-2 py-1 text-xs bg-sky-100 text-sky-700 rounded">Featured</span>
                                <% } %>
                                <div class="flex gap-2 ml-auto">
                                    <a href="<%= request.getContextPath() %>/admin-manage?action=edit_gallery&id=<%= g.getId() %>" class="px-3 py-1 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200 transition">Edit</a>
                                    <a href="<%= request.getContextPath() %>/admin-manage?action=delete_gallery&id=<%= g.getId() %>" onclick="return confirm('Yakin?')" class="px-3 py-1 text-xs bg-red-100 text-red-700 rounded hover:bg-red-200 transition">Hapus</a>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</div>
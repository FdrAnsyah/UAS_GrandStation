<%-- Gallery Form (Add/Edit) --%>
<%@ page import="model.*" %>
<%
    GalleryItem gallery = (GalleryItem) request.getAttribute("galleryItem");
    boolean isEdit = gallery != null;
%>

<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-4 sm:p-8">
        <h3 class="text-xl sm:text-2xl font-bold text-gray-900 mb-6">
            <%= isEdit ? "Edit Foto" : "Tambah Foto Baru" %>
        </h3>

        <form method="POST" action="<%= request.getContextPath() %>/admin-manage" class="space-y-6">
            <input type="hidden" name="action" value="<%= isEdit ? "update_gallery" : "add_gallery" %>">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= gallery.getId() %>">
            <% } %>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Judul</label>
                <input type="text" name="title" placeholder="Contoh: Stasiun Gambir Malam Hari" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? gallery.getTitle() : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Kategori</label>
                <input type="text" name="category" placeholder="Contoh: Stasiun, Kereta" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? gallery.getCategory() : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">URL Gambar</label>
                <input type="text" name="image_url" placeholder="Contoh: https://example.com/image.jpg" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                       value="<%= isEdit ? gallery.getImageUrl() : "" %>" required>
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Deskripsi</label>
                <textarea name="description" placeholder="Deskripsi foto..." class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent" rows="4"><%= isEdit ? gallery.getDescription() : "" %></textarea>
            </div>

            <div>
                <label class="flex items-center">
                    <input type="checkbox" name="featured" <%= isEdit && gallery.isFeatured() ? "checked" : "" %> class="w-4 h-4 rounded">
                    <span class="ml-2 text-sm font-semibold text-gray-900">Jadikan Featured</span>
                </label>
            </div>

            <div class="flex gap-3 pt-4">
                <button type="submit" class="px-6 py-3 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold hover:shadow-lg transition flex-1">
                    <%= isEdit ? "Update Foto" : "Tambah Foto" %>
                </button>
                <a href="<%= request.getContextPath() %>/admin-manage?action=manage_gallery" class="px-6 py-3 rounded-lg border border-gray-200 text-gray-700 font-semibold hover:bg-gray-50 transition flex-1 text-center">
                    Batal
                </a>
            </div>
        </form>
    </div>
</div>
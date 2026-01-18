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
                <textarea name="description" placeholder="Deskripsikan foto ini..." class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-red-500 focus:border-transparent" rows="3"><%= isEdit ? gallery.getDescription() : "" %></textarea>
            </div>

            <!-- Preview Gambar -->
            <div>
                <label class="block text-sm font-semibold text-gray-900 mb-2">Pratinjau Gambar</label>
                <div class="border-2 border-dashed border-gray-300 rounded-xl bg-gray-50 p-4 min-h-[200px] flex items-center justify-center">
                    <div id="imagePreview" class="w-full flex flex-col items-center">
                        <% if (isEdit && gallery.getImageUrl() != null && !gallery.getImageUrl().isEmpty()) { %>
                            <img src="<%= gallery.getImageUrl() %>" alt="Pratinjau Gambar" class="max-h-64 rounded-lg shadow-md object-contain" onerror="this.style.display='none'; document.getElementById('noImagePreview').style.display='block';">
                        <% } else { %>
                            <div id="noImagePreview" class="text-center text-gray-500">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mx-auto mb-3 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                                <p class="text-sm">Pratinjau gambar akan muncul di sini</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="flex items-center">
                <input type="checkbox" name="featured" id="featuredCheckbox" <%= isEdit && gallery.isFeatured() ? "checked" : "" %> class="w-4 h-4 text-red-600 rounded">
                <label for="featuredCheckbox" class="ml-2 text-sm font-semibold text-gray-900">Jadikan Featured</label>
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

<script>
    // Update preview when image URL changes
    document.addEventListener('DOMContentLoaded', function() {
        const imageUrlInput = document.querySelector('input[name="image_url"]');
        const imagePreview = document.getElementById('imagePreview');
        const noImagePreview = document.getElementById('noImagePreview');

        if (imageUrlInput) {
            imageUrlInput.addEventListener('input', function() {
                const url = this.value.trim();
                if (url) {
                    // Remove existing image if any
                    const existingImg = imagePreview.querySelector('img');
                    if (existingImg) {
                        existingImg.remove();
                    }

                    // Create new image element
                    const img = document.createElement('img');
                    img.src = url;
                    img.alt = 'Pratinjau Gambar';
                    img.className = 'max-h-64 rounded-lg shadow-md object-contain';
                    img.onerror = function() {
                        this.remove();
                        noImagePreview.style.display = 'block';
                    };
                    img.onload = function() {
                        noImagePreview.style.display = 'none';
                        imagePreview.appendChild(img);
                    };

                    // Only append if image loads successfully
                    if (noImagePreview) {
                        noImagePreview.style.display = 'none';
                    }
                } else {
                    // Remove image and show placeholder
                    const existingImg = imagePreview.querySelector('img');
                    if (existingImg) {
                        existingImg.remove();
                    }
                    if (noImagePreview) {
                        noImagePreview.style.display = 'block';
                    }
                }
            });
        }
    });
</script>
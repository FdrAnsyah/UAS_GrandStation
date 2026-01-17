<%@page import="dao.GalleryDAO"%>
<%@page import="model.GalleryItem"%>
<%@page import="java.util.List"%>
<%
    GalleryDAO galleryDAO = new GalleryDAO();
    List<GalleryItem> featured = galleryDAO.getFeatured(3);
    List<GalleryItem> items = galleryDAO.getAll();
%>

<section class="w-full bg-white border-b border-slate-200 py-6 sm:py-8 md:py-10 lg:py-12">
    <div class="max-w-6xl mx-auto px-3 sm:px-4 md:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 sm:gap-6 md:gap-8 items-center">
            <div>
                <h1 class="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-bold text-slate-900 mb-3 sm:mb-4 md:mb-5 leading-tight">Stasiun dan armada GrandStation.</h1>
                <div class="flex flex-wrap gap-2 sm:gap-3">
                    <span class="inline-block px-2.5 sm:px-3 py-1 sm:py-1.5 rounded-full bg-sky-50 border border-sky-200 text-xs sm:text-sm font-semibold text-sky-700">Featured</span>
                    <span class="inline-block px-2.5 sm:px-3 py-1 sm:py-1.5 rounded-full bg-slate-100 border border-slate-200 text-xs sm:text-sm font-semibold text-slate-700">Stasiun</span>
                    <span class="inline-block px-2.5 sm:px-3 py-1 sm:py-1.5 rounded-full bg-blue-50 border border-blue-200 text-xs sm:text-sm font-semibold text-blue-700">Kereta</span>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="py-8 sm:py-10 md:py-12 lg:py-14 bg-white">
    <div class="max-w-6xl mx-auto px-3 sm:px-4 md:px-6 lg:px-8">
        <div class="mb-6 sm:mb-8 md:mb-10">
            <h2 class="text-xl sm:text-2xl md:text-3xl font-bold text-slate-900 mb-2 sm:mb-3">Featured picks</h2>
        </div>
        <% if (featured == null || featured.isEmpty()) { %>
            <div class="p-4 sm:p-6 bg-sky-50 border border-sky-200 rounded-lg text-sky-900 text-sm sm:text-base">
                Belum ada item featured. Tandai salah satu item di dashboard admin.
            </div>
        <% } else { %>
            <div id="galleryCarousel" class="carousel slide rounded-lg sm:rounded-xl md:rounded-2xl overflow-hidden shadow-md sm:shadow-lg" data-bs-ride="carousel">
                <div class="carousel-indicators relative z-20 bottom-4 sm:bottom-5 md:bottom-6">
                    <% for (int i = 0; i < featured.size(); i++) { %>
                        <button type="button" data-bs-target="#galleryCarousel" data-bs-slide-to="<%= i %>" class="<%= i==0?"active":"" %> w-2.5 h-2.5 sm:w-3 sm:h-3 rounded-full <%= i==0?"bg-white":"bg-white/50" %> hover:bg-white transition-all" aria-current="<%= i==0?"true":"false" %>" aria-label="Slide <%= i+1 %>"></button>
                    <% } %>
                </div>

                <!-- Carousel Inner -->
                <div class="carousel-inner">
                    <% for (int i = 0; i < featured.size(); i++) {
                        GalleryItem g = featured.get(i);
                    %>
                        <div class="carousel-item <%= i==0?"active":"" %>">
                            <img src="<%= g.getImageUrl() %>" class="w-full h-auto object-cover" alt="<%= g.getTitle() %>" style="min-height: 300px; max-height: 500px;" loading="lazy">
                            <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
                            <div class="absolute bottom-0 left-0 right-0 p-4 sm:p-5 md:p-6 text-white">
                                <span class="inline-block px-2.5 sm:px-3 py-1 sm:py-1.5 rounded-full bg-sky-50 text-sky-700 text-xs sm:text-sm font-semibold mb-2 sm:mb-3"><%= g.getCategory() %></span>
                                <h5 class="text-lg sm:text-xl md:text-2xl font-bold mb-1 sm:mb-2"><%= g.getTitle() %></h5>
                                <p class="text-xs sm:text-sm text-slate-100"><%= g.getDescription() %></p>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Carousel Controls -->
                <button class="carousel-control-prev absolute top-1/2 left-4 -translate-y-1/2 z-20 w-10 h-10 rounded-full bg-black/50 hover:bg-black/70 flex items-center justify-center text-white transition-opacity opacity-70 hover:opacity-100" type="button" data-bs-target="#galleryCarousel" data-bs-slide="prev">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                    </svg>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next absolute top-1/2 right-4 -translate-y-1/2 z-20 w-10 h-10 rounded-full bg-black/50 hover:bg-black/70 flex items-center justify-center text-white transition-opacity opacity-70 hover:opacity-100" type="button" data-bs-target="#galleryCarousel" data-bs-slide="next">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        <% } %>
    </div>
</section>

<section class="bg-gradient-to-b from-slate-50 to-white py-8 sm:py-10 md:py-12 lg:py-14 border-t border-slate-200">
    <div class="max-w-6xl mx-auto px-3 sm:px-4 md:px-6 lg:px-8">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 sm:gap-4 md:gap-6 mb-6 sm:mb-8 md:mb-10">
            <div>
                <h2 class="text-xl sm:text-2xl md:text-3xl font-bold text-slate-900 mb-1 sm:mb-2">Semua koleksi</h2>
                <p class="text-sm sm:text-base text-slate-600">Stasiun, kereta, dan suasana perjalanan.</p>
            </div>
            <span class="inline-block px-3 sm:px-4 py-1.5 sm:py-2 rounded-full bg-slate-100 border border-slate-200 text-xs sm:text-sm font-semibold text-slate-700 whitespace-nowrap">Total: <%= items != null ? items.size() : 0 %> foto</span>
        </div>

        <% if (items == null || items.isEmpty()) { %>
            <div class="p-4 sm:p-6 bg-amber-50 border border-amber-200 rounded-lg text-amber-900 text-sm sm:text-base">
                Belum ada data galeri. Tambahkan minimal satu item dari dashboard admin.
            </div>
        <% } else { %>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-5 md:gap-6">
                <% for (GalleryItem g : items) { %>
                    <div class="bg-white rounded-lg sm:rounded-xl border border-slate-100 hover:border-slate-300 hover:shadow-lg shadow-sm transition-all overflow-hidden flex flex-col">
                        <!-- Image Container -->
                        <div class="relative overflow-hidden bg-slate-100 h-40 sm:h-48 md:h-52">
                            <img src="<%= g.getImageUrl() %>"
                                 class="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform"
                                 alt="<%= g.getTitle() %>"
                                 loading="lazy"
                                 data-lightbox-src="<%= g.getImageUrl() %>"
                                 data-lightbox-title="<%= g.getTitle() %>"
                                 data-lightbox-desc="<%= g.getDescription() %>"
                                 data-lightbox-category="<%= g.getCategory() %>">
                        </div>

                        <!-- Content -->
                        <div class="p-3 sm:p-4 md:p-5 flex flex-col flex-grow">
                            <!-- Badges -->
                            <div class="flex items-center gap-2 mb-2 sm:mb-3 flex-wrap">
                                <span class="inline-block px-2.5 sm:px-3 py-0.5 sm:py-1 rounded-full bg-slate-100 border border-slate-200 text-xs sm:text-xs font-semibold text-slate-700"><%= g.getCategory() %></span>
                                <% if (g.isFeatured()) { %>
                                    <span class="inline-block px-2.5 sm:px-3 py-0.5 sm:py-1 rounded-full bg-sky-50 border border-sky-200 text-xs sm:text-xs font-semibold text-sky-700">Featured</span>
                                <% } %>
                            </div>

                            <!-- Title & Description -->
                            <h6 class="text-sm sm:text-base font-bold text-slate-900 mb-1 sm:mb-2 line-clamp-2"><%= g.getTitle() %></h6>
                            <p class="text-xs sm:text-sm text-slate-600 flex-grow mb-3 sm:mb-4 line-clamp-2"><%= g.getDescription() %></p>

                            <!-- Date -->
                            <% if (g.getCreatedAt() != null) { %>
                                <small class="text-xs text-slate-500 mb-3 sm:mb-4">Ditambahkan: <%= g.getCreatedAt().toLocalDate() %></small>
                            <% } %>

                            <!-- Button -->
                            <button type="button"
                                    class="w-full px-3 sm:px-4 py-2 sm:py-2.5 border-2 border-sky-600 text-sky-700 font-bold rounded-lg hover:bg-sky-50 transition-all text-xs sm:text-sm open-lightbox"
                                    data-lightbox-src="<%= g.getImageUrl() %>"
                                    data-lightbox-title="<%= g.getTitle() %>"
                                    data-lightbox-desc="<%= g.getDescription() %>"
                                    data-lightbox-category="<%= g.getCategory() %>">
                                Lihat besar
                            </button>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</section>

<!-- Lightbox Modal -->
<div class="fixed inset-0 z-50 hidden" id="galleryLightbox" style="display:none;">
    <!-- Backdrop -->
    <div class="absolute inset-0 bg-black/70" data-bs-backdrop="static" data-bs-keyboard="false"></div>

    <!-- Modal Content -->
    <div class="absolute inset-4 sm:inset-6 md:inset-8 lg:inset-12 bg-white rounded-lg sm:rounded-xl overflow-hidden flex flex-col">
        <!-- Header -->
        <div class="flex items-center justify-between p-3 sm:p-4 md:p-5 border-b border-slate-200">
            <div class="flex items-center gap-2 sm:gap-3 flex-1 min-w-0">
                <span class="inline-block px-2.5 sm:px-3 py-1 sm:py-1.5 rounded-full bg-slate-100 border border-slate-200 text-xs sm:text-sm font-semibold text-slate-700 flex-shrink-0" id="lightboxCategory"></span>
                <h5 class="text-sm sm:text-base md:text-lg font-bold text-slate-900 truncate" id="lightboxTitle"></h5>
            </div>
            <button type="button" class="flex-shrink-0 ml-2 w-8 h-8 flex items-center justify-center rounded-lg hover:bg-slate-100 transition text-slate-600" data-dismiss="modal" aria-label="Close">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>

        <!-- Body -->
        <div class="flex-1 overflow-hidden flex items-center justify-center bg-slate-900 min-h-0">
            <img id="lightboxImg" src="" alt="" class="w-full h-full object-contain">
        </div>

        <!-- Footer -->
        <div class="p-3 sm:p-4 md:p-5 border-t border-slate-200 bg-slate-50">
            <p class="text-xs sm:text-sm text-slate-600 line-clamp-2" id="lightboxDesc"></p>
        </div>
    </div>
</div>

<script>
    (function(){
        var modalEl = document.getElementById('galleryLightbox');
        var hasBootstrap = !!(window.bootstrap && bootstrap.Modal);

        function openLightboxFrom(el){
            var src = el.getAttribute('data-lightbox-src');
            if(!src) return;
            var title = el.getAttribute('data-lightbox-title') || '';
            var desc = el.getAttribute('data-lightbox-desc') || '';
            var cat  = el.getAttribute('data-lightbox-category') || '';
            document.getElementById('lightboxImg').src = src;
            document.getElementById('lightboxTitle').textContent = title;
            document.getElementById('lightboxDesc').textContent = desc;
            document.getElementById('lightboxCategory').textContent = cat;
            if (hasBootstrap) {
                var m = bootstrap.Modal.getOrCreateInstance(modalEl);
                m.show();
            } else {
                // Fallback without Bootstrap JS
                modalEl.style.display = 'block';
                modalEl.classList.add('show');
                modalEl.removeAttribute('aria-hidden');
                modalEl.setAttribute('aria-modal','true');
            }
        }

        function closeFallbackModal(){
            if (hasBootstrap) return;
            if (!modalEl) return;
            modalEl.classList.remove('show');
            modalEl.style.display = 'none';
            modalEl.setAttribute('aria-hidden','true');
            modalEl.removeAttribute('aria-modal');
        }

        document.addEventListener('click', function(e){
            var trigger = e.target.closest('.open-lightbox, [data-lightbox-src]');
            if(!trigger) return;
            e.preventDefault();
            openLightboxFrom(trigger);
        }, false);

        // Fallback close handlers (only when Bootstrap JS is not present)
        if (!hasBootstrap && modalEl) {
            // Close on X button
            var closeBtn = modalEl.querySelector('[data-bs-dismiss="modal"]');
            if (closeBtn) {
                closeBtn.addEventListener('click', function(ev){
                    ev.preventDefault();
                    closeFallbackModal();
                });
            }
            // Close on backdrop (click outside dialog)
            modalEl.addEventListener('click', function(ev){
                if (ev.target === modalEl) {
                    closeFallbackModal();
                }
            });
            // Close on ESC key
            document.addEventListener('keydown', function(ev){
                if (ev.key === 'Escape') {
                    closeFallbackModal();
                }
            });
        }
    })();
</script>
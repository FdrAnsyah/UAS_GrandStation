<!doctype html>
<html lang="id">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>GrandStation - Pemesanan Kereta</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
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
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            /* Responsive text sizing */
            body {
                font-size: 16px;
            }

            @media (max-width: 640px) {
                body {
                    font-size: 14px;
                }
            }

            /* Responsive container padding */
            @media (max-width: 768px) {
                .container, .max-w-screen-xl {
                    padding-left: 0.75rem;
                    padding-right: 0.75rem;
                }
            }

            @media (max-width: 640px) {
                .container, .max-w-screen-xl {
                    padding-left: 0.5rem;
                    padding-right: 0.5rem;
                }
            }

            /* Optimize button spacing on mobile */
            @media (max-width: 640px) {
                button, a[type="button"], input[type="button"], input[type="submit"] {
                    min-height: 44px;
                }
            }

            /* Improve form field touch targets on mobile */
            @media (max-width: 768px) {
                input, select, textarea {
                    font-size: 16px !important;
                }
            }

            /* Fix overflow on mobile */
            @media (max-width: 640px) {
                .w-screen {
                    width: 100vw;
                    overflow-x: hidden;
                }
            }

            /* Responsive heading line-height */
            h1, h2, h3, h4, h5, h6 {
                line-height: 1.2;
            }

            @media (max-width: 768px) {
                h1, h2, h3 {
                    line-height: 1.1;
                }
            }

            /* Better spacing on mobile */
            @media (max-width: 640px) {
                section {
                    margin: 0;
                }
            }
        </style>
    </head>
    <body class="bg-slate-50 text-slate-900 flex flex-col min-h-screen">
        <%@ include file="menu.jsp" %>
        <main class="w-full flex-grow pt-0 pb-10">
            <%@ include file="main.jsp" %>
        </main>
        <%@ include file="footer.jsp" %>
    </body>
</html>

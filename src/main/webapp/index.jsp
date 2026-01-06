<!doctype html>
<html lang="id">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>GrandStation - Pemesanan Kereta</title>
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
        <main class="w-full flex-grow pt-0 pb-10">
            <%@ include file="main.jsp" %>
        </main>
        <%@ include file="footer.jsp" %>
    </body>
</html>

<%
    // Check if user is logged in and has admin role
    String userRole = (String) session.getAttribute("userRole");
    Object user = session.getAttribute("user");

    if (user == null) {
        // Not logged in - redirect to login
        response.sendRedirect(request.getContextPath() + "/login?error=login_required");
        return;
    }

    if (!"admin".equals(userRole)) {
        // Logged in but not admin - show access denied
        response.sendRedirect(request.getContextPath() + "/index.jsp?halaman=home&error=access_denied");
        return;
    }

    // User is admin - redirect to new unified dashboard
    response.sendRedirect(request.getContextPath() + "/admin-manage");
    return;
%>
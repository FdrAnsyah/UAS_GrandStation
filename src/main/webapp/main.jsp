<%
    // Check if user is requesting the admin page
    String hal = (String) request.getAttribute("halaman");
    if (hal == null || hal.isBlank()) {
        hal = request.getParameter("halaman");
    }

    // If admin page is requested, redirect to admin.jsp directly
    if ("admin".equals(hal)) {
        response.sendRedirect(request.getContextPath() + "/admin.jsp");
        return;
    }

    if (hal != null && !hal.isBlank()) {
        String url = hal + ".jsp";
%>
        <jsp:include page="<%= url %>" />
<%
    } else {
%>
        <%@ include file="home.jsp" %>
<%
    }
%>
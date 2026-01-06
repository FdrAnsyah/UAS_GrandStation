<%
    // Bisa dipakai dari URL (?halaman=...) atau dari Servlet (request attribute)
    String hal = (String) request.getAttribute("halaman");
    if (hal == null || hal.isBlank()) {
        hal = request.getParameter("halaman");
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
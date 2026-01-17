<%--
This page has been deprecated and replaced by admin-unified-bookings.jsp
All booking management functionality has been consolidated into a single page
for better user experience and easier maintenance.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirect to the unified booking management page
    response.sendRedirect(request.getContextPath() + "/admin-manage?action=approve_bookings");
%>
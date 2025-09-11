<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String requestURI = request.getRequestURI();
%>
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="admin?action=dashboard" class="logo"><i class="fas fa-cut"></i> Admin Premium</a>
    </div>
    <ul class="sidebar-nav">
        <li><a href="admin?action=dashboard" class="<%= requestURI.endsWith("admin") || requestURI.endsWith("dashboardAdmin.jsp") ? "active" : "" %>"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
        <li><a href="barbeiro?action=listar" class="<%= requestURI.contains("barbeiro") ? "active" : "" %>"><i class="fas fa-user-tie"></i> Barbeiros</a></li>
        <li><a href="corte?action=listar" class="<%= requestURI.contains("corte") ? "active" : "" %>"><i class="fas fa-stream"></i> Cortes</a></li>
        <li><a href="especialidade?action=gerenciar" class="<%= requestURI.contains("especialidade") ? "active" : "" %>"><i class="fas fa-star"></i> Especialidades</a></li>
    </ul>
</aside>

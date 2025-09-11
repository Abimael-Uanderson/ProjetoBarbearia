<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Corte" %>
<%@ page import="br.com.Barbearia.model.Administrador" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    Administrador admin = (Administrador) session.getAttribute("adminLogado");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin");
        return;
    }
    List<Corte> listaCortes = (List<Corte>) request.getAttribute("listaCortes");
    String msg = request.getParameter("msg");
    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Cortes - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-red: #8B0000; --dark-red: #600000; --white: #FFFFFF;
            --light-gray: #f8f9fa; --dark-gray: #343a40; --gold: #FFD700;
            --status-finalizado: #1cc88a; --status-cancelado: #e74a3b;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background-color: var(--light-gray); }
        .admin-wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: var(--dark-gray); color: var(--white); display: flex; flex-direction: column; position: fixed; height: 100%; box-shadow: 2px 0 10px rgba(0,0,0,0.1); z-index: 100; }
        .sidebar-header { padding: 1.5rem; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header .logo { font-size: 1.5rem; font-weight: bold; color: var(--white); text-decoration: none; }
        .main-content { flex-grow: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .header { background: var(--white); padding: 1rem 2rem; display: flex; justify-content: flex-end; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); border-bottom: 1px solid #eee; }
        .content-body { padding: 2rem; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .page-header h1 { font-size: 2.5rem; color: var(--dark-gray); }
        .btn { padding: 0.8rem 1.5rem; border-radius: 8px; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; border: none; cursor: pointer; }
        .btn-primary { background: var(--primary-red); color: var(--white); }
        .btn-edit { background-color: #f6c23e; color: white; padding: 0.5rem 1rem; }
        .btn-delete { background-color: var(--status-cancelado); color: white; padding: 0.5rem 1rem; }
        .table-container { background: var(--white); border-radius: 15px; box-shadow: 0 5px 25px rgba(0,0,0,0.08); overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #eee; }
        th { background-color: #f8f9fa; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; color: #666; }
        .actions { display: flex; gap: 0.5rem; }
        .alert { padding: 1rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 600; background: #e8f5e8; color: var(--status-finalizado); }
    </style>
</head>
<body>
    <div class="admin-wrapper">
        <%@ include file="shared/sidebar.jsp" %>
        <div class="main-content">
             <header class="header">
                 <div class="user-info"><span>Olá, <strong><%= admin.getEmail() %></strong></span><a href="admin?action=logout" class="btn-logout" style="background: var(--primary-red); color: white; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600;"><i class="fas fa-sign-out-alt"></i> Sair</a></div>
            </header>
            <main class="content-body">
                <div class="page-header">
                    <h1>Gerenciar Cortes</h1>
                    <a href="corte?action=formNovo" class="btn btn-primary"><i class="fas fa-plus"></i> Adicionar Corte</a>
                </div>

                <% if ("sucesso".equals(msg)) { %><div class="alert">Corte salvo com sucesso!</div><% } %>
                <% if ("editado".equals(msg)) { %><div class="alert">Corte atualizado com sucesso!</div><% } %>
                <% if ("apagado".equals(msg)) { %><div class="alert">Corte apagado com sucesso!</div><% } %>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr><th>ID</th><th>Nome</th><th>Valor</th><th>Duração (min)</th><th>Ações</th></tr>
                        </thead>
                        <tbody>
                        <% if (listaCortes != null && !listaCortes.isEmpty()) {
                            for (Corte corte : listaCortes) { %>
                            <tr>
                                <td><%= corte.getId_corte() %></td>
                                <td><%= corte.getNome_corte() %></td>
                                <td><%= formatoMoeda.format(corte.getValor_corte()) %></td>
                                <td><%= corte.getDuracao() %></td>
                                <td class="actions">
                                    <a href="corte?action=formEdicao&id=<%= corte.getId_corte() %>" class="btn btn-edit"><i class="fas fa-pen"></i></a>
                                    <form action="corte" method="post" onsubmit="return confirm('Tem certeza que deseja apagar este corte?');">
                                        <input type="hidden" name="action" value="apagar">
                                        <input type="hidden" name="id" value="<%= corte.getId_corte() %>">
                                        <button type="submit" class="btn btn-delete"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        <% }} else { %>
                            <tr><td colspan="5">Nenhum corte cadastrado.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>

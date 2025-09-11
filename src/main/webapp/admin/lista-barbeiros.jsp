<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Barbeiro" %>
<%@ page import="br.com.Barbearia.model.Administrador" %>

<%
    Administrador admin = (Administrador) session.getAttribute("adminLogado");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin");
        return;
    }
    List<Barbeiro> listaBarbeiros = (List<Barbeiro>) request.getAttribute("listaBarbeiros");
    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Barbeiros - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Estilos CSS (reutilizando o padrão do dashboard) -->
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
        .sidebar-header .logo i { color: var(--gold); }
        .sidebar-nav { flex-grow: 1; list-style: none; padding-top: 1rem; }
        .sidebar-nav a { display: flex; align-items: center; gap: 1rem; padding: 1rem 1.5rem; color: var(--light-gray); text-decoration: none; font-weight: 500; transition: all 0.3s ease; }
        .sidebar-nav a:hover { background: rgba(255,255,255,0.1); }
        .sidebar-nav a.active { background: var(--primary-red); color: var(--white); border-left: 4px solid var(--gold); }
        .sidebar-nav a i { width: 20px; text-align: center; }
        .main-content { flex-grow: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .header { background: var(--white); padding: 1rem 2rem; display: flex; justify-content: flex-end; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); border-bottom: 1px solid #eee; }
        .user-info { display: flex; align-items: center; gap: 1rem; }
        .btn-logout { background: var(--primary-red); color: var(--white); padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600; }
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
        .alert { padding: 1rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 600; }
        .alert-success { background: #e8f5e8; color: var(--status-finalizado); }
    </style>
</head>
<body>
    <div class="admin-wrapper">
        <%@ include file="shared/sidebar.jsp" %>
        <div class="main-content">
            <header class="header">
                <div class="user-info">
                    <span>Olá, <strong><%= admin.getEmail() %></strong></span>
                    <a href="admin?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
                </div>
            </header>
            <main class="content-body">
                <div class="page-header">
                    <h1>Gerenciar Barbeiros</h1>
                    <a href="barbeiro?action=formNovo" class="btn btn-primary"><i class="fas fa-plus"></i> Adicionar Barbeiro</a>
                </div>

                <% if ("sucesso".equals(msg)) { %><div class="alert alert-success">Barbeiro salvo com sucesso!</div><% } %>
                <% if ("editado".equals(msg)) { %><div class="alert alert-success">Barbeiro atualizado com sucesso!</div><% } %>
                <% if ("apagado".equals(msg)) { %><div class="alert alert-success">Barbeiro apagado com sucesso!</div><% } %>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr><th>CPF</th><th>Nome</th><th>Telefone</th><th>Email</th><th>Ações</th></tr>
                        </thead>
                        <tbody>
                        <% if (listaBarbeiros != null && !listaBarbeiros.isEmpty()) {
                            for (Barbeiro barbeiro : listaBarbeiros) { %>
                            <tr>
                                <td><%= barbeiro.getCpf() %></td>
                                <td><%= barbeiro.getNome() %></td>
                                <td><%= barbeiro.getTelefone() %></td>
                                <td><%= barbeiro.getEmail() %></td>
                                <td class="actions">
                                    <a href="barbeiro?action=formEdicao&cpf=<%= barbeiro.getCpf() %>" class="btn btn-edit"><i class="fas fa-pen"></i></a>
                                    <form action="barbeiro" method="post" onsubmit="return confirm('Tem certeza que deseja apagar este barbeiro?');">
                                        <input type="hidden" name="action" value="apagar">
                                        <input type="hidden" name="cpf" value="<%= barbeiro.getCpf() %>">
                                        <button type="submit" class="btn btn-delete"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        <% }} else { %>
                            <tr><td colspan="5">Nenhum barbeiro cadastrado.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>

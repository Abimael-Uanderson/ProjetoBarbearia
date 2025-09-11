<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.*" %>

<%
    Administrador admin = (Administrador) session.getAttribute("adminLogado");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin");
        return;
    }
    List<Barbeiro> listaBarbeiros = (List<Barbeiro>) request.getAttribute("listaBarbeiros");
    List<Corte> listaCortes = (List<Corte>) request.getAttribute("listaCortes");
    List<Especialidade> listaEspecialidades = (List<Especialidade>) request.getAttribute("listaEspecialidades");
    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Especialidades - Admin</title>
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
        .sidebar { width: 260px; background: var(--dark-gray); color: var(--white); display: flex; flex-direction: column; position: fixed; height: 100%; }
        .sidebar-header { padding: 1.5rem; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header .logo { font-size: 1.5rem; font-weight: bold; color: var(--white); text-decoration: none; }
        .main-content { flex-grow: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .header { background: var(--white); padding: 1rem 2rem; display: flex; justify-content: flex-end; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .content-body { padding: 2rem; }
        .page-header h1 { font-size: 2.5rem; color: var(--dark-gray); margin-bottom: 2rem; }
        .grid-container { display: grid; grid-template-columns: 1fr 2fr; gap: 2rem; }
        .form-container, .table-container { background: var(--white); padding: 2rem; border-radius: 15px; box-shadow: 0 5px 25px rgba(0,0,0,0.08); }
        h2 { font-size: 1.5rem; color: var(--dark-gray); margin-bottom: 1.5rem; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group select { width: 100%; padding: 1rem; border: 2px solid #ddd; border-radius: 10px; }
        .btn { padding: 1rem; border-radius: 10px; font-weight: 600; border: none; cursor: pointer; }
        .btn-primary { background: var(--primary-red); color: var(--white); width: 100%; }
        .table { width: 100%; border-collapse: collapse; }
        .table th, .table td { padding: 1rem; text-align: left; border-bottom: 1px solid #eee; }
        .btn-delete { background-color: var(--status-cancelado); color: white; padding: 0.5rem 1rem; border-radius: 8px; }
        .alert { padding: 1rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 600; background: #e8f5e8; color: var(--status-finalizado); }

        @media(max-width: 992px) {
            .grid-container { grid-template-columns: 1fr; }
        }
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
                <div class="page-header"><h1>Gerenciar Especialidades</h1></div>
                 <% if ("sucesso".equals(msg)) { %><div class="alert">Especialidade salva com sucesso!</div><% } %>
                 <% if ("apagado".equals(msg)) { %><div class="alert">Especialidade apagada com sucesso!</div><% } %>
                <div class="grid-container">
                    <div class="form-container">
                        <h2>Nova Especialidade</h2>
                        <form action="especialidade" method="post">
                             <input type="hidden" name="action" value="cadastrar">
                             <div class="form-group">
                                 <label for="barbeiro">Barbeiro</label>
                                 <select name="cpf_barbeiro" id="barbeiro" required>
                                     <option value="">Selecione...</option>
                                     <% for(Barbeiro b : listaBarbeiros) { %>
                                     <option value="<%= b.getCpf() %>"><%= b.getNome() %></option>
                                     <% } %>
                                 </select>
                             </div>
                             <div class="form-group">
                                 <label for="corte">Corte</label>
                                 <select name="id_corte" id="corte" required>
                                      <option value="">Selecione...</option>
                                     <% for(Corte c : listaCortes) { %>
                                     <option value="<%= c.getId_corte() %>"><%= c.getNome_corte() %></option>
                                     <% } %>
                                 </select>
                             </div>
                             <button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Adicionar</button>
                        </form>
                    </div>
                    <div class="table-container">
                        <h2>Especialidades Atuais</h2>
                        <table class="table">
                            <thead>
                                <tr><th>Barbeiro</th><th>Corte</th><th>Ação</th></tr>
                            </thead>
                            <tbody>
                                <% if (listaEspecialidades != null && !listaEspecialidades.isEmpty()) {
                                for(Especialidade e : listaEspecialidades) { %>
                                <tr>
                                    <td><%= e.getBarbeiro().getNome() %></td>
                                    <td><%= e.getCorte().getNome_corte() %></td>
                                    <td>
                                        <form action="especialidade" method="post" onsubmit="return confirm('Tem certeza?');">
                                            <input type="hidden" name="action" value="apagar">
                                            <input type="hidden" name="id_especialidade" value="<%= e.getId_especialidadeEp() %>">
                                            <button type="submit" class="btn btn-delete"><i class="fas fa-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                                <% }} else { %>
                                <tr><td colspan="3">Nenhuma especialidade cadastrada.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>

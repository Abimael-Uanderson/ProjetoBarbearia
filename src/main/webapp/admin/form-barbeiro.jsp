<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.Barbearia.model.Barbeiro" %>
<%@ page import="br.com.Barbearia.model.Administrador" %>

<%
    Administrador admin = (Administrador) session.getAttribute("adminLogado");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin");
        return;
    }
    Barbeiro barbeiro = (Barbeiro) request.getAttribute("barbeiro");
    boolean isEdicao = (barbeiro != null);
    String mensagemErro = (String) request.getAttribute("mensagemErro");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdicao ? "Editar" : "Cadastrar" %> Barbeiro - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-red: #8B0000; --dark-red: #600000; --white: #FFFFFF;
            --light-gray: #f8f9fa; --dark-gray: #343a40; --gold: #FFD700;
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
        .page-header h1 { font-size: 2.5rem; color: var(--dark-gray); margin-bottom: 2rem; }
        .form-container { max-width: 800px; background: var(--white); padding: 2rem; border-radius: 15px; box-shadow: 0 5px 25px rgba(0,0,0,0.08); }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input { width: 100%; padding: 1rem; border: 2px solid #ddd; border-radius: 10px; font-size: 1rem; }
        .form-actions { display: flex; gap: 1rem; margin-top: 2rem; }
        .btn { padding: 1rem; border-radius: 10px; font-weight: 600; text-decoration: none; border: none; cursor: pointer; }
        .btn-primary { background: var(--primary-red); color: var(--white); flex: 1; }
        .btn-secondary { background: #eee; color: var(--dark-gray); }
        .alert-error { background: #ffe6e6; color: #d63031; padding: 1rem; border-radius: 10px; margin-bottom: 1.5rem; }
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
                <div class="page-header"><h1><%= isEdicao ? "Editar Barbeiro" : "Novo Barbeiro" %></h1></div>
                <div class="form-container">
                    <% if (mensagemErro != null) { %><div class="alert alert-error"><%= mensagemErro %></div><% } %>
                    <form action="barbeiro" method="post">
                        <input type="hidden" name="action" value="<%= isEdicao ? "editar" : "cadastrar" %>">
                        <% if (isEdicao) { %><input type="hidden" name="cpf" value="<%= barbeiro.getCpf() %>"><% } %>

                        <div class="form-group">
                            <label for="cpf">CPF</label>
                            <input type="text" id="cpf" name="cpf" value="<%= isEdicao ? barbeiro.getCpf() : "" %>" <%= isEdicao ? "readonly" : "required" %>>
                        </div>
                        <div class="form-group">
                            <label for="nome">Nome Completo</label>
                            <input type="text" id="nome" name="nome" value="<%= isEdicao ? barbeiro.getNome() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="telefone">Telefone</label>
                            <input type="text" id="telefone" name="telefone" value="<%= isEdicao ? barbeiro.getTelefone() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= isEdicao ? barbeiro.getEmail() : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="senha">Senha</label>
                            <input type="password" id="senha" name="senha" placeholder="<%= isEdicao ? "Deixe em branco para não alterar" : "" %>" <%= !isEdicao ? "required" : "" %>>
                        </div>

                        <div class="form-actions">
                            <a href="barbeiro?action=listar" class="btn btn-secondary">Cancelar</a>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Salvar</button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
</body>
</html>

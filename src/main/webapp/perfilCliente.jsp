<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Perfil - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #f8f9fa; --medium-gray: #e9ecef; --dark-gray: #343a40;
            --gold: #FFD700; --green: #1cc88a;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background-color: var(--light-gray); color: var(--dark-gray); }
        .header { background: linear-gradient(135deg, var(--primary-red), var(--dark-red)); color: var(--white); padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 1000; }
        .nav-container { max-width: 1200px; margin: 0 auto; padding: 0 2rem; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.8rem; font-weight: bold; color: var(--white); text-decoration: none; }
        .logo i { margin-right: 0.5rem; color: var(--gold); }
        .nav-menu { display: flex; list-style: none; gap: 2rem; align-items: center; }
        .nav-menu a { color: var(--white); text-decoration: none; font-weight: 500; transition: color 0.3s ease; display: flex; align-items: center; gap: 0.5rem; }
        .nav-menu a:hover, .nav-menu a.active { color: var(--gold); }
        .user-info { display: flex; align-items: center; gap: 1rem; }
        .user-avatar { width: 40px; height: 40px; background: var(--gold); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--dark-gray); font-weight: bold; font-size: 1.2rem; }
        .user-name { font-weight: 600; }
        .btn-logout { background: transparent; border: 2px solid var(--white); color: var(--white); padding: 0.5rem 1rem; border-radius: 20px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; }
        .btn-logout:hover { background: var(--white); color: var(--primary-red); }
        .main-container { max-width: 800px; margin: 2rem auto; padding: 0 2rem; }
        .page-header h1 { font-size: 2.5rem; color: var(--primary-red); margin-bottom: 2rem; text-align: center; }
        .profile-card { background: var(--white); border-radius: 15px; padding: 2rem; box-shadow: 0 5px 25px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input { width: 100%; padding: 1rem; border: 2px solid var(--medium-gray); border-radius: 10px; font-size: 1rem; transition: border-color 0.3s ease; }
        .form-group input:focus { outline: none; border-color: var(--primary-red); }
        .input-icon { position: relative; }
        .input-icon i { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--dark-gray); opacity: 0.5; }
        .input-icon input { padding-left: 3rem; }
        .password-toggle { position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--dark-gray); opacity: 0.7; }
        .btn { width: 100%; padding: 1rem; background: var(--primary-red); color: var(--white); border: none; border-radius: 10px; font-size: 1.1rem; font-weight: 600; cursor: pointer; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 0.5rem; }
        .btn:hover { background: var(--dark-red); transform: translateY(-2px); }
        .alert { padding: 1rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 600; text-align: center; background: #e8f5e8; color: var(--green); border: 1px solid #a8e6cf; }
        @media (max-width: 768px) { .nav-menu { display: none; } }
    </style>
</head>
<body>

    <%
        Cliente cliente = (Cliente) session.getAttribute("usuarioLogado");
        if (cliente == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String primeiroNome = cliente.getNome().split(" ")[0];
        String mensagemSucesso = request.getParameter("msg");
    %>

    <!-- Cabeçalho -->
    <header class="header">
        <div class="nav-container">
            <a href="cliente?action=home" class="logo"><i class="fas fa-cut"></i> Barbearia Premium</a>
            <nav class="nav-menu">
                <a href="cliente?action=home"><i class="fas fa-home"></i> Início</a>
                <a href="agendamento.jsp"><i class="fas fa-calendar-plus"></i> Agendar</a>
                <a href="agendamento?action=verHistorico"><i class="fas fa-history"></i> Histórico</a>
                <a href="cliente?action=verPerfil" class="active"><i class="fas fa-user"></i> Perfil</a>
            </nav>
            <div class="user-info">
                <div class="user-avatar"><%= primeiroNome.charAt(0) %></div>
                <span class="user-name"><%= primeiroNome %></span>
                <a href="cliente?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
            </div>
        </div>
    </header>

    <!-- Conteúdo Principal -->
    <main class="main-container">
        <div class="page-header">
            <h1>Meu Perfil</h1>
        </div>
        
        <div class="profile-card">
            
            <% if ("sucesso".equals(mensagemSucesso)) { %>
                <div class="alert">
                    <i class="fas fa-check-circle"></i> Perfil atualizado com sucesso!
                </div>
            <% } %>

            <form action="cliente" method="post">
                <input type="hidden" name="action" value="editar">
                
                <div class="form-group">
                    <label for="nome">Nome Completo</label>
                    <div class="input-icon">
                        <i class="fas fa-user"></i>
                        <input type="text" id="nome" name="nome" value="<%= cliente.getNome() %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="cpf">CPF (não editável)</label>
                    <div class="input-icon">
                        <i class="fas fa-id-card"></i>
                        <input type="text" id="cpf" name="cpf" value="<%= cliente.getCpf() %>" readonly style="background-color: #eee;">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">E-mail</label>
                    <div class="input-icon">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" value="<%= cliente.getEmail() %>" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="telefone">Telefone</label>
                    <div class="input-icon">
                        <i class="fas fa-phone"></i>
                        <input type="tel" id="telefone" name="telefone" value="<%= cliente.getTelefone() %>" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="senha">Nova Senha (deixe em branco para não alterar)</label>
                    <div class="input-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="senha" name="senha" placeholder="********">
                        <span class="password-toggle"><i class="fas fa-eye" id="togglePassword"></i></span>
                    </div>
                </div>
                
                <button type="submit" class="btn">
                    <i class="fas fa-save"></i> Salvar Alterações
                </button>
            </form>
        </div>
    </main>
    
    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const passwordInput = document.querySelector('#senha');

        togglePassword.addEventListener('click', function () {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            // Altera o ícone do olho
            this.classList.toggle('fa-eye-slash');
        });
    </script>
</body>
</html>


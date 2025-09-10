<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Perfil - Royal Blades</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-red: #8B0000;
            --secondary-red: #B22222;
            --light-red: #DC143C;
            --dark-red: #600000;
            --white: #FFFFFF;
            --light-gray: #F8F8F8;
            --dark-gray: #333333;
            --gold: #FFD700;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--primary-red), var(--secondary-red));
            min-height: 100vh;
            padding: 1rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header-nav {
            background: var(--white);
            border-radius: 15px;
            padding: 1rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-red);
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav-links a {
            color: var(--dark-gray);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: var(--primary-red);
        }

        .nav-links a.active {
            color: var(--primary-red);
            font-weight: 600;
        }

        .profile-container {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            display: grid;
            grid-template-columns: 300px 1fr;
            min-height: 600px;
        }

        .profile-sidebar {
            background: linear-gradient(135deg, var(--primary-red), var(--secondary-red));
            padding: 2rem;
            text-align: center;
            color: var(--white);
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            background: var(--white);
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: var(--primary-red);
        }

        .profile-name {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .profile-email {
            opacity: 0.9;
            margin-bottom: 2rem;
            font-size: 0.9rem;
        }

        .profile-menu {
            list-style: none;
        }

        .profile-menu li {
            margin-bottom: 1rem;
        }

        .profile-menu a {
            color: var(--white);
            text-decoration: none;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            display: block;
            transition: background 0.3s ease;
        }

        .profile-menu a:hover,
        .profile-menu a.active {
            background: rgba(255, 255, 255, 0.2);
        }

        .profile-content {
            padding: 3rem;
        }

        .content-header {
            margin-bottom: 2rem;
        }

        .content-header h1 {
            color: var(--primary-red);
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .content-header p {
            color: var(--dark-gray);
            opacity: 0.7;
        }

        .form-section {
            background: var(--light-gray);
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }

        .form-section h3 {
            color: var(--primary-red);
            margin-bottom: 1.5rem;
            font-size: 1.2rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--dark-gray);
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 1rem;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-red);
        }

        .form-group input:disabled {
            background: #f5f5f5;
            color: #888;
            cursor: not-allowed;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: var(--primary-red);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--dark-red);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6c757d;
            color: var(--white);
        }

        .btn-secondary:hover {
            background: #545b62;
        }

        .btn-outline {
            background: transparent;
            color: var(--primary-red);
            border: 2px solid var(--primary-red);
        }

        .btn-outline:hover {
            background: var(--primary-red);
            color: var(--white);
        }

        .alert {
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }

        .alert-error {
            background: #ffe6e6;
            color: #d63031;
            border: 1px solid #fab1a0;
        }

        .alert-success {
            background: #e8f5e8;
            color: #00b894;
            border: 1px solid #a8e6cf;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-red);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--dark-gray);
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .profile-container {
                grid-template-columns: 1fr;
            }

            .profile-sidebar {
                padding: 1.5rem;
            }

            .profile-content {
                padding: 2rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .nav-links {
                gap: 1rem;
            }

            .header-nav {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 0.5rem;
            }

            .profile-content {
                padding: 1.5rem;
            }

            .content-header h1 {
                font-size: 1.5rem;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .profile-container {
            animation: fadeIn 0.6s ease-out;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation Header -->
        <nav class="header-nav">
            <div class="logo">
                <i class="fas fa-cut"></i> Royal Blades
            </div>
            <div class="nav-links">
                <a href="home.jsp"><i class="fas fa-home"></i> Início</a>
                <a href="cliente?action=verPerfil" class="active"><i class="fas fa-user"></i> Perfil</a>
                <a href="historico.jsp"><i class="fas fa-history"></i> Histórico</a>
                <a href="agendamento.jsp"><i class="fas fa-calendar-plus"></i> Agendar</a>
                <a href="cliente?action=logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
            </div>
        </nav>

        <div class="profile-container">
            <!-- Profile Sidebar -->
            <div class="profile-sidebar">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="profile-name">
                    <%= ((br.com.Barbearia.model.Cliente) session.getAttribute("usuarioLogado")).getNome() %>
                </div>
                <div class="profile-email">
                    <%= ((br.com.Barbearia.model.Cliente) session.getAttribute("usuarioLogado")).getEmail() %>
                </div>
                
                <ul class="profile-menu">
                    <li><a href="#dados" class="active" onclick="showSection('dados')"><i class="fas fa-user-edit"></i> Meus Dados</a></li>
                    <li><a href="#seguranca" onclick="showSection('seguranca')"><i class="fas fa-lock"></i> Segurança</a></li>
                    <li><a href="#estatisticas" onclick="showSection('estatisticas')"><i class="fas fa-chart-bar"></i> Estatísticas</a></li>
                </ul>
            </div>

            <!-- Profile Content -->
            <div class="profile-content">
                <!-- Success/Error Messages -->
                <%
                    String mensagemErro = (String) request.getAttribute("mensagemErro");
                    String mensagemSucesso = request.getParameter("msg");
                    if (mensagemErro != null) {
                %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i> <%= mensagemErro %>
                    </div>
                <%
                    }
                    if ("sucesso".equals(mensagemSucesso)) {
                %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> Perfil atualizado com sucesso!
                    </div>
                <%
                    }
                    
                    br.com.Barbearia.model.Cliente cliente = (br.com.Barbearia.model.Cliente) session.getAttribute("usuarioLogado");
                %>

                <!-- Dados Pessoais Section -->
                <div id="dados-section" class="content-section">
                    <div class="content-header">
                        <h1>Meus Dados</h1>
                        <p>Mantenha suas informações sempre atualizadas</p>
                    </div>

                    <form method="post" action="cliente" class="profile-form">
                        <input type="hidden" name="action" value="editar">
                        
                        <div class="form-section">
                            <h3><i class="fas fa-user"></i> Informações Pessoais</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="nome">Nome Completo</label>
                                    <input type="text" id="nome" name="nome" value="<%= cliente.getNome() %>" required>
                                </div>
                                <div class="form-group">
                                    <label for="cpf">CPF</label>
                                    <input type="text" id="cpf" name="cpf" value="<%= cliente.getCpf() %>" disabled>
                                    <small style="color: #888; font-size: 0.8rem;">O CPF não pode ser alterado</small>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3><i class="fas fa-envelope"></i> Contato</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="email">E-mail</label>
                                    <input type="email" id="email" name="email" value="<%= cliente.getEmail() %>" required>
                                </div>
                                <div class="form-group">
                                    <label for="telefone">Telefone</label>
                                    <input type="tel" id="telefone" name="telefone" value="<%= cliente.getTelefone() %>" 
                                           pattern="^\(\d{2}\) \d{4,5}-\d{4}$" 
                                           title="Formato: (99) 99999-9999" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3><i class="fas fa-key"></i> Alterar Senha</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="senha">Nova Senha</label>
                                    <input type="password" id="senha" name="senha" placeholder="Deixe em branco para manter a atual">
                                </div>
                                <div class="form-group">
                                    <label for="confirmarSenha">Confirmar Nova Senha</label>
                                    <input type="password" id="confirmarSenha" name="confirmarSenha" placeholder="Confirme a nova senha">
                                </div>
                            </div>
                        </div>

                        <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Salvar Alterações
                            </button>
                            <a href="historico.jsp" class="btn btn-outline">
                                <i class="fas fa-history"></i> Ver Histórico
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Segurança Section -->
                <div id="seguranca-section" class="content-section" style="display: none;">
                    <div class="content-header">
                        <h1>Segurança</h1>
                        <p>Mantenha sua conta segura</p>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-shield-alt"></i> Configurações de Segurança</h3>
                        <div style="padding: 1rem 0;">
                            <p style="margin-bottom: 1rem; color: var(--dark-gray);">
                                <i class="fas fa-info-circle" style="color: var(--primary-red);"></i>
                                Sua conta está protegida com criptografia de senha.
                            </p>
                            <p style="margin-bottom: 1rem; color: var(--dark-gray);">
                                Último acesso: <strong>Agora</strong>
                            </p>
                            <button type="button" class="btn btn-outline" onclick="alert('Funcionalidade em desenvolvimento')">
                                <i class="fas fa-key"></i> Alterar Senha
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Estatísticas Section -->
                <div id="estatisticas-section" class="content-section" style="display: none;">
                    <div class="content-header">
                        <h1>Minhas Estatísticas</h1>
                        <p>Acompanhe seu histórico na barbearia</p>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-number">15</div>
                            <div class="stat-label">Cortes Realizados</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">R$ 450</div>
                            <div class="stat-label">Total Investido</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">3</div>
                            <div class="stat-label">Barbeiros Diferentes</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">2</div>
                            <div class="stat-label">Agendamentos Futuros</div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-star"></i> Seu Corte Favorito</h3>
                        <p style="color: var(--dark-gray); margin-bottom: 1rem;">
                            <strong>Corte Social</strong> - Realizado 8 vezes
                        </p>
                        <a href="agendamento.jsp" class="btn btn-primary">
                            <i class="fas fa-calendar-plus"></i> Agendar Novamente
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Menu navigation
        function showSection(sectionName) {
            // Hide all sections
            document.querySelectorAll('.content-section').forEach(section => {
                section.style.display = 'none';
            });
            
            // Remove active class from all menu items
            document.querySelectorAll('.profile-menu a').forEach(link => {
                link.classList.remove('active');
            });
            
            // Show selected section
            document.getElementById(sectionName + '-section').style.display = 'block';
            
            // Add active class to clicked menu item
            event.target.classList.add('active');
        }

        // Form validation
        document.querySelector('.profile-form').addEventListener('submit', function(e) {
            const senha = document.getElementById('senha').value;
            const confirmarSenha = document.getElementById('confirmarSenha').value;
            
            if (senha && senha !== confirmarSenha) {
                e.preventDefault();
                alert('As senhas não coincidem!');
                return false;
            }
        });

        // Phone mask
        document.getElementById('telefone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 11) {
                value = value.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
            } else if (value.length >= 6) {
                value = value.replace(/(\d{2})(\d{4})(\d+)/, '($1) $2-$3');
            } else if (value.length >= 2) {
                value = value.replace(/(\d{2})(\d+)/, '($1) $2');
            }
            e.target.value = value;
        });
    </script>
</body>
</html>
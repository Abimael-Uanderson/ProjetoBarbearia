<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #f8f9fa; --medium-gray: #e9ecef; --dark-gray: #343a40;
            --gold: #FFD700; --danger: #d63031;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, var(--primary-red), var(--dark-red)); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 1rem; }
        .register-container { background: var(--white); border-radius: 20px; box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2); overflow: hidden; width: 100%; max-width: 500px; animation: fadeInUp 0.6s ease-out; }
        .register-form { padding: 3rem; }
        .form-header { text-align: center; margin-bottom: 2rem; }
        .form-header h1 { color: var(--primary-red); font-size: 2rem; margin-bottom: 0.5rem; }
        .form-header p { color: var(--dark-gray); opacity: 0.7; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; color: var(--dark-gray); font-weight: 600; }
        .form-group input { width: 100%; padding: 1rem; border: 2px solid var(--medium-gray); border-radius: 10px; font-size: 1rem; transition: border-color 0.3s ease; }
        .form-group input:focus { outline: none; border-color: var(--primary-red); }
        .input-icon { position: relative; }
        .input-icon i.fa-solid { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--dark-gray); opacity: 0.5; }
        .input-icon input { padding-left: 3rem; }
        .password-toggle { position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--dark-gray); opacity: 0.7; }
        .btn { width: 100%; padding: 1rem; background: var(--primary-red); color: var(--white); border: none; border-radius: 10px; font-size: 1.1rem; font-weight: 600; cursor: pointer; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 0.5rem; }
        .btn:hover { background: var(--dark-red); transform: translateY(-2px); }
        .login-link { text-align: center; margin-top: 1.5rem; }
        .login-link a { color: var(--primary-red); text-decoration: none; font-weight: 600; }
        .login-link a:hover { text-decoration: underline; }
        .alert-error { padding: 1rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 600; background: #ffe6e6; color: var(--danger); border: 1px solid #fab1a0; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 480px) { .register-form { padding: 1.5rem; } }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-form">
            <div class="form-header">
                <h1>Crie sua Conta</h1>
                <p>É rápido e fácil. Comece agora!</p>
            </div>

            <% String mensagemErro = (String) request.getAttribute("mensagemErro");
               if (mensagemErro != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> <%= mensagemErro %>
                </div>
            <% } %>

            <form action="cliente" method="post" id="registerForm">
                <input type="hidden" name="action" value="cadastrar">
                
                <div class="form-group">
                    <label for="nome">Nome Completo</label>
                    <div class="input-icon">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" id="nome" name="nome" placeholder="Seu nome completo" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="cpf">CPF</label>
                    <div class="input-icon">
                        <i class="fa-solid fa-id-card"></i>
                        <input type="text" id="cpf" name="cpf" placeholder="000.000.000-00" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">E-mail</label>
                    <div class="input-icon">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="seu@email.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="telefone">Telefone</label>
                    <div class="input-icon">
                        <i class="fa-solid fa-phone"></i>
                        <input type="tel" id="telefone" name="telefone" placeholder="(71) 99999-9999" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="senha">Senha</label>
                    <div class="input-icon">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="senha" name="senha" placeholder="Crie uma senha forte" required>
                        <span class="password-toggle"><i class="fas fa-eye" id="togglePassword"></i></span>
                    </div>
                </div>

                <!-- NOVO CAMPO ADICIONADO -->
                <div class="form-group">
                    <label for="confirmar_senha">Confirmar Senha</label>
                    <div class="input-icon">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="confirmar_senha" name="confirmar_senha" placeholder="Repita a senha" required>
                        <span class="password-toggle"><i class="fas fa-eye" id="toggleConfirmPassword"></i></span>
                    </div>
                </div>
                
                <button type="submit" class="btn">
                    <i class="fas fa-user-plus"></i> Cadastrar
                </button>
            </form>

            <div class="login-link">
                <p>Já tem uma conta? <a href="login.jsp">Faça login</a></p>
            </div>
        </div>
    </div>

    <script>
        // Função para alternar a visibilidade da senha
        function togglePasswordVisibility(inputId, toggleId) {
            const toggle = document.querySelector(toggleId);
            const input = document.querySelector(inputId);
            toggle.addEventListener('click', function () {
                const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
                input.setAttribute('type', type);
                this.querySelector('i').classList.toggle('fa-eye-slash');
            });
        }

        togglePasswordVisibility('#senha', '#togglePassword');
        togglePasswordVisibility('#confirmar_senha', '#toggleConfirmPassword');

        // Validação do formulário antes do envio
        const registerForm = document.getElementById('registerForm');
        registerForm.addEventListener('submit', function(event) {
            const senha = document.getElementById('senha').value;
            const confirmarSenha = document.getElementById('confirmar_senha').value;

            if (senha !== confirmarSenha) {
                // Impede o envio do formulário
                event.preventDefault(); 
                alert('As senhas não coincidem. Por favor, tente novamente.');
            }
        });
    </script>
</body>
</html>


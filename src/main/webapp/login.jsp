<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Barbearia Premium</title>
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
            --dark-red: #600000;
            --white: #FFFFFF;
            --light-gray: #F5F5F5;
            --dark-gray: #333333;
            --gold: #FFD700;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--primary-red), var(--secondary-red));
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }

        .login-container {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            width: 100%;
            max-width: 900px;
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            min-height: 600px;
            animation: fadeIn 0.8s ease-out;
        }

        .login-image {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://placehold.co/600x800/8B0000/FFFFFF?text=Barbearia\\nPremium');
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: var(--white);
            padding: 2rem;
        }

        .login-image h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .login-image p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .back-home {
            color: var(--gold);
            text-decoration: none;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border: 2px solid var(--gold);
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .back-home:hover {
            background: var(--gold);
            color: var(--dark-gray);
        }

        .login-form {
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-header h1 {
            color: var(--primary-red);
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: var(--dark-gray);
            opacity: 0.7;
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

        .form-group .input-icon {
            position: relative;
        }

        .form-group .input-icon .icon-left {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--dark-gray);
            opacity: 0.5;
        }

        .form-group .input-icon .password-toggle-icon {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--dark-gray);
            opacity: 0.6;
            cursor: pointer;
        }

        .form-group .input-icon input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid var(--light-gray);
            border-radius: 10px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        
        .form-group .input-icon input[type="password"] {
            padding-right: 3rem;
        }


        .form-group .input-icon input:focus {
            outline: none;
            border-color: var(--primary-red);
        }

        .btn {
            width: 100%;
            padding: 1rem;
            background: var(--primary-red);
            color: var(--white);
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 1rem;
        }

        .btn:hover {
            background: var(--dark-red);
            transform: translateY(-2px);
        }
        
        .register-link {
            text-align: center;
            margin-top: 1.5rem;
        }

        .register-link a {
            color: var(--primary-red);
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .alert {
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            animation: fadeIn 0.3s ease-out;
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

        /* Responsive Design */
        @media (max-width: 768px) {
            .login-container {
                grid-template-columns: 1fr;
                max-width: 400px;
            }

            .login-image {
                display: none;
            }
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Lado Esquerdo - Imagem -->
        <div class="login-image">
            <h2>Bem-vindo de volta!</h2>
            <p>Entre na sua conta para agendar os seus horários e acompanhar o seu histórico de serviços.</p>
            <a href="#" class="back-home">
                <i class="fas fa-home"></i> Voltar ao Início
            </a>
        </div>

        <!-- Lado Direito - Formulário -->
        <div class="login-form">
            <div class="form-header">
                <h1>Login do Cliente</h1>
                <p>Entre com as suas credenciais</p>
            </div>

            <!-- Mensagens de Erro/Sucesso -->
            <%
                String mensagemErro = (String) request.getAttribute("mensagemErro");
                String mensagemSucesso = (String) request.getAttribute("mensagemSucesso");
                if (mensagemErro != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> <%= mensagemErro %>
                </div>
            <%
                }
                if (mensagemSucesso != null) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= mensagemSucesso %>
                </div>
            <%
                }
            %>

            <!-- Formulário de Login -->
            <form id="loginForm" method="post" action="cliente">
                <div class="form-group">
                    <label for="email">E-mail</label>
                    <div class="input-icon">
                        <i class="fas fa-envelope icon-left"></i>
                        <input type="email" id="email" name="email" required placeholder="seu@email.com">
                    </div>
                </div>

                <div class="form-group">
                    <label for="senha">Senha</label>
                    <div class="input-icon">
                        <i class="fas fa-lock icon-left"></i>
                        <input type="password" id="senha" name="senha" required placeholder="A sua senha">
                        <i class="fas fa-eye password-toggle-icon" id="togglePassword"></i>
                    </div>
                </div>

                <input type="hidden" name="action" value="login">
                <button type="submit" class="btn">
                    <i class="fas fa-sign-in-alt"></i> Entrar
                </button>
            </form>

            <div class="register-link">
                <p>Não tem uma conta? <a href="cadastro-cliente.jsp">Registe-se agora</a></p>
            </div>
        </div>
    </div>

    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const passwordInput = document.querySelector('#senha');

        togglePassword.addEventListener('click', function () {
            // Altera o tipo do input
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            // Altera o ícone
            this.classList.toggle('fa-eye-slash');
        });
    </script>
</body>
</html>


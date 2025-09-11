<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login do Administrador - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #F5F5F5; --dark-gray: #333333; --gold: #FFD700;
        }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: var(--dark-gray);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }
        .login-card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 450px;
            padding: 3rem;
            animation: fadeIn 0.8s ease-out;
        }
        .form-header { text-align: center; margin-bottom: 2rem; }
        .form-header .icon { font-size: 3rem; color: var(--primary-red); margin-bottom: 1rem; }
        .form-header h1 { color: var(--primary-red); font-size: 2rem; margin-bottom: 0.5rem; }
        .form-header p { color: var(--dark-gray); opacity: 0.7; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; color: var(--dark-gray); font-weight: 600; }
        .input-icon { position: relative; }
        .input-icon .icon-left { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--dark-gray); opacity: 0.5; }
        .input-icon input { width: 100%; padding: 1rem 1rem 1rem 3rem; border: 2px solid #eee; border-radius: 10px; font-size: 1rem; transition: border-color 0.3s ease; }
        .input-icon input:focus { outline: none; border-color: var(--primary-red); }
        .btn { width: 100%; padding: 1rem; background: var(--primary-red); color: var(--white); border: none; border-radius: 10px; font-size: 1.1rem; font-weight: 600; cursor: pointer; transition: all 0.3s ease; margin-top: 1rem; }
        .btn:hover { background: var(--dark-red); }
        .alert { padding: 1rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 600; display: flex; align-items: center; gap: 0.5rem; animation: fadeIn 0.3s ease-out; background: #ffe6e6; color: #d63031; border: 1px solid #fab1a0; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="form-header">
            <div class="icon"><i class="fas fa-user-shield"></i></div>
            <h1>Painel do Administrador</h1>
            <p>Acesso restrito</p>
        </div>

        <%
            String mensagemErro = (String) request.getAttribute("mensagemErro");
            if (mensagemErro != null) {
        %>
            <div class="alert">
                <i class="fas fa-exclamation-triangle"></i> <%= mensagemErro %>
            </div>
        <%
            }
        %>

        <form method="post" action="admin">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label for="email">E-mail</label>
                <div class="input-icon">
                    <i class="fas fa-envelope icon-left"></i>
                    <input type="email" id="email" name="email" required placeholder="admin@email.com">
                </div>
            </div>
            <div class="form-group">
                <label for="senha">Senha</label>
                <div class="input-icon">
                    <i class="fas fa-lock icon-left"></i>
                    <input type="password" id="senha" name="senha" required placeholder="Sua senha">
                </div>
            </div>
            <button type="submit" class="btn">
                <i class="fas fa-sign-in-alt"></i> Entrar
            </button>
        </form>
    </div>
</body>
</html>

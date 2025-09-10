<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.Barbearia.model.Agendamento" %>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Recebe o objeto completo diretamente do AgendamentoController
    Agendamento agendamentoConfirmado = (Agendamento) request.getAttribute("agendamentoConfirmado");
    
    // Recupera o cliente logado da sessão para o header
    Cliente usuarioLogado = (Cliente) session.getAttribute("usuarioLogado");
    
    String erro = null;
    if (agendamentoConfirmado == null) {
        erro = "Não foi possível carregar os detalhes do agendamento. Por favor, tente novamente.";
    }

    // Formatadores para data, hora e moeda
    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
    DateTimeFormatter formatoData = DateTimeFormatter.ofPattern("dd 'de' MMMM 'de' yyyy", new Locale("pt", "BR"));
    DateTimeFormatter formatoHora = DateTimeFormatter.ofPattern("HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamento Confirmado! - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Estilos Globais e Variáveis */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #F8F8F8; --dark-gray: #333333; --gold: #FFD700;
            --success-green: #00b894;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-gray); }

        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary-red), var(--secondary-red));
            color: var(--white); padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; padding: 0 2rem; display: flex;
            justify-content: space-between; align-items: center;
        }
        .logo { font-size: 1.8rem; font-weight: bold; color: var(--white); text-decoration: none; }
        .logo i { margin-right: 0.5rem; color: var(--gold); }
        .user-info { display: flex; align-items: center; gap: 1rem; }
        .user-avatar {
            width: 40px; height: 40px; background: var(--gold); border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: var(--dark-gray); font-weight: bold; font-size: 1.2rem;
        }
        
        /* Conteúdo Principal */
        .main-container {
            max-width: 800px; margin: 2rem auto; padding: 2rem;
            display: flex; flex-direction: column; align-items: center; text-align: center;
        }

        .confirmation-card {
            background: var(--white);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 100%;
        }

        .success-icon {
            font-size: 4rem;
            color: var(--success-green);
            margin-bottom: 1.5rem;
            animation: popIn 0.5s ease-out;
        }

        .confirmation-title {
            font-size: 2.2rem;
            color: var(--primary-red);
            margin-bottom: 1rem;
        }

        .confirmation-subtitle {
            font-size: 1.1rem;
            color: var(--dark-gray);
            opacity: 0.8;
            margin-bottom: 2rem;
        }
        
        .summary-details {
            border: 2px solid var(--light-gray);
            border-radius: 15px;
            padding: 2rem;
            text-align: left;
            margin-bottom: 2rem;
        }

        .summary-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--dark-gray);
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .summary-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
        }
        
        .summary-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .summary-label {
            font-weight: 600;
            color: var(--dark-gray);
            opacity: 0.7;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .summary-value {
            font-weight: bold;
            font-size: 1.1rem;
            color: var(--primary-red);
        }

        .actions {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            width: 100%;
            max-width: 400px;
            margin: 0 auto;
        }

        .btn {
            padding: 1rem;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            font-size: 1rem;
            border: none;
        }

        .btn-primary {
            background: var(--primary-red);
            color: var(--white);
        }
        .btn-primary:hover {
            background: var(--dark-red);
        }

        .btn-secondary {
            background: transparent;
            color: var(--dark-gray);
            border: 2px solid var(--light-gray);
        }
        .btn-secondary:hover {
            border-color: var(--dark-gray);
        }

        .error-container {
            text-align: center;
            padding: 2rem;
        }

        @keyframes popIn {
            0% { transform: scale(0.5); opacity: 0; }
            80% { transform: scale(1.1); }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body>

    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <a href="cliente?action=home" class="logo"><i class="fas fa-cut"></i> Barbearia Premium</a>
            <% if (usuarioLogado != null) { %>
                <div class="user-info">
                    <div class="user-avatar"><%= usuarioLogado.getNome().charAt(0) %></div>
                </div>
            <% } %>
        </div>
    </header>

    <!-- Conteúdo Principal -->
    <div class="main-container">

    <% if (erro != null) { %>
        <div class="error-container">
            <h2><%= erro %></h2>
            <br>
            <a href="corte?action=listarParaAgendamento" class="btn btn-primary">Voltar ao Início do Agendamento</a>
        </div>
    <% } else { %>
        <div class="confirmation-card">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h1 class="confirmation-title">Agendamento Confirmado!</h1>
            <p class="confirmation-subtitle">Seu horário está reservado. Nos vemos em breve!</p>

            <div class="summary-details">
                <h2 class="summary-title">Resumo do Agendamento</h2>
                <ul class="summary-list">
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-cut"></i> Serviço</span>
                        <span class="summary-value"><%= agendamentoConfirmado.getItemAgendamento().getEspecialidade().getCorte().getNome_corte() %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-user-tie"></i> Profissional</span>
                        <span class="summary-value"><%= agendamentoConfirmado.getBarbeiro().getNome() %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-calendar-alt"></i> Data</span>
                        <span class="summary-value"><%= agendamentoConfirmado.getData_atendimentoAg().format(formatoData) %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-clock"></i> Horário</span>
                        <span class="summary-value"><%= agendamentoConfirmado.getData_atendimentoAg().format(formatoHora) %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-dollar-sign"></i> Valor</span>
                        <span class="summary-value"><%= formatoMoeda.format(agendamentoConfirmado.getItemAgendamento().getValor_itemIg()) %></span>
                    </li>
                </ul>
            </div>

            <div class="actions">
                <a href="cliente?action=home" class="btn btn-primary">
                    <i class="fas fa-home"></i> Ir para a Página Inicial
                </a>
                <a href="agendamento?action=verHistorico" class="btn btn-secondary">
                    <i class="fas fa-history"></i> Ver Meus Agendamentos
                </a>
            </div>
        </div>
    <% } %>

    </div>

</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>

<%
    // Recupera os dados enviados pelo AgendamentoController
    Corte corteSelecionado = (Corte) request.getAttribute("corteSelecionado");
    Barbeiro barbeiroSelecionado = (Barbeiro) request.getAttribute("barbeiroSelecionado");
    LocalDate dataSelecionada = (LocalDate) request.getAttribute("dataSelecionada");
    List<LocalDateTime> listaHorarios = (List<LocalDateTime>) request.getAttribute("listaHorarios");
    
    Cliente usuarioLogado = (Cliente) session.getAttribute("usuarioLogado");

    DateTimeFormatter formatoHora = DateTimeFormatter.ofPattern("HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamento: Passo 3 - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #F8F8F8; --dark-gray: #333333; --gold: #FFD700;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-gray); }
        .header { background: linear-gradient(135deg, var(--primary-red), var(--secondary-red)); color: var(--white); padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 1000; }
        .nav-container { max-width: 1200px; margin: 0 auto; padding: 0 2rem; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.8rem; font-weight: bold; color: var(--white); text-decoration: none; }
        .logo i { margin-right: 0.5rem; color: var(--gold); }
        .user-info { display: flex; align-items: center; gap: 1rem; }
        .user-avatar { width: 40px; height: 40px; background: var(--gold); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--dark-gray); font-weight: bold; font-size: 1.2rem; }
        .btn-logout { background: transparent; border: 2px solid var(--white); color: var(--white); padding: 0.5rem 1rem; border-radius: 20px; text-decoration: none; font-weight: 600; }
        .main-container { max-width: 1200px; margin: 0 auto; padding: 2rem; }
        .page-header { text-align: center; margin-bottom: 2rem; }
        .page-title { font-size: 2.5rem; color: var(--primary-red); margin-bottom: 0.5rem; }
        .page-subtitle { color: var(--dark-gray); opacity: 0.8; }
        .progress-bar { display: flex; justify-content: space-between; margin-bottom: 3rem; position: relative; }
        .progress-bar::before { content: ''; position: absolute; top: 50%; left: 0; right: 0; height: 4px; background: #e0e0e0; z-index: 1; }
        .progress-line { position: absolute; top: 50%; left: 0; height: 4px; background: var(--primary-red); width: 66%; z-index: 2; transition: width 0.5s ease;}
        .progress-step { display: flex; flex-direction: column; align-items: center; z-index: 3; text-align: center; width: 100px; }
        .step-circle { width: 40px; height: 40px; border-radius: 50%; background: #e0e0e0; display: flex; align-items: center; justify-content: center; font-weight: bold; color: var(--dark-gray); margin-bottom: 0.5rem; border: 4px solid var(--light-gray); }
        .step-label { font-weight: 600; color: var(--dark-gray); opacity: 0.6; }
        .progress-step.completed .step-circle { background: var(--primary-red); color: var(--white); }
        .progress-step.active .step-circle { background: var(--primary-red); color: var(--white); border-color: var(--secondary-red); }
        .progress-step.active .step-label { opacity: 1; }
        .content-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 2rem; }
        .summary-panel { background: var(--white); border-radius: 15px; padding: 2rem; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .summary-title { font-size: 1.5rem; color: var(--primary-red); margin-bottom: 1.5rem; border-bottom: 2px solid #eee; padding-bottom: 1rem; }
        .summary-list { list-style: none; display: flex; flex-direction: column; gap: 1rem; }
        .summary-item { display: flex; justify-content: space-between; }
        .summary-label { font-weight: 600; opacity: 0.7; }
        .summary-value { font-weight: bold; }
        .btn-back { display: inline-block; margin-top: 2rem; text-decoration: none; color: var(--primary-red); font-weight: bold; }
        .horarios-panel { background: var(--white); border-radius: 15px; padding: 2rem; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .date-selector { display: flex; gap: 1rem; align-items: center; margin-bottom: 2rem; }
        .date-selector label { font-weight: bold; }
        .date-selector input[type="date"] { padding: 0.8rem; border-radius: 8px; border: 2px solid #eee; font-size: 1rem; }
        .horarios-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 1rem; }
        .horario-btn { background: var(--light-gray); border: 2px solid #eee; color: var(--dark-gray); padding: 1rem; border-radius: 8px; text-align: center; text-decoration: none; font-weight: bold; transition: all 0.3s ease; }
        .horario-btn:hover { background: var(--primary-red); color: var(--white); border-color: var(--primary-red); }
        .empty-state { text-align: center; padding: 2rem; }
        @media (max-width: 992px) { .content-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
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

    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Novo Agendamento</h1>
            <p class="page-subtitle">Escolha o melhor dia e horário para você.</p>
        </div>

        <div class="progress-bar">
            <div class="progress-step completed"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Serviço</div></div>
            <div class="progress-step completed"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Barbeiro</div></div>
            <div class="progress-step active"><div class="step-circle">3</div><div class="step-label">Horário</div></div>
            <div class="progress-step"><div class="step-circle">4</div><div class="step-label">Confirmar</div></div>
        </div>

        <div class="content-grid">
            <aside class="summary-panel">
                <h2 class="summary-title">Resumo</h2>
                <ul class="summary-list">
                    <li class="summary-item">
                        <span class="summary-label">Serviço:</span>
                        <span class="summary-value"><%= (corteSelecionado != null) ? corteSelecionado.getNome_corte() : "N/A" %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label">Barbeiro:</span>
                        <span class="summary-value"><%= (barbeiroSelecionado != null) ? barbeiroSelecionado.getNome() : "N/A" %></span>
                    </li>
                </ul>
                <a href="especialidade?action=listarBarbeirosPorCorte&id_corte=<%= (corteSelecionado != null) ? corteSelecionado.getId_corte() : "" %>" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Voltar
                </a>
            </aside>

            <main class="horarios-panel">
                <form id="dateForm" action="agendamento" method="get">
                    <input type="hidden" name="action" value="passo3">
                    <input type="hidden" name="id_corte" value="<%= (corteSelecionado != null) ? corteSelecionado.getId_corte() : "" %>">
                    <input type="hidden" name="cpf_barbeiro" value="<%= (barbeiroSelecionado != null) ? barbeiroSelecionado.getCpf() : "" %>">
                    <div class="date-selector">
                        <label for="data">Escolha uma data:</label>
                        <input type="date" id="data" name="data" value="<%= (dataSelecionada != null) ? dataSelecionada.toString() : "" %>" min="<%= LocalDate.now().toString() %>" onchange="document.getElementById('dateForm').submit();">
                    </div>
                </form>

                <div class="horarios-grid">
                    <%
                        if (listaHorarios != null && !listaHorarios.isEmpty()) {
                            for (LocalDateTime horario : listaHorarios) {
                                String url = String.format("agendamento?action=passo4&id_corte=%d&cpf_barbeiro=%s&data_hora=%s",
                                    corteSelecionado.getId_corte(), barbeiroSelecionado.getCpf(), horario.toString());
                    %>
                                <a href="<%= url %>" class="horario-btn"><%= horario.format(formatoHora) %></a>
                    <%
                            }
                        } else {
                    %>
                        <div class="empty-state">
                            <p>Não há horários disponíveis para esta data. Por favor, selecione outro dia.</p>
                        </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>
</body>
</html>


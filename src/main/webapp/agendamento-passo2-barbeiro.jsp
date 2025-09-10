<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Barbeiro" %>
<%@ page import="br.com.Barbearia.model.Corte" %>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // Recupera os dados enviados pelo EspecialidadeController
    Corte corteSelecionado = (Corte) request.getAttribute("corteSelecionado");
    List<Barbeiro> listaBarbeiros = (List<Barbeiro>) request.getAttribute("listaBarbeiros");
    Cliente usuarioLogado = (Cliente) session.getAttribute("usuarioLogado");

    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamento: Passo 2 - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Estilos Globais e Variáveis */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #F8F8F8; --dark-gray: #333333; --gold: #FFD700;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-gray); }

        /* Header (mesmo padrão das outras páginas) */
        .header { background: linear-gradient(135deg, var(--primary-red), var(--secondary-red)); color: var(--white); padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 1000; }
        .nav-container { max-width: 1200px; margin: 0 auto; padding: 0 2rem; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.8rem; font-weight: bold; color: var(--white); text-decoration: none; }
        .logo i { margin-right: 0.5rem; color: var(--gold); }
        .user-info { display: flex; align-items: center; gap: 1rem; }
        .user-avatar { width: 40px; height: 40px; background: var(--gold); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--dark-gray); font-weight: bold; font-size: 1.2rem; }
        .btn-logout { background: transparent; border: 2px solid var(--white); color: var(--white); padding: 0.5rem 1rem; border-radius: 20px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; }
        .btn-logout:hover { background: var(--white); color: var(--primary-red); }
        
        /* Conteúdo Principal e Barra de Progresso */
        .main-container { max-width: 1200px; margin: 0 auto; padding: 2rem; }
        .page-header { text-align: center; margin-bottom: 2rem; }
        .page-title { font-size: 2.5rem; color: var(--primary-red); margin-bottom: 0.5rem; }
        .page-subtitle { color: var(--dark-gray); opacity: 0.8; }
        .progress-bar { display: flex; justify-content: space-between; margin-bottom: 3rem; position: relative; }
        .progress-bar::before { content: ''; position: absolute; top: 50%; left: 0; right: 0; height: 4px; background: #e0e0e0; transform: translateY(-50%); z-index: 1; }
        .progress-line { position: absolute; top: 50%; left: 0; height: 4px; background: var(--primary-red); transform: translateY(-50%); width: 33%; z-index: 2; transition: width 0.5s ease; }
        .progress-step { display: flex; flex-direction: column; align-items: center; z-index: 3; text-align: center; width: 100px; }
        .step-circle { width: 40px; height: 40px; border-radius: 50%; background: #e0e0e0; display: flex; align-items: center; justify-content: center; font-weight: bold; color: var(--dark-gray); margin-bottom: 0.5rem; border: 4px solid var(--light-gray); transition: all 0.5s ease; }
        .step-label { font-weight: 600; color: var(--dark-gray); opacity: 0.6; }
        .progress-step.completed .step-circle { background: var(--primary-red); color: var(--white); }
        .progress-step.active .step-circle { background: var(--primary-red); color: var(--white); border-color: var(--secondary-red); }
        .progress-step.active .step-label { opacity: 1; }

        /* Resumo do Serviço */
        .service-summary { background: var(--white); border-radius: 15px; padding: 1.5rem 2rem; margin-bottom: 2rem; box-shadow: 0 5px 15px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
        .summary-info h3 { font-size: 1.5rem; color: var(--primary-red); }
        .summary-info p { color: var(--dark-gray); opacity: 0.8; }
        .btn-change { background: transparent; border: 2px solid #ddd; color: var(--dark-gray); padding: 0.5rem 1rem; text-decoration: none; border-radius: 20px; font-weight: 600; }
        .btn-change:hover { border-color: var(--dark-gray); }

        /* Grid de Barbeiros */
        .barbers-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; }
        .barber-card { background: var(--white); border-radius: 15px; text-align: center; padding: 2rem; box-shadow: 0 5px 15px rgba(0,0,0,0.05); text-decoration: none; color: var(--dark-gray); transition: all 0.3s ease; }
        .barber-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .barber-avatar { width: 100px; height: 100px; border-radius: 50%; margin: 0 auto 1rem; background: var(--primary-red); display: flex; align-items: center; justify-content: center; font-size: 3rem; color: var(--gold); }
        .barber-name { font-size: 1.3rem; font-weight: bold; margin-bottom: 0.5rem; }
        .barber-rating { color: var(--gold); margin-bottom: 1rem; }
        .btn-select-barber { background: var(--primary-red); color: var(--white); padding: 0.8rem 1.5rem; border-radius: 8px; text-decoration: none; display: inline-block; }

        .empty-state { text-align: center; padding: 2rem; }
    </style>
</head>
<body>
    <header class="header">
        <div class="nav-container">
            <a href="cliente?action=home" class="logo"><i class="fas fa-cut"></i> Barbearia Premium</a>
            <% if (usuarioLogado != null) { %>
                <div class="user-info">
                    <div class="user-avatar"><%= usuarioLogado.getNome().charAt(0) %></div>
                    <a href="cliente?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
                </div>
            <% } %>
        </div>
    </header>

    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Novo Agendamento</h1>
            <p class="page-subtitle">Agora, escolha o seu profissional preferido.</p>
        </div>

        <div class="progress-bar">
            <div class="progress-line"></div>
            <div class="progress-step completed">
                <div class="step-circle"><i class="fas fa-check"></i></div>
                <div class="step-label">Serviço</div>
            </div>
            <div class="progress-step active">
                <div class="step-circle">2</div>
                <div class="step-label">Barbeiro</div>
            </div>
            <div class="progress-step">
                <div class="step-circle">3</div>
                <div class="step-label">Horário</div>
            </div>
            <div class="progress-step">
                <div class="step-circle">4</div>
                <div class="step-label">Confirmar</div>
            </div>
        </div>

        <% if (corteSelecionado != null) { %>
            <div class="service-summary">
                <div class="summary-info">
                    <h3><%= corteSelecionado.getNome_corte() %></h3>
                    <p>Duração: <%= corteSelecionado.getDuracao() %> min | Valor: <%= formatoMoeda.format(corteSelecionado.getValor_corte()) %></p>
                </div>
                <a href="corte?action=listarParaAgendamento" class="btn-change">
                    <i class="fas fa-exchange-alt"></i> Trocar Serviço
                </a>
            </div>
        <% } %>

        <div class="barbers-grid">
            <%
                if (listaBarbeiros != null && !listaBarbeiros.isEmpty()) {
                    for (Barbeiro b : listaBarbeiros) {
            %>
                        <!-- CORREÇÃO APLICADA AQUI: action=passo3 -->
                        <a href="agendamento?action=passo3&id_corte=<%= corteSelecionado.getId_corte() %>&cpf_barbeiro=<%= b.getCpf() %>" class="barber-card">
                            <div class="barber-avatar">
                                <i class="fas fa-user-tie"></i>
                            </div>
                            <h3 class="barber-name"><%= b.getNome() %></h3>
                            <div class="barber-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                            <span class="btn-select-barber">Selecionar</span>
                        </a>
            <%
                    }
                } else {
            %>
                <div class="empty-state">
                    <h3>Nenhum barbeiro encontrado</h3>
                    <p>Não há barbeiros disponíveis para este serviço no momento.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>


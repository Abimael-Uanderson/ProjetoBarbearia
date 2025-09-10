<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.Barbearia.dao.CorteDAO" %>
<%@ page import="br.com.Barbearia.dao.BarbeiroDAO" %>
<%@ page import="br.com.Barbearia.model.Corte" %>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<%@ page import="br.com.Barbearia.model.Barbeiro" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>

<%
    // Recupera os parâmetros da URL
    String idCorteParam = request.getParameter("id_corte");
    String cpfBarbeiro = request.getParameter("cpf_barbeiro");
    String dataHoraParam = request.getParameter("data_hora");

    Corte corteSelecionado = null;
    Barbeiro barbeiroSelecionado = null;
    LocalDateTime dataHoraSelecionada = null;

    // Validação e busca dos dados no banco
    if (idCorteParam != null && cpfBarbeiro != null && dataHoraParam != null) {
        try {
            int idCorte = Integer.parseInt(idCorteParam);
            
            // Instancia os DAOs para buscar os detalhes
            CorteDAO corteDAO = new CorteDAO();
            BarbeiroDAO barbeiroDAO = new BarbeiroDAO();

            corteSelecionado = corteDAO.buscarPorId(idCorte);
            barbeiroSelecionado = barbeiroDAO.buscarPorCpf(cpfBarbeiro);
            dataHoraSelecionada = LocalDateTime.parse(dataHoraParam);

        } catch (Exception e) {
            // Lida com possíveis erros (ex: ID inválido)
            e.printStackTrace();
            // Futuramente, redirecionar para uma página de erro
        }
    }
    
    // Recupera o cliente logado da sessão
    Cliente usuarioLogado = (Cliente) session.getAttribute("usuarioLogado");

    // Formatadores
    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
    DateTimeFormatter formatoDataExtenso = DateTimeFormatter.ofPattern("EEEE, dd 'de' MMMM 'de' yyyy", new Locale("pt", "BR"));
    DateTimeFormatter formatoHoraMinuto = DateTimeFormatter.ofPattern("HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamento: Passo 4 - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Estilos Globais, Variáveis e Header (mesmo padrão) */
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
        .btn-logout { background: transparent; border: 2px solid var(--white); color: var(--white); padding: 0.5rem 1rem; border-radius: 20px; text-decoration: none; font-weight: 600; transition: all 0.3s ease; }
        .btn-logout:hover { background: var(--white); color: var(--primary-red); }
        
        /* Conteúdo Principal */
        .main-container { max-width: 900px; margin: 0 auto; padding: 2rem; }
        .page-header { text-align: center; margin-bottom: 2rem; }
        .page-title { font-size: 2.5rem; color: var(--primary-red); margin-bottom: 0.5rem; }
        .page-subtitle { color: var(--dark-gray); opacity: 0.8; }

        /* Barra de Progresso */
        .progress-bar { display: flex; justify-content: space-between; margin-bottom: 3rem; position: relative; }
        .progress-bar::before, .progress-line { content: ''; position: absolute; top: 50%; left: 0; height: 4px; transform: translateY(-50%); }
        .progress-bar::before { right: 0; background: #e0e0e0; z-index: 1; }
        .progress-line { background: var(--primary-red); width: 0%; z-index: 2; transition: width 0.5s ease; }
        .progress-step { display: flex; flex-direction: column; align-items: center; z-index: 3; text-align: center; width: 100px; }
        .step-circle { width: 40px; height: 40px; border-radius: 50%; background: #e0e0e0; display: flex; align-items: center; justify-content: center; font-weight: bold; color: var(--dark-gray); margin-bottom: 0.5rem; border: 4px solid var(--light-gray); transition: all 0.5s ease; }
        .step-label { font-weight: 600; color: var(--dark-gray); opacity: 0.6; }
        .progress-step.completed .step-circle, .progress-step.active .step-circle { background: var(--primary-red); color: var(--white); border-color: var(--secondary-red); }
        .progress-step.completed .step-label, .progress-step.active .step-label { opacity: 1; }
        
        /* Card de Confirmação */
        .confirmation-card {
            background: var(--white); border-radius: 15px; padding: 2rem;
            box-shadow: 0 5px 25px rgba(0,0,0,0.1);
        }
        .confirmation-header h2 {
            font-size: 1.5rem; color: var(--primary-red); text-align: center;
            margin-bottom: 2rem;
        }
        .summary-list {
            list-style: none; margin-bottom: 2rem;
        }
        .summary-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 1rem 0; border-bottom: 1px solid #eee;
        }
        .summary-item:last-child { border-bottom: none; }
        .summary-label { font-weight: 600; color: var(--dark-gray); display: flex; align-items: center; gap: 0.5rem; }
        .summary-value { font-weight: 500; text-align: right; }
        .summary-value.highlight { font-weight: bold; color: var(--primary-red); font-size: 1.2rem; }

        /* Botões de Ação */
        .action-buttons {
            display: flex; gap: 1rem; margin-top: 1rem;
        }
        .btn {
            flex: 1; padding: 1rem; border-radius: 10px; font-weight: 600;
            cursor: pointer; transition: all 0.3s ease; text-decoration: none;
            font-size: 1.1rem; text-align: center; border: none;
            display: inline-flex; align-items: center; justify-content: center; gap: 0.5rem;
        }
        .btn-confirm { background: var(--primary-red); color: var(--white); }
        .btn-confirm:hover { background: var(--dark-red); }
        .btn-back {
            background: var(--light-gray); color: var(--dark-gray);
            border: 2px solid #eee;
        }
        .btn-back:hover { background: #eee; }
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
                    <a href="cliente?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
                </div>
            <% } %>
        </div>
    </header>

    <!-- Conteúdo Principal -->
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Novo Agendamento</h1>
            <p class="page-subtitle">Revise os detalhes e confirme o seu agendamento.</p>
        </div>

        <!-- Barra de Progresso -->
        <div class="progress-bar">
            <div class="progress-line" id="progressLine"></div>
            <div class="progress-step completed"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Serviço</div></div>
            <div class="progress-step completed"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Barbeiro</div></div>
            <div class="progress-step completed"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Horário</div></div>
            <div class="progress-step active"><div class="step-circle">4</div><div class="step-label">Confirmar</div></div>
        </div>
        
        <% if (corteSelecionado != null && barbeiroSelecionado != null && dataHoraSelecionada != null) { %>
            <div class="confirmation-card">
                <div class="confirmation-header">
                    <h2>Resumo do Agendamento</h2>
                </div>
                
                <ul class="summary-list">
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-calendar-day"></i> Data</span>
                        <span class="summary-value"><%= dataHoraSelecionada.format(formatoDataExtenso) %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-clock"></i> Horário</span>
                        <span class="summary-value"><%= dataHoraSelecionada.format(formatoHoraMinuto) %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-cut"></i> Serviço</span>
                        <span class="summary-value"><%= corteSelecionado.getNome_corte() %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-user-tie"></i> Profissional</span>
                        <span class="summary-value"><%= barbeiroSelecionado.getNome() %></span>
                    </li>
                    <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-stopwatch"></i> Duração</span>
                        <span class="summary-value"><%= corteSelecionado.getDuracao() %> minutos</span>
                    </li>
                     <li class="summary-item">
                        <span class="summary-label"><i class="fas fa-dollar-sign"></i> Valor</span>
                        <span class="summary-value highlight"><%= formatoMoeda.format(corteSelecionado.getValor_corte()) %></span>
                    </li>
                </ul>
                
                <!-- Formulário de Confirmação -->
                <form action="agendamento" method="POST">
                    <input type="hidden" name="action" value="cadastrar">
                    <input type="hidden" name="id_corte" value="<%= corteSelecionado.getId_corte() %>">
                    <input type="hidden" name="cpf_barbeiro" value="<%= barbeiroSelecionado.getCpf() %>">
                    <input type="hidden" name="data_hora" value="<%= dataHoraSelecionada.toString() %>">
                    
                    <div class="action-buttons">
                        <%
                            // Link para voltar para a seleção de horário
                            String linkVoltar = String.format(
                                "agendamento?action=verificarHorarios&id_corte=%d&cpf_barbeiro=%s&data=%s",
                                corteSelecionado.getId_corte(),
                                barbeiroSelecionado.getCpf(),
                                dataHoraSelecionada.toLocalDate().toString()
                            );
                        %>
                        <a href="<%= linkVoltar %>" class="btn btn-back">
                            <i class="fas fa-arrow-left"></i> Voltar
                        </a>
                        <button type="submit" class="btn btn-confirm">
                            <i class="fas fa-check-circle"></i> Confirmar Agendamento
                        </button>
                    </div>
                </form>
            </div>
        <% } else { %>
            <div class="empty-state">
                 <h3>Erro ao carregar os detalhes</h3>
                 <p>Não foi possível carregar os detalhes do agendamento. Por favor, tente novamente.</p>
                 <a href="corte?action=listarParaAgendamento" class="btn-back">Voltar ao Início do Agendamento</a>
            </div>
        <% } %>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const progressLine = document.getElementById('progressLine');
            // Como estamos no passo 4 de 4, a barra fica 100% preenchida
            setTimeout(() => {
                 progressLine.style.width = '100%'; 
            }, 100);
        });
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Agendamento" %>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.LocalDate" %>

<%
    // Verificação de segurança para o utilizador logado
    Cliente usuarioLogado = null;
    if (session.getAttribute("usuarioLogado") instanceof Cliente) {
        usuarioLogado = (Cliente) session.getAttribute("usuarioLogado");
    }

    List<Agendamento> agendamentos = (List<Agendamento>) request.getAttribute("listaAgendamentos");
    String msg = request.getParameter("msg");

    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
    DateTimeFormatter formatoDataExtenso = DateTimeFormatter.ofPattern("dd 'de' MMMM 'de' yyyy", new Locale("pt", "BR"));
    DateTimeFormatter formatoHora = DateTimeFormatter.ofPattern("HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Agendamentos - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #F8F8F8; --dark-gray: #333333; --gold: #FFD700;
            --success-green: #00b894; --warning-orange: #fdcb6e; --danger-red: #d63031;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-gray); }
        .header { background: linear-gradient(135deg, var(--primary-red), var(--secondary-red)); color: var(--white); padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 1000; }
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
        .main-container { max-width: 1200px; margin: 0 auto; padding: 2rem; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .page-title h1 { font-size: 2.5rem; color: var(--primary-red); }
        .btn { padding: 0.8rem 1.5rem; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 0.5rem; text-decoration: none; font-size: 0.9rem; }
        .btn-primary { background: var(--primary-red); color: var(--white); border:none; }
        .btn-primary:hover { background: var(--dark-red); transform: translateY(-2px); }
        .btn-secondary { background: transparent; border: 2px solid #ddd; color: var(--dark-gray); }
        .btn-danger { background: transparent; border: 2px solid var(--danger-red); color: var(--danger-red); }
        .status-tabs { display: flex; background: var(--white); border-radius: 15px; padding: 0.5rem; margin-bottom: 2rem; box-shadow: 0 5px 15px rgba(0,0,0,0.05); gap: 0.5rem; }
        .tab-button { flex: 1; padding: 1rem; background: transparent; border: none; border-radius: 10px; cursor: pointer; font-weight: 600; transition: all 0.3s ease; color: var(--dark-gray); }
        .tab-button.active { background: var(--primary-red); color: var(--white); }
        .tab-button:hover:not(.active) { background: var(--light-gray); }
        .appointments-list { display: flex; flex-direction: column; gap: 1.5rem; }
        .appointment-card { background: var(--white); border-radius: 15px; padding: 2rem; box-shadow: 0 5px 15px rgba(0,0,0,0.05); display: none; }
        .appointment-card.show { display: block; animation: fadeIn 0.5s ease; }
        .appointment-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem; }
        .appointment-info h2 { font-size: 1.5rem; color: var(--dark-gray); margin-bottom: 0.25rem; }
        .appointment-info p { color: var(--dark-gray); opacity: 0.7; }
        .appointment-status { padding: 0.5rem 1rem; border-radius: 20px; font-size: 0.8rem; font-weight: bold; text-transform: uppercase; }
        .status-AGENDADO { background: #e8f5e8; color: var(--success-green); }
        .status-CONCLUIDO { background: #f0f0f0; color: var(--dark-gray); }
        .status-CANCELADO { background: #ffe6e6; color: var(--danger-red); }
        .appointment-details { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; padding-top: 1.5rem; border-top: 1px solid #eee; }
        .detail-item { display: flex; flex-direction: column; gap: 0.3rem; }
        .detail-label { font-size: 0.8rem; color: var(--dark-gray); opacity: 0.6; text-transform: uppercase; }
        .detail-value { font-weight: 600; }
        .appointment-actions { margin-top: 1.5rem; display: flex; gap: 1rem; }
        .empty-state { text-align: center; padding: 4rem 2rem; background: var(--white); border-radius: 15px; display: none; }
        .empty-state.show { display: block; }
        .empty-state i { font-size: 4rem; color: var(--primary-red); opacity: 0.5; margin-bottom: 1rem; }
        .empty-state h3 { font-size: 1.5rem; margin-bottom: 1rem; }
        .empty-state p { opacity: 0.7; margin-bottom: 2rem; }
        .alert { padding: 1rem; border-radius: 10px; margin-bottom: 2rem; font-weight: 600; }
        .alert-success { background: #e8f5e8; color: #00b894; border: 1px solid #a8e6cf; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <header class="header">
        <div class="nav-container">
            <a href="cliente?action=home" class="logo"><i class="fas fa-cut"></i> Barbearia Premium</a>
            <% if (usuarioLogado != null) { %>
            <nav class="nav-menu">
                <a href="cliente?action=home"><i class="fas fa-home"></i> Início</a>
                <a href="corte?action=listarParaAgendamento"><i class="fas fa-calendar-plus"></i> Agendar</a>
                <a href="agendamento?action=verHistorico" class="active"><i class="fas fa-history"></i> Histórico</a>
                <a href="cliente?action=verPerfil"><i class="fas fa-user"></i> Perfil</a>
            </nav>
            <div class="user-info">
                <div class="user-avatar"><%= usuarioLogado.getNome().charAt(0) %></div>
                <span class="user-name"><%= usuarioLogado.getNome().split(" ")[0] %></span>
                <a href="cliente?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
            </div>
            <% } %>
        </div>
    </header>

    <div class="main-container">
        <div class="page-header">
            <div class="page-title">
                <h1>Meus Agendamentos</h1>
            </div>
            <a href="corte?action=listarParaAgendamento" class="btn btn-primary">
                <i class="fas fa-calendar-plus"></i> Novo Agendamento
            </a>
        </div>
        
        <% if ("cancelado".equals(msg)) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Agendamento cancelado com sucesso!
            </div>
        <% } %>

        <div class="status-tabs">
            <button type="button" class="tab-button active" data-status="todos">Todos</button>
            <button type="button" class="tab-button" data-status="proximos">Próximos</button>
            <button type="button" class="tab-button" data-status="concluidos">Concluídos</button>
            <button type="button" class="tab-button" data-status="cancelados">Cancelados</button>
        </div>

        <div class="appointments-list">
            <%
                if (agendamentos != null && !agendamentos.isEmpty()) {
                    for (Agendamento ag : agendamentos) {
                        String status = (ag.getStatus_agendamentoAg() != null) ? ag.getStatus_agendamentoAg().toUpperCase() : "N/A";
                        boolean isFuturo = (ag.getData_atendimentoAg() != null) && ag.getData_atendimentoAg().toLocalDate().isAfter(LocalDate.now().minusDays(1));
            %>
            <div class="appointment-card" data-status="<%= status %>" data-futuro="<%= isFuturo %>">
                <form action="agendamento" method="post" onsubmit="return confirm('Tem certeza que deseja cancelar este agendamento?');">
                    <input type="hidden" name="action" value="cancelar">
                    <input type="hidden" name="id_agendamento" value="<%= ag.getId_agendamentoAg() %>">

                    <div class="appointment-header">
                        <div class="appointment-info">
                            <h2><%= ag.getNomeServico() != null ? ag.getNomeServico() : "Serviço não informado" %></h2>
                            <p><%= ag.getData_atendimentoAg() != null ? ag.getData_atendimentoAg().format(formatoDataExtenso) + " às " + ag.getData_atendimentoAg().format(formatoHora) : "Data não informada" %></p>
                        </div>
                        <div class="appointment-status status-<%= status %>"><%= status %></div>
                    </div>
                    <div class="appointment-details">
                        <div class="detail-item">
                            <span class="detail-label">Barbeiro</span>
                            <span class="detail-value"><%= (ag.getBarbeiro() != null && ag.getBarbeiro().getNome() != null) ? ag.getBarbeiro().getNome() : "N/A" %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Duração</span>
                            <span class="detail-value"><%= ag.getDuracao_totalAg() %> min</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Valor</span>
                            <span class="detail-value"><%= (ag.getItemAgendamento() != null && ag.getItemAgendamento().getValor_itemIg() != null) ? formatoMoeda.format(ag.getItemAgendamento().getValor_itemIg()) : "N/A" %></span>
                        </div>
                    </div>
                    <% if (status.equals("AGENDADO") && isFuturo) { %>
                    <div class="appointment-actions">
                        <button type="button" class="btn btn-secondary" onclick="alert('Funcionalidade de reagendamento em desenvolvimento.');">Reagendar</button>
                        <button type="submit" class="btn btn-danger">Cancelar</button>
                    </div>
                    <% } %>
                </form>
            </div>
            <%
                    } // Fim do for
                }
            %>
        </div>
        
        <div class="empty-state">
            <i class="fas fa-calendar-times"></i>
            <h3>Nenhum agendamento encontrado</h3>
            <p>Não há agendamentos que correspondam a este filtro.</p>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const tabs = document.querySelectorAll('.tab-button');
            const cards = document.querySelectorAll('.appointment-card');
            const emptyState = document.querySelector('.empty-state');
            
            function filterAppointments(status) {
                let hasVisibleCard = false;
                
                cards.forEach(card => {
                    const cardStatus = card.getAttribute('data-status');
                    const cardIsFuturo = card.getAttribute('data-futuro') === 'true';
                    
                    let show = false;
                    switch(status) {
                        case 'todos': show = true; break;
                        case 'proximos': show = cardStatus === 'AGENDADO' && cardIsFuturo; break;
                        case 'concluidos': show = cardStatus === 'CONCLUIDO' || (cardStatus === 'AGENDADO' && !cardIsFuturo); break;
                        case 'cancelados': show = cardStatus === 'CANCELADO'; break;
                    }
                    
                    if (show) {
                        card.classList.add('show');
                        hasVisibleCard = true;
                    } else {
                        card.classList.remove('show');
                    }
                });

                if (hasVisibleCard) {
                    emptyState.classList.remove('show');
                } else {
                    emptyState.classList.add('show');
                }
            }

            tabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    tabs.forEach(t => t.classList.remove('active'));
                    tab.classList.add('active');
                    filterAppointments(tab.getAttribute('data-status'));
                });
            });

            if (cards.length === 0) {
                 emptyState.classList.add('show');
                 emptyState.querySelector('p').textContent = 'Você ainda não fez nenhum agendamento.';
                 const newButton = document.createElement('a');
                 newButton.href = 'corte?action=listarParaAgendamento';
                 newButton.className = 'btn btn-primary';
                 newButton.style.marginTop = '1rem';
                 newButton.innerHTML = '<i class="fas fa-calendar-plus"></i> Agendar Agora';
                 emptyState.appendChild(newButton);
            } else {
                filterAppointments('todos');
            }
        });
    </script>
</body>
</html>


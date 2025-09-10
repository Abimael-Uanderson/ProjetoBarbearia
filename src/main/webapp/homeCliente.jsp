<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Agendamento" %>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.LocalDate" %>

<%
    // Recupera os dados enviados pelo ClienteController
    Cliente usuarioLogado = (Cliente) session.getAttribute("usuarioLogado");
    List<Agendamento> agendamentos = (List<Agendamento>) request.getAttribute("listaAgendamentos");

    // Prepara o formato dos dados para o JavaScript
    // Vamos criar uma string no formato JSON para ser lida pelo script da página
    StringBuilder jsonAgendamentos = new StringBuilder("[");
    if (agendamentos != null) {
        for (int i = 0; i < agendamentos.size(); i++) {
            Agendamento ag = agendamentos.get(i);
            jsonAgendamentos.append("{");
            jsonAgendamentos.append("\"id\":").append(ag.getId_agendamentoAg()).append(",");
            jsonAgendamentos.append("\"data\":\"").append(ag.getData_atendimentoAg().toLocalDate().toString()).append("\",");
            jsonAgendamentos.append("\"hora\":\"").append(ag.getData_atendimentoAg().toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"))).append("\",");
            jsonAgendamentos.append("\"servico\":\"").append(ag.getNomeServico() != null ? ag.getNomeServico().replace("\"", "\\\"") : "Serviço não informado").append("\",");
            jsonAgendamentos.append("\"barbeiro\":\"").append(ag.getBarbeiro() != null ? ag.getBarbeiro().getNome().replace("\"", "\\\"") : "N/A").append("\",");
            jsonAgendamentos.append("\"valor\":").append(ag.getItemAgendamento() != null && ag.getItemAgendamento().getValor_itemIg() != null ? ag.getItemAgendamento().getValor_itemIg() : 0.0).append(",");
            jsonAgendamentos.append("\"status\":\"").append(ag.getStatus_agendamentoAg()).append("\"");
            jsonAgendamentos.append("}");
            if (i < agendamentos.size() - 1) {
                jsonAgendamentos.append(",");
            }
        }
    }
    jsonAgendamentos.append("]");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Início - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #f8f9fa; --dark-gray: #343a40;
            --gold: #FFD700; --green: #1cc88a; --blue: #4e73df; --orange: #f6c23e; --red: #e74a3b;
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
        .main-container { max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }
        .welcome-header { margin-bottom: 2rem; }
        .welcome-header h1 { font-size: 2.5rem; color: var(--primary-red); }
        .welcome-header p { font-size: 1.1rem; opacity: 0.8; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }
        .stat-card { background: var(--white); border-radius: 15px; padding: 1.5rem; box-shadow: 0 5px 25px rgba(0,0,0,0.08); display: flex; align-items: center; gap: 1.5rem; }
        .stat-card .icon { font-size: 2.5rem; padding: 1rem; border-radius: 50%; color: var(--white); }
        .stat-card .icon.green { background: var(--green); }
        .stat-card .icon.blue { background: var(--blue); }
        .stat-card .icon.orange { background: var(--orange); }
        .stat-card .info .title { font-size: 0.9rem; text-transform: uppercase; font-weight: 600; opacity: 0.7; }
        .stat-card .info .value { font-size: 1.8rem; font-weight: bold; color: var(--primary-red); }
        /* CORREÇÃO: Proporção do grid ajustada */
        .main-content { display: grid; grid-template-columns: 1.5fr 1fr; gap: 2rem; }
        .chart-container, .activity-feed { background: var(--white); height: 350px; border-radius: 15px; padding: 2rem; box-shadow: 0 5px 25px rgba(0,0,0,0.08); }
        .section-title { font-size: 1.5rem; color: var(--primary-red); margin-bottom: 1.5rem; }
        .activity-list { display: flex; flex-direction: column; gap: 1.5rem; }
        .activity-item { display: flex; align-items: center; gap: 1rem; }
        .activity-icon { width: 45px; height: 45px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--white); font-size: 1.2rem; }
        .activity-icon.AGENDADO { background-color: var(--blue); }
        .activity-icon.CONCLUIDO { background-color: var(--green); }
        .activity-icon.CANCELADO { background-color: var(--red); }
        .activity-content .title { font-weight: 600; }
        .activity-content .details { font-size: 0.9rem; opacity: 0.7; }
        .empty-state { text-align: center; padding: 2rem; }
        @media (max-width: 992px) { .main-content { grid-template-columns: 1fr; } }
        @media (max-width: 768px) { .nav-menu { display: none; } .stats-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <%
        String primeiroNome = "Visitante";
        if (usuarioLogado != null && usuarioLogado.getNome() != null) {
            primeiroNome = usuarioLogado.getNome().split(" ")[0];
        }
    %>

    <!-- Cabeçalho -->
    <header class="header">
        <div class="nav-container">
            <a href="cliente?action=home" class="logo"><i class="fas fa-cut"></i> Barbearia Premium</a>
            <% if (usuarioLogado != null) { %>
            <nav class="nav-menu">
                <a href="cliente?action=home" class="active"><i class="fas fa-home"></i> Início</a>
                <a href="corte?action=listarParaAgendamento"><i class="fas fa-calendar-plus"></i> Agendar</a>
                <a href="agendamento?action=verHistorico"><i class="fas fa-history"></i> Histórico</a>
                <a href="cliente?action=verPerfil"><i class="fas fa-user"></i> Perfil</a>
            </nav>
            <div class="user-info">
                <div class="user-avatar"><%= primeiroNome.charAt(0) %></div>
                <span class="user-name"><%= primeiroNome %></span>
                <a href="cliente?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
            </div>
            <% } %>
        </div>
    </header>

    <!-- Conteúdo Principal -->
    <main class="main-container">
        <div class="welcome-header">
            <h1>Olá, <%= primeiroNome %>!</h1>
            <p>Bem-vindo ao seu painel. Aqui está um resumo da sua atividade.</p>
        </div>

        <!-- Estatísticas -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="icon green"><i class="fas fa-calendar-check"></i></div>
                <div class="info">
                    <div class="title">Próximo Agendamento</div>
                    <div class="value" id="proximoAgendamento">--</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="icon blue"><i class="fas fa-history"></i></div>
                <div class="info">
                    <div class="title">Total de Agendamentos</div>
                    <div class="value" id="totalAgendamentos">0</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="icon orange"><i class="fas fa-dollar-sign"></i></div>
                <div class="info">
                    <div class="title">Total Gasto</div>
                    <div class="value" id="totalGasto">R$ 0,00</div>
                </div>
            </div>
        </div>

        <!-- Conteúdo Principal: Gráfico e Atividades -->
        <div class="main-content">
            <div class="chart-container">
                <h2 class="section-title">Agendamentos por Mês</h2>
                <canvas id="appointmentsChart"></canvas>
            </div>
            <div class="activity-feed">
                <h2 class="section-title">Atividade Recente</h2>
                <div class="activity-list" id="activityList">
                    <!-- Atividades recentes serão inseridas aqui pelo JavaScript -->
                </div>
            </div>
        </div>
    </main>
    
    <script>
        // --- PONTE ENTRE JAVA (JSP) E JAVASCRIPT ---
        const appointmentsData = <%= jsonAgendamentos.toString() %>;

        // --- LÓGICA DO JAVASCRIPT PARA RENDERIZAR A PÁGINA ---
        document.addEventListener('DOMContentLoaded', function() {
            if (appointmentsData && appointmentsData.length > 0) {
                processarDadosAgendamentos(appointmentsData);
            } else {
                exibirEstadoVazio();
            }
        });

        function processarDadosAgendamentos(data) {
            // Atualizar Estatísticas
            const totalAgendamentos = data.length;
            const totalGasto = data.filter(a => a.status.toUpperCase() === 'CONCLUIDO').reduce((sum, a) => sum + a.valor, 0);
            
            // CORREÇÃO: Lógica mais robusta para encontrar o próximo agendamento
            const hoje = new Date();
            hoje.setHours(0, 0, 0, 0); // Zera a hora para comparar apenas a data

            const proximoAgendamento = data
                .filter(a => {
                    const dataAgendamento = new Date(a.data + "T00:00:00"); // Assegura fuso horário local
                    return a.status.toUpperCase() === 'AGENDADO' && dataAgendamento >= hoje;
                })
                .sort((a, b) => {
                    return new Date(a.data + 'T' + a.hora) - new Date(b.data + 'T' + b.hora);
                })[0];
            
            document.getElementById('totalAgendamentos').textContent = totalAgendamentos;
            document.getElementById('totalGasto').textContent = `R$ ${totalGasto.toFixed(2).replace('.', ',')}`;
            
            if (proximoAgendamento) {
                // CORREÇÃO: Exibe a data e a hora do agendamento mais próximo
                const [ano, mes, dia] = proximoAgendamento.data.split('-');
                const dataProximo = new Date(ano, mes - 1, dia);
                const diaFormatado = dataProximo.toLocaleDateString('pt-BR', {day: '2-digit', month: 'short'});
                const hora = proximoAgendamento.hora;
                document.getElementById('proximoAgendamento').textContent = diaFormatado + ' às ' + hora;
            } else {
                 document.getElementById('proximoAgendamento').textContent = "Nenhum";
            }

            // Renderizar Atividades Recentes
            const activityList = document.getElementById('activityList');
            activityList.innerHTML = '';
            const recentes = data.slice(0, 4);
            
            recentes.forEach(ag => {
                const item = document.createElement('div');
                item.className = 'activity-item';
                
                const iconClass = getIconeAtividade(ag.status.toUpperCase());
                const titulo = getTituloAtividade(ag.status.toUpperCase(), ag.servico);
                const dataFormatada = new Date(ag.data).toLocaleString('pt-BR', {day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit'});

                item.innerHTML = 
                    '<div class="activity-icon ' + ag.status.toUpperCase() + '">' +
                        '<i class="fas ' + iconClass + '"></i>' +
                    '</div>' +
                    '<div class="activity-content">' +
                        '<div class="title">' + titulo + '</div>' +
                        '<div class="details">' + dataFormatada + '</div>' +
                    '</div>';
                activityList.appendChild(item);
            });
            
            // Renderizar Gráfico
            renderizarGrafico(data);
        }
        
        function exibirEstadoVazio() {
             document.getElementById('activityList').innerHTML = '<p class="empty-state">Nenhuma atividade recente encontrada.</p>';
             document.getElementById('proximoAgendamento').textContent = "Nenhum";
        }

        function getIconeAtividade(status) {
            if (status === 'CONCLUIDO') return 'fa-check';
            if (status === 'CANCELADO') return 'fa-times';
            return 'fa-calendar-alt'; // AGENDADO
        }

        function getTituloAtividade(status, servico) {
            if (status === 'CONCLUIDO') return `Serviço "${servico}" concluído`;
            if (status === 'CANCELADO') return `Agendamento de "${servico}" cancelado`;
            return `Novo agendamento: "${servico}"`;
        }

        function renderizarGrafico(data) {
            const ctx = document.getElementById('appointmentsChart').getContext('2d');
            const agendamentosPorMes = new Array(12).fill(0);
            
            data.forEach(ag => {
                const mes = new Date(ag.data).getMonth(); // 0 = Jan, 11 = Dez
                agendamentosPorMes[mes]++;
            });

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'],
                    datasets: [{
                        label: 'Nº de Agendamentos',
                        data: agendamentosPorMes,
                        backgroundColor: 'rgba(139, 0, 0, 0.7)',
                        borderColor: 'rgba(139, 0, 0, 1)',
                        borderWidth: 1,
                        borderRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        }
    </script>
</body>
</html>


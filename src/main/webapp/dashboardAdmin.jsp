<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Agendamento" %>
<%@ page import="br.com.Barbearia.model.Administrador" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>


<%
    Administrador admin = (Administrador) session.getAttribute("adminLogado");
    if (admin == null) {
        response.sendRedirect("admin");
        return;
    }

    List<Agendamento> agendamentos = (List<Agendamento>) request.getAttribute("listaAgendamentos");
    if (agendamentos == null) {
        agendamentos = new ArrayList<>();
    }
    
    // Recupera os dados das estatísticas e filtro
    Double faturamentoMes = (Double) request.getAttribute("faturamentoMes");
    Integer totalPendentes = (Integer) request.getAttribute("totalPendentes");
    Integer totalPagos = (Integer) request.getAttribute("totalPagos");
    Integer mesSelecionado = (Integer) request.getAttribute("mesSelecionado");
    Integer anoSelecionado = (Integer) request.getAttribute("anoSelecionado");

    DateTimeFormatter formatoDataHora = DateTimeFormatter.ofPattern("dd/MM/yyyy 'às' HH:mm", new Locale("pt", "BR"));
    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
    String msg = request.getParameter("msg");
    
    int anoAtual = LocalDate.now().getYear();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-red: #8B0000; --dark-red: #600000; --white: #FFFFFF;
            --light-gray: #f8f9fa; --dark-gray: #343a40; --gold: #FFD700;
            --status-agendado: #4e73df; --status-finalizado: #1cc88a; --status-cancelado: #e74a3b;
            --status-pendente: #f6c23e; --status-pago: #1cc88a;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background-color: var(--light-gray); }

        .admin-wrapper { display: flex; min-height: 100vh; }

        /* Sidebar de Navegação */
        .sidebar {
            width: 260px; background: var(--dark-gray); color: var(--white);
            display: flex; flex-direction: column; position: fixed; height: 100%;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1); z-index: 100;
        }
        .sidebar-header { padding: 1.5rem; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header .logo { font-size: 1.5rem; font-weight: bold; color: var(--white); text-decoration: none; }
        .sidebar-header .logo i { color: var(--gold); }
        .sidebar-nav { flex-grow: 1; list-style: none; padding-top: 1rem; }
        .sidebar-nav a { display: flex; align-items: center; gap: 1rem; padding: 1rem 1.5rem; color: var(--light-gray); text-decoration: none; font-weight: 500; transition: all 0.3s ease; }
        .sidebar-nav a:hover { background: rgba(255,255,255,0.1); }
        .sidebar-nav a.active { background: var(--primary-red); color: var(--white); border-left: 4px solid var(--gold); }
        .sidebar-nav a i { width: 20px; text-align: center; }

        /* Conteúdo Principal */
        .main-content { flex-grow: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .header { background: var(--white); padding: 1rem 2rem; display: flex; justify-content: flex-end; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); border-bottom: 1px solid #eee; }
        .user-info { display: flex; align-items: center; gap: 1rem; }
        .btn-logout { background: var(--primary-red); color: var(--white); padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 600; transition: background 0.3s ease; }
        .btn-logout:hover { background: var(--dark-red); }
        .content-body { padding: 2rem; }
        .page-header { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 2rem; }
        .page-header h1 { font-size: 2.5rem; color: var(--dark-gray); }

        /* Filtro de Data */
        .date-filter { display: flex; gap: 1rem; align-items: center; }
        .date-filter select { padding: 0.5rem; border-radius: 8px; border: 2px solid #ddd; font-weight: bold; }
        .date-filter .btn-filter { background: var(--primary-red); color: white; border: none; padding: 0.6rem 1rem; border-radius: 8px; cursor: pointer; font-weight: 600; }


        /* Cards de Estatísticas */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }
        .stat-card { background: var(--white); border-radius: 15px; padding: 1.5rem; box-shadow: 0 5px 25px rgba(0,0,0,0.08); display: flex; align-items: center; gap: 1.5rem; border-left: 5px solid; }
        .stat-card.faturamento { border-color: var(--status-pago); }
        .stat-card.pendentes { border-color: var(--status-pendente); }
        .stat-card.pagos { border-color: var(--status-agendado); }
        .stat-card .icon { font-size: 2.5rem; }
        .stat-card .info .title { font-size: 0.9rem; text-transform: uppercase; font-weight: 600; opacity: 0.7; }
        .stat-card .info .value { font-size: 1.8rem; font-weight: bold; }

        /* Seções das Tabelas */
        .table-section { margin-bottom: 3rem; }
        .table-section h2 { font-size: 1.8rem; color: var(--dark-gray); margin-bottom: 1.5rem; padding-bottom: 0.5rem; border-bottom: 2px solid #eee; }
        .table-container { background: var(--white); border-radius: 15px; box-shadow: 0 5px 25px rgba(0,0,0,0.08); overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #eee; white-space: nowrap; }
        th { background-color: #f8f9fa; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; color: #666; }
        tr:last-child td { border-bottom: none; }
        select { padding: 0.5rem; border-radius: 8px; border: 2px solid #eee; font-weight: bold; }
        .btn-save { background: var(--status-finalizado); color: var(--white); border: none; padding: 0.6rem 1rem; border-radius: 8px; cursor: pointer; font-weight: 600; }
        .alert { padding: 1rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 600; background: #e8f5e8; color: var(--status-finalizado); }
        .empty-row td { text-align: center; padding: 2rem; opacity: 0.7; }

        @media (max-width: 992px) {
            .sidebar {
                position: static;
                width: 100%;
                height: auto;
                z-index: 1;
            }
            .main-content {
                margin-left: 0;
            }
            .admin-wrapper {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="admin-wrapper">
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="admin" class="logo"><i class="fas fa-cut"></i> Admin Premium</a>
            </div>
            <ul class="sidebar-nav">
                <li><a href="admin?action=dashboard" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="barbeiro?action=listar"><i class="fas fa-user-tie"></i> Barbeiros</a></li>
                <li><a href="corte?action=listar"><i class="fas fa-stream"></i> Cortes</a></li>
                <li><a href="#"><i class="fas fa-star"></i> Especialidades</a></li>
            </ul>
        </aside>

        <div class="main-content">
            <header class="header">
                <div class="user-info">
                    <span>Olá, <strong><%= admin.getEmail() %></strong></span>
                    <a href="admin?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
                </div>
            </header>

            <main class="content-body">
                <div class="page-header">
                    <h1>Dashboard</h1>
                    <form action="admin" method="GET" class="date-filter" id="filterForm">
                         <input type="hidden" name="action" value="dashboard">
                         <select name="mes">
                            <% for (int i = 1; i <= 12; i++) { %>
                                <option value="<%= i %>" <%= (mesSelecionado != null && mesSelecionado == i) ? "selected" : "" %>><%= new java.text.DateFormatSymbols(new Locale("pt", "BR")).getMonths()[i-1] %></option>
                            <% } %>
                         </select>
                         <select name="ano">
                            <% for (int i = anoAtual; i >= anoAtual - 5; i--) { %>
                                <option value="<%= i %>" <%= (anoSelecionado != null && anoSelecionado == i) ? "selected" : "" %>><%= i %></option>
                            <% } %>
                         </select>
                         <button type="submit" class="btn-filter"><i class="fas fa-filter"></i> Filtrar</button>
                    </form>
                </div>
                
                <% if ("sucesso".equals(msg)) { %>
                    <div class="alert"><i class="fas fa-check-circle"></i> Status atualizado com sucesso!</div>
                <% } %>
                
                <!-- Cards de Estatísticas -->
                <div class="stats-grid">
                    <div class="stat-card faturamento">
                        <div class="icon" style="color: var(--status-pago);"><i class="fas fa-dollar-sign"></i></div>
                        <div class="info">
                            <div class="title">Faturamento no Mês</div>
                            <div class="value"><%= formatoMoeda.format(faturamentoMes != null ? faturamentoMes : 0.0) %></div>
                        </div>
                    </div>
                    <div class="stat-card pendentes">
                        <div class="icon" style="color: var(--status-pendente);"><i class="fas fa-hourglass-half"></i></div>
                        <div class="info">
                            <div class="title">Pagamentos Pendentes</div>
                            <div class="value"><%= totalPendentes != null ? totalPendentes : 0 %></div>
                        </div>
                    </div>
                    <div class="stat-card pagos">
                        <div class="icon" style="color: var(--status-agendado);"><i class="fas fa-calendar-check"></i></div>
                        <div class="info">
                            <div class="title">Agendamentos Pagos</div>
                            <div class="value"><%= totalPagos != null ? totalPagos : 0 %></div>
                        </div>
                    </div>
                </div>

                <!-- Seção de Pagamentos Pendentes -->
                <section class="table-section">
                    <h2><i class="fas fa-clock" style="color: var(--status-pendente);"></i> Pagamentos Pendentes</h2>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr><th>Cliente</th><th>Barbeiro</th><th>Serviço</th><th>Data & Hora</th><th>Atendimento</th><th>Pagamento</th><th>Ação</th></tr>
                            </thead>
                            <tbody>
                                <% boolean hasPendentes = false;
                                for (Agendamento ag : agendamentos) {
                                    if ("PENDENTE".equals(ag.getStatus_pagamentoAg())) {
                                    hasPendentes = true; %>
                                    <tr>
                                        <form action="admin" method="post">
                                            <input type="hidden" name="action" value="atualizarStatus">
                                            <input type="hidden" name="id_agendamento" value="<%= ag.getId_agendamentoAg() %>">
                                            <input type="hidden" name="mesFiltro" value="<%= mesSelecionado %>">
                                            <input type="hidden" name="anoFiltro" value="<%= anoSelecionado %>">
                                            <td><%= ag.getCliente().getNome() %></td>
                                            <td><%= ag.getBarbeiro().getNome() %></td>
                                            <td><%= ag.getNomeServico() %></td>
                                            <td><%= ag.getData_atendimentoAg().format(formatoDataHora) %></td>
                                            <td>
                                                <select name="status_agendamento">
                                                    <option value="AGENDADO" <%= "AGENDADO".equals(ag.getStatus_agendamentoAg()) ? "selected" : "" %>>Agendado</option>
                                                    <option value="FINALIZADO" <%= "FINALIZADO".equals(ag.getStatus_agendamentoAg()) ? "selected" : "" %>>Finalizado</option>
                                                    <option value="CANCELADO" <%= "CANCELADO".equals(ag.getStatus_agendamentoAg()) ? "selected" : "" %>>Cancelado</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="status_pagamento">
                                                    <option value="PENDENTE" selected>Pendente</option>
                                                    <option value="PAGO">Pago</option>
                                                </select>
                                            </td>
                                            <td><button type="submit" class="btn-save">Salvar</button></td>
                                        </form>
                                    </tr>
                                <%  }} if (!hasPendentes) { %>
                                    <tr class="empty-row"><td colspan="7">Nenhum agendamento com pagamento pendente para este mês.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Seção de Pagamentos Concluídos -->
                <section class="table-section">
                    <h2><i class="fas fa-check-circle" style="color: var(--status-pago);"></i> Pagamentos Concluídos</h2>
                    <div class="table-container">
                        <table>
                             <thead>
                                <tr><th>Cliente</th><th>Barbeiro</th><th>Serviço</th><th>Data & Hora</th><th>Atendimento</th><th>Pagamento</th><th>Ação</th></tr>
                            </thead>
                            <tbody>
                                <% boolean hasPagos = false;
                                for (Agendamento ag : agendamentos) {
                                    if ("PAGO".equals(ag.getStatus_pagamentoAg())) {
                                    hasPagos = true; %>
                                    <tr>
                                        <form action="admin" method="post">
                                            <input type="hidden" name="action" value="atualizarStatus">
                                            <input type="hidden" name="id_agendamento" value="<%= ag.getId_agendamentoAg() %>">
                                            <input type="hidden" name="mesFiltro" value="<%= mesSelecionado %>">
                                            <input type="hidden" name="anoFiltro" value="<%= anoSelecionado %>">
                                            <td><%= ag.getCliente().getNome() %></td>
                                            <td><%= ag.getBarbeiro().getNome() %></td>
                                            <td><%= ag.getNomeServico() %></td>
                                            <td><%= ag.getData_atendimentoAg().format(formatoDataHora) %></td>
                                            <td>
                                                <select name="status_agendamento">
                                                    <option value="AGENDADO" <%= "AGENDADO".equals(ag.getStatus_agendamentoAg()) ? "selected" : "" %>>Agendado</option>
                                                    <option value="FINALIZADO" <%= "FINALIZADO".equals(ag.getStatus_agendamentoAg()) ? "selected" : "" %>>Finalizado</option>
                                                    <option value="CANCELADO" <%= "CANCELADO".equals(ag.getStatus_agendamentoAg()) ? "selected" : "" %>>Cancelado</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="status_pagamento">
                                                    <option value="PENDENTE">Pendente</option>
                                                    <option value="PAGO" selected>Pago</option>
                                                </select>
                                            </td>
                                            <td><button type="submit" class="btn-save">Salvar</button></td>
                                        </form>
                                    </tr>
                                <%  }} if(!hasPagos) { %>
                                    <tr class="empty-row"><td colspan="7">Nenhum agendamento pago para este mês.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </section>
            </main>
        </div>
    </div>
</body>
</html>


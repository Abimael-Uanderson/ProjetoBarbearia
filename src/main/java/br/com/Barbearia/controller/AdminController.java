package br.com.Barbearia.controller;

import br.com.Barbearia.dao.AdministradorDAO;
import br.com.Barbearia.dao.AgendamentoDAO;
import br.com.Barbearia.model.Administrador;
import br.com.Barbearia.model.Agendamento;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin")
public class AdminController extends HttpServlet {
    private AdministradorDAO adminDAO;
    private AgendamentoDAO agendamentoDAO;

    @Override
    public void init() {
        adminDAO = new AdministradorDAO();
        agendamentoDAO = new AgendamentoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        try {
            HttpSession session = request.getSession(false);
            // Bloqueia o acesso a qualquer página do admin se não estiver logado, exceto o logout
            if (session == null || session.getAttribute("adminLogado") == null) {
                 if ("logout".equals(action)) {
                    logout(request, response);
                } else {
                    // Se não está logado, manda para a tela de login
                    RequestDispatcher dispatcher = request.getRequestDispatcher("loginAdmin.jsp");
                    dispatcher.forward(request, response);
                }
                return;
            }

            switch (action) {
                case "logout":
                    logout(request, response);
                    break;
                case "dashboard":
                default:
                    listarAgendamentos(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("admin?action=dashboard");
            return;
        }

        try {
            switch (action) {
                case "login":
                    login(request, response);
                    break;
                case "atualizarStatus":
                    atualizarStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação POST inválida.");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        Administrador admin = adminDAO.buscarPorEmailESenha(email, senha);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("adminLogado", admin);
            response.sendRedirect("admin?action=dashboard");
        } else {
            request.setAttribute("mensagemErro", "E-mail ou senha incorretos.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("loginAdmin.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("admin");
    }

    private void listarAgendamentos(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        // Lógica de filtro de data
        LocalDate hoje = LocalDate.now();
        int mesAtual = hoje.getMonthValue();
        int anoAtual = hoje.getYear();

        String mesParam = request.getParameter("mes");
        String anoParam = request.getParameter("ano");

        if (mesParam != null && !mesParam.isEmpty()) {
            mesAtual = Integer.parseInt(mesParam);
        }
        if (anoParam != null && !anoParam.isEmpty()) {
            anoAtual = Integer.parseInt(anoParam);
        }

        List<Agendamento> listaAgendamentos = agendamentoDAO.listarAgendamentosPorMes(mesAtual, anoAtual);

        // Lógica de cálculo para os cards de estatísticas
        double faturamentoMes = 0;
        int totalPendentes = 0;
        int totalPagos = 0;

        for (Agendamento ag : listaAgendamentos) {
            if ("PAGO".equals(ag.getStatus_pagamentoAg()) && ag.getItemAgendamento() != null) {
                faturamentoMes += ag.getItemAgendamento().getValor_itemIg();
                totalPagos++;
            }
            if ("PENDENTE".equals(ag.getStatus_pagamentoAg())) {
                totalPendentes++;
            }
        }

        request.setAttribute("listaAgendamentos", listaAgendamentos);
        request.setAttribute("faturamentoMes", faturamentoMes);
        request.setAttribute("totalPendentes", totalPendentes);
        request.setAttribute("totalPagos", totalPagos);
        request.setAttribute("mesSelecionado", mesAtual);
        request.setAttribute("anoSelecionado", anoAtual);

        RequestDispatcher dispatcher = request.getRequestDispatcher("dashboardAdmin.jsp");
        dispatcher.forward(request, response);
    }

    private void atualizarStatus(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int idAgendamento = Integer.parseInt(request.getParameter("id_agendamento"));
        String statusAgendamento = request.getParameter("status_agendamento");
        String statusPagamento = request.getParameter("status_pagamento");
        
        // Parâmetros para manter o filtro após a atualização
        String mes = request.getParameter("mesFiltro");
        String ano = request.getParameter("anoFiltro");

        agendamentoDAO.atualizarStatus(idAgendamento, statusAgendamento, statusPagamento);
        
        // Redireciona de volta para o dashboard com os filtros aplicados
        response.sendRedirect("admin?action=dashboard&mes=" + mes + "&ano=" + ano + "&msg=sucesso");
    }
}


package br.com.Barbearia.controller;

import br.com.Barbearia.dao.Item_agendamentoDAO;
import br.com.Barbearia.model.Item_agendamento;
import br.com.Barbearia.model.Especialidade;
import br.com.Barbearia.model.Agendamento;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ItemAgendamentoController")
public class Item_agendamentoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Item_agendamentoDAO itemAgendamentoDAO;

    @Override
    public void init() throws ServletException {
        itemAgendamentoDAO = new Item_agendamentoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("listarPorAgendamento".equals(action)) {
            try {
                listarItensPorAgendamento(request, response);
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação não especificada.");
            return;
        }

        try {
            switch (action) {
                case "cadastrar":
                    cadastrarItemAgendamento(request, response);
                    break;
                case "apagar":
                    apagarItemAgendamento(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida.");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void cadastrarItemAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String valorParam = request.getParameter("valor_itemIg");
        String idEspecialidadeParam = request.getParameter("especialidade");
        String idAgendamentoParam = request.getParameter("agendamento");
        
        if (valorParam == null || valorParam.isEmpty() || idEspecialidadeParam == null || idEspecialidadeParam.isEmpty() || idAgendamentoParam == null || idAgendamentoParam.isEmpty()) {
            request.setAttribute("mensagemErro", "Todos os campos são obrigatórios para o cadastro do item.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            BigDecimal valor = new BigDecimal(valorParam);
            int idEspecialidade = Integer.parseInt(idEspecialidadeParam);
            int idAgendamento = Integer.parseInt(idAgendamentoParam);
            
            Item_agendamento novoItem = new Item_agendamento();
            novoItem.setValor_itemIg(valor.doubleValue());
            
            Especialidade especialidade = new Especialidade();
            especialidade.setId_especialidadeEp(idEspecialidade);
            novoItem.setEspecialidade(especialidade);
            
            Agendamento agendamento = new Agendamento();
            agendamento.setId_agendamentoAg(idAgendamento);
            novoItem.setAgendamento(agendamento);
            
            itemAgendamentoDAO.inserirItemAgendamento(novoItem);
            response.sendRedirect("ItemAgendamentoController?action=listarPorAgendamento&id=" + idAgendamento);

        } catch (NumberFormatException e) {
            request.setAttribute("mensagemErro", "Erro de formato: O valor e os IDs devem ser números válidos.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            System.err.println("Erro ao cadastrar item de agendamento: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensagemErro", "Erro ao cadastrar item de agendamento.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void apagarItemAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id_itemIg");
        String idAgendamentoParaRedirecionar = request.getParameter("agendamento"); // Adicionado para manter o contexto
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do item é obrigatório para apagar.");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            itemAgendamentoDAO.apagarItemAgendamento(id);
            
            response.sendRedirect("ItemAgendamentoController?action=listarPorAgendamento&id=" + idAgendamentoParaRedirecionar);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do item deve ser um número válido.");
        } catch (SQLException e) {
            System.err.println("Erro ao apagar item de agendamento: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao apagar item de agendamento.");
        }
    }

    private void listarItensPorAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idAgendamentoParam = request.getParameter("id");
        if (idAgendamentoParam == null || idAgendamentoParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do agendamento é obrigatório.");
            return;
        }

        try {
            int idAgendamento = Integer.parseInt(idAgendamentoParam);
            List<Item_agendamento> itens = itemAgendamentoDAO.listarPorAgendamento(idAgendamento);
            request.setAttribute("listaItensAgendamento", itens);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("listaItensAgendamento.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do agendamento deve ser um número válido.");
        } catch (SQLException e) {
            System.err.println("Erro ao listar itens de agendamento: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao listar itens de agendamento.");
        }
    }
}

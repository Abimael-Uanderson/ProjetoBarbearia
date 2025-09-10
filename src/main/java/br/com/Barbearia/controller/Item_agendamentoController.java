package br.com.Barbearia.controller;

import br.com.Barbearia.dao.Item_agendamentoDAO;
import br.com.Barbearia.model.Item_agendamento;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/itemAgendamento")
public class Item_agendamentoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Item_agendamentoDAO itemAgendamentoDAO;

    @Override
    public void init() {
        itemAgendamentoDAO = new Item_agendamentoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("listarPorAgendamento".equals(action)) {
                listarItensPorAgendamento(request, response);
            } else {
                // Ação padrão ou erro
                listarItensPorAgendamento(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("apagar".equals(action)) {
                apagarItemAgendamento(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void apagarItemAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id_itemIg"));
        // Pega o id do agendamento para poder redirecionar de volta para a mesma página
        String idAgendamentoParaRedirecionar = request.getParameter("id_agendamentoAg");
        
        itemAgendamentoDAO.apagar(id);
        
        response.sendRedirect("itemAgendamento?action=listarPorAgendamento&id=" + idAgendamentoParaRedirecionar);
    }

    private void listarItensPorAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idAgendamentoParam = request.getParameter("id");
        if (idAgendamentoParam == null || idAgendamentoParam.isEmpty()) {
            request.setAttribute("mensagemErro", "O ID do agendamento é necessário para listar os itens.");
            request.getRequestDispatcher("erro.jsp").forward(request, response);
            return;
        }

        int idAgendamento = Integer.parseInt(idAgendamentoParam);
        List<Item_agendamento> listaItens = itemAgendamentoDAO.listarPorAgendamento(idAgendamento);
        
        request.setAttribute("listaItens", listaItens);
        // Você pode querer buscar o objeto Agendamento completo também para exibir informações dele na página
        // Agendamento agendamento = new AgendamentoDAO().buscarPorId(idAgendamento);
        // request.setAttribute("agendamento", agendamento);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("detalhesAgendamento.jsp"); // Sugestão de nome de página
        dispatcher.forward(request, response);
    }
}

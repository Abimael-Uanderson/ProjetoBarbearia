package br.com.Barbearia.controller;

import br.com.Barbearia.dao.AgendamentoDAO;
import br.com.Barbearia.model.Agendamento;
import br.com.Barbearia.model.Cliente;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/AgendamentoController")
public class AgendamentoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AgendamentoDAO agendamentoDAO;

    @Override
    public void init() throws ServletException {
        agendamentoDAO = new AgendamentoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        try {
            switch (action) {
                case "listar":
                default:
                    listarAgendamentos(request, response);
                    break;
                case "listarPorCliente":
                    listarAgendamentosPorCliente(request, response);
                    break;
                case "buscarPorId":
                    buscarAgendamentoPorId(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        try {
            switch (action) {
                case "cadastrar":
                    cadastrarAgendamento(request, response);
                    break;
                case "editar":
                    editarAgendamento(request, response);
                    break;
                case "apagar":
                    apagarAgendamento(request, response);
                    break;
                default:
                    listarAgendamentos(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void cadastrarAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String dataAtendimentoParam = request.getParameter("data_atendimentoAg");
        String statusAgendamento = request.getParameter("status_agendamentoAg");
        String duracaoTotalParam = request.getParameter("duracao_totalAg");
        String clienteCpf = request.getParameter("cliente");

        if (dataAtendimentoParam == null || dataAtendimentoParam.isEmpty() ||
            statusAgendamento == null || statusAgendamento.isEmpty() ||
            duracaoTotalParam == null || duracaoTotalParam.isEmpty() ||
            clienteCpf == null || clienteCpf.isEmpty()) {

            request.setAttribute("mensagemErro", "Todos os campos são obrigatórios para o cadastro de agendamento.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime dataAtendimento = LocalDateTime.parse(dataAtendimentoParam, formatter);
            int duracaoTotal = Integer.parseInt(duracaoTotalParam);

            LocalDateTime fimAgendamento = dataAtendimento.plusMinutes(duracaoTotal);

            // Obter todos os agendamentos existentes para verificar conflitos
            List<Agendamento> listaAgendamentos = agendamentoDAO.listarAgendamentos();

            if (temConflito(dataAtendimento, fimAgendamento, listaAgendamentos)) {
                request.setAttribute("mensagemErro", "Já existe um agendamento neste intervalo de horário.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
                dispatcher.forward(request, response);
                return;
            }

            Agendamento novoAgendamento = new Agendamento();
            novoAgendamento.setData_atendimentoAg(dataAtendimento);
            novoAgendamento.setStatus_agendamentoAg(statusAgendamento);
            novoAgendamento.setDuracao_totalAg(duracaoTotal);

            Cliente cliente = new Cliente();
            cliente.setCpf(clienteCpf);
            novoAgendamento.setCliente(cliente);

            agendamentoDAO.inserirAgendamento(novoAgendamento);
            response.sendRedirect("AgendamentoController?action=listar");

        } catch (NumberFormatException e) {
            request.setAttribute("mensagemErro", "Erro de formato: A duração total deve ser um número válido.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println("Erro ao cadastrar agendamento: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensagemErro", "Erro ao cadastrar agendamento. Verifique se os dados estão corretos.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void editarAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id_agendamentoAg");
        String dataAtendimentoParam = request.getParameter("data_atendimentoAg");
        String statusAgendamento = request.getParameter("status_agendamentoAg");
        String duracaoTotalParam = request.getParameter("duracao_totalAg");
        String clienteCpf = request.getParameter("cliente");

        if (idParam == null || idParam.isEmpty() ||
            dataAtendimentoParam == null || dataAtendimentoParam.isEmpty() ||
            statusAgendamento == null || statusAgendamento.isEmpty() ||
            duracaoTotalParam == null || duracaoTotalParam.isEmpty() ||
            clienteCpf == null || clienteCpf.isEmpty()) {

            request.setAttribute("mensagemErro", "Todos os campos são obrigatórios para a edição de agendamento.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime dataAtendimento = LocalDateTime.parse(dataAtendimentoParam, formatter);
            int duracaoTotal = Integer.parseInt(duracaoTotalParam);
            LocalDateTime fimAgendamento = dataAtendimento.plusMinutes(duracaoTotal);

            // Obter agendamentos para verificar conflito (ignorando o próprio id)
            List<Agendamento> listaAgendamentos = agendamentoDAO.listarAgendamentos();
            listaAgendamentos.removeIf(a -> a.getId_agendamentoAg() == id);

            if (temConflito(dataAtendimento, fimAgendamento, listaAgendamentos)) {
                request.setAttribute("mensagemErro", "Já existe um agendamento neste intervalo de horário.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
                dispatcher.forward(request, response);
                return;
            }

            Agendamento agendamento = new Agendamento();
            agendamento.setId_agendamentoAg(id);
            agendamento.setData_atendimentoAg(dataAtendimento);
            agendamento.setStatus_agendamentoAg(statusAgendamento);
            agendamento.setDuracao_totalAg(duracaoTotal);

            Cliente cliente = new Cliente();
            cliente.setCpf(clienteCpf);
            agendamento.setCliente(cliente);

            agendamentoDAO.editarAgendamento(agendamento);
            response.sendRedirect("AgendamentoController?action=listar");
        } catch (NumberFormatException e) {
            request.setAttribute("mensagemErro", "Erro de formato: O ID e a duração total devem ser números válidos.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println("Erro ao editar agendamento: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensagemErro", "Erro ao editar agendamento. Verifique se os dados estão corretos.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void apagarAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id_agendamentoAg");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do agendamento é obrigatório para apagar.");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            agendamentoDAO.apagarAgendamento(id);
            response.sendRedirect("AgendamentoController?action=listar");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do agendamento deve ser um número válido.");
        } catch (SQLException e) {
            System.err.println("Erro ao apagar agendamento: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao apagar agendamento.");
        }
    }

    private void listarAgendamentos(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            List<Agendamento> listaAgendamentos = agendamentoDAO.listarAgendamentos();
            request.setAttribute("listaAgendamentos", listaAgendamentos);
            RequestDispatcher dispatcher = request.getRequestDispatcher("listaAgendamentos.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            System.err.println("Erro ao listar agendamentos: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao listar agendamentos.");
        }
    }

    private void listarAgendamentosPorCliente(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String cpfParam = request.getParameter("cpfCliente");
        if (cpfParam == null || cpfParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "CPF do cliente é obrigatório.");
            return;
        }

        try {
            List<Agendamento> listaAgendamentos = agendamentoDAO.listarAgendamentosPorCliente(cpfParam);
            request.setAttribute("listaAgendamentos", listaAgendamentos);
            RequestDispatcher dispatcher = request.getRequestDispatcher("listaAgendamentos.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            System.err.println("Erro ao listar agendamentos por cliente: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao listar agendamentos.");
        }
    }

    private void buscarAgendamentoPorId(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id_agendamentoAg");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do agendamento é obrigatório para a busca.");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Agendamento agendamento = agendamentoDAO.buscarAgendamentoPorId(id);

            if (agendamento != null) {
                request.setAttribute("agendamentoEncontrado", agendamento);
                RequestDispatcher dispatcher = request.getRequestDispatcher("detalheAgendamento.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Agendamento não encontrado.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do agendamento deve ser um número válido.");
        } catch (SQLException e) {
            System.err.println("Erro ao buscar agendamento por ID: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao buscar agendamento.");
        }
    }

    // Método auxiliar para verificar conflito de horários
    private boolean temConflito(LocalDateTime novoInicio, LocalDateTime novoFim, List<Agendamento> agendamentos) {
        for (Agendamento agendamento : agendamentos) {
            LocalDateTime inicioExistente = agendamento.getData_atendimentoAg();
            LocalDateTime fimExistente = inicioExistente.plusMinutes(agendamento.getDuracao_totalAg());

            if (novoInicio.isBefore(fimExistente) && novoFim.isAfter(inicioExistente)) {
                return true; // Existe sobreposição
            }
        }
        return false;
    }
}

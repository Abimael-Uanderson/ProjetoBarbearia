package br.com.Barbearia.controller;

import br.com.Barbearia.dao.*;
import br.com.Barbearia.model.*;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/agendamento")
public class AgendamentoController extends HttpServlet {

    private AgendamentoDAO agendamentoDAO;
    private EspecialidadeDAO especialidadeDAO;
    private Item_agendamentoDAO itemAgendamentoDAO;
    private CorteDAO corteDAO;
    private BarbeiroDAO barbeiroDAO;

    @Override
    public void init() {
        agendamentoDAO = new AgendamentoDAO();
        especialidadeDAO = new EspecialidadeDAO();
        itemAgendamentoDAO = new Item_agendamentoDAO();
        corteDAO = new CorteDAO();
        barbeiroDAO = new BarbeiroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "passo3"; 
        }

        try {
            switch(action) {
                case "passo3":
                    mostrarPasso3(request, response);
                    break;
                case "passo4":
                    mostrarPasso4(request, response);
                    break;
                case "verHistorico":
                    verHistorico(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação GET inválida.");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch(action) {
                case "cadastrar":
                    cadastrarAgendamento(request, response);
                    break;
                case "cancelar":
                    cancelarAgendamento(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação POST inválida.");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void verHistorico(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Cliente clienteLogado = (Cliente) session.getAttribute("usuarioLogado");
        List<Agendamento> historico = agendamentoDAO.listarPorCliente(clienteLogado.getCpf());

        request.setAttribute("listaAgendamentos", historico);
        request.getRequestDispatcher("historicoAgendamentos.jsp").forward(request, response);
    }
    
    private void cancelarAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idAgendamento = Integer.parseInt(request.getParameter("id_agendamento"));
        agendamentoDAO.cancelar(idAgendamento); 
        response.sendRedirect("agendamento?action=verHistorico&msg=cancelado");
    }

    private void mostrarPasso3(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idCorte = Integer.parseInt(request.getParameter("id_corte"));
        String cpfBarbeiro = request.getParameter("cpf_barbeiro");
        String dataParam = request.getParameter("data");

        LocalDate dataSelecionada = (dataParam == null || dataParam.isEmpty()) ? LocalDate.now() : LocalDate.parse(dataParam);
        
        Corte corte = corteDAO.buscarPorId(idCorte);
        Barbeiro barbeiro = barbeiroDAO.buscarPorCpf(cpfBarbeiro);
        
        request.setAttribute("corteSelecionado", corte);
        request.setAttribute("barbeiroSelecionado", barbeiro);
        
        List<Agendamento> agendaDoBarbeiro = agendamentoDAO.listarPorBarbeiroNaData(cpfBarbeiro, dataSelecionada);
        List<LocalDateTime> horariosDisponiveis = gerarHorariosDisponiveis(agendaDoBarbeiro, dataSelecionada.atStartOfDay(), corte.getDuracao());

        request.setAttribute("listaHorarios", horariosDisponiveis);
        request.setAttribute("dataSelecionada", dataSelecionada);

        request.getRequestDispatcher("agendamento-passo3-horario.jsp").forward(request, response);
    }
    
    private void mostrarPasso4(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idCorte = Integer.parseInt(request.getParameter("id_corte"));
        String cpfBarbeiro = request.getParameter("cpf_barbeiro");
        String dataHora = request.getParameter("data_hora");

        Corte corte = corteDAO.buscarPorId(idCorte);
        Barbeiro barbeiro = barbeiroDAO.buscarPorCpf(cpfBarbeiro);

        request.setAttribute("corteSelecionado", corte);
        request.setAttribute("barbeiroSelecionado", barbeiro);
        request.setAttribute("dataHoraSelecionada", LocalDateTime.parse(dataHora));

        request.getRequestDispatcher("agendamento-passo4-confirmacao.jsp").forward(request, response);
    }

    private void cadastrarAgendamento(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Cliente clienteLogado = (Cliente) session.getAttribute("usuarioLogado");

        String cpfBarbeiro = request.getParameter("cpf_barbeiro");
        String dataHoraParam = request.getParameter("data_hora");
        int idCorte = Integer.parseInt(request.getParameter("id_corte"));

        LocalDateTime inicioAgendamento = LocalDateTime.parse(dataHoraParam);
        
        Especialidade especialidade = especialidadeDAO.buscarPorCorteEBarbeiro(idCorte, cpfBarbeiro);
        if (especialidade == null) {
            throw new ServletException("O barbeiro não possui a especialidade para o corte informado.");
        }

        int duracao = especialidade.getCorte().getDuracao();
        
        List<Agendamento> agendaDoBarbeiro = agendamentoDAO.listarPorBarbeiroNaData(cpfBarbeiro, inicioAgendamento.toLocalDate());
        if (temConflito(inicioAgendamento, inicioAgendamento.plusMinutes(duracao), agendaDoBarbeiro)) {
             request.setAttribute("mensagemErro", "Conflito de horário. Este horário foi reservado enquanto você decidia.");
             request.getRequestDispatcher("erro.jsp").forward(request, response);
             return;
        }
        
        Barbeiro barbeiro = barbeiroDAO.buscarPorCpf(cpfBarbeiro);
        Agendamento novoAgendamento = new Agendamento(inicioAgendamento, "AGENDADO", duracao, clienteLogado, barbeiro);
        int novoAgendamentoId = agendamentoDAO.inserir(novoAgendamento);
        novoAgendamento.setId_agendamentoAg(novoAgendamentoId);

        Item_agendamento novoItem = new Item_agendamento();
        novoItem.setAgendamento(novoAgendamento);
        novoItem.setEspecialidade(especialidade);
        novoItem.setValor_itemIg(especialidade.getCorte().getValor_corte());
        itemAgendamentoDAO.inserir(novoItem);
        
        novoAgendamento.setItemAgendamento(novoItem);

        request.setAttribute("agendamentoConfirmado", novoAgendamento);
        request.getRequestDispatcher("agendamento-sucesso.jsp").forward(request, response);
    }

    // --- MÉTODOS DE LÓGICA INTERNA ---

    private boolean temConflito(LocalDateTime novoInicio, LocalDateTime novoFim, List<Agendamento> agendaDoBarbeiro) {
        for (Agendamento agendamentoExistente : agendaDoBarbeiro) {
            LocalDateTime inicioExistente = agendamentoExistente.getData_atendimentoAg();
            LocalDateTime fimExistente = inicioExistente.plusMinutes(agendamentoExistente.getDuracao_totalAg());
            if (novoInicio.isBefore(fimExistente) && novoFim.isAfter(inicioExistente)) {
                return true;
            }
        }
        return false;
    }

    private List<LocalDateTime> gerarHorariosDisponiveis(List<Agendamento> agendamentos, LocalDateTime inicioDoDia, int duracao) {
        List<LocalDateTime> horarios = new ArrayList<>();
        
        LocalDateTime fimManha = inicioDoDia.withHour(12);
        for (LocalDateTime hora = inicioDoDia.withHour(8); !hora.plusMinutes(duracao).isAfter(fimManha); hora = hora.plusMinutes(30)) {
            if (!temConflito(hora, hora.plusMinutes(duracao), agendamentos)) {
                horarios.add(hora);
            }
        }
        
        LocalDateTime fimTarde = inicioDoDia.withHour(19);
        for (LocalDateTime hora = inicioDoDia.withHour(13); !hora.plusMinutes(duracao).isAfter(fimTarde); hora = hora.plusMinutes(30)) {
            if (!temConflito(hora, hora.plusMinutes(duracao), agendamentos)) {
                horarios.add(hora);
            }
        }
        return horarios;
    }
}


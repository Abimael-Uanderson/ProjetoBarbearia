package br.com.Barbearia.controller;

import br.com.Barbearia.dao.EspecialidadeDAO;
import br.com.Barbearia.model.Especialidade;
import br.com.Barbearia.model.Corte;
import br.com.Barbearia.model.Barbeiro;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/EspecialidadeController")
public class EspecialidadeController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EspecialidadeDAO especialidadeDAO;

    @Override
    public void init() throws ServletException {
        especialidadeDAO = new EspecialidadeDAO();
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
                    listarEspecialidades(request, response);
                    break;
                case "buscarPorId":
                    buscarEspecialidadePorId(request, response);
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
                    cadastrarEspecialidade(request, response);
                    break;
                case "apagar":
                    apagarEspecialidade(request, response);
                    break;
                default:
                    listarEspecialidades(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listarEspecialidades(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            List<Especialidade> listaEspecialidades = especialidadeDAO.listarEspecialidades();
            request.setAttribute("listaEspecialidades", listaEspecialidades);
            RequestDispatcher dispatcher = request.getRequestDispatcher("listaEspecialidades.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            System.err.println("Erro ao listar especialidades: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensagemErro", "Erro ao carregar lista de especialidades.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void buscarEspecialidadePorId(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id_especialidade");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID da especialidade é obrigatório.");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Especialidade especialidade = especialidadeDAO.buscarEspecialidadePorId(id);
            request.setAttribute("especialidadeEncontrada", especialidade);

            RequestDispatcher dispatcher = request.getRequestDispatcher("detalheEspecialidade.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID da especialidade deve ser um número válido.");
        } catch (SQLException e) {
            System.err.println("Erro ao buscar especialidade por ID: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao buscar especialidade.");
        }
    }

    private void cadastrarEspecialidade(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idCorteParam = request.getParameter("id_corte");
        String cpfBarbeiroParam = request.getParameter("cpf_barbeiro");

        if (idCorteParam == null || idCorteParam.isEmpty() || cpfBarbeiroParam == null || cpfBarbeiroParam.isEmpty()) {
            request.setAttribute("mensagemErro", "ID do corte e CPF do barbeiro são obrigatórios para cadastro.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            int idCorte = Integer.parseInt(idCorteParam);
            
            Especialidade novaEspecialidade = new Especialidade();
            Corte corte = new Corte();
            corte.setId_corte(idCorte);
            novaEspecialidade.setCorte(corte);
            
            Barbeiro barbeiro = new Barbeiro();
            barbeiro.setCpf(cpfBarbeiroParam);
            novaEspecialidade.setBarbeiro(barbeiro);

            especialidadeDAO.inserirEspecialidade(novaEspecialidade);
            response.sendRedirect("EspecialidadeController?action=listar");
            request.setAttribute("mensagemErro", "Erro de formato: O ID do corte deve sdddddddder um número válido.");
            
        } catch (NumberFormatException e) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            System.err.println("Erro ao cadastrar especialidade: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensagemErro", "Erro ao cadastrar especialidade. Verifique se o corte e o barbeiro existem.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void apagarEspecialidade(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id_especialidade");

        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("mensagemErro", "O ID da especialidade é obrigatório para apagar.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            especialidadeDAO.apagarEspecialidade(id);
            
            response.sendRedirect("EspecialidadeController?action=listar");
        } catch (NumberFormatException e) {
            request.setAttribute("mensagemErro", "Erro de formato: O ID da especialidade deve ser um número válido.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            System.err.println("Erro ao apagar especialidade: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensagemErro", "Erro ao apagar especialidade.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("erro.jsp");
            dispatcher.forward(request, response);
        }
    }
}

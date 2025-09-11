package br.com.Barbearia.controller;

import br.com.Barbearia.dao.BarbeiroDAO;
import br.com.Barbearia.dao.CorteDAO;
import br.com.Barbearia.dao.EspecialidadeDAO;
import br.com.Barbearia.model.Barbeiro;
import br.com.Barbearia.model.Corte;
import br.com.Barbearia.model.Especialidade;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/especialidade")
public class EspecialidadeController extends HttpServlet {
    private EspecialidadeDAO especialidadeDAO;
    private CorteDAO corteDAO;
    private BarbeiroDAO barbeiroDAO;

    @Override
    public void init() {
        especialidadeDAO = new EspecialidadeDAO();
        corteDAO = new CorteDAO();
        barbeiroDAO = new BarbeiroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "gerenciar"; // Ação padrão para admin
        }
        
        // Proteção para área de admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminLogado") == null) {
            if(!"listarBarbeirosPorCorte".equals(action)) { // Permite a ação do cliente
                response.sendRedirect("admin");
                return;
            }
        }

        try {
            switch (action) {
                case "listarBarbeirosPorCorte":
                    listarBarbeirosPorCorte(request, response);
                    break;
                case "gerenciar":
                default:
                    mostrarTelaGerenciar(request, response);
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

        try {
            switch (action) {
                case "cadastrar":
                    cadastrarEspecialidade(request, response);
                    break;
                case "apagar":
                    apagarEspecialidade(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida.");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listarBarbeirosPorCorte(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        // ... (código existente, sem alteração)
        String idCorteParam = request.getParameter("id_corte");

        if (idCorteParam == null || idCorteParam.isEmpty()) {
            throw new ServletException("O ID do corte é obrigatório para listar os barbeiros.");
        }

        int idCorte = Integer.parseInt(idCorteParam);
        
        List<Barbeiro> barbeiros = especialidadeDAO.listarBarbeirosPorCorte(idCorte);
        Corte corteSelecionado = corteDAO.buscarPorId(idCorte);

        request.setAttribute("listaBarbeiros", barbeiros);
        request.setAttribute("corteSelecionado", corteSelecionado);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("agendamento-passo2-barbeiro.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarTelaGerenciar(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Barbeiro> listaBarbeiros = barbeiroDAO.listar();
        List<Corte> listaCortes = corteDAO.listar();
        List<Especialidade> listaEspecialidades = especialidadeDAO.listarTodas();

        request.setAttribute("listaBarbeiros", listaBarbeiros);
        request.setAttribute("listaCortes", listaCortes);
        request.setAttribute("listaEspecialidades", listaEspecialidades);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/gerenciar-especialidades.jsp");
        dispatcher.forward(request, response);
    }

    private void cadastrarEspecialidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        int idCorte = Integer.parseInt(request.getParameter("id_corte"));
        String cpfBarbeiro = request.getParameter("cpf_barbeiro");

        Corte corte = new Corte();
        corte.setId_corte(idCorte);

        Barbeiro barbeiro = new Barbeiro();
        barbeiro.setCpf(cpfBarbeiro);

        Especialidade novaEspecialidade = new Especialidade(corte, barbeiro);
        especialidadeDAO.inserir(novaEspecialidade);

        response.sendRedirect("especialidade?action=gerenciar&msg=sucesso");
    }

    private void apagarEspecialidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int idEspecialidade = Integer.parseInt(request.getParameter("id_especialidade"));
        especialidadeDAO.apagar(idEspecialidade);
        response.sendRedirect("especialidade?action=gerenciar&msg=apagado");
    }
}

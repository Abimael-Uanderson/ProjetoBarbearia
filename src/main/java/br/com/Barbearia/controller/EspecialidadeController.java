package br.com.Barbearia.controller;

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

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/especialidade")
public class EspecialidadeController extends HttpServlet {
    private EspecialidadeDAO especialidadeDAO;
    private CorteDAO corteDAO; // Adicionado para buscar detalhes do corte

    @Override
    public void init() {
        especialidadeDAO = new EspecialidadeDAO();
        corteDAO = new CorteDAO(); // Inicializa o CorteDAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar"; // Ação padrão para admin
        }

        try {
            switch (action) {
                case "listarBarbeirosPorCorte":
                    listarBarbeirosPorCorte(request, response);
                    break;
                case "listar": // Ação de admin
                default:
                    response.sendRedirect("admin/dashboard.jsp"); 
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

    // --- LÓGICA DO FLUXO DO CLIENTE ---

    private void listarBarbeirosPorCorte(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String idCorteParam = request.getParameter("id_corte");

        if (idCorteParam == null || idCorteParam.isEmpty()) {
            throw new ServletException("O ID do corte é obrigatório para listar os barbeiros.");
        }

        int idCorte = Integer.parseInt(idCorteParam);
        
        // Busca a lista de barbeiros que fazem o corte
        List<Barbeiro> barbeiros = especialidadeDAO.listarBarbeirosPorCorte(idCorte);
        
        // Busca os detalhes do corte selecionado para exibir na página
        Corte corteSelecionado = corteDAO.buscarPorId(idCorte);

        // Envia ambos os dados para a página do Passo 2
        request.setAttribute("listaBarbeiros", barbeiros);
        request.setAttribute("corteSelecionado", corteSelecionado);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("agendamento-passo2-barbeiro.jsp");
        dispatcher.forward(request, response);
    }
    
    // --- LÓGICA PARA O PAINEL DE ADMIN ---

    private void cadastrarEspecialidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String idCorteParam = request.getParameter("id_corte");
        String cpfBarbeiro = request.getParameter("cpf_barbeiro");

        if (idCorteParam == null || cpfBarbeiro == null) {
             throw new ServletException("Parâmetros id_corte e cpf_barbeiro são obrigatórios.");
        }

        int idCorte = Integer.parseInt(idCorteParam);

        Corte corte = new Corte();
        corte.setId_corte(idCorte);

        Barbeiro barbeiro = new Barbeiro();
        barbeiro.setCpf(cpfBarbeiro);

        Especialidade novaEspecialidade = new Especialidade(corte, barbeiro);
        especialidadeDAO.inserir(novaEspecialidade);

        response.sendRedirect("admin/especialidades.jsp?msg=sucesso");
    }

    private void apagarEspecialidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int idEspecialidade = Integer.parseInt(request.getParameter("id_especialidade"));
        especialidadeDAO.apagar(idEspecialidade);
        response.sendRedirect("admin/especialidades.jsp?msg=apagado");
    }
}


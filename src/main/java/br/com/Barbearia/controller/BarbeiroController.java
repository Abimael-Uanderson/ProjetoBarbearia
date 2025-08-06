package br.com.Barbearia.controller;

import java.io.IOException;

import br.com.Barbearia.dao.BarbeiroDAO;
import br.com.Barbearia.model.Barbeiro;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BarbeiroController")
public class BarbeiroController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BarbeiroDAO barbeiroDAO;
	
	@Override
    public void init() throws ServletException {
		barbeiroDAO = new BarbeiroDAO(); 
    }
	
	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "cadastrar":
                    cadastrarBarbeiro(request, response);
                    break;
                case "login":
                    loginBarbeiro(request, response);
                    break;
                case "verPerfil":
                    verPerfil(request, response);
                    break;
                case "editar":
                    editarBarbeiro(request, response);
                    break;
                case "excluir":
                    excluirBarbeiro(request, response);
                    break;
                case "logout":
                    logout(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida.");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
	
	
	public void cadastrarBarbeiro(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String cpf = request.getParameter("cpf");
        String nome = request.getParameter("nome");
        String telefone = request.getParameter("telefone");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
		
        Barbeiro barbeiro = new Barbeiro();
        barbeiro.setCpf(cpf);
        barbeiro.setNome(nome);
        barbeiro.setTelefone(telefone);
        barbeiro.setEmail(email);
        barbeiro.setSenha(senha);
      
        // Supondo que o BarbeiroDAO tenha métodos similares ao ClienteDAO
        if (barbeiroDAO.buscarBarbeiroPorCpf(cpf) != null || barbeiroDAO.buscarBarbeiroPorEmail(email) != null) {
            response.getWriter().write("CPF ou E-mail já cadastrado.");
            return;
        }
        barbeiroDAO.inserirBarbeiro(barbeiro);
        
        response.getWriter().write("Barbeiro cadastrado com sucesso!");
    }
	
	public void loginBarbeiro(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        Barbeiro barbeiro = barbeiroDAO.buscarBarbeiroPorEmail(email);
        
        if(barbeiro != null && barbeiro.getSenha().equals(senha)) {
            HttpSession session = request.getSession();
            session.setAttribute("barbeiroLogado", barbeiro); // guardou na sessão
            response.getWriter().write("Login efetuado com sucesso!");
        } else {
            response.getWriter().write("Email ou senha inválidos.");
        }
    }
	
	public void verPerfil(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("barbeiroLogado") == null) {
	        response.sendRedirect("loginBarbeiro.jsp"); // Sugestão: uma página de login para barbeiros
	    } else {
	        Barbeiro barbeiro = (Barbeiro) session.getAttribute("barbeiroLogado");
	        request.setAttribute("barbeiro", barbeiro);
	        request.getRequestDispatcher("perfilBarbeiro.jsp").forward(request, response); // Sugestão: uma página de perfil para barbeiros
	    }
	}

    public void editarBarbeiro(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("barbeiroLogado") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Usuário não autenticado.");
            return;
        }

        Barbeiro barbeiroLogado = (Barbeiro) session.getAttribute("barbeiroLogado");

        String nome = request.getParameter("nome");
        String telefone = request.getParameter("telefone");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        barbeiroLogado.setNome(nome);
        barbeiroLogado.setTelefone(telefone);
        barbeiroLogado.setEmail(email);
        barbeiroLogado.setSenha(senha);

        barbeiroDAO.editarBarbeiro(barbeiroLogado);

        session.setAttribute("barbeiroLogado", barbeiroLogado);

        response.getWriter().write("Perfil atualizado com sucesso!");
    }

    public void excluirBarbeiro(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("barbeiroLogado") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Usuário não autenticado.");
            return;
        }

        Barbeiro barbeiroLogado = (Barbeiro) session.getAttribute("barbeiroLogado");
        
        barbeiroDAO.apagarBarbeiro(barbeiroLogado.getCpf());

        session.invalidate();

        response.getWriter().write("Conta excluída com sucesso.");
    }

    public void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.getWriter().write("Logout efetuado com sucesso.");
    }
}
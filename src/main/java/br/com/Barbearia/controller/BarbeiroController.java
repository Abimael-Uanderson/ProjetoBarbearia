package br.com.Barbearia.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import br.com.Barbearia.dao.BarbeiroDAO;
import br.com.Barbearia.model.Barbeiro;
import br.com.Barbearia.utils.CriptografiaUtils;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/barbeiro")
public class BarbeiroController extends HttpServlet {
	private BarbeiroDAO barbeiroDAO;

	@Override
	public void init() {
		barbeiroDAO = new BarbeiroDAO();
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
				case "formNovo":
					mostrarForm(request, response, "novo");
					break;
				case "formEdicao":
					mostrarForm(request, response, "edicao");
					break;
				case "verPerfil":
					verPerfil(request, response);
					break;
				case "logout":
					logout(request, response);
					break;
				case "listar": // Ação de admin
				default:
					listarBarbeiros(request, response);
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
					cadastrarBarbeiro(request, response);
					break;
				case "editar":
					editarBarbeiro(request, response);
					break;
				case "apagar":
					apagarBarbeiro(request, response);
					break;
				case "login":
					loginBarbeiro(request, response);
					break;
				default:
					response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida.");
			}
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	// --- MÉTODOS DE AÇÃO ---

	private void cadastrarBarbeiro(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		String cpf = request.getParameter("cpf");
		String nome = request.getParameter("nome");
		String telefone = request.getParameter("telefone");
		String email = request.getParameter("email");
		String senhaPlana = request.getParameter("senha");

		// Validação para impedir CPF ou E-mail duplicado
		if (barbeiroDAO.buscarPorCpf(cpf) != null) {
			request.setAttribute("mensagemErro", "Este CPF já está cadastrado.");
			mostrarForm(request, response, "novo");
			return;
		}
		if (barbeiroDAO.buscarPorEmail(email) != null) {
			request.setAttribute("mensagemErro", "Este e-mail já está cadastrado.");
			mostrarForm(request, response, "novo");
			return;
		}
		
		String senhaCriptografada = CriptografiaUtils.hashSenha(senhaPlana);
		
		Barbeiro novoBarbeiro = new Barbeiro(cpf, nome, telefone, email, senhaCriptografada);
		barbeiroDAO.inserir(novoBarbeiro);

		response.sendRedirect("barbeiro?action=listar&msg=sucesso");
	}

	private void loginBarbeiro(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		String email = request.getParameter("email");
		String senha = request.getParameter("senha");

		Barbeiro barbeiro = barbeiroDAO.buscarPorEmailESenha(email, senha);

		if (barbeiro != null) {
			HttpSession session = request.getSession();
			session.setAttribute("barbeiroLogado", barbeiro);
			response.sendRedirect("admin/dashboard.jsp"); // Redireciona para o painel do barbeiro
		} else {
			request.setAttribute("mensagemErro", "E-mail ou senha incorretos.");
			request.getRequestDispatcher("loginBarbeiro.jsp").forward(request, response);
		}
	}

	private void verPerfil(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("barbeiroLogado") == null) {
			response.sendRedirect("loginBarbeiro.jsp");
		} else {
			request.getRequestDispatcher("perfilBarbeiro.jsp").forward(request, response);
		}
	}

	private void editarBarbeiro(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
		String cpf = request.getParameter("cpf"); // O CPF não muda, então vem do form
		String nome = request.getParameter("nome");
		String telefone = request.getParameter("telefone");
		String email = request.getParameter("email");
		String senhaPlana = request.getParameter("senha");

		Barbeiro barbeiro = barbeiroDAO.buscarPorCpf(cpf);
		if (barbeiro == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "Barbeiro não encontrado.");
			return;
		}

		barbeiro.setNome(nome);
		barbeiro.setTelefone(telefone);
		barbeiro.setEmail(email);

		if (senhaPlana != null && !senhaPlana.isEmpty()) { 
			String senhaCriptografada = CriptografiaUtils.hashSenha(senhaPlana);
			barbeiro.setSenha(senhaCriptografada);
		}

		barbeiroDAO.editar(barbeiro);
		response.sendRedirect("barbeiro?action=listar&msg=editado");
	}
	
	private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		response.sendRedirect("loginBarbeiro.jsp");
	}
	
	// --- MÉTODOS PARA ADMIN ---
	
	private void listarBarbeiros(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		List<Barbeiro> listaBarbeiros = barbeiroDAO.listar();
		request.setAttribute("listaBarbeiros", listaBarbeiros);
		RequestDispatcher dispatcher = request.getRequestDispatcher("admin/lista-barbeiros.jsp");
		dispatcher.forward(request, response);
	}
	
	private void mostrarForm(HttpServletRequest request, HttpServletResponse response, String tipo) throws SQLException, ServletException, IOException {
		if (tipo.equals("edicao")) {
			String cpf = request.getParameter("cpf");
			Barbeiro barbeiroExistente = barbeiroDAO.buscarPorCpf(cpf);
			request.setAttribute("barbeiro", barbeiroExistente);
		}
		RequestDispatcher dispatcher = request.getRequestDispatcher("admin/form-barbeiro.jsp");
		dispatcher.forward(request, response);
	}

	private void apagarBarbeiro(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		String cpf = request.getParameter("cpf");
		barbeiroDAO.apagar(cpf);
		response.sendRedirect("barbeiro?action=listar&msg=apagado");
	}
}

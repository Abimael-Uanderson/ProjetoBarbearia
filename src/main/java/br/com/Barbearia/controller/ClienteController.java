package br.com.Barbearia.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import br.com.Barbearia.dao.AgendamentoDAO;
import br.com.Barbearia.dao.ClienteDAO;
import br.com.Barbearia.model.Agendamento;
import br.com.Barbearia.model.Cliente;
import br.com.Barbearia.utils.CriptografiaUtils;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cliente")
public class ClienteController extends HttpServlet {
	private ClienteDAO clienteDAO;
	private AgendamentoDAO agendamentoDAO;

	@Override
	public void init() {
		clienteDAO = new ClienteDAO();
		agendamentoDAO = new AgendamentoDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			action = "home";
		}

		try {
			switch (action) {
				case "home":
					mostrarHome(request, response);
					break;
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
					listarClientes(request, response);
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
					cadastrarCliente(request, response);
					break;
				case "editar":
					editarCliente(request, response);
					break;
				case "apagar":
					apagarCliente(request, response);
					break;
				case "login":
					loginCliente(request, response);
					break;
				default:
					response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida.");
			}
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	// --- MÉTODOS DE AÇÃO ---

	private void mostrarHome(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Cliente clienteLogado = (Cliente) session.getAttribute("usuarioLogado");
        
        List<Agendamento> agendamentos = agendamentoDAO.listarPorCliente(clienteLogado.getCpf());

        request.setAttribute("listaAgendamentos", agendamentos);
        RequestDispatcher dispatcher = request.getRequestDispatcher("homeCliente.jsp");
        dispatcher.forward(request, response);
	}

	private void cadastrarCliente(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		String cpfComFormatacao = request.getParameter("cpf");
		String nome = request.getParameter("nome");
		String telefone = request.getParameter("telefone");
		String email = request.getParameter("email");
		String senha = request.getParameter("senha");
		String confirmarSenha = request.getParameter("confirmar_senha");

		// CORREÇÃO: Remove todos os caracteres que não são dígitos do CPF
        String cpf = cpfComFormatacao.replaceAll("[^0-9]", "");

		// Validação do lado do servidor para garantir que as senhas coincidem
		if (senha == null || !senha.equals(confirmarSenha)) {
			request.setAttribute("mensagemErro", "As senhas não coincidem.");
			request.getRequestDispatcher("cadastro-cliente.jsp").forward(request, response);
			return;
		}

		if (clienteDAO.buscarPorCpf(cpf) != null) {
			request.setAttribute("mensagemErro", "Este CPF já está cadastrado.");
			request.getRequestDispatcher("cadastro-cliente.jsp").forward(request, response);
			return;
		}
		if (clienteDAO.buscarPorEmail(email) != null) {
			request.setAttribute("mensagemErro", "Este e-mail já está cadastrado.");
			request.getRequestDispatcher("cadastro-cliente.jsp").forward(request, response);
			return;
		}
		
		String senhaCriptografada = CriptografiaUtils.hashSenha(senha);
		Cliente novoCliente = new Cliente(cpf, nome, telefone, email, senhaCriptografada);
		clienteDAO.inserir(novoCliente);

		request.setAttribute("mensagemSucesso", "Cadastro realizado! Faça seu login.");
		request.getRequestDispatcher("login.jsp").forward(request, response);
	}

	private void loginCliente(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		String email = request.getParameter("email");
		String senha = request.getParameter("senha");

		Cliente cliente = clienteDAO.buscarPorEmailESenha(email, senha);

		if (cliente != null) {
			HttpSession session = request.getSession();
			session.setAttribute("usuarioLogado", cliente);
			response.sendRedirect("cliente?action=home");
		} else {
			request.setAttribute("mensagemErro", "E-mail ou senha incorretos.");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
	}

	private void verPerfil(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("usuarioLogado") == null) {
			response.sendRedirect("login.jsp");
		} else {
			request.getRequestDispatcher("perfilCliente.jsp").forward(request, response);
		}
	}

	private void editarCliente(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("usuarioLogado") == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		Cliente clienteLogado = (Cliente) session.getAttribute("usuarioLogado");
		
		String nome = request.getParameter("nome");
		String telefone = request.getParameter("telefone");
		String email = request.getParameter("email");
		String senha = request.getParameter("senha");

		clienteLogado.setNome(nome);
		clienteLogado.setTelefone(telefone);
		clienteLogado.setEmail(email);
		if (senha != null && !senha.isEmpty()) {
			String senhaCriptografada = CriptografiaUtils.hashSenha(senha);
			clienteLogado.setSenha(senhaCriptografada);
		}

		clienteDAO.editar(clienteLogado);
		session.setAttribute("usuarioLogado", clienteLogado);
		response.sendRedirect("cliente?action=verPerfil&msg=sucesso");
	}
	
	private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		response.sendRedirect("login.jsp");
	}
	
	// --- MÉTODOS PARA ADMIN ---
	
	private void listarClientes(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		List<Cliente> listaClientes = clienteDAO.listar();
		request.setAttribute("listaClientes", listaClientes);
		RequestDispatcher dispatcher = request.getRequestDispatcher("admin/lista-clientes.jsp");
		dispatcher.forward(request, response);
	}
	
	private void mostrarForm(HttpServletRequest request, HttpServletResponse response, String tipo) throws SQLException, ServletException, IOException {
		if (tipo.equals("edicao")) {
			String cpf = request.getParameter("cpf");
			Cliente clienteExistente = clienteDAO.buscarPorCpf(cpf);
			request.setAttribute("cliente", clienteExistente);
		}
		RequestDispatcher dispatcher = request.getRequestDispatcher("admin/form-cliente.jsp");
		dispatcher.forward(request, response);
	}

	private void apagarCliente(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		String cpf = request.getParameter("cpf");
		clienteDAO.apagar(cpf);
		response.sendRedirect("cliente?action=listar&msg=apagado");
	}
}


package br.com.Barbearia.controller;

import java.io.IOException;

import br.com.Barbearia.dao.ClienteDAO;
import br.com.Barbearia.model.Cliente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ClienteController")
public class ClienteController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ClienteDAO clienteDAO;
	
	@Override
    public void init() throws ServletException {
		clienteDAO = new ClienteDAO(); 
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
                case "login":
                    loginCliente(request, response);
                    break;
                case "verPerfil":
                    verPerfil(request, response);
                    break;
                case "editar":
                    editarCliente(request, response);
                    break;
                case "excluir":
                    excluirCliente(request, response);
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
	
	
	public void cadastrarCliente(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String cpf = request.getParameter("cpf");
        String nome = request.getParameter("nome");
        String telefone = request.getParameter("telefone");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
		
        Cliente cliente = new Cliente();
        cliente.setCpf(cpf);
        cliente.setNome(nome);
        cliente.setTelefone(telefone);
        cliente.setEmail(email);
        cliente.setSenha(senha);
      
        if (clienteDAO.buscarClientePorCpf(cpf) != null || clienteDAO.buscarClientePorEmail(email) != null) {
            response.getWriter().write("CPF ou E-mail já cadastrado.");
            return;
        }
        clienteDAO.inserirCliente(cliente);
        
        response.getWriter().write("Pessoa cadastrada com sucesso!");
    }
	
	public void loginCliente(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        Cliente cliente = clienteDAO.buscarClientePorEmail(email);
        
        if(cliente != null && cliente.getSenha().equals(senha)) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogado", cliente); // guardou na sessão
            response.getWriter().write("Login efetuado com sucesso!");
        } else {
            response.getWriter().write("Email ou senha inválidos.");
        }
    }
	
	public void verPerfil(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("usuarioLogado") == null) {
	        response.sendRedirect("login.jsp");
	    } else {
	        Cliente cliente = (Cliente) session.getAttribute("usuarioLogado");
	        request.setAttribute("cliente", cliente);
	        request.getRequestDispatcher("perfil.jsp").forward(request, response);
	    }
	}

    public void editarCliente(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Usuário não autenticado.");
            return;
        }

        
        Cliente clienteLogado = (Cliente) session.getAttribute("usuarioLogado");

        // Pega os novos dados do formulário
        String nome = request.getParameter("nome");
        String telefone = request.getParameter("telefone");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        
        clienteLogado.setNome(nome);
        clienteLogado.setTelefone(telefone);
        clienteLogado.setEmail(email);
        clienteLogado.setSenha(senha);

        clienteDAO.editarCliente(clienteLogado);

      
        session.setAttribute("usuarioLogado", clienteLogado);

        response.getWriter().write("Perfil atualizado com sucesso!");
    }

    public void excluirCliente(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Usuário não autenticado.");
            return;
        }

        Cliente clienteLogado = (Cliente) session.getAttribute("usuarioLogado");
        
       
        clienteDAO.apagarCliente(clienteLogado.getCpf());

        
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

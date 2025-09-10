package br.com.Barbearia.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import br.com.Barbearia.dao.CorteDAO;
import br.com.Barbearia.model.Corte;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/corte")
public class CorteController extends HttpServlet {
	private CorteDAO corteDAO;

	@Override
	public void init() {
		corteDAO = new CorteDAO();
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
				case "listarParaAgendamento": // NOVA AÇÃO PARA O FLUXO DO CLIENTE
					listarCortesParaAgendamento(request, response);
					break;
				case "formNovo":
					mostrarFormNovo(request, response);
					break;
				case "formEdicao":
					mostrarFormEdicao(request, response);
					break;
				case "listar": // Ação de admin
				default:
					listarCortes(request, response);
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
					cadastrarCorte(request, response);
					break;
				case "editar":
					editarCorte(request, response);
					break;
				case "apagar":
					apagarCorte(request, response);
					break;
				default:
					listarCortes(request, response);
					break;
			}
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	// --- NOVO MÉTODO PARA O FLUXO DE AGENDAMENTO ---
	private void listarCortesParaAgendamento(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		List<Corte> listaCortes = corteDAO.listar();
		request.setAttribute("listaCortes", listaCortes);
		
		System.out.println("DEBUG: Cortes encontrados no banco de dados: " + listaCortes.size());
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("agendamento-passo1-servico.jsp");
		dispatcher.forward(request, response);
	}

	// --- MÉTODOS PARA ADMIN ---
	private void listarCortes(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		List<Corte> listaCortes = corteDAO.listar();
		request.setAttribute("listaCortes", listaCortes);
		RequestDispatcher dispatcher = request.getRequestDispatcher("admin/lista-cortes.jsp");
		dispatcher.forward(request, response);
	}
	
	private void mostrarFormNovo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("admin/form-corte.jsp");
		dispatcher.forward(request, response);
	}
	
	private void mostrarFormEdicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		Corte corteExistente = corteDAO.buscarPorId(id);
		request.setAttribute("corte", corteExistente);
		RequestDispatcher dispatcher = request.getRequestDispatcher("admin/form-corte.jsp");
		dispatcher.forward(request, response);
	}

	private void cadastrarCorte(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		String nome = request.getParameter("nome");
		double valor = Double.parseDouble(request.getParameter("valor"));
		int duracao = Integer.parseInt(request.getParameter("duracao"));

		Corte novoCorte = new Corte(nome, valor, duracao);
		corteDAO.inserir(novoCorte);
		
		response.sendRedirect("corte?action=listar&msg=sucesso");
	}

	private void editarCorte(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		String nome = request.getParameter("nome");
		double valor = Double.parseDouble(request.getParameter("valor"));
		int duracao = Integer.parseInt(request.getParameter("duracao"));

		Corte corte = new Corte(id, nome, valor, duracao);
		corteDAO.editar(corte);
		
		response.sendRedirect("corte?action=listar&msg=editado");
	}

	private void apagarCorte(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		corteDAO.apagar(id);
		
		response.sendRedirect("corte?action=listar&msg=apagado");
	}
}


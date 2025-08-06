package br.com.Barbearia.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import br.com.Barbearia.dao.CorteDAO;
import br.com.Barbearia.model.Corte;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CorteController")
public class CorteController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CorteDAO corteDAO;

	@Override
	public void init() throws ServletException {
		corteDAO = new CorteDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			// Por padrão, uma requisição GET listará os cortes
			listarCortes(request, response);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			action = "listar"; // Ação padrão se nenhuma for especificada
		}

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
				case "listar":
				default:
					listarCortes(request, response);
					break;
			}
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	private void cadastrarCorte(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String nome = request.getParameter("nome_corte");
		double valor = Double.parseDouble(request.getParameter("valor_corte"));
		int duracao = Integer.parseInt(request.getParameter("duracao"));

		Corte novoCorte = new Corte();
		novoCorte.setNome_corte(nome);
		novoCorte.setValor_corte(valor);
		novoCorte.setDuracao(duracao);

		corteDAO.inserirCorte(novoCorte);
		
		// Redireciona para a lista de cortes para ver o novo item
		response.sendRedirect("CorteController?action=listar");
	}

	private void editarCorte(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int id = Integer.parseInt(request.getParameter("id_corte"));
		String nome = request.getParameter("nome_corte");
		double valor = Double.parseDouble(request.getParameter("valor_corte"));
		int duracao = Integer.parseInt(request.getParameter("duracao"));

		Corte corte = new Corte();
		corte.setId_corte(id);
		corte.setNome_corte(nome);
		corte.setValor_corte(valor);
		corte.setDuracao(duracao);

		corteDAO.editarCorte(corte);
		
		response.sendRedirect("CorteController?action=listar");
	}

	private void apagarCorte(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int id = Integer.parseInt(request.getParameter("id_corte"));
		corteDAO.apagarCorte(id);
		
		response.sendRedirect("CorteController?action=listar");
	}

	private void listarCortes(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Corte> listaCortes = corteDAO.listarCortes();
		request.setAttribute("listaCortes", listaCortes);
		
		// Encaminha para uma página JSP que exibirá a lista
		RequestDispatcher dispatcher = request.getRequestDispatcher("listaCortes.jsp");
		dispatcher.forward(request, response);
	}
}

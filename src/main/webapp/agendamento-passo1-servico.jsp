<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Corte" %>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // Recupera a lista de cortes e faz o "cast" para o tipo correto.
    // Isto torna o código no loop muito mais simples e seguro.
    List<Corte> listaCortes = (List<Corte>) request.getAttribute("listaCortes");

    // Recupera o cliente logado da sessão.
    Cliente usuarioLogado = (Cliente) session.getAttribute("usuarioLogado");
    
    // Cria um formatador para exibir os valores como moeda (R$).
    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamento: Passo 1 - Barbearia Premium</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Estilos Globais e Variáveis */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #8B0000; --secondary-red: #B22222; --dark-red: #600000;
            --white: #FFFFFF; --light-gray: #F8F8F8; --dark-gray: #333333; --gold: #FFD700;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-gray); }

        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary-red), var(--secondary-red));
            color: var(--white); padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; padding: 0 2rem; display: flex;
            justify-content: space-between; align-items: center;
        }
        .logo { font-size: 1.8rem; font-weight: bold; color: var(--white); text-decoration: none; }
        .logo i { margin-right: 0.5rem; color: var(--gold); }
        .user-info { display: flex; align-items: center; gap: 1rem; }
        .user-avatar {
            width: 40px; height: 40px; background: var(--gold); border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: var(--dark-gray); font-weight: bold; font-size: 1.2rem;
        }
        .btn-logout {
            background: transparent; border: 2px solid var(--white); color: var(--white);
            padding: 0.5rem 1rem; border-radius: 20px; text-decoration: none;
            font-weight: 600; transition: all 0.3s ease;
        }
        .btn-logout:hover { background: var(--white); color: var(--primary-red); }
        
        /* Conteúdo Principal */
        .main-container { max-width: 1200px; margin: 0 auto; padding: 2rem; }
        .page-header { text-align: center; margin-bottom: 2rem; }
        .page-title { font-size: 2.5rem; color: var(--primary-red); margin-bottom: 0.5rem; }
        .page-subtitle { color: var(--dark-gray); opacity: 0.8; }

        /* Barra de Progresso */
        .progress-bar {
            display: flex; justify-content: space-between; margin-bottom: 3rem; position: relative;
        }
        .progress-bar::before {
            content: ''; position: absolute; top: 50%; left: 0; right: 0;
            height: 4px; background: #e0e0e0; transform: translateY(-50%); z-index: 1;
        }
        .progress-line {
            position: absolute; top: 50%; left: 0;
            height: 4px; background: var(--primary-red); transform: translateY(-50%);
            width: 0%; z-index: 2; transition: width 0.5s ease;
        }
        .progress-step {
            display: flex; flex-direction: column; align-items: center; z-index: 3;
            text-align: center; width: 100px;
        }
        .step-circle {
            width: 40px; height: 40px; border-radius: 50%; background: #e0e0e0;
            display: flex; align-items: center; justify-content: center;
            font-weight: bold; color: var(--dark-gray); margin-bottom: 0.5rem;
            border: 4px solid var(--light-gray); transition: all 0.5s ease;
        }
        .step-label { font-weight: 600; color: var(--dark-gray); opacity: 0.6; }
        .progress-step.active .step-circle {
            background: var(--primary-red); color: var(--white); border-color: var(--secondary-red);
        }
        .progress-step.active .step-label { opacity: 1; }

        /* Grid de Serviços */
        .services-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
        }
        .service-card {
            background: var(--white); border-radius: 15px; overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); text-decoration: none;
            color: var(--dark-gray); display: flex; flex-direction: column;
            transition: all 0.3s ease;
        }
        .service-card:hover {
            transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .card-image {
            height: 150px; background-color: var(--primary-red);
            display: flex; align-items: center; justify-content: center;
            font-size: 3rem; color: var(--gold);
        }
        .card-content { padding: 1.5rem; flex-grow: 1; }
        .card-title { font-size: 1.5rem; margin-bottom: 0.5rem; color: var(--primary-red); }
        .card-details { display: flex; justify-content: space-between; color: var(--dark-gray); opacity: 0.8; }
        .card-details span { display: flex; align-items: center; gap: 0.5rem; }
        .card-footer {
            background: var(--light-gray); padding: 1rem 1.5rem; text-align: center;
            font-weight: bold; color: var(--primary-red);
        }
        .card-footer i { margin-left: 0.5rem; }
        
        .empty-state { text-align: center; padding: 2rem; }

        @media (max-width: 768px) {
            .progress-step { width: 80px; }
            .step-label { font-size: 0.8rem; }
        }
    </style>
</head>
<body>

    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <a href="cliente?action=home" class="logo"><i class="fas fa-cut"></i> Barbearia Premium</a>
            <% if (usuarioLogado != null) { %>
                <div class="user-info">
                    <div class="user-avatar"><%= usuarioLogado.getNome().charAt(0) %></div>
                    <a href="cliente?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
                </div>
            <% } %>
        </div>
    </header>

    <!-- Conteúdo Principal -->
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Novo Agendamento</h1>
            <p class="page-subtitle">Comece escolhendo o serviço que deseja.</p>
        </div>

        <!-- Barra de Progresso -->
        <div class="progress-bar">
            <div class="progress-line"></div>
            <div class="progress-step active">
                <div class="step-circle">1</div>
                <div class="step-label">Serviço</div>
            </div>
            <div class="progress-step">
                <div class="step-circle">2</div>
                <div class="step-label">Barbeiro</div>
            </div>
            <div class="progress-step">
                <div class="step-circle">3</div>
                <div class="step-label">Horário</div>
            </div>
            <div class="progress-step">
                <div class="step-circle">4</div>
                <div class="step-label">Confirmar</div>
            </div>
        </div>

        <!-- Grid de Serviços -->
        <div class="services-grid">
            <%
                if (listaCortes != null && !listaCortes.isEmpty()) {
                    for (Corte corte : listaCortes) {
            %>
                        <a href="especialidade?action=listarBarbeirosPorCorte&id_corte=<%= corte.getId_corte() %>" class="service-card">
                            <div class="card-image">
                                <i class="fas fa-cut"></i>
                            </div>
                            <div class="card-content">
                                <h2 class="card-title"><%= corte.getNome_corte() %></h2>
                                <div class="card-details">
                                    <span>
                                        <i class="fas fa-dollar-sign"></i>
                                        <%= formatoMoeda.format(corte.getValor_corte()) %>
                                    </span>
                                    <span>
                                        <i class="fas fa-clock"></i>
                                        <%= corte.getDuracao() %> min
                                    </span>
                                </div>
                            </div>
                            <div class="card-footer">
                                Escolher Serviço <i class="fas fa-arrow-right"></i>
                            </div>
                        </a>
            <%
                    } // Fim do for
                } else {
            %>
                <div class="empty-state">
                     <h3>Nenhum serviço encontrado</h3>
                     <p>Não há serviços de corte cadastrados no momento. Volte mais tarde.</p>
                </div>
            <% } // Fim do if %>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const progressLine = document.querySelector('.progress-line');
            setTimeout(() => {
                 progressLine.style.width = '0%';
            }, 100);
        });
    </script>

</body>
</html>


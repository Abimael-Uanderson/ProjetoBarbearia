<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil - Royal Blades</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'wine-main': '#7B1E2B',
                        'wine-dark': '#5A121C',
                        'gray-light': '#f5f5f5',
                    },
                    fontFamily: {
                        'playfair': ['"Playfair Display"', 'serif'],
                        'montserrat': ['"Montserrat"', 'sans-serif'],
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-light">
    <% 
        // Simulação de dados do cliente logado
        Cliente cliente = new Cliente();
        cliente.setNome("Carlos Silva");
        cliente.setEmail("carlos.silva@email.com");
        cliente.setTelefone("(11) 99999-8888");
        cliente.setCpf("12345678901");
        // Em uma aplicação real, este objeto viria da sessão.
        // Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
        
        String nomeCliente = (cliente != null) ? cliente.getNome() : "Visitante";
        String emailCliente = (cliente != null) ? cliente.getEmail() : "N/A";
        String telefoneCliente = (cliente != null) ? cliente.getTelefone() : "N/A";
        String cpfCliente = (cliente != null) ? cliente.getCpf().substring(0, 3) + ".***.***-" + cliente.getCpf().substring(9) : "N/A";
        String iniciais = (cliente != null) ? cliente.getNome().substring(0, 1).toUpperCase() : "?";
    %>
    <div class="w-full max-w-sm mx-auto bg-gray-light min-h-screen flex flex-col">
        
        <main class="flex-grow">
            <div class="h-40 flex flex-col items-center justify-center bg-wine-main">
                <img src="https://placehold.co/96x96/FFFFFF/7B1E2B?text=<%= iniciais %>" alt="Foto de Perfil" class="w-24 h-24 rounded-full border-4 border-white shadow-md">
                <h1 class="font-playfair text-2xl text-white mt-2"><%= nomeCliente %></h1>
            </div>

            <div class="p-6 space-y-4">
                <div class="bg-white p-4 rounded-lg shadow-sm">
                    <label class="text-xs text-gray-500">Email</label>
                    <p class="font-medium text-gray-800"><%= emailCliente %></p>
                </div>
                <div class="bg-white p-4 rounded-lg shadow-sm">
                    <label class="text-xs text-gray-500">Telefone</label>
                    <p class="font-medium text-gray-800"><%= telefoneCliente %></p>
                </div>
                <div class="bg-white p-4 rounded-lg shadow-sm">
                    <label class="text-xs text-gray-500">CPF</label>
                    <p class="font-medium text-gray-800"><%= cpfCliente %></p>
                </div>
            </div>

            <div class="px-6 mt-2 space-y-3">
                <a href="#" class="w-full text-left p-4 rounded-lg bg-white shadow-sm block">Editar Perfil</a>
                <a href="AgendamentoController?action=listarPorCliente&cpfCliente=<%= (cliente != null) ? cliente.getCpf() : "" %>" class="w-full text-left p-4 rounded-lg bg-white shadow-sm block">Histórico de Agendamentos</a>
            </div>
            
            <div class="p-6 mt-4">
                <a href="login.jsp" class="w-full h-[50px] text-center font-bold rounded-md bg-gray-200 text-wine-main flex items-center justify-center">
                    Sair
                </a>
            </div>
        </main>

        <nav class="w-full h-20 bg-white rounded-t-2xl flex justify-around items-center border-t sticky bottom-0">
            <a href="inicial.jsp" class="text-center text-gray-400">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" viewBox="0 0 20 20" fill="currentColor"><path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" /></svg>
                <span class="text-xs">Início</span>
            </a>
            <a href="agendamento.jsp" class="text-center text-gray-400">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                <span class="text-xs">Agendar</span>
            </a>
            <a href="#" class="text-center text-wine-main">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                <span class="text-xs">Perfil</span>
            </a>
        </nav>
    </div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Corte" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Escolha o Corte - Royal Blades</title>
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

    <div class="w-full max-w-sm mx-auto bg-gray-light min-h-screen flex flex-col">
        
        <main class="p-6 flex-grow">
            <h1 class="font-playfair text-3xl text-center mt-10 mb-8 text-wine-main">Escolha o Corte</h1>
            
            <div class="grid grid-cols-2 gap-5">
                <% 
                // A lista de cortes viria do Controller via request.getAttribute()
                List<Corte> listaCortes = (List<Corte>) request.getAttribute("listaCortes");
                if (listaCortes != null) {
                    for (Corte corte : listaCortes) {
                %>
                <a href="agendamento.jsp?corteId=<%= corte.getId_corte() %>" class="bg-white rounded-lg shadow-sm overflow-hidden block">
                    <img src="https://placehold.co/200x150/7B1E2B/FFFFFF?text=<%= corte.getNome_corte() %>" alt="Corte <%= corte.getNome_corte() %>" class="w-full h-24 object-cover">
                    <div class="p-3 text-center">
                        <h2 class="font-playfair text-md text-wine-dark"><%= corte.getNome_corte() %></h2>
                        <p class="font-montserrat text-sm text-gray-600">R$ <%= String.format("%.2f", corte.getValor_corte()) %></p>
                    </div>
                </a>
                <%
                    }
                } else {
                %>
                <p>Nenhum corte disponível no momento.</p>
                <%
                }
                %>
            </div>
        </main>

        <nav class="w-full h-20 bg-white rounded-t-2xl flex justify-around items-center border-t sticky bottom-0">
            <a href="inicial.jsp" class="text-center text-gray-400">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" viewBox="0 0 20 20" fill="currentColor"><path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" /></svg>
                <span class="text-xs">Início</span>
            </a>
            <a href="agendamento.jsp" class="text-center text-wine-main">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                <span class="text-xs">Agendar</span>
            </a>
            <a href="perfil.jsp" class="text-center text-gray-400">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                <span class="text-xs">Perfil</span>
            </a>
        </nav>
    </div>

</body>
</html>

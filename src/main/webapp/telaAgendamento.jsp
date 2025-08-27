<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="br.com.Barbearia.model.Cliente" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.Barbearia.model.Agendamento" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamento - Royal Blades</title>
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
        // Simulação de dados dinâmicos para a página
        // Na implementação real, estes dados viriam do Controller via request.getAttribute()
        Cliente clienteLogado = new Cliente();
        clienteLogado.setCpf("11122233344");

        // Simulação de horários de trabalho
        List<String> horariosDisponiveis = List.of("09:00", "10:00", "11:00", "14:00", "15:00");
        List<String> horariosOcupados = List.of("12:00", "16:00");
    %>
    <div class="w-full max-w-sm mx-auto bg-gray-light min-h-screen flex flex-col">
        
        <main class="p-6 flex-grow">
            <h1 class="font-playfair text-3xl text-center mt-10 mb-6 text-wine-main">Agendar Horário</h1>
            
            <div class="bg-white p-3 rounded-lg shadow-sm text-sm">
                <div class="flex justify-between items-center mb-2">
                    <button class="font-bold text-lg text-wine-main">&lt;</button>
                    <h2 class="font-bold text-wine-main">Agosto 2025</h2>
                    <button class="font-bold text-lg text-wine-main">&gt;</button>
                </div>
                <div class="grid grid-cols-7 text-center text-xs text-gray-400 font-bold">
                    <span>D</span><span>S</span><span>T</span><span>Q</span><span>Q</span><span>S</span><span>S</span>
                </div>
                <div class="grid grid-cols-7 text-center text-xs mt-1">
                    <span class="p-1.5 text-gray-300">27</span><span class="p-1.5 text-gray-300">28</span><span class="p-1.5 text-gray-300">29</span><span class="p-1.5 text-gray-300">30</span><span class="p-1.5 text-gray-300">31</span><span class="p-1.5">1</span><span class="p-1.5">2</span>
                    <span class="p-1.5">3</span><span class="p-1.5">4</span><span class="p-1.5">5</span><span class="p-1.5">6</span><span class="p-1.5">7</span><span class="p-1.5">8</span><span class="p-1.5">9</span>
                    <span class="p-1.5">10</span><span class="p-1.5">11</span><span class="p-1.5">12</span><span class="p-1.5">13</span><span class="p-1.5">14</span><span class="p-1.5 bg-gray-200 rounded-full">15</span><span class="p-1.5">16</span>
                    <span class="p-1.5">17</span><span class="p-1.5">18</span><span class="p-1.5 bg-wine-main/20 text-wine-dark font-bold rounded-full">19</span><span class="p-1.5">20</span><span class="p-1.5">21</span><span class="p-1.5">22</span><span class="p-1.5">23</span>
                </div>
            </div>

            <h3 class="font-playfair text-lg mt-4 mb-2 text-wine-main">Horários disponíveis</h3>
            
            <form action="AgendamentoController" method="POST">
                <input type="hidden" name="action" value="cadastrar">
                <input type="hidden" name="data_atendimentoAg" id="dataSelecionada" value="">
                <input type="hidden" name="duracao_totalAg" value="60"> <!-- Valor estático para o exemplo, pode ser dinâmico -->
                <input type="hidden" name="status_agendamentoAg" value="PENDENTE">
                <input type="hidden" name="cliente" value="<%= clienteLogado.getCpf() %>">

                <div class="grid grid-cols-4 gap-2 text-center text-xs">
                    <% for (String horario : horariosDisponiveis) { %>
                        <button type="submit" name="horario_selecionado" value="<%= horario %>" class="p-2 border border-gray-300 rounded-md hover:bg-gray-200">
                            <%= horario %>
                        </button>
                    <% } %>
                    <% for (String horario : horariosOcupados) { %>
                        <button type="button" class="p-2 border border-gray-200 bg-gray-100 text-gray-300 rounded-md" disabled>
                            <%= horario %>
                        </button>
                    <% } %>
                </div>
                
                <div class="w-full mt-8">
                    <button type="submit" class="w-full h-[50px] text-center font-bold rounded-md bg-wine-main text-white flex items-center justify-center">
                        Confirmar Agendamento
                    </button>
                </div>
            </form>
        </main>

        <nav class="w-full h-20 bg-white rounded-t-2xl flex justify-around items-center border-t sticky bottom-0">
            <a href="inicial.jsp" class="text-center text-gray-400">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" viewBox="0 0 20 20" fill="currentColor"><path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" /></svg>
                <span class="text-xs">Início</span>
            </a>
            <a href="#" class="text-center text-wine-main">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                <span class="text-xs">Agendar</span>
            </a>
            <a href="perfil.jsp" class="text-center text-gray-400">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                <span class="text-xs">Perfil</span>
            </a>
        </nav>
    </div>
    <script>
        // Lógica para selecionar a data e o horário
        const dataSelecionadaInput = document.getElementById('dataSelecionada');
        document.querySelectorAll('.grid-cols-7 span').forEach(day => {
            day.addEventListener('click', () => {
                // Remove a seleção do dia anterior
                document.querySelector('.bg-wine-main/20')?.classList.remove('bg-wine-main/20', 'text-wine-dark', 'font-bold');
                // Adiciona a nova seleção
                day.classList.add('bg-wine-main/20', 'text-wine-dark', 'font-bold');
                // Atualiza o input oculto
                const dia = day.textContent.trim();
                const mes = "08"; // Mês fixo para o exemplo, na realidade seria dinâmico
                const ano = "2025"; // Ano fixo para o exemplo, na realidade seria dinâmico
                const dataFormatada = ano + "-" + mes + "-" + dia.padStart(2, '0');
                dataSelecionadaInput.value = dataFormatada + " 09:00:00"; // Define um horário padrão inicial
            });
        });

        // Lógica para selecionar o horário e atualizar o input de data/hora
        document.querySelectorAll('.grid-cols-4 button[type="submit"]').forEach(hourButton => {
            hourButton.addEventListener('click', (event) => {
                // Impede o envio imediato do formulário
                event.preventDefault();

                // Remove a seleção do horário anterior
                document.querySelector('.bg-wine-main')?.classList.remove('bg-wine-main', 'text-white');
                // Adiciona a nova seleção
                hourButton.classList.add('bg-wine-main', 'text-white');
                
                // Extrai o horário do botão
                const horario = hourButton.textContent.trim();
                // Atualiza o input de data/hora com o horário selecionado
                const dataAtual = dataSelecionadaInput.value.split(" ")[0];
                dataSelecionadaInput.value = dataAtual + " " + horario + ":00";
            });
        });
    </script>
</body>
</html>

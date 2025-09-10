<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Histórico - Royal Blades</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-red: #8B0000;
            --secondary-red: #B22222;
            --light-red: #DC143C;
            --dark-red: #600000;
            --white: #FFFFFF;
            --light-gray: #F8F8F8;
            --dark-gray: #333333;
            --gold: #FFD700;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--primary-red), var(--secondary-red));
            min-height: 100vh;
            padding: 1rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header-nav {
            background: var(--white);
            border-radius: 15px;
            padding: 1rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-red);
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav-links a {
            color: var(--dark-gray);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: var(--primary-red);
        }

        .nav-links a.active {
            color: var(--primary-red);
            font-weight: 600;
        }

        .main-container {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            min-height: 600px;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-red), var(--secondary-red));
            color: var(--white);
            padding: 3rem;
            text-align: center;
        }

        .page-header h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .content-area {
            padding: 3rem;
        }

        .filter-bar {
            background: var(--light-gray);
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-group label {
            font-weight: 600;
            color: var(--dark-gray);
        }

        .filter-group select,
        .filter-group input {
            padding: 0.5rem;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 0.9rem;
        }

        .filter-group select:focus,
        .filter-group input:focus {
            outline: none;
            border-color: var(--primary-red);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: var(--primary-red);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--dark-red);
        }

        .btn-outline {
            background: transparent;
            color: var(--primary-red);
            border: 2px solid var(--primary-red);
        }

        .btn-outline:hover {
            background: var(--primary-red);
            color: var(--white);
        }

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-left: 4px solid var(--primary-red);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-red);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--dark-gray);
            font-size: 0.9rem;
        }

        .appointments-grid {
            display: grid;
            gap: 1.5rem;
        }

        .appointment-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .appointment-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .appointment-header {
            padding: 1.5rem;
            display: flex;
            justify-content: between;
            align-items: center;
            border-bottom: 1px solid #eee;
        }

        .appointment-date {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--primary-red);
        }

        .appointment-time {
            color: var(--dark-gray);
            font-size: 0.9rem;
        }

        .appointment-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-concluido {
            background: #e8f5e8;
            color: #00b894;
        }

        .status-agendado {
            background: #e3f2fd;
            color: #1976d2;
        }

        .status-cancelado {
            background: #ffe6e6;
            color: #d63031;
        }

        .appointment-body {
            padding: 1.5rem;
        }

        .appointment-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-item i {
            color: var(--primary-red);
            width: 16px;
        }

        .info-item span {
            color: var(--dark-gray);
        }

        .appointment-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--dark-gray);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--primary-red);
            opacity: 0.3;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            margin-bottom: 1rem;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin-top: 2rem;
            padding: 1rem;
        }

        .pagination button {
            padding: 0.5rem 1rem;
            border: 2px solid var(--primary-red);
            background: transparent;
            color: var(--primary-red);
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .pagination button:hover,
        .pagination button.active {
            background: var(--primary-red);
            color: var(--white);
        }

        .pagination button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-group {
                justify-content: space-between;
            }

            .appointment-info {
                grid-template-columns: 1fr;
            }

            .appointment-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .nav-links {
                gap: 1rem;
            }

            .header-nav {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
            }

            .content-area {
                padding: 2rem;
            }

            .page-header {
                padding: 2rem;
            }

            .page-header h1 {
                font-size: 2rem;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 0.5rem;
            }

            .content-area {
                padding: 1.5rem;
            }

            .page-header {
                padding: 1.5rem;
            }

            .page-header h1 {
                font-size: 1.5rem;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .appointment-card {
            animation: fadeInUp 0.6s ease-out;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation Header -->
        <nav class="header-nav">
            <div class="logo">
                <i class="fas fa-cut"></i> Royal Blades
            </div>
            <div class="nav-links">
                <a href="index.jsp"><i class="fas fa-home"></i> Início</a>
                <a href="cliente?action=verPerfil"><i class="fas fa-user"></i> Perfil</a>
                <a href="historico.jsp" class="active"><i class="fas fa-history"></i> Histórico</a>
                <a href="agendamento.jsp"><i class="fas fa-calendar-plus"></i> Agendar</a>
                <a href="cliente?action=logout"><i class="fas fa-sign-out-alt"></i> Sair</a>
            </div>
        </nav>

        <div class="main-container">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fas fa-history"></i> Meu Histórico</h1>
                <p>Acompanhe todos os seus agendamentos e serviços realizados</p>
            </div>

            <!-- Content Area -->
            <div class="content-area">
                <!-- Statistics Overview -->
                <div class="stats-overview">
                    <div class="stat-card">
                        <div class="stat-number">15</div>
                        <div class="stat-label">Total de Cortes</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">R$ 450</div>
                        <div class="stat-label">Valor Total Gasto</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">2</div>
                        <div class="stat-label">Agendamentos Futuros</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">1</div>
                        <div class="stat-label">Cancelamentos</div>
                    </div>
                </div>

                <!-- Filter Bar -->
                <div class="filter-bar">
                    <div class="filter-group">
                        <label for="status-filter">Status:</label>
                        <select id="status-filter">
                            <option value="">Todos</option>
                            <option value="AGENDADO">Agendado</option>
                            <option value="CONCLUIDO">Concluído</option>
                            <option value="CANCELADO">Cancelado</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="periodo-filter">Período:</label>
                        <select id="periodo-filter">
                            <option value="">Todos</option>
                            <option value="30">Últimos 30 dias</option>
                            <option value="90">Últimos 3 meses</option>
                            <option value="365">Último ano</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label for="data-inicio">De:</label>
                        <input type="date" id="data-inicio">
                    </div>

                    <div class="filter-group">
                        <label for="data-fim">Até:</label>
                        <input type="date" id="data-fim">
                    </div>

                    <button class="btn btn-primary" onclick="aplicarFiltros()">
                        <i class="fas fa-search"></i> Filtrar
                    </button>
                </div>

                <!-- Appointments List -->
                <div class="appointments-grid" id="appointments-list">
                    <!-- Agendamento Futuro -->
                    <div class="appointment-card">
                        <div class="appointment-header">
                            <div>
                                <div class="appointment-date">25 de Dezembro de 2024</div>
                                <div class="appointment-time">14:30</div>
                            </div>
                            <span class="appointment-status status-agendado">Agendado</span>
                        </div>
                        <div class="appointment-body">
                            <div class="appointment-info">
                                <div class="info-item">
                                    <i class="fas fa-cut"></i>
                                    <span><strong>Serviço:</strong> Corte Social</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-user"></i>
                                    <span><strong>Barbeiro:</strong> João Silva</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-clock"></i>
                                    <span><strong>Duração:</strong> 30 min</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-dollar-sign"></i>
                                    <span><strong>Valor:</strong> R$ 30,00</span>
                                </div>
                            </div>
                            <div class="appointment-actions">
                                <button class="btn btn-outline" onclick="cancelarAgendamento(1)">
                                    <i class="fas fa-times"></i> Cancelar
                                </button>
                                <button class="btn btn-primary" onclick="remarcarAgendamento(1)">
                                    <i class="fas fa-calendar-alt"></i> Remarcar
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Agendamento Futuro 2 -->
                    <div class="appointment-card">
                        <div class="appointment-header">
                            <div>
                                <div class="appointment-date">28 de Dezembro de 2024</div>
                                <div class="appointment-time">16:00</div>
                            </div>
                            <span class="appointment-status status-agendado">Agendado</span>
                        </div>
                        <div class="appointment-body">
                            <div class="appointment-info">
                                <div class="info-item">
                                    <i class="fas fa-cut"></i>
                                    <span><strong>Serviço:</strong> Corte Degradê</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-user"></i>
                                    <span><strong>Barbeiro:</strong> Carlos Santos</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-clock"></i>
                                    <span><strong>Duração:</strong> 45 min</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-dollar-sign"></i>
                                    <span><strong>Valor:</strong> R$ 35,00</span>
                                </div>
                            </div>
                            <div class="appointment-actions">
                                <button class="btn btn-outline" onclick="cancelarAgendamento(2)">
                                    <i class="fas fa-times"></i> Cancelar
                                </button>
                                <button class="btn btn-primary" onclick="remarcarAgendamento(2)">
                                    <i class="fas fa-calendar-alt"></i> Remarcar
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Agendamento Concluído -->
                    <div class="appointment-card">
                        <div class="appointment-header">
                            <div>
                                <div class="appointment-date">20 de Dezembro de 2024</div>
                                <div class="appointment-time">15:00</div>
                            </div>
                            <span class="appointment-status status-concluido">Concluído</span>
                        </div>
                        <div class="appointment-body">
                            <div class="appointment-info">
                                <div class="info-item">
                                    <i class="fas fa-cut"></i>
                                    <span><strong>Serviço:</strong> Corte Social</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-user"></i>
                                    <span><strong>Barbeiro:</strong> João Silva</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-clock"></i>
                                    <span><strong>Duração:</strong> 30 min</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-dollar-sign"></i>
                                    <span><strong>Valor:</strong> R$ 30,00</span>
                                </div>
                            </div>
                            <div class="appointment-actions">
                                <button class="btn btn-primary" onclick="agendarNovamente('corte-social')">
                                    <i class="fas fa-redo"></i> Agendar Novamente
                                </button>
                                <button class="btn btn-outline" onclick="avaliarServico(3)">
                                    <i class="fas fa-star"></i> Avaliar
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Agendamento Cancelado -->
                    <div class="appointment-card">
                        <div class="appointment-header">
                            <div>
                                <div class="appointment-date">15 de Dezembro de 2024</div>
                                <div class="appointment-time">10:00</div>
                            </div>
                            <span class="appointment-status status-cancelado">Cancelado</span>
                        </div>
                        <div class="appointment-body">
                            <div class="appointment-info">
                                <div class="info-item">
                                    <i class="fas fa-cut"></i>
                                    <span><strong>Serviço:</strong> Corte Degradê</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-user"></i>
                                    <span><strong>Barbeiro:</strong> Carlos Santos</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-info-circle"></i>
                                    <span><strong>Motivo:</strong> Cancelado pelo cliente</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-dollar-sign"></i>
                                    <span><strong>Valor:</strong> R$ 35,00</span>
                                </div>
                            </div>
                            <div class="appointment-actions">
                                <button class="btn btn-primary" onclick="agendarNovamente('corte-degrade')">
                                    <i class="fas fa-calendar-plus"></i> Reagendar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="pagination">
                    <button onclick="changePage(-1)" id="prev-btn">
                        <i class="fas fa-chevron-left"></i> Anterior
                    </button>
                    <button class="active" onclick="goToPage(1)">1</button>
                    <button onclick="goToPage(2)">2</button>
                    <button onclick="goToPage(3)">3</button>
                    <button onclick="changePage(1)" id="next-btn">
                        Próximo <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentPage = 1;
        let totalPages = 3;

        // Filter functions
        function aplicarFiltros() {
            const status = document.getElementById('status-filter').value;
            const periodo = document.getElementById('periodo-filter').value;
            const dataInicio = document.getElementById('data-inicio').value;
            const dataFim = document.getElementById('data-fim').value;
            
            // Implementar lógica de filtragem aqui
            console.log('Aplicando filtros:', { status, periodo, dataInicio, dataFim });
            
            // Simular filtragem
            const cards = document.querySelectorAll('.appointment-card');
            cards.forEach(card => {
                // Lógica de filtragem baseada nos valores selecionados
                card.style.display = 'block';
            });
        }

        // Appointment actions
        function cancelarAgendamento(id) {
            if (confirm('Tem certeza que deseja cancelar este agendamento?')) {
                // Implementar cancelamento via AJAX ou redirecionamento
                alert('Agendamento cancelado com sucesso!');
                location.reload();
            }
        }

        function remarcarAgendamento(id) {
            // Redirecionar para página de agendamento com dados preenchidos
            window.location.href = `agendamento.jsp?remarcar=${id}`;
        }

        function agendarNovamente(tipoCorte) {
            // Redirecionar para agendamento com serviço pré-selecionado
            window.location.href = `agendamento.jsp?servico=${tipoCorte}`;
        }

        function avaliarServico(id) {
            alert('Funcionalidade de avaliação em desenvolvimento.');
        }

        // Pagination
        function changePage(direction) {
            const newPage = currentPage + direction;
            if (newPage >= 1 && newPage <= totalPages) {
                goToPage(newPage);
            }
        }

        function goToPage(page) {
            currentPage = page;
            
            // Update active button
            document.querySelectorAll('.pagination button').forEach(btn => {
                btn.classList.remove('active');
            });
            document.querySelector(`button[onclick="goToPage(${page})"]`).classList.add('active');
            
            // Update prev/next buttons
            document.getElementById('prev-btn').disabled = (currentPage === 1);
            document.getElementById('next-btn').disabled = (currentPage === totalPages);
            
            // Implementar carregamento de dados da página
            console.log(`Carregando página ${page}`);
        }

        // Initialize pagination
        document.addEventListener('DOMContentLoaded', function() {
            goToPage(1);
        });

        // Auto-apply filters on change
        document.getElementById('status-filter').addEventListener('change', aplicarFiltros);
        document.getElementById('periodo-filter').addEventListener('change', aplicarFiltros);
    </script>
</body>
</html>
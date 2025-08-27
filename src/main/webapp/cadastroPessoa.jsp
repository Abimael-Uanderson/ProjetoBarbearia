<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro - Royal Blades</title>
    
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
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

    <div class="w-full max-w-sm bg-white rounded-2xl shadow-xl p-8">
        
        <header class="text-center mb-8">
            <h1 class="font-playfair text-3xl text-wine-main">Criar Conta</h1>
            <p class="text-gray-500 mt-1">Junte-se à Royal Blades</p>
        </header>

        <div id="form-messages" class="mb-4 hidden p-3 rounded-md text-sm text-red-700 bg-red-100 border border-red-200"></div>

        <form action="ClienteController" method="POST" id="cadastro-form" class="space-y-4">
            <input type="hidden" name="action" value="cadastrar">
            
            <div>
                <label for="nome" class="text-sm font-medium text-gray-700">Nome Completo</label>
                <input type="text" id="nome" name="nome" placeholder="Seu nome completo"
                        class="w-full h-[50px] bg-gray-100 text-gray-800 px-4 mt-1 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-wine-main" required>
            </div>

            <div>
                <label for="email" class="text-sm font-medium text-gray-700">E-mail</label>
                <input type="email" id="email" name="email" placeholder="seu@email.com"
                        class="w-full h-[50px] bg-gray-100 text-gray-800 px-4 mt-1 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-wine-main" required>
            </div>

            <div>
                <label for="telefone" class="text-sm font-medium text-gray-700">Telefone</label>
                <input type="tel" id="telefone" name="telefone" placeholder="(11) 99999-8888"
                        pattern="^\(\d{2}\) \d{4,5}-\d{4}$"
                        title="Formato: (99) 99999-9999 ou (99) 9999-9999"
                        class="w-full h-[50px] bg-gray-100 text-gray-800 px-4 mt-1 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-wine-main" required>
            </div>

            <div>
                <label for="cpf" class="text-sm font-medium text-gray-700">CPF</label>
                <input type="text" id="cpf" name="cpf" placeholder="000.000.000-00"
                        pattern="^\d{3}\.\d{3}\.\d{3}-\d{2}$"
                        title="Formato: 000.000.000-00"
                        class="w-full h-[50px] bg-gray-100 text-gray-800 px-4 mt-1 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-wine-main" required>
            </div>

            <div>
                <label for="senha" class="text-sm font-medium text-gray-700">Senha</label>
                <input type="password" id="senha" name="senha" placeholder="Crie uma senha forte"
                        class="w-full h-[50px] bg-gray-100 text-gray-800 px-4 mt-1 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-wine-main" required>
            </div>

            <div>
                <label for="confirmarSenha" class="text-sm font-medium text-gray-700">Confirmar Senha</label>
                <input type="password" id="confirmarSenha" name="confirmarSenha" placeholder="Repita a senha"
                        class="w-full h-[50px] bg-gray-100 text-gray-800 px-4 mt-1 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-wine-main" required>
            </div>

            <div class="pt-4">
                <button type="submit"
                        class="w-full h-[50px] text-center font-bold text-white rounded-md bg-wine-main hover:bg-wine-dark transition-colors">
                    Cadastrar
                </button>
            </div>
        </form>

        <div class="text-center mt-6">
            <a href="login.jsp" class="font-montserrat text-sm text-wine-main underline">
                Já tenho conta
            </a>
        </div>
    </div>

    <script>
        document.getElementById('cadastro-form').addEventListener('submit', function(event) {
            const senha = document.getElementById('senha').value;
            const confirmarSenha = document.getElementById('confirmarSenha').value;
            const mensagemErroDiv = document.getElementById('form-messages');

            if (senha !== confirmarSenha) {
                event.preventDefault();
                mensagemErroDiv.textContent = 'As senhas não coincidem. Por favor, verifique.';
                mensagemErroDiv.classList.remove('hidden');
            } else {
                mensagemErroDiv.classList.add('hidden');
            }
        });
    </script>

</body>
</html>

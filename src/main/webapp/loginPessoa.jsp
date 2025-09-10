<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Royal Blades</title>
    
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
<body class="bg-wine-main flex items-center justify-center min-h-screen">

    <div class="w-full max-w-sm p-8">
        
        <header class="text-center mb-10">
            <h1 class="font-playfair text-5xl text-white">Royal Blades</h1>
        </header>

        <form action="LoginServlet" method="POST" class="space-y-5">
            
            <div class="relative">
                <label for="email" class="sr-only">E-mail</label>
                <span class="absolute left-4 top-1/2 -translate-y-1/2 text-white/60">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                        <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                    </svg>
                </span>
                <input type="email" id="email" name="email" placeholder="E-mail"
                        class="w-full h-[50px] bg-white/20 text-white placeholder-white/80 pl-12 pr-4 rounded-md border border-white/40 focus:outline-none focus:ring-2 focus:ring-white" required>
            </div>

            <div class="relative">
                <label for="senha" class="sr-only">Senha</label>
                <span class="absolute left-4 top-1/2 -translate-y-1/2 text-white/60">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                    </svg>
                </span>
                <input type="password" id="senha" name="senha" placeholder="Senha"
                        class="w-full h-[50px] bg-white/20 text-white placeholder-white/80 pl-12 pr-4 rounded-md border border-white/40 focus:outline-none focus:ring-2 focus:ring-white" required>
            </div>

            <div class="pt-4">
                <button type="submit"
                        class="w-full h-[50px] text-center font-bold text-wine-main rounded-md bg-white hover:bg-gray-200 transition-colors" >
                    Entrar
                </button>
            </div>
        </form>

        <div class="text-center mt-6">
            <a href="cadastroPessoa.jsp" class="font-montserrat text-sm text-white underline">
                Criar conta
            </a>
        </div>
    </div>

</body>
</html>

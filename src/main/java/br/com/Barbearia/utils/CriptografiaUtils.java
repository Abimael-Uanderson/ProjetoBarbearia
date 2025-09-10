package br.com.Barbearia.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Classe utilitária para criptografia de senhas.
 */
public class CriptografiaUtils {

    /**
     * Gera um hash SHA-256 para a senha fornecida.
     * @param senha A senha em texto plano.
     * @return O hash da senha em formato hexadecimal.
     */
    public static String hashSenha(String senha) {
        try {
            // Obtém uma instância do algoritmo de hash SHA-256
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            
            // Converte a senha para bytes e calcula o hash
            byte[] hashBytes = digest.digest(senha.getBytes(StandardCharsets.UTF_8));
            
            // Converte o array de bytes para uma string hexadecimal
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            // Este erro não deve acontecer se o algoritmo "SHA-256" for válido
            throw new RuntimeException("Erro ao criptografar a senha.", e);
        }
    }
}


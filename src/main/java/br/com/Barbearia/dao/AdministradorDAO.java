package br.com.Barbearia.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import br.com.Barbearia.model.Administrador;
import br.com.Barbearia.utils.Conexao;
import br.com.Barbearia.utils.CriptografiaUtils;

public class AdministradorDAO {

    /**
     * Verifica as credenciais de login de um administrador.
     * @param email O email fornecido no login.
     * @param senhaPlana A senha em TEXTO PLANO fornecida no login.
     * @return O objeto Administrador se as credenciais estiverem corretas, ou null caso contrário.
     */
    public Administrador buscarPorEmailESenha(String email, String senhaPlana) throws SQLException {
        String sql = "SELECT id_admin, email, senha FROM administrador WHERE email = ? AND senha = ?";
        Administrador admin = null;
        
        String senhaCriptografada = CriptografiaUtils.hashSenha(senhaPlana);
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, senhaCriptografada);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    admin = new Administrador();
                    admin.setId_admin(rs.getInt("id_admin"));
                    admin.setEmail(rs.getString("email"));
                    admin.setSenha(rs.getString("senha"));
                }
            }
        } 
        return admin;
    }
}
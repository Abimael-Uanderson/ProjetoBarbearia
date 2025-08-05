package br.com.Barbearia.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Barbeiro;
import br.com.Barbearia.utils.Conexao;

public class BarbeiroDAO {

    public void inserirBarbeiro(Barbeiro barbeiro) throws SQLException {
        String sql = "INSERT INTO barbeiro (cpf, nome, telefone, email, senha) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, barbeiro.getCpf());
            stmt.setString(2, barbeiro.getNome());
            stmt.setString(3, barbeiro.getTelefone());
            stmt.setString(4, barbeiro.getEmail());
            stmt.setString(5, barbeiro.getSenha());
            
            stmt.executeUpdate();
        }catch (SQLException e){
        	e.printStackTrace();
        }
    }

    public void editarBarbeiro(Barbeiro barbeiro) throws SQLException {
        String sql = "UPDATE barbeiro SET nome = ?, telefone = ?, email = ?, senha = ? WHERE cpf = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setString(1, barbeiro.getNome());
            stmt.setString(2, barbeiro.getTelefone());
            stmt.setString(3, barbeiro.getEmail());
            stmt.setString(4, barbeiro.getSenha());
            stmt.setString(5, barbeiro.getCpf());
            
            stmt.executeUpdate();
        }catch (SQLException e){
        	e.printStackTrace();
        }
    }

    public void apagarBarbeiro(String cpf) throws SQLException {
        String sql = "DELETE FROM barbeiro WHERE cpf = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, cpf);
            
            stmt.executeUpdate();
        }catch (SQLException e){
        	e.printStackTrace();
        }
    }

    public List<Barbeiro> listarBarbeiros() throws SQLException {
        List<Barbeiro> barbeiros = new ArrayList<>();
        String sql = "SELECT cpf, nome, telefone, email, senha FROM barbeiro";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Barbeiro barbeiro = new Barbeiro();
                barbeiro.setCpf(rs.getString("cpf"));
                barbeiro.setNome(rs.getString("nome"));
                barbeiro.setTelefone(rs.getString("telefone"));
                barbeiro.setEmail(rs.getString("email"));
                barbeiro.setSenha(rs.getString("senha"));
                
                barbeiros.add(barbeiro);
            }
        }catch (SQLException e){
        	e.printStackTrace();
        }
        return barbeiros;
    }
    
    public Barbeiro buscarBarbeiroPorCpf(String cpf) throws SQLException {
        String sql = "SELECT cpf, nome, telefone, email, senha FROM barbeiro WHERE cpf = ?";
        Barbeiro barbeiro = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, cpf);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    barbeiro = new Barbeiro();
                    barbeiro.setCpf(rs.getString("cpf"));
                    barbeiro.setNome(rs.getString("nome"));
                    barbeiro.setTelefone(rs.getString("telefone"));
                    barbeiro.setEmail(rs.getString("email"));
                    barbeiro.setSenha(rs.getString("senha"));
                }
            }
        }catch (SQLException e){
        	e.printStackTrace();
        }
        return barbeiro;
    }
    
    public Barbeiro buscarBarbeiroPorEmail(String email) throws SQLException {
        String sql = "SELECT cpf, nome, telefone, email, senha FROM barbeiro WHERE email = ?";
        Barbeiro barbeiro = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    barbeiro = new Barbeiro();
                    barbeiro.setCpf(rs.getString("cpf"));
                    barbeiro.setNome(rs.getString("nome"));
                    barbeiro.setTelefone(rs.getString("telefone"));
                    barbeiro.setEmail(rs.getString("email"));
                    barbeiro.setSenha(rs.getString("senha"));
                }
            }
        }catch (SQLException e){
        	e.printStackTrace();
        }
        return barbeiro;
    }
}

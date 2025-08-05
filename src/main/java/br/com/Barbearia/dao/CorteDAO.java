package br.com.Barbearia.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Corte;
import br.com.Barbearia.utils.Conexao;

public class CorteDAO {

    public void inserirCorte(Corte corte) throws SQLException {
        String sql = "INSERT INTO corte (nome_corte, valor_corte, duracao) VALUES (?, ?, ?)";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, corte.getNome_corte());
            stmt.setBigDecimal(2, BigDecimal.valueOf(corte.getValor_corte()));
            stmt.setInt(3, corte.getDuracao());
            
            stmt.executeUpdate();
        }catch (SQLException e){
        	e.printStackTrace();
        }
    }

    public void editarCorte(Corte corte) throws SQLException {
        String sql = "UPDATE corte SET nome_corte = ?, valor_corte = ?, duracao = ? WHERE id_corte = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setString(1, corte.getNome_corte());
            stmt.setBigDecimal(2, BigDecimal.valueOf(corte.getValor_corte()));
            stmt.setInt(3, corte.getDuracao());
            stmt.setInt(4, corte.getId_corte());
            
            stmt.executeUpdate();
        }catch (SQLException e){
        	e.printStackTrace();
        }
    }

    public void apagarCorte(int id) throws SQLException {
        String sql = "DELETE FROM corte WHERE id_corte = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            stmt.executeUpdate();
        }catch (SQLException e){
        	e.printStackTrace();
        }
    }

    public List<Corte> listarCortes() throws SQLException {
        List<Corte> cortes = new ArrayList<>();
        String sql = "SELECT id_corte, nome_corte, valor_corte, duracao FROM corte";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Corte corte = new Corte();
                corte.setId_corte(rs.getInt("id_corte"));
                corte.setNome_corte(rs.getString("nome_corte"));
                corte.setValor_corte(rs.getBigDecimal("valor_corte").doubleValue());
                corte.setDuracao(rs.getInt("duracao"));
                
                cortes.add(corte);
            }
        }catch (SQLException e){
        	e.printStackTrace();
        }
        return cortes;
    }
    
    public Corte buscarCortePorId(int id) throws SQLException {
        String sql = "SELECT id_corte, nome_corte, valor_corte, duracao FROM corte WHERE id_corte = ?";
        Corte corte = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    corte = new Corte();
                    corte.setId_corte(rs.getInt("id_corte"));
                    corte.setNome_corte(rs.getString("nome_corte"));
                    corte.setValor_corte(rs.getBigDecimal("valor_corte").doubleValue());
                    corte.setDuracao(rs.getInt("duracao"));
                }
            }
        }catch (SQLException e){
        	e.printStackTrace();
        }
        return corte;
    }
}

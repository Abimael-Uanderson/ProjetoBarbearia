package br.com.Barbearia.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Barbeiro;
import br.com.Barbearia.model.Corte;
import br.com.Barbearia.model.Especialidade;
import br.com.Barbearia.utils.Conexao;

public class EspecialidadeDAO {

    public void inserirEspecialidade(Especialidade especialidade) throws SQLException {
        String sql = "INSERT INTO especialidade (corte, barbeiro) VALUES (?, ?)";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, especialidade.getCorte().getId_corte());
            stmt.setString(2, especialidade.getBarbeiro().getCpf());
            
            stmt.executeUpdate();
        }catch (SQLException e){
        	e.printStackTrace();
        }
    }

    public void apagarEspecialidade(int id) throws SQLException {
        String sql = "DELETE FROM especialidade WHERE id_especialidadeEp = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            stmt.executeUpdate();
        }catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public List<Especialidade> listarEspecialidades() throws SQLException {
        List<Especialidade> especialidades = new ArrayList<>();
        
        String sql = "SELECT esp.id_especialidadeEp, "
                   + "c.nome_corte, c.valor_corte, c.id_corte, c.duracao, "
                   + "b.cpf AS barbeiro_cpf, b.nome AS barbeiro_nome "
                   + "FROM especialidade AS esp "
                   + "INNER JOIN corte AS c ON esp.corte = c.id_corte "
                   + "INNER JOIN barbeiro AS b ON esp.barbeiro = b.cpf";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Especialidade especialidade = new Especialidade();
                    especialidade.setId_especialidadeEp(rs.getInt("id_especialidadeEp"));

                    Corte corte = new Corte();
                    corte.setId_corte(rs.getInt("id_corte"));
                    corte.setNome_corte(rs.getString("nome_corte"));
                    corte.setValor_corte(rs.getBigDecimal("valor_corte").doubleValue()); // Convertendo para Double
                    corte.setDuracao(rs.getInt("duracao"));
                    especialidade.setCorte(corte);

                    Barbeiro barbeiro = new Barbeiro();
                    barbeiro.setCpf(rs.getString("barbeiro_cpf"));
                    barbeiro.setNome(rs.getString("barbeiro_nome"));
                    especialidade.setBarbeiro(barbeiro);
                    
                    especialidades.add(especialidade);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return especialidades;
    }
    
    public Especialidade buscarEspecialidadePorId(int id) throws SQLException {
        String sql = "SELECT esp.id_especialidadeEp, "
                   + "c.nome_corte, c.valor_corte, c.id_corte, c.duracao, "
                   + "b.cpf AS barbeiro_cpf, b.nome AS barbeiro_nome "
                   + "FROM especialidade AS esp "
                   + "INNER JOIN corte AS c ON esp.corte = c.id_corte "
                   + "INNER JOIN barbeiro AS b ON esp.barbeiro = b.cpf "
                   + "WHERE esp.id_especialidadeEp = ?"; 
        
        Especialidade especialidade = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    especialidade = new Especialidade();
                    especialidade.setId_especialidadeEp(rs.getInt("id_especialidadeEp"));

                    Corte corte = new Corte();
                    corte.setId_corte(rs.getInt("id_corte"));
                    corte.setNome_corte(rs.getString("nome_corte"));
                    corte.setValor_corte(rs.getBigDecimal("valor_corte").doubleValue());
                    corte.setDuracao(rs.getInt("duracao"));
                    especialidade.setCorte(corte);

                    Barbeiro barbeiro = new Barbeiro();
                    barbeiro.setCpf(rs.getString("barbeiro_cpf"));
                    barbeiro.setNome(rs.getString("barbeiro_nome"));
                    especialidade.setBarbeiro(barbeiro);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return especialidade;
    }
}

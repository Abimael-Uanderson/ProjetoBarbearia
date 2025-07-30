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
        }
    }

    public void apagarEspecialidade(int id) throws SQLException {
        String sql = "DELETE FROM especialidade WHERE id_especialidadeEp = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            stmt.executeUpdate();
        }
    }

    public List<Especialidade> listarEspecialidades() throws SQLException {
        List<Especialidade> especialidades = new ArrayList<>();
        String sql = "SELECT id_especialidadeEp, corte, barbeiro FROM especialidade";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Especialidade especialidade = new Especialidade();
                especialidade.setId_especialidadeEp(rs.getInt("id_especialidadeEp"));

                Corte corte = new Corte();
                corte.setId_corte(rs.getInt("corte"));
                especialidade.setCorte(corte);

                Barbeiro barbeiro = new Barbeiro();
                barbeiro.setCpf(rs.getString("barbeiro"));
                especialidade.setBarbeiro(barbeiro);
                
                especialidades.add(especialidade);
            }
        }
        return especialidades;
    }
    
    public Especialidade buscarEspecialidadePorId(int id) throws SQLException {
        String sql = "SELECT id_especialidadeEp, corte, barbeiro FROM especialidade WHERE id_especialidadeEp = ?";
        Especialidade especialidade = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    especialidade = new Especialidade();
                    especialidade.setId_especialidadeEp(rs.getInt("id_especialidadeEp"));

                    Corte corte = new Corte();
                    corte.setId_corte(rs.getInt("corte"));
                    especialidade.setCorte(corte);

                    Barbeiro barbeiro = new Barbeiro();
                    barbeiro.setCpf(rs.getString("barbeiro"));
                    especialidade.setBarbeiro(barbeiro);
                }
            }
        }
        return especialidade;
    }
}

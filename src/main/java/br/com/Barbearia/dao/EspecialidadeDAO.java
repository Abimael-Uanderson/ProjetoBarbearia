package br.com.Barbearia.dao;

import br.com.Barbearia.model.Barbeiro;
import br.com.Barbearia.model.Corte;
import br.com.Barbearia.model.Especialidade;
import br.com.Barbearia.utils.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EspecialidadeDAO {

    public void inserir(Especialidade especialidade) throws SQLException {
        String sql = "INSERT INTO especialidade (corte, barbeiro) VALUES (?, ?)";
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, especialidade.getCorte().getId_corte());
            stmt.setString(2, especialidade.getBarbeiro().getCpf());
            stmt.executeUpdate();
        }
    }

    public void apagar(int id) throws SQLException {
        String sql = "DELETE FROM especialidade WHERE id_especialidadeEp = ?";
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Barbeiro> listarBarbeirosPorCorte(int idCorte) throws SQLException {
        List<Barbeiro> barbeiros = new ArrayList<>();
        String sql = "SELECT b.cpf, b.nome, b.telefone, b.email " +
                     "FROM barbeiro b " +
                     "INNER JOIN especialidade e ON b.cpf = e.barbeiro " +
                     "WHERE e.corte = ?";
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, idCorte);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Barbeiro barbeiro = new Barbeiro();
                    barbeiro.setCpf(rs.getString("cpf"));
                    barbeiro.setNome(rs.getString("nome"));
                    barbeiro.setTelefone(rs.getString("telefone"));
                    barbeiro.setEmail(rs.getString("email"));
                    barbeiros.add(barbeiro);
                }
            }
        }
        return barbeiros;
    }
    
    /**
     * NOVO MÉTODO: Lista todas as especialidades cadastradas.
     * @return Uma lista de objetos Especialidade com dados completos de Barbeiro e Corte.
     */
    public List<Especialidade> listarTodas() throws SQLException {
        List<Especialidade> especialidades = new ArrayList<>();
        String sql = "SELECT e.id_especialidadeEp, " +
                     "b.cpf as barbeiro_cpf, b.nome as barbeiro_nome, " +
                     "c.id_corte, c.nome_corte " +
                     "FROM especialidade e " +
                     "INNER JOIN barbeiro b ON e.barbeiro = b.cpf " +
                     "INNER JOIN corte c ON e.corte = c.id_corte " +
                     "ORDER BY b.nome, c.nome_corte";
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Barbeiro b = new Barbeiro();
                b.setCpf(rs.getString("barbeiro_cpf"));
                b.setNome(rs.getString("barbeiro_nome"));

                Corte c = new Corte();
                c.setId_corte(rs.getInt("id_corte"));
                c.setNome_corte(rs.getString("nome_corte"));

                Especialidade e = new Especialidade();
                e.setId_especialidadeEp(rs.getInt("id_especialidadeEp"));
                e.setBarbeiro(b);
                e.setCorte(c);
                
                especialidades.add(e);
            }
        }
        return especialidades;
    }


    public Especialidade buscarPorCorteEBarbeiro(int idCorte, String cpfBarbeiro) throws SQLException {
        String sql = "SELECT e.id_especialidadeEp, " +
                     "c.id_corte, c.nome_corte, c.valor_corte, c.duracao " +
                     "FROM especialidade e " +
                     "INNER JOIN corte c ON e.corte = c.id_corte " +
                     "WHERE e.corte = ? AND e.barbeiro = ?";
        Especialidade especialidade = null;
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, idCorte);
            stmt.setString(2, cpfBarbeiro);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Corte corte = new Corte();
                    corte.setId_corte(rs.getInt("id_corte"));
                    corte.setNome_corte(rs.getString("nome_corte"));
                    corte.setValor_corte(rs.getDouble("valor_corte"));
                    corte.setDuracao(rs.getInt("duracao"));

                    Barbeiro barbeiro = new Barbeiro();
                    barbeiro.setCpf(cpfBarbeiro);

                    especialidade = new Especialidade();
                    especialidade.setId_especialidadeEp(rs.getInt("id_especialidadeEp"));
                    especialidade.setCorte(corte);
                    especialidade.setBarbeiro(barbeiro);
                }
            }
        }
        return especialidade;
    }
}

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
     * MÉTODO CHAVE: Busca uma especialidade específica e carrega os dados completos do corte.
     * Essencial para o AgendamentoController saber o valor do serviço.
     * @param idCorte O ID do corte desejado.
     * @param cpfBarbeiro O CPF do barbeiro.
     * @return Um objeto Especialidade com os dados do Corte preenchidos, ou null se não encontrar.
     */
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


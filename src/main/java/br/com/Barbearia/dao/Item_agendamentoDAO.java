package br.com.Barbearia.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Agendamento;
import br.com.Barbearia.model.Barbeiro;
import br.com.Barbearia.model.Corte;
import br.com.Barbearia.model.Especialidade;
import br.com.Barbearia.model.Item_agendamento;
import br.com.Barbearia.utils.Conexao;

public class Item_agendamentoDAO {

    public void inserirItemAgendamento(Item_agendamento item) throws SQLException {
        String sql = "INSERT INTO item_agendamento (valor_itemIg, especialidade, agendamento) VALUES (?, ?, ?)";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setBigDecimal(1, BigDecimal.valueOf(item.getValor_itemIg()));
            stmt.setInt(2, item.getEspecialidade().getId_especialidadeEp());
            stmt.setInt(3, item.getAgendamento().getId_agendamentoAg());
            
            stmt.executeUpdate();
        }
    }

    public void apagarItemAgendamento(int id) throws SQLException {
        String sql = "DELETE FROM item_agendamento WHERE id_itemIg = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            stmt.executeUpdate();
        }catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public List<Item_agendamento> listarPorAgendamento(int idAgendamento) throws SQLException {
        List<Item_agendamento> itens = new ArrayList<>();
        final String sql = "SELECT " +
                           "    ia.id_itemIg, ia.valor_itemIg, ia.agendamento, " +
                           "    e.id_especialidadeEp, " +
                           "    c.id_corte, c.nome_corte, c.valor_corte, c.duracao, " +
                           "    b.cpf AS barbeiro_cpf, b.nome AS barbeiro_nome " +
                           "FROM " +
                           "    item_agendamento ia " +
                           "INNER JOIN " +
                           "    especialidade e ON ia.especialidade = e.id_especialidadeEp " +
                           "INNER JOIN " +
                           "    corte c ON e.corte = c.id_corte " +
                           "INNER JOIN " +
                           "    barbeiro b ON e.barbeiro = b.cpf " +
                           "WHERE " +
                           "    ia.agendamento = ?";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, idAgendamento);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    itens.add(mapearItemCompleto(rs));
                }
            }
        }catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return itens;
    }

    private Item_agendamento mapearItemCompleto(ResultSet rs) throws SQLException {
        Barbeiro barbeiro = new Barbeiro();
        barbeiro.setCpf(rs.getString("barbeiro_cpf"));
        barbeiro.setNome(rs.getString("barbeiro_nome"));

        Corte corte = new Corte();
        corte.setId_corte(rs.getInt("id_corte"));
        corte.setNome_corte(rs.getString("nome_corte"));
        corte.setValor_corte(rs.getBigDecimal("valor_corte").doubleValue());
        corte.setDuracao(rs.getInt("duracao"));

        Especialidade especialidade = new Especialidade();
        especialidade.setId_especialidadeEp(rs.getInt("id_especialidadeEp"));
        especialidade.setCorte(corte);
        especialidade.setBarbeiro(barbeiro);

        Agendamento agendamento = new Agendamento();
        agendamento.setId_agendamentoAg(rs.getInt("agendamento"));

        Item_agendamento item = new Item_agendamento();
        item.setId_itemIg(rs.getInt("id_itemIg"));
        item.setValor_itemIg(rs.getBigDecimal("valor_itemIg").doubleValue());
        item.setEspecialidade(especialidade);
        item.setAgendamento(agendamento);

        return item;
    }
}

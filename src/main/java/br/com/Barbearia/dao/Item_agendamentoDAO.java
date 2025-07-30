package br.com.Barbearia.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Agendamento;
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
        }
    }

    public List<Item_agendamento> listarItensPorAgendamento(int idAgendamento) throws SQLException {
        List<Item_agendamento> itens = new ArrayList<>();
        String sql = "SELECT id_itemIg, valor_itemIg, especialidade, agendamento FROM item_agendamento WHERE agendamento = ?";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, idAgendamento);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Item_agendamento item = new Item_agendamento();
                    item.setId_itemIg(rs.getInt("id_itemIg"));
                    item.setValor_itemIg(rs.getBigDecimal("valor_itemIg").doubleValue());

                    Especialidade especialidade = new Especialidade();
                    especialidade.setId_especialidadeEp(rs.getInt("especialidade"));
                    item.setEspecialidade(especialidade);

                    Agendamento agendamento = new Agendamento();
                    agendamento.setId_agendamentoAg(rs.getInt("agendamento"));
                    item.setAgendamento(agendamento);
                    
                    itens.add(item);
                }
            }
        }
        return itens;
    }
}

package br.com.Barbearia.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Agendamento;
import br.com.Barbearia.model.Cliente;
import br.com.Barbearia.utils.Conexao;

public class AgendamentoDAO {

    public void inserirAgendamento(Agendamento agendamento) throws SQLException {
        String sql = "INSERT INTO agendamento (data_atendimentoAg, status_agendamentoAg, duracao_totalAg, cliente) VALUES (?, ?, ?, ?)";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(agendamento.getData_atendimentoAg()));
            stmt.setString(2, agendamento.getStatus_agendamentoAg());
            stmt.setInt(3, agendamento.getDuracao_totalAg());
            stmt.setString(4, agendamento.getCliente().getCpf());
            
            stmt.executeUpdate();
        }
    }

    public void editarAgendamento(Agendamento agendamento) throws SQLException {
        String sql = "UPDATE agendamento SET data_atendimentoAg = ?, status_agendamentoAg = ?, duracao_totalAg = ?, cliente = ? WHERE id_agendamentoAg = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setTimestamp(1, Timestamp.valueOf(agendamento.getData_atendimentoAg()));
            stmt.setString(2, agendamento.getStatus_agendamentoAg());
            stmt.setInt(3, agendamento.getDuracao_totalAg());
            stmt.setString(4, agendamento.getCliente().getCpf());
            stmt.setInt(5, agendamento.getId_agendamentoAg());
            
            stmt.executeUpdate();
        }
    }

    public void apagarAgendamento(int id) throws SQLException {
        String sql = "DELETE FROM agendamento WHERE id_agendamentoAg = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            stmt.executeUpdate();
        }
    }

    public List<Agendamento> listarAgendamentos() throws SQLException {
        List<Agendamento> agendamentos = new ArrayList<>();
        String sql = "SELECT id_agendamentoAg, data_atendimentoAg, status_agendamentoAg, duracao_totalAg, cliente FROM agendamento";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Agendamento agendamento = new Agendamento();
                agendamento.setId_agendamentoAg(rs.getInt("id_agendamentoAg"));
                agendamento.setData_atendimentoAg(rs.getTimestamp("data_atendimentoAg").toLocalDateTime());
                agendamento.setStatus_agendamentoAg(rs.getString("status_agendamentoAg"));
                agendamento.setDuracao_totalAg(rs.getInt("duracao_totalAg"));
                
                Cliente cliente = new Cliente();
                cliente.setCpf(rs.getString("cliente"));
                agendamento.setCliente(cliente);
                
                agendamentos.add(agendamento);
            }
        }
        return agendamentos;
    }
    
    public Agendamento buscarAgendamentoPorId(int id) throws SQLException {
        String sql = "SELECT id_agendamentoAg, data_atendimentoAg, status_agendamentoAg, duracao_totalAg, cliente FROM agendamento WHERE id_agendamentoAg = ?";
        Agendamento agendamento = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    agendamento = new Agendamento();
                    agendamento.setId_agendamentoAg(rs.getInt("id_agendamentoAg"));
                    agendamento.setData_atendimentoAg(rs.getTimestamp("data_atendimentoAg").toLocalDateTime());
                    agendamento.setStatus_agendamentoAg(rs.getString("status_agendamentoAg"));
                    agendamento.setDuracao_totalAg(rs.getInt("duracao_totalAg"));

                    Cliente cliente = new Cliente();
                    cliente.setCpf(rs.getString("cliente"));
                    agendamento.setCliente(cliente);
                }
            }
        }
        return agendamento;
    }
}
package br.com.Barbearia.dao;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.*;
import br.com.Barbearia.utils.Conexao;

public class AgendamentoDAO {

    /**
     * Insere um novo agendamento no banco de dados.
     * @param agendamento O objeto Agendamento a ser inserido.
     * @return O ID do agendamento recém-criado, ou -1 em caso de falha.
     */
    public int inserir(Agendamento agendamento) throws SQLException {
        String sql = "INSERT INTO agendamento (data_atendimentoAg, status_agendamentoAg, duracao_totalAg, cliente, barbeiro) VALUES (?, ?, ?, ?, ?)";
        int idGerado = -1;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setTimestamp(1, Timestamp.valueOf(agendamento.getData_atendimentoAg()));
            stmt.setString(2, agendamento.getStatus_agendamentoAg());
            stmt.setInt(3, agendamento.getDuracao_totalAg());
            stmt.setString(4, agendamento.getCliente().getCpf());
            stmt.setString(5, agendamento.getBarbeiro().getCpf());

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    idGerado = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return idGerado;
    }
    
    /**
     * Altera o status de um agendamento para 'CANCELADO'.
     * @param idAgendamento O ID do agendamento a ser cancelado.
     */
    public void cancelar(int idAgendamento) throws SQLException {
        String sql = "UPDATE agendamento SET status_agendamentoAg = 'CANCELADO' WHERE id_agendamentoAg = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, idAgendamento);
            stmt.executeUpdate();
        }
    }


    /**
     * Lista o histórico de agendamentos de um cliente específico.
     * @param cpfCliente O CPF do cliente.
     * @return Uma lista com o histórico de agendamentos do cliente.
     */
    public List<Agendamento> listarPorCliente(String cpfCliente) throws SQLException {
        List<Agendamento> agendamentos = new ArrayList<>();
        // Consulta poderosa que busca tudo o que a home page precisa de uma só vez
        String sql = "SELECT " +
                     "    ag.id_agendamentoAg, ag.data_atendimentoAg, ag.status_agendamentoAg, ag.duracao_totalAg, " +
                     "    b.nome AS barbeiro_nome, " +
                     "    co.nome_corte, " +
                     "    ia.valor_itemIg " +
                     "FROM agendamento ag " +
                     "INNER JOIN barbeiro b ON ag.barbeiro = b.cpf " +
                     "LEFT JOIN item_agendamento ia ON ag.id_agendamentoAg = ia.agendamento " +
                     "LEFT JOIN especialidade e ON ia.especialidade = e.id_especialidadeEp " +
                     "LEFT JOIN corte co ON e.corte = co.id_corte " +
                     "WHERE ag.cliente = ? " +
                     "ORDER BY ag.data_atendimentoAg DESC";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setString(1, cpfCliente);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Agendamento agendamento = new Agendamento();
                    agendamento.setId_agendamentoAg(rs.getInt("id_agendamentoAg"));
                    agendamento.setData_atendimentoAg(rs.getTimestamp("data_atendimentoAg").toLocalDateTime());
                    agendamento.setStatus_agendamentoAg(rs.getString("status_agendamentoAg"));
                    agendamento.setDuracao_totalAg(rs.getInt("duracao_totalAg"));

                    Barbeiro barbeiro = new Barbeiro();
                    barbeiro.setNome(rs.getString("barbeiro_nome"));
                    agendamento.setBarbeiro(barbeiro);
                    
                    // Monta a estrutura de objetos completa que a JSP precisa
                    Corte corte = new Corte();
                    corte.setNome_corte(rs.getString("nome_corte"));

                    Especialidade especialidade = new Especialidade();
                    especialidade.setCorte(corte);

                    Item_agendamento item = new Item_agendamento();
                    item.setValor_itemIg(rs.getDouble("valor_itemIg"));
                    item.setEspecialidade(especialidade);
                    
                    // Define o item completo no agendamento
                    agendamento.setItemAgendamento(item);

                    // Define o campo facilitador também, para consistência
                    agendamento.setNomeServico(rs.getString("nome_corte"));

                    agendamentos.add(agendamento);
                }
            }
        }
        return agendamentos;
    }

    /**
     * Busca um agendamento completo pelo seu ID, incluindo todos os detalhes.
     * @param idAgendamento o ID do agendamento a ser buscado.
     * @return um objeto Agendamento completo, ou null se não for encontrado.
     */
    public Agendamento buscarCompletoPorId(int idAgendamento) throws SQLException {
        Agendamento agendamento = null;
        String sql = "SELECT " +
                     "    ag.id_agendamentoAg, ag.data_atendimentoAg, ag.status_agendamentoAg, ag.duracao_totalAg, " +
                     "    c.cpf AS cliente_cpf, c.nome AS cliente_nome, " +
                     "    b.cpf AS barbeiro_cpf, b.nome AS barbeiro_nome, " +
                     "    ia.id_itemIg, ia.valor_itemIg, " +
                     "    co.id_corte, co.nome_corte, co.duracao " +
                     "FROM agendamento ag " +
                     "INNER JOIN cliente c ON ag.cliente = c.cpf " +
                     "INNER JOIN barbeiro b ON ag.barbeiro = b.cpf " +
                     "INNER JOIN item_agendamento ia ON ag.id_agendamentoAg = ia.agendamento " +
                     "INNER JOIN especialidade e ON ia.especialidade = e.id_especialidadeEp " +
                     "INNER JOIN corte co ON e.corte = co.id_corte " +
                     "WHERE ag.id_agendamentoAg = ?";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setInt(1, idAgendamento);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    agendamento = new Agendamento();
                    agendamento.setId_agendamentoAg(rs.getInt("id_agendamentoAg"));
                    agendamento.setData_atendimentoAg(rs.getTimestamp("data_atendimentoAg").toLocalDateTime());
                    agendamento.setStatus_agendamentoAg(rs.getString("status_agendamentoAg"));
                    agendamento.setDuracao_totalAg(rs.getInt("duracao_totalAg"));

                    Cliente cliente = new Cliente();
                    cliente.setCpf(rs.getString("cliente_cpf"));
                    cliente.setNome(rs.getString("cliente_nome"));
                    agendamento.setCliente(cliente);

                    Barbeiro barbeiro = new Barbeiro();
                    barbeiro.setCpf(rs.getString("barbeiro_cpf"));
                    barbeiro.setNome(rs.getString("barbeiro_nome"));
                    agendamento.setBarbeiro(barbeiro);

                    Corte corte = new Corte();
                    corte.setId_corte(rs.getInt("id_corte"));
                    corte.setNome_corte(rs.getString("nome_corte"));
                    corte.setDuracao(rs.getInt("duracao"));
                    corte.setValor_corte(rs.getDouble("valor_itemIg"));

                    Especialidade esp = new Especialidade();
                    esp.setCorte(corte);
                    esp.setBarbeiro(barbeiro);

                    Item_agendamento item = new Item_agendamento();
                    item.setId_itemIg(rs.getInt("id_itemIg"));
                    item.setValor_itemIg(rs.getDouble("valor_itemIg"));
                    item.setEspecialidade(esp);
                    
                    agendamento.setItemAgendamento(item);
                }
            }
        }
        return agendamento;
    }
    
    /**
     * Lista os agendamentos de um barbeiro específico em uma data.
     * @param cpfBarbeiro O CPF do barbeiro.
     * @param dia A data para a qual os agendamentos serão listados.
     * @return Uma lista de agendamentos para o barbeiro no dia especificado.
     */
    public List<Agendamento> listarPorBarbeiroNaData(String cpfBarbeiro, LocalDate dia) throws SQLException {
        List<Agendamento> agendamentos = new ArrayList<>();
        String sql = "SELECT id_agendamentoAg, data_atendimentoAg, duracao_totalAg " +
                     "FROM agendamento " +
                     "WHERE barbeiro = ? AND DATE(data_atendimentoAg) = ?";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setString(1, cpfBarbeiro);
            stmt.setDate(2, Date.valueOf(dia));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Agendamento agendamento = new Agendamento();
                    agendamento.setId_agendamentoAg(rs.getInt("id_agendamentoAg"));
                    agendamento.setData_atendimentoAg(rs.getTimestamp("data_atendimentoAg").toLocalDateTime());
                    agendamento.setDuracao_totalAg(rs.getInt("duracao_totalAg"));
                    agendamentos.add(agendamento);
                }
            }
        }
        return agendamentos;
    }
}


package br.com.Barbearia.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Barbeiro;
import br.com.Barbearia.utils.Conexao;
import br.com.Barbearia.utils.CriptografiaUtils; // Importa a classe de criptografia

public class BarbeiroDAO {

	/**
	 * Insere um novo barbeiro no banco de dados.
	 * A senha JÁ DEVE VIR CRIPTOGRAFADA do Controller.
	 * @param barbeiro O objeto Barbeiro a ser inserido.
	 */
	public void inserir(Barbeiro barbeiro) throws SQLException {
		String sql = "INSERT INTO barbeiro (cpf, nome, telefone, email, senha) VALUES (?, ?, ?, ?, ?)";
		
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
        	
            stmt.setString(1, barbeiro.getCpf());
            stmt.setString(2, barbeiro.getNome());
            stmt.setString(3, barbeiro.getTelefone());
            stmt.setString(4, barbeiro.getEmail());
            stmt.setString(5, barbeiro.getSenha()); // Salva a senha já criptografada
            
            stmt.executeUpdate();
        }
	}
	
	/**
	 * Atualiza os dados de um barbeiro existente.
	 * A senha JÁ DEVE VIR CRIPTOGRAFADA do Controller.
	 * @param barbeiro O objeto Barbeiro com os dados atualizados.
	 */
	public void editar(Barbeiro barbeiro) throws SQLException {
		String sql = "UPDATE barbeiro SET nome = ?, telefone = ?, email = ?, senha = ? WHERE cpf = ?";
		
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setString(1, barbeiro.getNome());
            stmt.setString(2, barbeiro.getTelefone());
            stmt.setString(3, barbeiro.getEmail());
            stmt.setString(4, barbeiro.getSenha()); // Salva a senha já criptografada
            stmt.setString(5, barbeiro.getCpf());
            
            stmt.executeUpdate();
        }
	}

	/**
	 * Apaga um barbeiro do banco de dados pelo CPF.
	 * @param cpf O CPF do barbeiro a ser apagado.
	 */
	public void apagar(String cpf) throws SQLException {
        String sql = "DELETE FROM barbeiro WHERE cpf = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
        	
            stmt.setString(1, cpf);
            
            stmt.executeUpdate();
        }
    }

	/**
	 * Lista todos os barbeiros cadastrados no sistema.
	 * @return Uma lista de objetos Barbeiro.
	 */
	public List<Barbeiro> listar() throws SQLException {
        List<Barbeiro> barbeiros = new ArrayList<>();
        String sql = "SELECT cpf, nome, telefone, email FROM barbeiro"; // Não seleciona a senha por segurança

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Barbeiro barbeiro = new Barbeiro();
                barbeiro.setCpf(rs.getString("cpf"));
                barbeiro.setNome(rs.getString("nome"));
                barbeiro.setTelefone(rs.getString("telefone"));
                barbeiro.setEmail(rs.getString("email"));
                
                barbeiros.add(barbeiro);
            }
        }
        return barbeiros;
    }
    
	/**
	 * Busca um barbeiro específico pelo seu CPF.
	 * @param cpf O CPF do barbeiro.
	 * @return O objeto Barbeiro encontrado, ou null se não existir.
	 */
	public Barbeiro buscarPorCpf(String cpf) throws SQLException {
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
        }
        return barbeiro;
    }
    
	/**
	 * Busca um barbeiro específico pelo seu Email.
	 * @param email O Email do barbeiro.
	 * @return O objeto Barbeiro encontrado, ou null se não existir.
	 */
	public Barbeiro buscarPorEmail(String email) throws SQLException {
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
        }
        return barbeiro;
    }

	/**
	 * Verifica as credenciais de login de um barbeiro.
	 * @param email O email fornecido no login.
	 * @param senhaPlana A senha em TEXTO PLANO fornecida no login.
	 * @return O objeto Barbeiro se as credenciais estiverem corretas, ou null caso contrário.
	 */
    public Barbeiro buscarPorEmailESenha(String email, String senhaPlana) throws SQLException {
        String sql = "SELECT cpf, nome, telefone, email, senha FROM barbeiro WHERE email = ? AND senha = ?";
        Barbeiro barbeiro = null;
        
        // Criptografa a senha recebida para comparar com a do banco
        String senhaCriptografada = CriptografiaUtils.hashSenha(senhaPlana);
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, senhaCriptografada); // Compara o hash da senha
            
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
        } 
        return barbeiro;
    }
}

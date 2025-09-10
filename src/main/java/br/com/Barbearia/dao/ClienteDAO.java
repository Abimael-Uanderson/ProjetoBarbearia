package br.com.Barbearia.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Cliente;
import br.com.Barbearia.utils.Conexao;
import br.com.Barbearia.utils.CriptografiaUtils; // Importa a nova classe

public class ClienteDAO {
	
	/**
	 * Insere um novo cliente no banco de dados.
	 * A senha JÁ DEVE VIR CRIPTOGRAFADA do Controller.
	 * @param cliente O objeto Cliente a ser inserido.
	 */
	public void inserir(Cliente cliente) throws SQLException {
		String sql = "INSERT INTO cliente (cpf, nome, telefone, email, senha) VALUES (?, ?, ?, ?, ?)";
		
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
        	stmt.setString(1, cliente.getCpf());
            stmt.setString(2, cliente.getNome());
            stmt.setString(3, cliente.getTelefone());
            stmt.setString(4, cliente.getEmail());
            stmt.setString(5, cliente.getSenha()); // Salva a senha já criptografada
            
            stmt.executeUpdate();
        }
	}
	
	/**
	 * Atualiza os dados de um cliente existente.
	 * A senha JÁ DEVE VIR CRIPTOGRAFADA do Controller.
	 * @param cliente O objeto Cliente com os dados atualizados.
	 */
	public void editar(Cliente cliente) throws SQLException {
		String sql = "UPDATE cliente SET nome = ?, telefone = ?, email = ?, senha = ? WHERE cpf = ?";
		
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
        	stmt.setString(1, cliente.getNome());
            stmt.setString(2, cliente.getTelefone());
            stmt.setString(3, cliente.getEmail());
            stmt.setString(4, cliente.getSenha()); // Salva a senha já criptografada
            stmt.setString(5, cliente.getCpf());
            
            stmt.executeUpdate();
        }
	}
	
	public void apagar(String cpf) throws SQLException {
        String sql = "DELETE FROM cliente WHERE cpf = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, cpf);
            
            stmt.executeUpdate();
        }
    }
	
	public List<Cliente> listar() throws SQLException {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT cpf, nome, telefone, email FROM cliente"; // Não seleciona a senha por segurança

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setCpf(rs.getString("cpf"));
                cliente.setNome(rs.getString("nome"));
                cliente.setTelefone(rs.getString("telefone"));
                cliente.setEmail(rs.getString("email"));
                // Não recuperamos a senha
                
                clientes.add(cliente);
            }
        }
        return clientes;
    }

	
	/**
	 * Busca um cliente específico pelo seu CPF.
	 * @param cpf O CPF do cliente.
	 * @return O objeto Cliente encontrado, ou null se não existir.
	 */
	public Cliente buscarPorCpf(String cpf) throws SQLException {
        String sql = "SELECT cpf, nome, telefone, email, senha FROM cliente WHERE cpf = ?";
        Cliente cliente = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, cpf);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setCpf(rs.getString("cpf"));
                    cliente.setNome(rs.getString("nome"));
                    cliente.setTelefone(rs.getString("telefone"));
                    cliente.setEmail(rs.getString("email"));
                    cliente.setSenha(rs.getString("senha"));
                }
            }
        }
        return cliente;
    }
	
	/**
	 * Busca um cliente específico pelo seu Email.
	 * @param email O Email do cliente.
	 * @return O objeto Cliente encontrado, ou null se não existir.
	 */
	public Cliente buscarPorEmail(String email) throws SQLException {
        String sql = "SELECT cpf, nome, telefone, email, senha FROM cliente WHERE email = ?";
        Cliente cliente = null;

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setCpf(rs.getString("cpf"));
                    cliente.setNome(rs.getString("nome"));
                    cliente.setTelefone(rs.getString("telefone"));
                    cliente.setEmail(rs.getString("email"));
                    cliente.setSenha(rs.getString("senha"));
                }
            }
        }
        return cliente;
    }
	
	/**
	 * Verifica as credenciais de login de um cliente.
	 * @param email O email fornecido no login.
	 * @param senhaPlana A senha em TEXTO PLANO fornecida no login.
	 * @return O objeto Cliente se as credenciais estiverem corretas, ou null caso contrário.
	 */
    public Cliente buscarPorEmailESenha(String email, String senhaPlana) throws SQLException {
        String sql = "SELECT cpf, nome, telefone, email, senha FROM cliente WHERE email = ? AND senha = ?";
        Cliente cliente = null;
        
        // Criptografa a senha recebida para comparar com a do banco
        String senhaCriptografada = CriptografiaUtils.hashSenha(senhaPlana);
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, senhaCriptografada); // Compara o hash da senha
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setCpf(rs.getString("cpf"));
                    cliente.setNome(rs.getString("nome"));
                    cliente.setTelefone(rs.getString("telefone"));
                    cliente.setEmail(rs.getString("email"));
                    cliente.setSenha(rs.getString("senha")); // Recupera a senha já criptografada do BD
                }
            }
        } 
        return cliente;
    }
}


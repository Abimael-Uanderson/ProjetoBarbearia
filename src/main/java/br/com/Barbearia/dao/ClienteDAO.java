package br.com.Barbearia.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.Barbearia.model.Cliente;
import br.com.Barbearia.utils.Conexao;

public class ClienteDAO {
	public void inserirCliente(Cliente cliente) throws SQLException {
		String sql = "INSERT INTO cliente  (cpf, nome, telefone, email, senha) VALUES (?, ?, ?, ?, ?)";
		
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
        	stmt.setString(1, cliente.getCpf().toString());
            stmt.setString(2, cliente.getNome().toString());
            stmt.setString(3, cliente.getTelefone().toString());
            stmt.setString(4, cliente.getEmail().toString());
            stmt.setString(5, cliente.getSenha().toString());
            
            stmt.executeUpdate();
        }
	}
	
	public void editarCliente(Cliente cliente) throws SQLException {
		String sql = "UPDATE cliente SET nome = ?, telefone = ?, email = ?, senha = ? WHERE cpf = ?";
		
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
        	stmt.setString(1, cliente.getNome());
            stmt.setString(2, cliente.getTelefone());
            stmt.setString(3, cliente.getEmail());
            stmt.setString(4, cliente.getSenha());
         
            stmt.setString(5, cliente.getCpf());
            
            stmt.executeUpdate();
        }
	}
	
	public void apagarCliente(String cpf) throws SQLException {
        String sql = "DELETE FROM cliente WHERE cpf = ?";
        
        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, cpf);
            
            stmt.executeUpdate();
        }
    }
	
	public List<Cliente> listarClientes() throws SQLException {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT cpf, nome, telefone, email, senha FROM cliente";

        try (Connection conexao = Conexao.getConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

        
            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setCpf(rs.getString("cpf"));
                cliente.setNome(rs.getString("nome"));
                cliente.setTelefone(rs.getString("telefone"));
                cliente.setEmail(rs.getString("email"));
                cliente.setSenha(rs.getString("senha"));
                
               
                clientes.add(cliente);
            }
        }
        return clientes;
    }
	
	public Cliente buscarClientePorCpf(String cpf) throws SQLException {
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
	
	
	public Cliente buscarClientePorEmail(String email) throws SQLException {
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
	
	
		
}

package br.com.Barbearia.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {
	 	private static final String URL = "jdbc:mysql://localhost:3306/Barbearia";
	    private static final String USUARIO = "root";
	    private static final String SENHA = "Lord12dt,";

	    public static Connection getConnection() {
	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	            return DriverManager.getConnection(URL, USUARIO, SENHA);
	        } catch (ClassNotFoundException | SQLException e) {
	            throw new RuntimeException("Erro na conexão com o banco de dados", e);
	        }
	    }
}

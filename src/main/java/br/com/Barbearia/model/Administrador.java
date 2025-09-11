package br.com.Barbearia.model;

public class Administrador {
    private int id_admin;
    private String email;
    private String senha;

    public Administrador() {
        super();
    }

    public Administrador(String email, String senha) {
        super();
        this.email = email;
        this.senha = senha;
    }

    public Administrador(int id_admin, String email, String senha) {
        super();
        this.id_admin = id_admin;
        this.email = email;
        this.senha = senha;
    }

    public int getId_admin() {
        return id_admin;
    }

    public void setId_admin(int id_admin) {
        this.id_admin = id_admin;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }
}

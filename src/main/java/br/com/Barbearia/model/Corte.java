package br.com.Barbearia.model;

public class Corte {
	private int id_corte;
    private String nome_corte;
    private Double valor_corte;
    private int duracao;
    
	public int getId_corte() {
		return id_corte;
	}
	public void setId_corte(int id_corte) {
		this.id_corte = id_corte;
	}
	public String getNome_corte() {
		return nome_corte;
	}
	public void setNome_corte(String nome_corte) {
		this.nome_corte = nome_corte;
	}
	public Double getValor_corte() {
		return valor_corte;
	}
	public void setValor_corte(Double valor_corte) {
		this.valor_corte = valor_corte;
	}
	public int getDuracao() {
		return duracao;
	}
	public void setDuracao(int duracao) {
		this.duracao = duracao;
	}
}

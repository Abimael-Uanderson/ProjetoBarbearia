package br.com.Barbearia.model;

public class Especialidade {
	private int id_especialidadeEp;
    private Corte corte;
    private Barbeiro barbeiro;
    
    
	public Especialidade() {
		super();
	}
	
	
	public Especialidade(Corte corte, Barbeiro barbeiro) {
		super();
		this.corte = corte;
		this.barbeiro = barbeiro;
	}

	
	public Especialidade(int id_especialidadeEp, Corte corte, Barbeiro barbeiro) {
		super();
		this.id_especialidadeEp = id_especialidadeEp;
		this.corte = corte;
		this.barbeiro = barbeiro;
	}


	public int getId_especialidadeEp() {
		return id_especialidadeEp;
	}
	public void setId_especialidadeEp(int id_especialidadeEp) {
		this.id_especialidadeEp = id_especialidadeEp;
	}
	public Corte getCorte() {
		return corte;
	}
	public void setCorte(Corte corte) {
		this.corte = corte;
	}
	public Barbeiro getBarbeiro() {
		return barbeiro;
	}
	public void setBarbeiro(Barbeiro barbeiro) {
		this.barbeiro = barbeiro;
	}
    
    
}

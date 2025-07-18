package br.com.Barbearia.model;

public class Item_agendamento {
	private int id_itemIg;
    private Double valor_itemIg;
    private Especialidade especialidade;
    private Agendamento agendamento;
    
    
	public Item_agendamento() {
		super();
	}
	
	
	public Item_agendamento(Double valor_itemIg, Especialidade especialidade, Agendamento agendamento) {
		super();
		this.valor_itemIg = valor_itemIg;
		this.especialidade = especialidade;
		this.agendamento = agendamento;
	}

	
	public Item_agendamento(int id_itemIg, Double valor_itemIg, Especialidade especialidade, Agendamento agendamento) {
		super();
		this.id_itemIg = id_itemIg;
		this.valor_itemIg = valor_itemIg;
		this.especialidade = especialidade;
		this.agendamento = agendamento;
	}


	public int getId_itemIg() {
		return id_itemIg;
	}
	public void setId_itemIg(int id_itemIg) {
		this.id_itemIg = id_itemIg;
	}
	public Double getValor_itemIg() {
		return valor_itemIg;
	}
	public void setValor_itemIg(Double valor_itemIg) {
		this.valor_itemIg = valor_itemIg;
	}
	public Especialidade getEspecialidade() {
		return especialidade;
	}
	public void setEspecialidade(Especialidade especialidade) {
		this.especialidade = especialidade;
	}
	public Agendamento getAgendamento() {
		return agendamento;
	}
	public void setAgendamento(Agendamento agendamento) {
		this.agendamento = agendamento;
	}
    
    
}

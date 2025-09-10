package br.com.Barbearia.model;

import java.time.LocalDateTime;

public class Agendamento {
	private int id_agendamentoAg;
    private LocalDateTime data_atendimentoAg;
    private String status_agendamentoAg;
    private int duracao_totalAg;
    private Cliente cliente;
    private Barbeiro barbeiro;
    
    // Campo essencial para carregar os detalhes do serviço (item)
    private Item_agendamento itemAgendamento;
    
    // Campo "facilitador" para a home page
    private String nomeServico;
    
    // Construtores
	public Agendamento() {
		super();
	}
    
	public Agendamento(LocalDateTime data_atendimentoAg, String status_agendamentoAg, int duracao_totalAg,
			Cliente cliente, Barbeiro barbeiro) {
		super();
		this.data_atendimentoAg = data_atendimentoAg;
		this.status_agendamentoAg = status_agendamentoAg;
		this.duracao_totalAg = duracao_totalAg;
		this.cliente = cliente;
		this.barbeiro = barbeiro;
	}

	// Getters e Setters
	public int getId_agendamentoAg() { return id_agendamentoAg; }
	public void setId_agendamentoAg(int id_agendamentoAg) { this.id_agendamentoAg = id_agendamentoAg; }
	public LocalDateTime getData_atendimentoAg() { return data_atendimentoAg; }
	public void setData_atendimentoAg(LocalDateTime data_atendimentoAg) { this.data_atendimentoAg = data_atendimentoAg; }
	public String getStatus_agendamentoAg() { return status_agendamentoAg; }
	public void setStatus_agendamentoAg(String status_agendamentoAg) { this.status_agendamentoAg = status_agendamentoAg; }
	public int getDuracao_totalAg() { return duracao_totalAg; }
	public void setDuracao_totalAg(int duracao_totalAg) { this.duracao_totalAg = duracao_totalAg; }
	public Cliente getCliente() { return cliente; }
	public void setCliente(Cliente cliente) { this.cliente = cliente; }
	public Barbeiro getBarbeiro() { return barbeiro; }
	public void setBarbeiro(Barbeiro barbeiro) { this.barbeiro = barbeiro; }
	
	// --- MÉTODOS ADICIONADOS E CORRIGIDOS ---
	public Item_agendamento getItemAgendamento() {
		return itemAgendamento;
	}
	public void setItemAgendamento(Item_agendamento item) {
		this.itemAgendamento = item;
	}
	public String getNomeServico() {
		return nomeServico;
	}
	public void setNomeServico(String nomeServico) {
		this.nomeServico = nomeServico;
	}
}


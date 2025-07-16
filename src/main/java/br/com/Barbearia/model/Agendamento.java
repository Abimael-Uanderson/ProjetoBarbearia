package br.com.Barbearia.model;

import java.time.LocalDateTime;

public class Agendamento {
	private int id_agendamentoAg;
    private LocalDateTime data_atendimentoAg;
    private String status_agendamentoAg;
    private int duracao_totalAg;
    private Cliente cliente;
    
	public int getId_agendamentoAg() {
		return id_agendamentoAg;
	}
	public void setId_agendamentoAg(int id_agendamentoAg) {
		this.id_agendamentoAg = id_agendamentoAg;
	}
	public LocalDateTime getData_atendimentoAg() {
		return data_atendimentoAg;
	}
	public void setData_atendimentoAg(LocalDateTime data_atendimentoAg) {
		this.data_atendimentoAg = data_atendimentoAg;
	}
	public String getStatus_agendamentoAg() {
		return status_agendamentoAg;
	}
	public void setStatus_agendamentoAg(String status_agendamentoAg) {
		this.status_agendamentoAg = status_agendamentoAg;
	}
	public int getDuracao_totalAg() {
		return duracao_totalAg;
	}
	public void setDuracao_totalAg(int duracao_totalAg) {
		this.duracao_totalAg = duracao_totalAg;
	}
	public Cliente getCliente() {
		return cliente;
	}
	public void setCliente(Cliente cliente) {
		this.cliente = cliente;
	}
    
    
}

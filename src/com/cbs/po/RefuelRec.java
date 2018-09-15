package com.cbs.po;

import java.io.Serializable;
import java.sql.Timestamp;

//加油记录实体
public class RefuelRec implements Serializable{
	private Integer id;
	private Car car;
	private CurrentUnit oilSta;//加油�?
	private Timestamp oilDate;
	private Dictionary oilLabel;//油料标号
	private Double unitPrice=0.0;
	private Double amount;
	private Integer this_mil=0;//本次里程
	private Integer last_mil=0;//上次里程
	private Double this_volu=0.0;//本次加油�?
	private Double last_volu=0.0;//上次加油�?
	private Driver operator;
	private String remarks;
	
	//分页专用
	private int page;
	private int rows;
	
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getRows() {
		return rows;
	}
	public void setRows(int rows) {
		this.rows = rows;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Car getCar() {
		return car;
	}
	public void setCar(Car car) {
		this.car = car;
	}
	public CurrentUnit getOilSta() {
		return oilSta;
	}
	public void setOilSta(CurrentUnit oilSta) {
		this.oilSta = oilSta;
	}	
	public Timestamp getOilDate() {
		return oilDate;
	}
	public void setOilDate(Timestamp oilDate) {
		this.oilDate = oilDate;
	}
	public Dictionary getOilLabel() {
		return oilLabel;
	}
	public void setOilLabel(Dictionary oilLabel) {
		this.oilLabel = oilLabel;
	}
	public Double getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(Double unitPrice) {
		this.unitPrice = unitPrice;
	}
	public Double getAmount() {
		return amount;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public Integer getThis_mil() {
		return this_mil;
	}
	public void setThis_mil(Integer this_mil) {
		this.this_mil = this_mil;
	}
	public Integer getLast_mil() {
		return last_mil;
	}
	public void setLast_mil(Integer last_mil) {
		this.last_mil = last_mil;
	}
	public Double getThis_volu() {
		return this_volu;
	}
	public void setThis_volu(Double this_volu) {
		this.this_volu = this_volu;
	}
	public Double getLast_volu() {
		return last_volu;
	}
	public void setLast_volu(Double last_volu) {
		this.last_volu = last_volu;
	}
	public Driver getOperator() {
		return operator;
	}
	public void setOperator(Driver operator) {
		this.operator = operator;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	
}

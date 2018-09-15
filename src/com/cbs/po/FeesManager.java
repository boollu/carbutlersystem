package com.cbs.po;

import java.io.Serializable;
import java.sql.Timestamp;

//规费管理
public class FeesManager implements Serializable{
	private Integer id;
	private Car car;
	private String feesName;
	private Timestamp feesDate;
	private Double feesAmount;
	private CurrentUnit feesUnit;
	private Driver operator;
	private String remarks;
	
	//分页专用
	private int page;
	private int rows;
	
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
	public String getFeesName() {
		return feesName;
	}
	public void setFeesName(String feesName) {
		this.feesName = feesName;
	}
	public Timestamp getFeesDate() {
		return feesDate;
	}
	public void setFeesDate(Timestamp feesDate) {
		this.feesDate = feesDate;
	}
	public Double getFeesAmount() {
		return feesAmount;
	}
	public void setFeesAmount(Double feesAmount) {
		this.feesAmount = feesAmount;
	}	
	public CurrentUnit getFeesUnit() {
		return feesUnit;
	}
	public void setFeesUnit(CurrentUnit feesUnit) {
		this.feesUnit = feesUnit;
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
	
	
}

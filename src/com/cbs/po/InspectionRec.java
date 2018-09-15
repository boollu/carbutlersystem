package com.cbs.po;

import java.io.Serializable;
import java.sql.Date;

//年检记录
public class InspectionRec implements Serializable{
	private Integer id;
	private Car car;
	private String insNo;//年检编号
	private Date insDate;//年检日期
	private Double insAmount;
	private CurrentUnit vao;//vehicle administrative office缩写
	private Date expireDate;
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
	public String getInsNo() {
		return insNo;
	}
	public void setInsNo(String insNo) {
		this.insNo = insNo;
	}
	public Date getInsDate() {
		return insDate;
	}
	public void setInsDate(Date insDate) {
		this.insDate = insDate;
	}
	public Double getInsAmount() {
		return insAmount;
	}
	public void setInsAmount(Double insAmount) {
		this.insAmount = insAmount;
	}
	public CurrentUnit getVao() {
		return vao;
	}
	public void setVao(CurrentUnit vao) {
		this.vao = vao;
	}
	public Date getExpireDate() {
		return expireDate;
	}
	public void setExpireDate(Date expireDate) {
		this.expireDate = expireDate;
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

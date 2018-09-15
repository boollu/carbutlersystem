package com.cbs.po;

import java.io.Serializable;
import java.sql.Date;

//保险记录�?
public class InsuranceRec implements Serializable{
	private Integer id;
	private Car car;
	private String insNo;//保险编号
	private Date insDate;//保险�?��日期
	private Dictionary insType;//多对�?
	private Double insAmount;
	private CurrentUnit insUnit;
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
	public Dictionary getInsType() {
		return insType;
	}
	public void setInsType(Dictionary insType) {
		this.insType = insType;
	}
	public Double getInsAmount() {
		return insAmount;
	}
	public void setInsAmount(Double insAmount) {
		this.insAmount = insAmount;
	}
	public CurrentUnit getInsUnit() {
		return insUnit;
	}
	public void setInsUnit(CurrentUnit insUnit) {
		this.insUnit = insUnit;
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

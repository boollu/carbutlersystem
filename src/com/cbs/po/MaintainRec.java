package com.cbs.po;

import java.io.Serializable;
import java.sql.Date;

//保养记录
public class MaintainRec implements Serializable{
	private Integer id;
	private Car car;
	private Dictionary mainType;//多对�?
	private Date mainDate=new Date(System.currentTimeMillis());
	private Double mainAmount;
	private CurrentUnit mainUnit;
	private Double mainMil=0d;
	private String mainContent;
	private Date nextDate;
	private Double nextMil;
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
	public Dictionary getMainType() {
		return mainType;
	}
	public void setMainType(Dictionary mainType) {
		this.mainType = mainType;
	}
	public Date getMainDate() {
		return mainDate;
	}
	public void setMainDate(Date mainDate) {
		this.mainDate = mainDate;
	}
	public Double getMainAmount() {
		return mainAmount;
	}
	public void setMainAmount(Double mainAmount) {
		this.mainAmount = mainAmount;
	}
	public CurrentUnit getMainUnit() {
		return mainUnit;
	}
	public void setMainUnit(CurrentUnit mainUnit) {
		this.mainUnit = mainUnit;
	}
	public Double getMainMil() {
		return mainMil;
	}
	public void setMainMil(Double mainMil) {
		this.mainMil = mainMil;
	}
	public String getMainContent() {
		return mainContent;
	}
	public void setMainContent(String mainContent) {
		this.mainContent = mainContent;
	}
	public Date getNextDate() {
		return nextDate;
	}
	public void setNextDate(Date nextDate) {
		this.nextDate = nextDate;
	}
	public Double getNextMil() {
		return nextMil;
	}
	public void setNextMil(Double nextMil) {
		this.nextMil = nextMil;
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

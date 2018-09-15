package com.cbs.po;

import java.io.Serializable;

public class ViewCostDistribution implements Serializable{
	private Integer id;
	private Integer cid;
	private String carNo;
	private Double carCost;
	private String text;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getCid() {
		return cid;
	}
	public void setCid(Integer cid) {
		this.cid = cid;
	}
	public String getCarNo() {
		return carNo;
	}
	public void setCarNo(String carNo) {
		this.carNo = carNo;
	}
	public Double getCarCost() {
		return carCost;
	}
	public void setCarCost(Double carCost) {
		this.carCost = carCost;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	
}

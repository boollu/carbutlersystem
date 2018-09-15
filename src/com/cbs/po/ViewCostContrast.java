package com.cbs.po;

import java.io.Serializable;

public class ViewCostContrast implements Serializable{
	private Integer id;
	private String carNo;
	private Double carCost;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
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
	
	
	
}

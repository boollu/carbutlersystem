package com.cbs.po;

import java.io.Serializable;
import java.sql.Timestamp;

//违章记录�?
public class PeccancyRec implements Serializable {
	private Integer id;
	private Car car;
	private Dictionary option;//多对�?
	private Timestamp pecDate;
	private Double fine;
	private Integer points;
	private Driver driver;
	private String place;
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
	public Dictionary getOption() {
		return option;
	}
	public void setOption(Dictionary option) {
		this.option = option;
	}
	public Timestamp getPecDate() {
		return pecDate;
	}
	public void setPecDate(Timestamp pecDate) {
		this.pecDate = pecDate;
	}
	public Double getFine() {
		return fine;
	}
	public void setFine(Double fine) {
		this.fine = fine;
	}	
	public Integer getPoints() {
		return points;
	}
	public void setPoints(Integer points) {
		this.points = points;
	}
	public Driver getDriver() {
		return driver;
	}
	public void setDriver(Driver driver) {
		this.driver = driver;
	}
	public String getPlace() {
		return place;
	}
	public void setPlace(String place) {
		this.place = place;
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

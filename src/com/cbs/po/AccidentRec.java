package com.cbs.po;

import java.io.Serializable;
import java.sql.Timestamp;

//事故记录�?
public class AccidentRec implements Serializable{
	private Integer id;
	private Car car;
	private Driver driver;
	private Timestamp accDate;
	private String accPlace;
	private String accExplain;//事故说明
	private String weSituation;//我方情况
	private String otherSituation;//对方情况
	private String result;//处理结果
	private Double weAmount;//我方承担金额
	private Double otherAmount;//对方承担金额
	private Double insAmount;//保险承担金额	
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
	public Driver getDriver() {
		return driver;
	}
	public void setDriver(Driver driver) {
		this.driver = driver;
	}
	public Timestamp getAccDate() {
		return accDate;
	}
	public void setAccDate(Timestamp accDate) {
		this.accDate = accDate;
	}
	public String getAccPlace() {
		return accPlace;
	}
	public void setAccPlace(String accPlace) {
		this.accPlace = accPlace;
	}
	public String getAccExplain() {
		return accExplain;
	}
	public void setAccExplain(String accExplain) {
		this.accExplain = accExplain;
	}
	public String getWeSituation() {
		return weSituation;
	}
	public void setWeSituation(String weSituation) {
		this.weSituation = weSituation;
	}
	public String getOtherSituation() {
		return otherSituation;
	}
	public void setOtherSituation(String otherSituation) {
		this.otherSituation = otherSituation;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public Double getWeAmount() {
		return weAmount;
	}
	public void setWeAmount(Double weAmount) {
		this.weAmount = weAmount;
	}
	public Double getOtherAmount() {
		return otherAmount;
	}
	public void setOtherAmount(Double otherAmount) {
		this.otherAmount = otherAmount;
	}
	public Double getInsAmount() {
		return insAmount;
	}
	public void setInsAmount(Double insAmount) {
		this.insAmount = insAmount;
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

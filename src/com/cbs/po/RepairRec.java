package com.cbs.po;

import java.io.Serializable;
import java.sql.Timestamp;

//维修记录�?
public class RepairRec implements Serializable{
	private Integer id;
	private Car car;	
	private CurrentUnit repDepot;//修理�?
	private Timestamp sendTime;//送修时间
	private Timestamp estTime;//预计取车时间
	private String sendReason;//送修原因
	private String sendRemarks;//送修备注
	private Driver operator;//经办�?
	private Dictionary repType;//维修类别
	private Timestamp getTime;//取车时间
	private Double repCost;//花费金额
	private String repOption;//维修项目
	private String useStuff;//使用材料
	private String getRemarks;//取车备注
	
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
	public CurrentUnit getRepDepot() {
		return repDepot;
	}
	public void setRepDepot(CurrentUnit repDepot) {
		this.repDepot = repDepot;
	}
	public Timestamp getSendTime() {
		return sendTime;
	}
	public void setSendTime(Timestamp sendTime) {
		this.sendTime = sendTime;
	}
	public Timestamp getEstTime() {
		return estTime;
	}
	public void setEstTime(Timestamp estTime) {
		this.estTime = estTime;
	}
	public String getSendReason() {
		return sendReason;
	}
	public void setSendReason(String sendReason) {
		this.sendReason = sendReason;
	}
	public String getSendRemarks() {
		return sendRemarks;
	}
	public void setSendRemarks(String sendRemarks) {
		this.sendRemarks = sendRemarks;
	}
	public Driver getOperator() {
		return operator;
	}
	public void setOperator(Driver operator) {
		this.operator = operator;
	}
	public Dictionary getRepType() {
		return repType;
	}
	public void setRepType(Dictionary repType) {
		this.repType = repType;
	}
	public Timestamp getGetTime() {
		return getTime;
	}
	public void setGetTime(Timestamp getTime) {
		this.getTime = getTime;
	}
	public Double getRepCost() {
		return repCost;
	}
	public void setRepCost(Double repCost) {
		this.repCost = repCost;
	}
	public String getRepOption() {
		return repOption;
	}
	public void setRepOption(String repOption) {
		this.repOption = repOption;
	}
	public String getUseStuff() {
		return useStuff;
	}
	public void setUseStuff(String useStuff) {
		this.useStuff = useStuff;
	}
	public String getGetRemarks() {
		return getRemarks;
	}
	public void setGetRemarks(String getRemarks) {
		this.getRemarks = getRemarks;
	}
	
}

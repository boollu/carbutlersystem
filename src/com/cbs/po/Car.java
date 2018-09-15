package com.cbs.po;

import java.io.File;
import java.io.Serializable;
import java.sql.Date;
import java.util.Set;

public class Car implements Serializable {
	private Integer id;
	private String carNo;
	private Dictionary carBrand;//多对�?
	private Dictionary carModel;//多对�?
	private Integer carColor;//采用本地颜色数据
	private Double carLoad;
	private Integer carSeats;
	private Double oilWear;
	private Integer initMil;
	private Integer maintainMil;
	private Integer maintainPeriod;
	private String engineNum;
	private String frameNum;
	private CurrentUnit sup;//多对�?
	private Double purchasePrice;
	private Date purchaseDate;
	private Dictionary dept;//多对�?
	private Integer carState;//采用本地车辆状�?数据
	private String remarks;
	private Integer isdisable=1;
	//private Set<CarPic> carPics;//�?���?
	
	//分页专用
	private int page;
	private int rows;
	
	//删除单一图片专用
	private int carPicId;
	private String carPicPath;
	
	//查询车辆型号专用
	private int carBrandId;
	
	//上传车辆图片专用
	private File[] carPic;
	private String[] carPicFileName;
	private String[] carPicContentType;
	private String[] desc;
	
	
	
	
	public String getCarPicPath() {
		return carPicPath;
	}
	public void setCarPicPath(String carPicPath) {
		this.carPicPath = carPicPath;
	}
	public String[] getDesc() {
		return desc;
	}
	public void setDesc(String[] desc) {
		this.desc = desc;
	}
	public File[] getCarPic() {
		return carPic;
	}
	public void setCarPic(File[] carPic) {
		this.carPic = carPic;
	}	
	public String[] getCarPicFileName() {
		return carPicFileName;
	}
	public void setCarPicFileName(String[] carPicFileName) {
		this.carPicFileName = carPicFileName;
	}
	public String[] getCarPicContentType() {
		return carPicContentType;
	}
	public void setCarPicContentType(String[] carPicContentType) {
		this.carPicContentType = carPicContentType;
	}
	public int getCarBrandId() {
		return carBrandId;
	}
	public void setCarBrandId(int carBrandId) {
		this.carBrandId = carBrandId;
	}
	public int getCarPicId() {
		return carPicId;
	}
	public void setCarPicId(int carPicId) {
		this.carPicId = carPicId;
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
	public Dictionary getCarBrand() {
		return carBrand;
	}
	public void setCarBrand(Dictionary carBrand) {
		this.carBrand = carBrand;
	}
	public Dictionary getCarModel() {
		return carModel;
	}
	public void setCarModel(Dictionary carModel) {
		this.carModel = carModel;
	}
	public Integer getCarColor() {
		return carColor;
	}
	public void setCarColor(Integer carColor) {
		this.carColor = carColor;
	}
	public Double getCarLoad() {
		return carLoad;
	}
	public void setCarLoad(Double carLoad) {
		this.carLoad = carLoad;
	}
	public Integer getCarSeats() {
		return carSeats;
	}
	public void setCarSeats(Integer carSeats) {
		this.carSeats = carSeats;
	}
	public Double getOilWear() {
		return oilWear;
	}
	public void setOilWear(Double oilWear) {
		this.oilWear = oilWear;
	}
	public Integer getInitMil() {
		return initMil;
	}
	public void setInitMil(Integer initMil) {
		this.initMil = initMil;
	}
	public Integer getMaintainMil() {
		return maintainMil;
	}
	public void setMaintainMil(Integer maintainMil) {
		this.maintainMil = maintainMil;
	}
	public Integer getMaintainPeriod() {
		return maintainPeriod;
	}
	public void setMaintainPeriod(Integer maintainPeriod) {
		this.maintainPeriod = maintainPeriod;
	}
	public String getEngineNum() {
		return engineNum;
	}
	public void setEngineNum(String engineNum) {
		this.engineNum = engineNum;
	}
	public String getFrameNum() {
		return frameNum;
	}
	public void setFrameNum(String frameNum) {
		this.frameNum = frameNum;
	}
	public CurrentUnit getSup() {
		return sup;
	}
	public void setSup(CurrentUnit sup) {
		this.sup = sup;
	}
	public Double getPurchasePrice() {
		return purchasePrice;
	}
	public void setPurchasePrice(Double purchasePrice) {
		this.purchasePrice = purchasePrice;
	}
	public Date getPurchaseDate() {
		return purchaseDate;
	}
	public void setPurchaseDate(Date purchaseDate) {
		this.purchaseDate = purchaseDate;
	}
	public Dictionary getDept() {
		return dept;
	}
	public void setDept(Dictionary dept) {
		this.dept = dept;
	}
	public Integer getCarState() {
		return carState;
	}
	public void setCarState(Integer carState) {
		this.carState = carState;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getIsdisable() {
		return isdisable;
	}
	public void setIsdisable(Integer isdisable) {
		this.isdisable = isdisable;
	}
	/*public Set<CarPic> getCarPics() {
		return carPics;
	}
	public void setCarPics(Set<CarPic> carPics) {
		this.carPics = carPics;
	}*/
	
	
	
	
	
	
}

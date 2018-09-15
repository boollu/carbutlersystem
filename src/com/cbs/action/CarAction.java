package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Car;
import com.cbs.po.CurrentUnit;
import com.cbs.po.Dictionary;
import com.cbs.po.PageModel;
import com.cbs.service.ICarService;
import com.cbs.service.ICurrentUnitService;
import com.cbs.service.IDictionaryService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class CarAction extends BaseAction implements ModelDriven<Car> {
  private Car car;
  private ICarService icars;
  private IDictionaryService idics;
  private ICurrentUnitService icus;
public Car getCar() {
	return car;
}
public void setCar(Car car) {
	this.car = car;
}
public ICarService getIcars() {
	return icars;
}
public void setIcars(ICarService icars) {
	this.icars = icars;
}
public IDictionaryService getIdics() {
	return idics;
}
public void setIdics(IDictionaryService idics) {
	this.idics = idics;
}
public ICurrentUnitService getIcus() {
	return icus;
}
public void setIcus(ICurrentUnitService icus) {
	this.icus = icus;
}
public Car getModel() {
	if(car==null){
		car=new Car();
	}
	return car;
}
/**获取分页模型结果集*/
  public void findCarDG(){
	  PageModel<Car> pm=icars.findCarDG(car);
	  this.wirteJSON(pm);
	  
  }
  /**查询所有可用的车辆*/
  public void findCarList(){
	  List<Car> clist=icars.findCarList(-1, 1);
	  this.WriteJson(clist);
  }
  
  /**查询车辆所属部门下拉列表*/
  public void findDeptList(){
	  List<Dictionary> dlist=idics.findByText("部门");
	  this.wirteJSON(dlist);
  }
  /**查询车辆品牌下拉列表*/
  public void findCarBrandList(){
	  List<Dictionary> blist=idics.findByText("车辆品牌");
	  this.wirteJSON(blist);
  }
  /**查询车辆来往单位下拉列表*/
  public void findSupList(){
	 
	  List<CurrentUnit> clist=icus.findCULByType("4S");
	
	  System.out.println("4s商家的数量为："+clist.size());
	  this.wirteJSON(clist);
  }
  /**通过id查询指定车辆*/
  public void findCarById(){
	  Car dcar=icars.findCarById(car.getId());
	  this.wirteJSON(dcar);
  }
  /**修改指定车辆信息*/
  public void updCar(){
	  boolean f=icars.updCar(car);
	  Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
  }
  /**删除指定车辆信息（改为禁用）*/
  public void delCar(){
	  boolean f=icars.delCar(car.getId());
	  Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
  }
//新增车辆信息
	public void addCar(){
		//车牌号码都转为大写
		car.setCarNo(car.getCarNo().toUpperCase());
		boolean f=icars.addCar(car);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
		}
	/**获取品牌对应的车型*/
	public void findCarModelList(){
		List<Dictionary> dmlist=idics.findDicByPid(car.getCarBrand().getId());
		this.wirteJSON(dmlist);
	}
}
